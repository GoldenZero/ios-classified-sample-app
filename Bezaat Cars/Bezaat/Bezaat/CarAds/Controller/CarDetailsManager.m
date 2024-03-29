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

#define COMMENTS_AD_ID_JKEY                 @"AdID"
#define COMMENTS_COMMENT_ID_JKEY            @"CommentID"
#define COMMENTS_COMMENT_TEXT_JKEY          @"CommentText"
#define COMMENTS_POSTED_BY_ID_JKEY          @"PostedByID"
#define COMMENTS_POSTED_ON_JKEY             @"PostedOn"
#define COMMENTS_USERNAME_JKEY              @"UserName"

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

#define DEFAULT_COMMENTS_PAGE_SIZE  50


@interface CarDetailsManager ()
{
    InternetManager * internetMngr;
    InternetManager * postCommentMngr;
    InternetManager * getCommentsMngr;
    InternetManager * abuseMngr;

}
@end

@implementation CarDetailsManager

@synthesize delegate, commentsDel,abuseAdDelegate;

static NSString * details_url = @"/json/ad-details?adId=%li";
static NSString * post_comment_url = @"/json/post-comment";
static NSString * get_ad_comments_url = @"/json/get-ad-comments?adId=%@&pageNo=%@&pageSize=%@";
static NSString * abuse_ad_url = @"/json/report-abuse?adID=%i&reasonID=%i";


static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = nil;
        self.commentsDel = nil;
        self.abuseAdDelegate = nil;
        details_url = [API_MAIN_URL stringByAppendingString:details_url];
        post_comment_url = [API_MAIN_URL stringByAppendingString:post_comment_url];
        get_ad_comments_url = [API_MAIN_URL stringByAppendingString:get_ad_comments_url];
        abuse_ad_url = [API_MAIN_URL stringByAppendingString:abuse_ad_url];

        
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

- (NSUInteger) nextPage {
    self.commentsPageNumber ++;
    return self.commentsPageNumber;
}

- (NSUInteger) getCurrentCommentsPageNum {
    return self.commentsPageNumber;
}

- (NSUInteger) getCurrentCommentsPageSize {
    return self.commentsPageSize;
}


- (void) setCurrentCommentsPageNum:(NSUInteger) pNum {
    self.commentsPageNumber = pNum;
}

- (void) setCurrentCommentsPageSize:(NSUInteger) pSize {
    self.commentsPageSize = pSize;
}

- (void) setCommentsPageSizeToDefault {
    self.commentsPageSize = DEFAULT_COMMENTS_PAGE_SIZE;
}

- (void) loadCarDetailsOfAdID:(NSUInteger) adID WithDelegate:(id <CarDetailsManagerDelegate>) del {
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
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

- (void) postCommentForAd:(NSUInteger) adID WithText:(NSString *) commentText WithDelegate:(id <CommentsDelegate>) del {
    
    //1- set the delegate
    self.commentsDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    NSString * fullURLString = post_comment_url;
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        //post keys
        NSString * prePost =[NSString stringWithFormat:@"AdID=%i&CommentText=%@",adID, commentText];
        
        
        
        NSString * post = [prePost stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //[request setTimeoutInterval:60];
        
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
        
        postCommentMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.commentsDel)
            [self.commentsDel commentsDidFailPostingWithError:error];
        return ;
    }
    
}

- (void) getAdCommentsForAd:(NSUInteger)adID OfPage:(NSUInteger)pageNum WithDelegate:(id<CommentsDelegate>)del {
    //1- set the delegate
    self.commentsDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:get_ad_comments_url,
                                [NSString stringWithFormat:@"%i", adID],
                                [NSString stringWithFormat:@"%i", pageNum],
                                [NSString stringWithFormat:@"%i", self.commentsPageSize]];
    
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
        getCommentsMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.commentsDel)
            [self.commentsDel commentsDidFailLoadingWithError:error];
        return ;
    }

}


