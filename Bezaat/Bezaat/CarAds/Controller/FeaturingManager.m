//
//  FeaturingManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "FeaturingManager.h"

#define PRICING_STATUS_CODE_JKEY    @"StatusCode"
#define PRICING_STATUS_MSG_JKEY     @"StatusMessage"
#define PRICING_DATA_JKEY           @"Data"

//pricing options
#define PRICING_OPTIONS_PRICING_ID_JKEY         @"PricingID"
#define PRICING_OPTIONS_COUNTRY_ID_JKEY         @"CountryID"
#define PRICING_OPTIONS_AD_PERIOD_DAYS_JKEY     @"AdPeriodDays"
#define PRICING_OPTIONS_PRICE_JKEY              @"Price"
#define PRICING_OPTIONS_PRICING_NAME_JKEY       @"PricingName"
//#define PRICING_OPTIONS_CATEGORY_ID_JKEY        @"CategoryID"
//#define PRICING_OPTIONS_CURRENCY_ID_JKEY        @"CurrencyID"
//#define PRICING_OPTIONS_CURRENCY_NAME_JKEY      @"CurrencyName"
//#define PRICING_OPTIONS_CURRENCY_NAME_EN_JKEY   @"CurrencyNameEn"

@interface FeaturingManager() {
    InternetManager * pricingManager;
}
@end

@implementation FeaturingManager
@synthesize pricingDelegate;

static NSString * pricing_options_url = @"http://gfctest.edanat.com/v1.0/json/featured-ad-pricing?countryId=%i";
static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        self.pricingDelegate = nil;
    }
    return self;
}

+ (FeaturingManager *) sharedInstance {
    static FeaturingManager * instance = nil;
    if (instance == nil) {
        instance = [[FeaturingManager alloc] init];
    }
    return instance;
}


- (void) loadPricingOptionsForCountry:(NSInteger) countryID withDelegate:(id <PricingOptionsDelegate>) del {
    
    //1- set the delegate
    self.pricingDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.pricingDelegate)
            [self.pricingDelegate optionsDidFailLoadingWithError:error];
        return ;
    }
    
    //3- check if valid country
    else if (countryID <= 0)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل خيارات التمييز في بلدك الحالي"];
        
        if (self.pricingDelegate)
            [self.pricingDelegate optionsDidFailLoadingWithError:error];
        return ;
    }
    
    //4- set the url string
    NSString * fullURLString = [NSString stringWithFormat:pricing_options_url, countryID];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        //4- set user credentials in HTTP header
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        //passing device token as a http header request
        NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
        [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
        
        //passing user id as a http header request
        NSString * userIDString = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the ID
            userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
        
        [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
        
        //passing password as a http header request
        NSString * passwordMD5String = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the password
            passwordMD5String = savedProfile.passwordMD5;
        
        [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
        
        //5- send the request
        [request setURL:correctURL];
        pricingManager = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.pricingDelegate)
            [self.pricingDelegate optionsDidFailLoadingWithError:error];
        return ;
    }
    
    
}

#pragma mark - Data Delegate methods

- (void) manager:(BaseDataManager *)manager connectionDidFailWithError:(NSError *)error {
    if (manager == pricingManager)
    {
        if (self.pricingDelegate)
            [pricingDelegate optionsDidFailLoadingWithError:error];
    }
}

- (void) manager:(BaseDataManager *)manager connectionDidSucceedWithObjects:(NSData *)result {
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        if (manager == pricingManager)
        {
            if (self.pricingDelegate)
                [pricingDelegate optionsDidFailLoadingWithError:error];
        }
    }
    else
    {
        if (manager == pricingManager)
        {
            NSArray * pricingOptions = [self createPricingOptionsArrayWithData:(NSArray *) result];
            [pricingDelegate optionsDidFinishLoadingWithData:pricingOptions];
        }
    }
}

#pragma mark - helper methods
- (NSArray * ) createPricingOptionsArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [totalDict objectForKey:PRICING_STATUS_CODE_JKEY];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSString * statusMessageProcessed = [[[totalDict objectForKey:PRICING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        
        NSMutableArray * optionsArray = [NSMutableArray new];
        if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
        {
            NSArray * dataOptionsArray = [totalDict objectForKey:PRICING_DATA_JKEY];
            if ((dataOptionsArray) && (dataOptionsArray.count))
            {
                for (NSDictionary * optionDict in dataOptionsArray)
                {
                    
                    PricingOption * option = [[PricingOption alloc]
                                              initWithPricingIDString:[optionDict objectForKey:PRICING_OPTIONS_PRICING_ID_JKEY]
                                              countryID:[optionDict objectForKey:PRICING_OPTIONS_COUNTRY_ID_JKEY]
                                              adPeriodDaysString:[optionDict objectForKey:PRICING_OPTIONS_AD_PERIOD_DAYS_JKEY]
                                              price:[optionDict objectForKey:PRICING_OPTIONS_PRICE_JKEY]
                                              pricingName:[optionDict objectForKey:PRICING_OPTIONS_PRICING_NAME_JKEY]
                                              ];
                    
                    [optionsArray addObject:option];
                    
                }
            }
        }
        return optionsArray;
    }
    return [NSArray new];
}
@end
