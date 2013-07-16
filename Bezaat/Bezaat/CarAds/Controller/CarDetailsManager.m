//
//  CarDetailsManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarDetailsManager.h"

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

//attributes id
#define DETAILS_ATTRS_AD_ATTR_ID_JKEY       @"AdAttributeID"
#define DETAILS_ATTRS_ATTR_VALUE_JKEY       @"AttributeValue"
#define DETAILS_ATTRS_CAT_ATTR_ID_JKEY      @"CategoryAttributeID"
#define DETAILS_ATTRS_DISPLAY_NAME_JKEY     @"DisplayName"

#pragma mark - literals

#define ARABIC_BEFORE_TEXT          @"قبل"
#define ARABIC_SECOND_TEXT          @"ثانية"
#define ARABIC_LESS_MINUTE_TEXT     @"قبل دقيقة"
#define ARABIC_MINUTE_TEXT          @"دقيقة"
#define ARABIC_HOUR_TEXT            @"ساعة"
#define ARABIC_DAY_TEXT             @"يوم"
#define ARABIC_WEEK_TEXT            @"أسبوع"
#define ARABIC_MONTH_TEXT           @"شهر"
#define ARABIC_YEAR_TEXT            @"سنة"


@interface CarDetailsManager ()
{
    InternetManager * internetMngr;
    InternetManager * postCommentMngr;
    InternetManager * getCommentsMngr;
}
@end

@implementation CarDetailsManager

@synthesize delegate, commentsDel;

static NSString * details_url = @"/json/ad-details?adId=%li";
static NSString * post_comment_url = @"/json/post-comment";
static NSString * get_ad_comments_url = @"/json/get-ad-comments?adId=%@&pageNo=%@&pageSize=%@";

static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = nil;
        self.commentsDel = nil;
        
        details_url = [API_MAIN_URL stringByAppendingString:details_url];
        post_comment_url = [API_MAIN_URL stringByAppendingString:post_comment_url];
        get_ad_comments_url = [API_MAIN_URL stringByAppendingString:get_ad_comments_url];
        
    }
    return self;
}

