//
//  CarDetalisManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarDetalisManager.h"

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

//images array
#define DETAILS_IMGS_IMAGE_ID_JKEY          @"ImageID"
#define DETAILS_IMGS_IMAGE_URL_JKEY         @"ImageURL"
#define DETAILS_IMGS_THUMBNAIL_ID_JKEY      @"ThumbnailID"
#define DETAILS_IMGS_THUMBNAIL_IMG_URL_JKEY @"ThumbnailImageURL"

//attributes id
#define DETAILS_ATTRS_AD_ATTR_ID_JKEY       @"AdAttributeID"
#define DETAILS_ATTRS_ATTR_VALUE_JKEY       @"AttributeValue"
#define DETAILS_ATTRS_CAT_ATTR_ID_JKEY      @"CategoryAttributeID"
#define DETAILS_ATTRS_DISPLAY_NAME_JKEY     @"DisplayName"

@interface CarDetalisManager ()
{
    InternetManager * internetMngr;
}
@end

@implementation CarDetalisManager

@synthesize delegate;

static NSString * details_url = @"http://gfctest.edanat.com/v1.0/json/ad-details?adId=%li";
static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = nil;
    }
    return self;
}

+ (CarDetalisManager *) sharedInstance {
    static CarDetalisManager * instance = nil;
    if (instance == nil) {
        instance = [[CarDetalisManager alloc] init];
    }
    return instance;
}

- (void) loadCarDetailsOfAdID:(NSUInteger) adID WithDelegate:(id <CarDetailsManagerDelegate>) del {
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate detailsDidFailLoadingWithError:error];
        return ;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:details_url, adID];
                                
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
        internetMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate detailsDidFailLoadingWithError:error];
        return ;
    }
}

#pragma mark - Data delegate methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    
    if (self.delegate)
        [delegate detailsDidFailLoadingWithError:error];
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
    
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate detailsDidFailLoadingWithError:error];
    }
    else
    {
        //NSLog(@"%@", result.description);
        if (self.delegate)
        {
            CarDetalis * detailsObject = [self createCarDetailsObjectWithData:(NSArray *)result];
            [delegate detailsDidFinishLoadingWithData:detailsObject];
        }
    }
}

#pragma mark - helper methods

- (CarDetalis * ) createCarDetailsObjectWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [totalDict objectForKey:DETAILS_STATUS_CODE_JKEY];
        NSInteger statusCode = statusCodeString.integerValue;
        NSString * statusMessageProcessed = [[[totalDict objectForKey:DETAILS_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        
        if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
        {
            NSDictionary * dataDict = [totalDict objectForKey:DETAILS_DATA_JKEY];
            if (dataDict)
            {
                //1- parse images
                NSMutableArray * imagesArray = [NSMutableArray new];
                NSArray * parsedImagesArray = [dataDict objectForKey:DETAILS_AD_IMAGES_JKEY];
                for (NSDictionary * imageDict in parsedImagesArray)
                {
                    CarDetailsImage * imgObj =
                    [[CarDetailsImage alloc]
                            initWithImageIDString:[imageDict objectForKey:DETAILS_IMGS_IMAGE_ID_JKEY]
                            imageURLString:[imageDict objectForKey:DETAILS_IMGS_IMAGE_URL_JKEY]
                            thumbnailIDString:[imageDict objectForKey:DETAILS_IMGS_THUMBNAIL_ID_JKEY]
                            thumbnailImageURLString:[imageDict objectForKey:DETAILS_IMGS_THUMBNAIL_IMG_URL_JKEY]];
                    
                    [imagesArray addObject:imgObj];
                }
                
                //2- parse attributes
                NSMutableArray * attrsArray = [NSMutableArray new];
                NSArray * parsedAttributesArray = [dataDict objectForKey:DETAILS_ATTRIBUTES_JKEY];
                for (NSDictionary * attrDict in parsedAttributesArray)
                {
                    CarDetailsAttribute * attrObj =
                    [[CarDetailsAttribute alloc]
                     initWithAdAttributeIDString:[attrDict objectForKey:DETAILS_ATTRS_AD_ATTR_ID_JKEY]
                     attributeValue:[attrDict objectForKey:DETAILS_ATTRS_ATTR_VALUE_JKEY]
                     categoryAttributeID:[attrDict objectForKey:DETAILS_ATTRS_CAT_ATTR_ID_JKEY]
                     displayName:[attrDict objectForKey:DETAILS_ATTRS_DISPLAY_NAME_JKEY]];
                    
                    [attrsArray addObject:attrObj];
                }
                
                
                //3- create the object
                CarDetalis * detailsObject =
                [[CarDetalis alloc]
                 initWithDescription:[dataDict objectForKey:DETAILS_DESCRIPTION_JKEY]
                 adImages:imagesArray
                 attributes:attrsArray
                 mobileNumber:[dataDict objectForKey:DETAILS_MOBILE_NUM_JKEY]
                 landlineNumber:[dataDict objectForKey:DETAILS_LANDLINE_NUMBER_JKEY]
                 longitudeString:[dataDict objectForKey:DETAILS_LONGITUDE_JKEY]
                 latitudeString:[dataDict objectForKey:DETAILS_LATITUDE_JKEY]
                 area:[dataDict objectForKey:DETAILS_AREA_JKEY]
                 adIDString:[dataDict objectForKey:DETAILS_AD_ID_JKEY]
                 ownerIDString:[dataDict objectForKey:DETAILS_OWNER_ID_JKEY]
                 storeIDString:[dataDict objectForKey:DETAILS_STORE_ID_JKEY]
                 isFeaturedString:[dataDict objectForKey:DETAILS_IS_FEATURED_JKEY]
                 thumbnailURL:[dataDict objectForKey:DETAILS_THUMBNAIL_URL_JKEY]
                 title:[dataDict objectForKey:DETAILS_TITLE_JKEY]
                 priceString:[dataDict objectForKey:DETAILS_PRICE_JKEY]
                 currencyString:[dataDict objectForKey:DETAILS_CURRENCY_JKEY]
                 postedOnDateString:[dataDict objectForKey:DETAILS_POSTED_ON_JKEY]
                 modelYearString:[dataDict objectForKey:DETAILS_MODEL_YEAR_JKEY]
                 distanceRangeInKmString:[dataDict objectForKey:DETAILS_DISTANCE_KM_JKEY]
                 viewCountString:[dataDict objectForKey:DETAILS_VIEW_COUNT_JKEY]
                 isFavoriteString:[dataDict objectForKey:DETAILS_IS_FAVORITE_JKEY]
                 storeName:[dataDict objectForKey:DETAILS_STORE_NAME_JKEY]
                 storeLogoURL:[dataDict objectForKey:DETAILS_STORE_LOGO_URL_JKEY]
                 ];
                
                return detailsObject;
            }
        }
    }
    return nil;
}

@end
