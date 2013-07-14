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


#define DEFAULT_PAGE_SIZE           50

//#define GalleriesURL [NSURL URLWithString: @"http://http://gfctest.edanat.com/v1.1/json/get-stores-by-country"]
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


#define GALLERY_AD_MODEL_YEAR_JKEY @"ModelYear"
#define GALLERY_AD_DISTANCE_RANGE_JKEY @"DistanceRangeInKm"
#define GALLERY_AD_AREA_JKEY @"Area"
#define GALLERY_AD_AD_ID_JKEY @"AdID"
#define GALLERY_AD_OWNER_ID_JKEY @"OwnerID"
#define GALLERY_AD_STORE_ID_JKEY @"StoreID"
#define GALLERY_AD_IS_FEATURED_JKEY @"IsFeatured"
#define GALLERY_AD_THUMBNAIL_URL_JKEY @"ThumbnailURL"
#define GALLERY_AD_TITLE_JKEY @"Title"
#define GALLERY_AD_PRICE_JKEY @"Price"
#define GALLERY_AD_CURRENCY_JKEY @"Currency"
#define GALLERY_AD_POSTED_ON_JKEY @"PostedOn"
#define GALLERY_AD_VIEW_COUNT_JKEY @"ViewCount"
#define GALLERY_AD_IS_FAVORITE_JKEY @"IsFavorite"
#define GALLERY_AD_STORE_NAME_JKEY @"StoreName"
#define GALLERY_AD_STORE_LOGO_URL_JKEY @"StoreLogoURL"
#define GALLERY_AD_POSTED_FROM_CITY_ID_JKEY @"PostedFromCityID"
#define GALLERY_AD_CAT_ID_JKEY @"CategoryID"
#define GALLERY_AD_MAIN_CAT_ID_JKEY @"MainCategoryID"
#define GALLERY_AD_ROOMS_JKEY @"Rooms"
#define GALLERY_AD_ROOMS_COUNT_JKEY @"RoomsCount"
#define GALLERY_AD_ENC_EDIT_ID_JKEY @"EncEditID"
#define GALLERY_AD_AD_URL_JKEY @"AdURL"
#define GALLERY_AD_COUNTRY_ID_JKEY @"CountryID"
#define GALLERY_AD_LONGITUDE_JKEY @"Longitude"
#define GALLERY_AD_LATITUDE_JKEY @"Latitude"

@interface gallariesManager () {
    //NSMutableArray *result;
    InternetManager * galleriesMngr;
    InternetManager * carsInGalleryMngr;
    InternetManager * postCommentMngr;
    InternetManager * getCommentsMngr;
    
}
@end

@implementation gallariesManager

@synthesize galleriesDel, carsDel, commentsDel;

static NSString * stores_by_country_url = @"/json/get-stores-by-country?countryid=%i";
static NSString * cars_in_gallery_url = @"/json/store-ads?pageNo=%@&pageSize=%@&countryId=%i&cityId=%i&storeId=%i&textTerm=%@&brandId=%@&modelId=%@&minPrice=%@&maxPrice=%@&destanceRange=%@&fromYear=%@&toYear=%@&adsWithImages=%@&adsWithPrice=%@&area=%@&orderby=%@&lastRefreshed=%@";

static NSString * post_comment_url = @"/json/post-comment";
static NSString * get_ad_comments_url = @"/json/get-ad-comments?adId=%@&pageNo=%@&pageSize=%@";

static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    
    self = [super init];
    if (self) {
        //result=[[NSMutableArray alloc]init];
        self.galleriesDel = nil;
        self.carsDel = nil;
        self.commentsDel = nil;
        
        stores_by_country_url = [API_MAIN_URL stringByAppendingString:stores_by_country_url];
        post_comment_url = [API_MAIN_URL stringByAppendingString:post_comment_url];
        get_ad_comments_url = [API_MAIN_URL stringByAppendingString:get_ad_comments_url];
        
        [self setPageSizeToDefault];
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

- (NSUInteger) nextPage {
    self.carsPageNumber ++;
    return self.carsPageNumber;
}

- (NSUInteger) getCurrentPageNum {
    return self.carsPageNumber;
}

- (NSUInteger) getCurrentPageSize {
    return self.carsPageSize;
}


- (void) setCurrentPageNum:(NSUInteger) pNum {
    self.carsPageNumber = pNum;
}

- (void) setCurrentPageSize:(NSUInteger) pSize {
    self.carsPageSize = pSize;
}

- (void) setPageSizeToDefault {
    self.carsPageSize = DEFAULT_PAGE_SIZE;
}


- (void) getGallariesInCountry:(NSInteger) countryID WithDelegate:(id <GalleriesDelegate>) del {
    
    //1- set the delegate
    self.galleriesDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.galleriesDel)
            [self.galleriesDel galleriesDidFailLoadingWithError:error];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:stores_by_country_url, countryID];
    
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        //NSLog(@"%@", correctURLstring);
        //passing device token as a http header request
        NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
        [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
        
        
        //5- send the request
        [request setURL:correctURL];
        galleriesMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.galleriesDel)
            [self.galleriesDel galleriesDidFailLoadingWithError:error];
        return ;
    }
    
}

