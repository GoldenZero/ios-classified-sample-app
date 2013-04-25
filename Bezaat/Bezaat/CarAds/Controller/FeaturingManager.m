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


#pragma mark - Payment methods numbers

//From the Api: "Payment method values will be iPhone:4, Android:5, iPad:6, Other Tablets:7"
#define IPHONE_PAYMENT_METHOD_NUMBER    4
#define IPAD_PAYMENT_METHOD_NUMBER      6

#pragma mark - post keys
#define CREATE_ORDER_PRICING_ID_POST_KEY             @"PricingID"
#define CREATE_ORDER_PAYMENT_METHOD_POST_KEY         @"PaymentMethod"
#define CREATE_ORDER_AD_ID_POST_KEY                  @"AdID"

@interface FeaturingManager() {
    InternetManager * pricingManager;
    InternetManager * createOrderManager;
}
@end

@implementation FeaturingManager
@synthesize pricingDelegate;
@synthesize orderDelegate;

static NSString * pricing_options_url = @"http://gfctest.edanat.com/v1.0/json/featured-ad-pricing?countryId=%i";
static NSString * create_order_url = @"http://gfctest.edanat.com/v1.0/json/process-for-featurad";

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



- (void) createOrderForFeaturingAdID:(NSInteger) adID withPricingID:(NSInteger) pricingID WithDelegate:(id <FeaturingOrderDelegate>) del { //(Payment method will be detected inside)
    
    //1- set the delegate
    self.orderDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.orderDelegate)
            [self.orderDelegate orderDidFailCreationWithError:error];
        return ;
    }
    
    NSString * fullURLString = create_order_url;
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        NSInteger paymentMethod;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            paymentMethod = IPHONE_PAYMENT_METHOD_NUMBER;
        else
            paymentMethod = IPAD_PAYMENT_METHOD_NUMBER;
        
        //3- start the request
        NSString * post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",
         CREATE_ORDER_PRICING_ID_POST_KEY, [NSString stringWithFormat:@"%i", pricingID],
         CREATE_ORDER_PAYMENT_METHOD_POST_KEY, [NSString stringWithFormat:@"%i", paymentMethod],
         CREATE_ORDER_AD_ID_POST_KEY, [NSString stringWithFormat:@"%i", adID]
         ];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:20];
        
        [request setURL:correctURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
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
        
        [request setHTTPBody:postData];
        
        createOrderManager = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
        
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.orderDelegate)
            [self.orderDelegate orderDidFailCreationWithError:error];
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
    else if (manager == createOrderManager)
    {
        if (self.orderDelegate)
            [orderDelegate orderDidFailCreationWithError:error];
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
        else if (manager == createOrderManager)
        {
            if (self.orderDelegate)
                [orderDelegate orderDidFailCreationWithError:error];
        }
    }
    else
    {
        if (manager == pricingManager)
        {
            NSArray * pricingOptions = [self createPricingOptionsArrayWithData:(NSArray *) result];
            [pricingDelegate optionsDidFinishLoadingWithData:pricingOptions];
        }
        else if (manager == createOrderManager)
        {
            NSArray * data = (NSArray *)result;
            if ((data) && (data.count > 0))
            {
                NSDictionary * totalDict = [data objectAtIndex:0];
                NSString * statusCodeString = [totalDict objectForKey:PRICING_STATUS_CODE_JKEY];
                NSInteger statusCode = statusCodeString.integerValue;
                
                NSString * statusMessageProcessed = [[[totalDict objectForKey:PRICING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                
                if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                {
                    NSString * orderIdentifier = [totalDict objectForKey:PRICING_DATA_JKEY];
                    
                    if (self.orderDelegate)
                        [orderDelegate orderDidFinishCreationWithID:orderIdentifier];
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    
                    if (self.orderDelegate)
                        [orderDelegate orderDidFailCreationWithError:error];
                }
                
            }
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