- (void) abuseForAd:(NSUInteger) adID WithReason:(NSInteger) reasonID WithDelegate:(id <AbuseAdDelegate>) del {
    
    //1- set the delegate
    self.abuseAdDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:abuse_ad_url,
                                adID,
                                reasonID];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
        abuseMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.abuseAdDelegate)
            [self.abuseAdDelegate abuseDidFailLoadingWithError:error];
        return ;
    }
    
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
    else if (manager == abuseMngr) {
        
        if (self.abuseAdDelegate)
            [abuseAdDelegate abuseDidFailLoadingWithError:error];
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
        else if (manager == abuseMngr) {
            
            if (self.abuseAdDelegate)
                [abuseAdDelegate abuseDidFailLoadingWithError:error];
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
            
            if (self.commentsDel) {

                CommentOnAd * comment = nil;
                NSArray * data = (NSArray *) result;
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
                            
                            //3- create the object
                            comment = [[CommentOnAd alloc]
                             initWithAdIDString:[dataDict objectForKey:COMMENTS_AD_ID_JKEY]
                             commentIDString:[dataDict objectForKey:COMMENTS_COMMENT_ID_JKEY]
                             commentTextString:[dataDict objectForKey:COMMENTS_COMMENT_TEXT_JKEY]
                             postedByIDString:[dataDict objectForKey:COMMENTS_POSTED_BY_ID_JKEY]
                             postedOnDateString:[dataDict objectForKey:COMMENTS_POSTED_ON_JKEY]
                             userNameString:[dataDict objectForKey:COMMENTS_USERNAME_JKEY]
                             ];
                        }
                    }
                    else {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        
                        if (self.commentsDel) {
                            [self.commentsDel commentsDidFailPostingWithError:error];
                            return;
                        }
                    }
                    //NSLog(@"comment is: %@", result);

                    if (comment)
                        [self.commentsDel commentsDidPostWithData:comment];
                    else {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        [self.commentsDel commentsDidFailPostingWithError:error];
                    }
                    

                }
            }
            
        }
        
        else if (manager == getCommentsMngr)
        {
            
            if (self.commentsDel) {
                NSArray * commentsArray = [self createCommentsArrayWithData:(NSArray *)result];
                [self.commentsDel commentsDidFinishLoadingWithData:commentsArray];
            }
            
        }
        else if (manager == abuseMngr)
        {
            NSArray * data = (NSArray *) result;
            if ((data) && (data.count > 0))
            {
                NSDictionary * totalDict = [data objectAtIndex:0];
                NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:DETAILS_STATUS_CODE_JKEY]];
                NSInteger statusCode = statusCodeString.integerValue;
                
                NSString * statusMessageProcessed = [[[totalDict objectForKey:DETAILS_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                
                if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                {
                    if (self.abuseAdDelegate)
                        [self.abuseAdDelegate abuseDidFinishLoadingWithData:YES];
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    if (self.abuseAdDelegate)
                        [self.abuseAdDelegate abuseDidFailLoadingWithError:error];
                }
            }
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

- (NSArray * ) createCommentsArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:DETAILS_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        NSString * statusMessageProcessed = [[[totalDict objectForKey:DETAILS_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        
        NSMutableArray * comments = [NSMutableArray new];
        if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
        {
            //NSDictionary * dataDict = [totalDict objectForKey:DETAILS_DATA_JKEY];
            NSArray * dataCommentsArray = [totalDict objectForKey:DETAILS_DATA_JKEY];
            if ((dataCommentsArray) && (![@"" isEqualToString:(NSString *)dataCommentsArray]) && (dataCommentsArray.count)) {
                
                for (NSDictionary * cDict in dataCommentsArray)
                {
                    //3- create the object
                    CommentOnAd * comment = [[CommentOnAd alloc]
                                initWithAdIDString:[cDict objectForKey:COMMENTS_AD_ID_JKEY]
                                commentIDString:[cDict objectForKey:COMMENTS_COMMENT_ID_JKEY]
                                commentTextString:[cDict objectForKey:COMMENTS_COMMENT_TEXT_JKEY]
                                postedByIDString:[cDict objectForKey:COMMENTS_POSTED_BY_ID_JKEY]
                                postedOnDateString:[cDict objectForKey:COMMENTS_POSTED_ON_JKEY]
                                userNameString:[cDict objectForKey:COMMENTS_USERNAME_JKEY]
                                ];
                    
                    [comments addObject:comment];
                }
            }
        }
        return comments;
    }
    return [NSArray new];
    
}
@end