+ (CarDetailsManager *) sharedInstance {
    static CarDetailsManager * instance = nil;
    if (instance == nil) {
        instance = [[CarDetailsManager alloc] init];
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
    
    //NSString * fullURLString = @"http://gfctest.edanat.com/v1.1/json/ad-details?adId=5030074";
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", correctURLstring);
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

- (NSString *) getDateDifferenceStringFromDate:(NSDate *) input {
    
    NSString * result = @"";
    
    NSDate * today = [NSDate date];
    
    NSTimeInterval diffInSeconds = [today timeIntervalSinceDate:input];
    
    if (diffInSeconds > 60)
    {
        float diffInMinutes = diffInSeconds / 60;
        if (diffInMinutes > 60)
        {
            float diffInHours = diffInMinutes / 60;
            if (diffInHours > 24)
            {
                float diffInDays = diffInHours / 24;
                
                if (diffInDays > 30)
                {
                    float diffInMonths = diffInDays / 30;
                    if (diffInMonths > 12)
                    {
                        float diffInYears = diffInMonths / 12;
                        result = [NSString stringWithFormat:@"%@ %i %@", ARABIC_BEFORE_TEXT, (int)diffInYears, ARABIC_YEAR_TEXT];
                    }
                    else
                        result = [NSString stringWithFormat:@"%@ %i %@", ARABIC_BEFORE_TEXT, (int)diffInMonths, ARABIC_MONTH_TEXT];
                    
                }
                else
                    result = [NSString stringWithFormat:@"%@ %i %@", ARABIC_BEFORE_TEXT, (int)diffInDays, ARABIC_DAY_TEXT];
            }
            else
                result = [NSString stringWithFormat:@"%@ %i %@", ARABIC_BEFORE_TEXT, (int)diffInHours, ARABIC_HOUR_TEXT];
        }
        else
            result = [NSString stringWithFormat:@"%@ %i %@", ARABIC_BEFORE_TEXT, (int)diffInMinutes, ARABIC_MINUTE_TEXT];
    }
    else
        result = [NSString stringWithFormat:@"%@", ARABIC_LESS_MINUTE_TEXT];
    
    return result;
}

#pragma mark - Data delegate methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    
    if (manager == internetMngr) {
        if (self.delegate)
            [delegate detailsDidFailLoadingWithError:error];
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

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
   
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (manager == internetMngr) {
            if (self.delegate)
                [self.delegate detailsDidFailLoadingWithError:error];
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
        if (manager == internetMngr) {
            if (self.delegate)
            {
                CarDetails * detailsObject = [self createCarDetailsObjectWithData:(NSArray *)result];
                [delegate detailsDidFinishLoadingWithData:detailsObject];
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

- (CarDetails * ) createCarDetailsObjectWithData:(NSArray *) data {
    
    //NSLog(@"%@", data);
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:DETAILS_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        NSString * statusMessageProcessed = [[[totalDict objectForKey:DETAILS_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        
        if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
        {
            NSDictionary * dataDict = [totalDict objectForKey:DETAILS_DATA_JKEY];
            if (dataDict)
            {
                //1- parse images
                NSMutableArray * imagesArray = [NSMutableArray new];
                //if parsed as string ==> it is empty !!
                NSString * tryCastString = [dataDict objectForKey:DETAILS_AD_IMAGES_JKEY];
                if ([tryCastString class] != [NSString class])
                {
                    NSArray * parsedImagesArray = [dataDict objectForKey:DETAILS_AD_IMAGES_JKEY];
                    if (parsedImagesArray)
                    {
                        for (NSDictionary * imageDict in parsedImagesArray)
                        {
                            CarDetailsImage * imgObj =
                            [[CarDetailsImage alloc]
                             initWithImageIDString:[imageDict objectForKey:DETAILS_IMGS_IMAGE_ID_JKEY]
                             imageURLString:[imageDict objectForKey:DETAILS_IMGS_IMAGE_URL_JKEY]
                             thumbnailIDString:[imageDict objectForKey:DETAILS_IMGS_THUMBNAIL_ID_JKEY]
                             thumbnailImageURLString:[imageDict objectForKey:DETAILS_IMGS_THUMBNAIL_IMG_URL_JKEY]];
                            
                            [imagesArray addObject:imgObj];
                            //[self performSelectorOnMainThread:@selector(cacheImageSizeForGallery:) withObject:imgObj waitUntilDone:NO];
                            [self performSelectorInBackground:@selector(cacheImageSizeForGallery:) withObject:imgObj];
                        }
                    }
                    
                }
                
                
                //2- parse attributes
                //if parsed as string ==> it is empty !!
                tryCastString = [dataDict objectForKey:DETAILS_ATTRIBUTES_JKEY];
                NSMutableArray * attrsArray = [NSMutableArray new];
                if ([tryCastString class] != [NSString class])
                {
                    NSArray * parsedAttributesArray = [dataDict objectForKey:DETAILS_ATTRIBUTES_JKEY];
                    if (parsedAttributesArray)
                    {
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
                    }
                }
                
                
                //3- create the object
                CarDetails * detailsObject =
                [[CarDetails alloc]
                 initWithDescription:[dataDict objectForKey:DETAILS_DESCRIPTION_JKEY]
                 adImages:imagesArray
                 attributes:attrsArray
                 mobileNumber:[dataDict objectForKey:DETAILS_MOBILE_NUM_JKEY]
                 landlineNumber:[dataDict objectForKey:DETAILS_LANDLINE_NUMBER_JKEY]
                 longitudeString:[dataDict objectForKey:DETAILS_LONGITUDE_JKEY]
                 latitudeString:[dataDict objectForKey:DETAILS_LATITUDE_JKEY]
                 area:[dataDict objectForKey:DETAILS_AREA_JKEY]
                 emailAddress:[dataDict objectForKey:DETAILS_EMAIL_JKEY]
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
                 distanceRangeInKmString:[dataDict objectForKey:DETAILS_DISTANCE_KM_JKEY] EncryptedEditID:[dataDict objectForKey:DETAILS_AD_EDIT_ID_JKEY]
                 viewCountString:[dataDict objectForKey:DETAILS_VIEW_COUNT_JKEY]
                 isFavoriteString:[dataDict objectForKey:DETAILS_IS_FAVORITE_JKEY]
                 storeName:[dataDict objectForKey:DETAILS_STORE_NAME_JKEY]
                 storeLogoURL:[dataDict objectForKey:DETAILS_STORE_LOGO_URL_JKEY]
                 adURL:[dataDict objectForKey:DETAILS_AD_URL_JKEY]
                 adCountryID:[dataDict objectForKey:DETAILS_AD_COUNTRY_ID_JKEY]
                 ];
                //NSLog(@"%@",[dataDict objectForKey:DETAILS_AD_EDIT_ID_JKEY]);
                return detailsObject;
            }
        }else{
            CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
            [error setDescMessage:statusMessageProcessed];
            
            if (self.delegate)
                [self.delegate detailsDidFailLoadingWithError:error];
        }
    }
    return nil;
}

- (void) cacheImageSizeForGallery:(CarDetailsImage *) img {
    
    NSString * correctURLstring = [img.imageURL.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
    
    NSString * imageFileName = [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
    NSString * imageFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], imageFileName];
    
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
    {
        NSMutableDictionary * dictToBeWritten = [NSMutableDictionary new];
        NSData *imageData = [NSData dataWithContentsOfURL:img.imageURL];
        
        dispatch_async( dispatch_get_main_queue(), ^(void){
            
            UIImage *theImage = [UIImage imageWithData:imageData];
            
            [dictToBeWritten setObject:[NSNumber numberWithFloat:theImage.size.width] forKey:@"width"];
            [dictToBeWritten setObject:[NSNumber numberWithFloat:theImage.size.height] forKey:@"height"];
            
            
            //4- convert dictionary to NSData
            NSError  *error;
            NSData * dataToBeWritten = [NSKeyedArchiver archivedDataWithRootObject:dictToBeWritten];
            [dataToBeWritten writeToFile:imageFilePath options:NSDataWritingAtomic error:&error];
        });
    });
    
}

@end