//country id is the id of the store's country
- (void) getCarAdsOfPage:(NSUInteger) pageNum forStore:(NSUInteger) storeID InCountry:(NSUInteger) countryID  WithDelegate:(id <CarsInGalleryDelegate>) del {

    //1- set the delegate
    self.carsDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.carsDel)
            [self.carsDel carsDidFailLoadingWithError:error];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:cars_in_gallery_url,
                                [NSString stringWithFormat:@"%i", self.carsPageNumber],
                                [NSString stringWithFormat:@"%i", self.carsPageSize],
                                countryID,
                                @"",
                                storeID,
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @""];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //NSLog(@"%@", correctURLstring);
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        //4- set user credentials in HTTP header
        UserProfile * savedProfile = [[ProfileManager sharedInstance] getSavedUserProfile];
        
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
        carsInGalleryMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.carsDel)
            [self.carsDel carsDidFailLoadingWithError:error];
        return ;
    }
}


/*
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

*/

#pragma mark - DataDelegate methods

- (void)manager:(BaseDataManager *)manager connectionDidFailWithError:(NSError *)error {
    
    if (manager == galleriesMngr) {
        
        if (self.galleriesDel)
            [galleriesDel galleriesDidFailLoadingWithError:error];
    }
    
    else if (manager == carsInGalleryMngr) {
        
        if (self.carsDel)
            [carsDel carsDidFailLoadingWithError:error];
    }
    
    else if (manager == postCommentMngr) {
        
        if (self.commentsDel)
            [commentsDel commentsDidFailPostingWithError:error];
    }
    
    else if (manager == getCommentsMngr) {
        
        if (self.commentsDel)
            [commentsDel commentsDidFailLoadingWithError:error];
    }
    
}

- (void) manager:(BaseDataManager *)manager connectionDidSucceedWithObjects:(NSData *)result {
    
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (manager == galleriesMngr) {
            
            if (self.galleriesDel)
                [galleriesDel galleriesDidFailLoadingWithError:error];
        }
        
        else if (manager == carsInGalleryMngr) {
            
            if (self.carsDel)
                [carsDel carsDidFailLoadingWithError:error];
        }
        
        else if (manager == postCommentMngr) {
            
            if (self.commentsDel)
                [commentsDel commentsDidFailPostingWithError:error];
        }
        
        else if (manager == getCommentsMngr) {
            
            if (self.commentsDel)
                [commentsDel commentsDidFailLoadingWithError:error];
        }

    }
    else
    {
        if (manager == galleriesMngr) {
            
            if (self.galleriesDel) {
                NSArray * galleriesArray = [self createGalleriesArrayWithData:(NSArray *)result];
                [galleriesDel galleriesDidFinishLoadingWithData:galleriesArray];
            }
                
        }
        
        else if (manager == carsInGalleryMngr) {
            
            if (self.carsDel) {
                NSArray * carsInGalleryArray = [self createCarsInGalleryArrayWithData:(NSArray *) result];
                [carsDel carsDidFinishLoadingWithData:carsInGalleryArray];
            }
            
        }
        
        else if (manager == postCommentMngr) {
            
            if (self.commentsDel) {}
            
        }
        
        else if (manager == getCommentsMngr) {
            
            if (self.commentsDel) {}
                
        }
    }
}

