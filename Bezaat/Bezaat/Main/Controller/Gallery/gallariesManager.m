//
//  gallariesManager.m
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "gallariesManager.h"
#import "CarsGallery.h"

#define GalleriesURL [NSURL URLWithString: @"http://http://gfctest.edanat.com/v1.1/json/get-stores-by-country"]
#define GALLERY_ID_JSONK @"StoreID"
#define GALLERY_IMAGE_URL_JSONK @"StoreImageURL"
#define GALLERY_NAME_JSONK @"StoreName"
#define GALLERY_OWNER_EMAIL_JSONK @"StoreOwnerEmail"
#define GALLERY_STATUS_JSONK @"StoreStatus"
#define GALLERY_SUBSCRIPTION_EXPIRED_JSONK @"SubscriptionExpiryDate"
#define GALLERY_ACTIVEADS_COUNT_JSONK @"ActiveAdsCount"
#define GALLERY_COUNTRY_ID_JSONK @"CountryID"
#define GALLERY_REMAINING_DAYS_JSONK @"RemainingDays"
#define GALLERY_REMAINING_FREEADS_JSONK @"RemainingFreeFeatureAds"
#define GALLERY_CONTACT_NO_JSONK @"StoreContactNo"

@interface gallariesManager () {
    NSMutableArray *result;
}
@end
@implementation gallariesManager


@synthesize delegate,countryID;

- (id) init {
    
    self = [super init];
    if (self) {
        result=[[NSMutableArray alloc]init];
    }
    return self;
}


+ (gallariesManager *) sharedInstance {
    static gallariesManager * instance = nil;
    if (instance == nil) {
        instance = [[gallariesManager alloc] init];
    }
    return instance;
}

- (NSArray*) getGallariesWithDelegate:(id <GallariesManagerDelegate>) del{
    
    NSString * post =[NSString stringWithFormat:@"countryid=%@",countryID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    
    [request setURL:GalleriesURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //get response
    NSHTTPURLResponse * urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary* returnedJson = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *gallaries=[returnedJson objectForKey:@"Data"];
    
    for (int i=0; i<gallaries.count; i++) {
        NSDictionary *temp=[gallaries objectAtIndex:i];
        CarsGallery * cg=[[CarsGallery alloc] init];
        cg.StoreID=(NSInteger*)[[temp objectForKey:GALLERY_ID_JSONK] integerValue];
        cg.ActiveAdsCount=(NSInteger*)[[temp objectForKey:GALLERY_ACTIVEADS_COUNT_JSONK] integerValue];
        cg.StoreContactNo=(NSInteger*)[[temp objectForKey:GALLERY_CONTACT_NO_JSONK] integerValue];
        cg.StoreImageURL=(NSURL*)[temp objectForKey:GALLERY_IMAGE_URL_JSONK];
        cg.CountryID=(NSInteger*)[[temp objectForKey:GALLERY_COUNTRY_ID_JSONK] integerValue];
        cg.StoreName=(NSString*)[[temp objectForKey:GALLERY_NAME_JSONK] stringValue];
        cg.StoreOwnerEmail=(NSString*)[[temp objectForKey:GALLERY_OWNER_EMAIL_JSONK] stringValue];
        cg.RemainingDays=(NSInteger*)[[temp objectForKey:GALLERY_REMAINING_DAYS_JSONK] integerValue];
        cg.RemainingFreeFeatureAds=(NSInteger*)[[temp objectForKey:GALLERY_REMAINING_FREEADS_JSONK] integerValue];
        cg.StoreStatus=(NSInteger*)[[temp objectForKey:GALLERY_STATUS_JSONK] integerValue];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        cg.SubscriptionExpiryDate=[df dateFromString:(NSString*)[[temp objectForKey:GALLERY_SUBSCRIPTION_EXPIRED_JSONK] stringValue]];


        [result addObject:cg];
         
    }
    NSLog(@"%@",returnedJson);
    [del didFinishLoadingWithData:result];
    return result;
}

@end
