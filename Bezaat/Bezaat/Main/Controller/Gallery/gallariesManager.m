//
//  gallariesManager.m
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "gallariesManager.h"
#import "CarsGallery.h"
#import "CarDetails.h"


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

#pragma mark - car details json keys

#define DETAILS_STATUS_CODE_JKEY    @"StatusCode"
#define DETAILS_STATUS_MSG_JKEY     @"StatusMessage"
#define DETAILS_DATA_JKEY           @"Data"

#define DETAILS_DESCRIPTION_JKEY    @"Description"
#define DETAILS_AD_IMAGES_JKEY       @"AdImages"
#define DETAILS_ATTRIBUTES_JKEY      @"Attributes"
#define DETAILS_MOBILE_NUM_JKEY      @"MobileNumber"
#define DETAILS_LANDLINE_NUMBER_JKEY @"LandlineNumber"
#define DETAILS_LONGITUDE_JKEY       @"Longitude"
#define DETAILS_LATITUDE_JKEY        @"Latitude"
#define DETAILS_AREA_JKEY            @"Area"
#define DETAILS_EMAIL_JKEY            @"EmailAddress"
#define DETAILS_AD_ID_JKEY           @"AdID"
#define DETAILS_OWNER_ID_JKEY        @"OwnerID"
#define DETAILS_STORE_ID_JKEY        @"StoreID"
#define DETAILS_IS_FEATURED_JKEY     @"IsFeatured"
#define DETAILS_THUMBNAIL_URL_JKEY   @"ThumbnailURL"
#define DETAILS_TITLE_JKEY           @"Title"
#define DETAILS_PRICE_JKEY           @"Price"
#define DETAILS_CURRENCY_JKEY        @"Currency"
#define DETAILS_POSTED_ON_JKEY       @"PostedOn"
#define DETAILS_MODEL_YEAR_JKEY      @"ModelYear"
#define DETAILS_DISTANCE_KM_JKEY  @"DistanceRangeInKm"
#define DETAILS_VIEW_COUNT_JKEY      @"ViewCount"
#define DETAILS_IS_FAVORITE_JKEY      @"IsFavorite"
#define DETAILS_STORE_NAME_JKEY      @"StoreName"
#define DETAILS_STORE_LOGO_URL_JKEY  @"StoreLogoURL"
#define DETAILS_AD_URL_JKEY          @"AdURL"
#define DETAILS_AD_EDIT_ID_JKEY      @"EncEditID"
#define DETAILS_AD_COUNTRY_ID_JKEY   @"CountryID"

//images array
#define DETAILS_IMGS_IMAGE_ID_JKEY          @"ImageID"
#define DETAILS_IMGS_IMAGE_URL_JKEY         @"ImageURL"
#define DETAILS_IMGS_THUMBNAIL_ID_JKEY      @"ThumbnailID"
#define DETAILS_IMGS_THUMBNAIL_IMG_URL_JKEY @"ThumbnailImageURL"

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

- (NSArray*) getCarsInGalleryWithDelegateOfPage:(NSUInteger) pageNum forStore:(NSUInteger) storeID Country:(NSInteger) counttryID pageSize:(NSUInteger) pageSize WithDelegate:(id <GallariesManagerDelegate>) del{
    
    self.delegate=del;
    NSString *url =[NSString stringWithFormat:@"http://gfctest.edanat.com/v1.1/json/store-ads?pageNo=%lu&pageSize=%lu&countryId=%ld&storeId=%lu", (unsigned long)pageNum ,(unsigned long)pageSize,(long)counttryID,(unsigned long)storeID];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"]; // This might be redundant, I'm pretty sure GET is the default value
    
    //get response
    NSHTTPURLResponse * urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary* returnedJson = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *gallaries=[returnedJson objectForKey:@"Data"];
    
    for (int i=0; i<gallaries.count; i++) {
        NSDictionary *temp=[gallaries objectAtIndex:i];
        CarDetails * cg=[[CarDetails alloc] init];
        cg.description=[temp objectForKey:DETAILS_DESCRIPTION_JKEY];
        cg.title=[temp objectForKey:DETAILS_TITLE_JKEY];
        cg.price=(float) [[temp objectForKey:DETAILS_PRICE_JKEY] floatValue];
        cg.isFeatured=(bool)[[temp objectForKey:DETAILS_IS_FEATURED_JKEY] boolValue];
        cg.storeID=(int)[[temp objectForKey:DETAILS_STORE_ID_JKEY] integerValue];
        cg.longitude=(double)[[temp objectForKey:DETAILS_LONGITUDE_JKEY] doubleValue];
        cg.latitude=(double)[[temp objectForKey:DETAILS_LATITUDE_JKEY] doubleValue];
        cg.currencyString=[temp objectForKey:DETAILS_CURRENCY_JKEY];
        cg.distanceRangeInKm=(int) [[temp objectForKey:DETAILS_DISTANCE_KM_JKEY] integerValue];
        cg.modelYear=(int) [[temp objectForKey:DETAILS_MODEL_YEAR_JKEY] integerValue];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        cg.postedOnDate=[df dateFromString:(NSString*)[[temp objectForKey:DETAILS_POSTED_ON_JKEY] stringValue]];
        cg.countryID=(int)[[temp objectForKey:DETAILS_AD_COUNTRY_ID_JKEY] integerValue];
        cg.viewCount=(int)[[temp objectForKey:DETAILS_VIEW_COUNT_JKEY] integerValue];
        cg.ownerID=(int)[[temp objectForKey:DETAILS_OWNER_ID_JKEY] integerValue];
        cg.thumbnailURL=[NSURL URLWithString:[temp objectForKey:DETAILS_THUMBNAIL_URL_JKEY]];
        cg.storeName=[temp objectForKey:DETAILS_STORE_NAME_JKEY];
        cg.storeLogoURL=[NSURL URLWithString:[temp objectForKey:DETAILS_STORE_LOGO_URL_JKEY]];
        cg.area=[temp objectForKey:DETAILS_AREA_JKEY];
        cg.adID=(int)[[temp objectForKey:DETAILS_AD_ID_JKEY] integerValue];
        cg.adURL=[NSURL URLWithString:[temp objectForKey:DETAILS_AD_URL_JKEY]];
        cg.isFavorite=(bool)[[temp objectForKey:DETAILS_IS_FAVORITE_JKEY] boolValue];
        
        [result addObject:cg];
        
    }
    NSLog(@"%@",returnedJson);
    [del didFinishLoadingWithData:result];
    return result;
    
    
}


@end