#pragma mark - helper methods
- (NSArray *) createGalleriesArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:DETAILS_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * galleriesArray = [NSMutableArray new];
        
        NSString * statusMessageProcessed = [[[totalDict objectForKey:DETAILS_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        
        if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
        {
            NSArray * dataGalleriesArray = [totalDict objectForKey:DETAILS_DATA_JKEY];
            if ((dataGalleriesArray) && (![@"" isEqualToString:(NSString *)dataGalleriesArray]) && (dataGalleriesArray.count))
            {
                for (NSDictionary * gDict in dataGalleriesArray)
                {
                    
                    CarsGallery * gallery =
                    [[CarsGallery alloc]
                     initWithStoreIDString:[gDict objectForKey:GALLERY_ID_JSONK]
                            StoreNameString:[gDict objectForKey:GALLERY_NAME_JSONK]
                            StoreOwnerEmailString:[gDict objectForKey:GALLERY_OWNER_EMAIL_JSONK]
                            StoreImageURLString:[gDict objectForKey:GALLERY_IMAGE_URL_JSONK]
                            CountryIDString:[gDict objectForKey:GALLERY_COUNTRY_ID_JSONK]
                            ActiveAdsCountString:[gDict objectForKey:GALLERY_ACTIVEADS_COUNT_JSONK]
                            StoreStatusString:[gDict objectForKey:GALLERY_STATUS_JSONK]
                            StoreContactNoString:[gDict objectForKey:GALLERY_CONTACT_NO_JSONK]
                     RemainingFreeFeatureAdsString:[gDict objectForKey:GALLERY_REMAINING_DAYS_JSONK]
                SubscriptionExpiryDateString:[gDict objectForKey:GALLERY_SUBSCRIPTION_EXPIRED_JSONK]
                            RemainingDaysString:[gDict objectForKey:GALLERY_REMAINING_FREEADS_JSONK]
                     ];
                    
                    [galleriesArray addObject:gallery];
                }
            }
        }
        return galleriesArray;
    }
    return [NSArray new];
}

- (NSArray *) createCarsInGalleryArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:DETAILS_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * carsArray = [NSMutableArray new];
        
        NSString * statusMessageProcessed = [[[totalDict objectForKey:DETAILS_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        
        if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
        {
            NSArray * dataCarsArray = [totalDict objectForKey:DETAILS_DATA_JKEY];
            if ((dataCarsArray) && (![@"" isEqualToString:(NSString *)dataCarsArray]) && (dataCarsArray.count))
            {
                for (NSDictionary * adDict in dataCarsArray)
                {
                    GalleryAd * gAd =
                    [[GalleryAd alloc]
                     initWithAdIDString:[adDict objectForKey:GALLERY_AD_AD_ID_JKEY]
                     ownerIDString:[adDict objectForKey:GALLERY_AD_OWNER_ID_JKEY]
                     storeIDString:[adDict objectForKey:GALLERY_AD_STORE_ID_JKEY]
                     isFeaturedString:[adDict objectForKey:GALLERY_AD_IS_FEATURED_JKEY]
                     thumbnailURLString:[adDict objectForKey:GALLERY_AD_THUMBNAIL_URL_JKEY]
                     titleString:[adDict objectForKey:GALLERY_AD_TITLE_JKEY]
                     priceString:[adDict objectForKey:GALLERY_AD_PRICE_JKEY]
                     currencyString:[adDict objectForKey:GALLERY_AD_CURRENCY_JKEY]
                     postedOnDateString:[adDict objectForKey:GALLERY_AD_POSTED_ON_JKEY]
                     modelYearString:[adDict objectForKey:GALLERY_AD_MODEL_YEAR_JKEY]
                     distanceRangeInKmString:[adDict objectForKey:GALLERY_AD_DISTANCE_RANGE_JKEY]
                     viewCountString:[adDict objectForKey:GALLERY_AD_VIEW_COUNT_JKEY]
                     isFavoriteString:[adDict objectForKey:GALLERY_AD_IS_FAVORITE_JKEY]
                     storeNameString:[adDict objectForKey:GALLERY_AD_STORE_NAME_JKEY]
                     storeLogoURLString:[adDict objectForKey:GALLERY_AD_STORE_LOGO_URL_JKEY]
                     countryIDString:[adDict objectForKey:GALLERY_AD_COUNTRY_ID_JKEY]
                     EncEditIDString:[adDict objectForKey:GALLERY_AD_ENC_EDIT_ID_JKEY]
                     longitudeString:[adDict objectForKey:GALLERY_AD_LONGITUDE_JKEY]
                     latitudeString:[adDict objectForKey:GALLERY_AD_LATITUDE_JKEY]
                     areaString:[adDict objectForKey:GALLERY_AD_AREA_JKEY]
                     postedFromCityIDString:[adDict objectForKey:GALLERY_AD_POSTED_FROM_CITY_ID_JKEY]
                     categoryIDString:[adDict objectForKey:GALLERY_AD_CAT_ID_JKEY]
                     mainCategoryIDString:[adDict objectForKey:GALLERY_AD_MAIN_CAT_ID_JKEY]
                     roomsString:[adDict objectForKey:GALLERY_AD_ROOMS_JKEY]
                     roomsCountString:[adDict objectForKey:GALLERY_AD_ROOMS_COUNT_JKEY]
                     adURLString:[adDict objectForKey:GALLERY_AD_AD_URL_JKEY]
                     ];
                                        
                    [carsArray addObject:gAd];
                }
            }
        }
        return carsArray;
    }
    return [NSArray new];
}
@end
