//
//  AdsManager.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AdsManager.h"

#define LISTING_STATUS_CODE_JKEY    @"StatusCode"
#define LISTING_STATUS_MSG_JKEY     @"StatusMessage"
#define LISTING_DATA_JKEY           @"Data"

#pragma mark - file names
#define CATEGORIES_FOR_SALE_FILE_NAME   @"Categories_sale.json"
#define CATEGORIES_FOR_RENT_FILE_NAME   @"Categories_rent.json"

#pragma mark - ad json keys

#define CAT_ID      @"categoryid"
#define CAT_NAME    @"CategoryName"
#define CAT_NAME_EN @"CategoryNameEn"

#define AD_AREA_JKEY @"Area"
#define AD_AD_ID_JKEY @"AdID"
#define AD_OWNER_ID_JKEY @"OwnerID"
#define AD_STORE_ID_JKEY @"StoreID"
#define AD_IS_FEATURED_JKEY @"IsFeatured"
#define AD_THUMBNAIL_URL_JKEY @"ThumbnailURL"
#define AD_TITLE_JKEY @"Title"
#define AD_PRICE_JKEY @"Price"
#define AD_CURRENCY_JKEY @"Currency"
#define AD_POSTED_ON_JKEY @"PostedOn"
#define AD_VIEW_COUNT_JKEY @"ViewCount"
#define AD_IS_FAVORITE_JKEY @"IsFavorite"
#define AD_STORE_NAME_JKEY @"StoreName"
#define AD_STORE_LOGO_URL_JKEY @"StoreLogoURL"
#define AD_POSTED_FROM_CITY_ID_JKEY @"PostedFromCityID"
#define AD_CAT_ID_JKEY @"CategoryID"
#define AD_MAIN_CAT_ID_JKEY @"MainCategoryID"
#define AD_ROOMS_JKEY @"Rooms"
#define AD_ROOMS_COUNT_JKEY @"RoomsCount"
#define AD_ENC_EDIT_ID_JKEY @"EncEditID"
#define AD_AD_URL_JKEY @"AdURL"
#define AD_COUNTRY_ID_JKEY @"CountryID"
#define AD_LONGITUDE_JKEY @"Longitude"
#define AD_LATITUDE_JKEY @"Latitude"


#define UPLOAD_IMAGE_URL_JKEY           @"URL"
#define UPLOAD_IMAGE_CREATIVE_ID_JKEY   @"CreativeID"

#pragma mark - literals

#define DEFAULT_PAGE_SIZE           50

#define ARABIC_BEFORE_TEXT          @"قبل"
#define ARABIC_SECOND_TEXT          @"ثانية"
#define ARABIC_MINUTE_TEXT          @"دقيقة"
#define ARABIC_LESS_MINUTE_TEXT     @"قبل دقيقة"
#define ARABIC_HOUR_TEXT            @"ساعة"
#define ARABIC_DAY_TEXT             @"يوم"
#define ARABIC_WEEK_TEXT            @"أسبوع"
#define ARABIC_MONTH_TEXT           @"شهر"
#define ARABIC_YEAR_TEXT            @"سنة"

#define SALE_PURPOSE                @"sale"
#define RENT_PURPOSE                @""


@interface AdsManager ()
{
    NSFileManager * fileMngr;
    
    InternetManager * browseAdsMngr;
    InternetManager * uploadImageMngr;

    InternetManager * requestEditAdMngr;
    InternetManager * requestEditStoreMngr;
    
    InternetManager * postAdMngr;
    InternetManager * storePostAdMngr;
    InternetManager * editAdMngr;
    InternetManager * editStoreAdMngr;
    
    InternetManager * sendEmailMngr;
    InternetManager * categoriesCountMngr;

    NSMutableArray * categoriesForSaleArray;
    NSMutableArray * categoriesForRentArray;
    
}
@end

@implementation AdsManager

static NSString * ads_url = @"/json/searchads?pageNo=%@&pageSize=%@&cityId=%i&textTerm=%@&subcatId=%@&serviceType=%@&minPrice=%@&maxPrice=%@&adsWithImages=%@&adsWithPrice=%@&area=%@&orderby=%@&lastRefreshed=%@&noofroomsid=%@&purpose=%@&withGeo=%@&longituted=%@&latituted=%@&radius=%@&currency=%@";

static NSString * upload_image_url = @"/json/upload-image?theFile=";
static NSString * post_sale_ad_url = @"/json/post-an-ad-sale?subcatid=%@&cityId=%@&fromPhone=%i&userEmail=%@&noOfRooms=%@&collection=%@";
static NSString * post_rent_ad_url = @"/json/post-an-ad-rent?subcatid=%@&cityId=%@&fromPhone=%i&userEmail=%@&noOfRooms=%@&collection=%@";

static NSString * post_sale_store_ad_url = @"/json/post-a-store-ad-sale?subcatid=%@&cityid=%@&storeid=%@&noofrooms=%@&collection=";
static NSString * post_rent_store_ad_url = @"/json/post-a-store-ad-rent?subcatid=%@&cityid=%@&storeid=%@&noofrooms=%@&collection=";
static NSString * user_ads_url = @"/json/myads?status=%@&pageNo=%@&pageSize=%@";
static NSString * request_edit_ads_url = @"/json/request-to-edit?encEditID=%@";
static NSString * request_edit_store_ads_url = @"/json/request-to-edit-store-ad?encAdId=%@&storeId=%@";
static NSString * edit_sale_id_url = @"/json/update-ad-sale?country=%@&city=%@&enceditid=%@&noofrooms=%@&collection=%@";
static NSString * edit_rent_id_url = @"/json/update-ad-rent?country=%@&city=%@&enceditid=%@&noofrooms=%@&collection=%@";
static NSString * edit_store_sale_ad_id_url = @"/json/update-store-ad-sale?encEditID=%@&storeId=%@&noOfRooms=%@";
static NSString * edit_store_rent_ad_id_url = @"/json/update-store-ad-rent?encEditID=%@&storeId=%@&noOfRooms=%@";
static NSString * sending_email_id_url = @"/json/send-an-email";
static NSString * categories_count_id_url = @"/json/getsubcategoriesadscount?parentCategoryName=%@&cityID=%i&servicetype=%@";

static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        //set all the delegates to nil
        self.browseAdsDel = nil;
        self.requestEditAdDel = nil;
        self.requestEditStoreDel = nil;
        self.uploadImageDel = nil;
        self.postAdDel = nil;
        self.storePostAdDel = nil;
        self.sendEmailDel = nil;
        self.categoriesCountDelegate = nil;

        categoriesForSaleArray = nil;
        categoriesForRentArray = nil;
        
        self.pageNumber = 0;
        self.pageSize = DEFAULT_PAGE_SIZE;
        ads_url = [API_MAIN_URL stringByAppendingString:ads_url];
        upload_image_url = [API_MAIN_URL stringByAppendingString:upload_image_url];
        post_sale_ad_url = [API_MAIN_URL stringByAppendingString:post_sale_ad_url];
        post_rent_ad_url = [API_MAIN_URL stringByAppendingString:post_rent_ad_url];
        post_sale_store_ad_url = [API_MAIN_URL stringByAppendingString:post_sale_store_ad_url];
        post_rent_store_ad_url = [API_MAIN_URL stringByAppendingString:post_rent_store_ad_url];
        user_ads_url = [API_MAIN_URL stringByAppendingString:user_ads_url];
        request_edit_ads_url = [API_MAIN_URL stringByAppendingString:request_edit_ads_url];
        request_edit_store_ads_url = [API_MAIN_URL stringByAppendingString:request_edit_store_ads_url];
        edit_sale_id_url = [API_MAIN_URL stringByAppendingString:edit_sale_id_url];
        edit_rent_id_url = [API_MAIN_URL stringByAppendingString:edit_rent_id_url];
        edit_store_sale_ad_id_url = [API_MAIN_URL stringByAppendingString:edit_store_sale_ad_id_url];
        edit_store_rent_ad_id_url = [API_MAIN_URL stringByAppendingString:edit_store_rent_ad_id_url];
        sending_email_id_url = [API_MAIN_URL stringByAppendingString:sending_email_id_url];
        categories_count_id_url = [API_MAIN_URL stringByAppendingString:categories_count_id_url];

    }
    return self;
}

+ (AdsManager *) sharedInstance {
    static AdsManager * instance = nil;
    if (instance == nil) {
        instance = [[AdsManager alloc] init];
    }
    return instance;
    
}

- (NSUInteger) nextPage {
    self.pageNumber ++;
    return self.pageNumber;
}

- (NSUInteger) getCurrentPageNum {
    return self.pageNumber;
}

- (NSUInteger) getCurrentPageSize {
    return self.pageSize;
}


- (void) setCurrentPageNum:(NSUInteger) pNum {
    self.pageNumber = pNum;
}

- (void) setCurrentPageSize:(NSUInteger) pSize {
    self.pageSize = pSize;
}

- (void) setPageSizeToDefault {
    self.pageSize = DEFAULT_PAGE_SIZE;
}

//load
- (void) loadAdsOfPage:(NSUInteger) pageNum forSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID andPurpose:(NSString*)purpose WithDelegate:(id <BrowseAdsDelegate>) del
{
    
    //1- set the delegate
    self.browseAdsDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.browseAdsDel)
            [self.browseAdsDel adsDidFailLoadingWithError:error];
        return ;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:ads_url,
                                [NSString stringWithFormat:@"%i", pageNum],
                                [NSString stringWithFormat:@"%i", self.pageSize],
                                cityID,
                                @"",
                                [NSString stringWithFormat:@"%@", (subCatID == -1 ? @"" : [NSString stringWithFormat:@"%i", subCatID])],
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                purpose,
                                @"",
                                @"",
                                @"",
                                @"",@""];
    
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
        browseAdsMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.browseAdsDel)
            [self.browseAdsDel adsDidFailLoadingWithError:error];
        return ;
    }
    
}

- (void) loadUserAdsOfStatus:(NSString*) status forPage:(NSUInteger) pageNum andSize:(NSInteger) pageSize WithDelegate:(id <BrowseAdsDelegate>) del {
    
    //1- set the delegate
    self.browseAdsDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:user_ads_url,
                                status,
                                [NSString stringWithFormat:@"%i", pageNum],
                                [NSString stringWithFormat:@"%i", self.pageSize]];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSString * correctURLstring = @"http://gfctest.edanat.com/v1.0/json/searchads?pageNo=1&pageSize=50&cityId=13&textTerm=&brandId=208&modelId=2008&minPrice=&maxPrice=&destanceRange=&fromYear=&toYear=&adsWithImages=&adsWithPrice=&area=&orderby=";
    
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
        browseAdsMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.browseAdsDel)
            [self.browseAdsDel adsDidFailLoadingWithError:error];
        return ;
    }
    
}


- (void) sendEmailofName:(NSString*) UserName withEmail:(NSString*) emailAddress phoneNumber:(NSInteger) phone message:(NSString*) SubjectMessage withAdID:(NSInteger)AdID WithDelegate:(id <SendEmailDelegate>) del {
    
    //1- set the delegate
    self.sendEmailDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    NSString * fullURLString = sending_email_id_url;
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        
        //3- start the request
        NSString * post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                           @"Name", UserName,
                           @"Phone", [NSString stringWithFormat:@"%i", phone],
                           @"Email", emailAddress,
                           @"Message",SubjectMessage,
                           @"AdID",[NSString stringWithFormat:@"%i", AdID]
                           ];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:60];
        
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
        
        sendEmailMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
        
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.sendEmailDel)
            [self.sendEmailDel EmailDidFailSendingWithError:error];
        return ;
    }
    
}

- (void) searchCarAdsOfPage:(NSUInteger) pageNum
             forSubCategory:(NSInteger) subCatID
                     InCity:(NSUInteger) cityID
                   textTerm:(NSString *) aTextTerm
                serviceType:(NSString *) aServiceType
                   minPrice:(NSString *) aMinPrice
                   maxPrice:(NSString *) aMaxPrice
              adsWithImages:(BOOL) aAdsWithImages
               adsWithPrice:(BOOL) aAdsWithPrice
                       area:(NSString *) aArea
                    orderby:(NSString *) aOrderby
              lastRefreshed:(NSString *) aLastRefreshed
               numOfRoomsID:(NSString *) aNumOfRoomsIDString
                    purpose:(NSString *) aPurpose
                    withGeo:(NSString *) aWithGeo
                  longitute:(NSString *) aLongitute
                   latitute:(NSString *) aLatitute
                     radius:(NSString *) aRadius
                   currency:(NSString *) aCurrency
               WithDelegate:(id <BrowseAdsDelegate>) del {
    
    //1- set the delegate
    self.browseAdsDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.browseAdsDel)
            [self.browseAdsDel adsDidFailLoadingWithError:error];
        return ;
    }
    
    //3- set the url string
    NSString * fullURLString =
    [NSString stringWithFormat:ads_url,
     [NSString stringWithFormat:@"%i", pageNum],
     [NSString stringWithFormat:@"%i", self.pageSize],
     cityID,
     aTextTerm,
     [NSString stringWithFormat:@"%@", (subCatID == -1 ? @"" : [NSString stringWithFormat:@"%i", subCatID])],
     aServiceType,
     aMinPrice,
     aMaxPrice,
     (aAdsWithImages ? [NSString stringWithFormat:@"%i", aAdsWithImages]: @""),
     (aAdsWithPrice ? [NSString stringWithFormat:@"%i", aAdsWithPrice] : @""),
     aArea,
     aOrderby,
     aLastRefreshed,
     aNumOfRoomsIDString,
     aPurpose,
     aWithGeo,
     aLongitute,
     aLatitute,
     aRadius,aCurrency
     ];
    
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
        browseAdsMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.browseAdsDel)
            [self.browseAdsDel adsDidFailLoadingWithError:error];
        return ;
    }
    
}

- (void) postAdForSaleOfCategory:(NSUInteger) categoryID
                   InCity:(NSUInteger) cityID
                userEmail:(NSString *) usermail
                    title:(NSString *) aTitle
              description:(NSString *) aDescription
                 adPeriod:(NSInteger)aPeriodID
           requireService:(NSInteger)aServiceID
                    price:(NSString *) aPrice
          currencyValueID:(NSInteger) aCurrencyValueID
                unitPrice:(NSString*)aUnitPrice
                 unitType:(NSInteger)aUnitTypeID
                 imageIDs:(NSArray *) aImageIDsArray
                longitude:(NSString*)aLongitude
                 latitude:(NSString*)aLatitude
               roomNumber:(NSString*) aRoomNumber
                    space:(NSString *) aSpace
                     area:(NSString *) aArea
                   mobile:(NSString *) aMobileNum
               phoneNumer:(NSString *) aPhoneNumer
             withDelegate:(id <PostAdDelegate>) del {
    
    //1- set the delegate
    self.postAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
       // [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@";
    NSString * fullURLString = [NSString stringWithFormat:post_sale_ad_url,
                                [NSString stringWithFormat:@"%i", categoryID],
                                [NSString stringWithFormat:@"%i", cityID],
                                1, //the fromPhone is 1 for iOS
                                usermail,
                                (aRoomNumber) ? aRoomNumber : @"",
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
       // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        //NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%i",
                              205,aTitle,
                              216,aDescription,
                              405,aPeriodID,
                              209,aServiceID,
                              211,aPrice,
                              212,aCurrencyValueID,
                              698,aUnitTypeID,
                              700,aUnitPrice,
                              -100,usermail,
                              //-99,cityID,
                              IMAGES_ID_POST_KEY,aImageIDsArray,
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              1049,aSpace,
                              1002,aArea,
                              222,aMobileNum,
                              867,aPhoneNumer,
                              895,1];
        
        /*
         NSString * prePost = @"524=text&523=نص&507=987123&502=1189&520=3210987456&508=1235&505=830&509=1207&518=321789&528=&868=&907=1&1076=2675&952=1553&ImagesID=7730822,7730862";
         */
        
        
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
        
        postAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.postAdDel)
            [self.postAdDel adDidFailPostingWithError:error];
        return ;
    }
    
}

- (void) postAdForRentOfCategory:(NSUInteger) categoryID
                          InCity:(NSUInteger) cityID
                       userEmail:(NSString *) usermail
                           title:(NSString *) aTitle
                     description:(NSString *) aDescription
                        adPeriod:(NSInteger)aPeriodID
                  requireService:(NSInteger)aServiceID
                           price:(NSString *) aPrice
                 currencyValueID:(NSInteger) aCurrencyValueID
                       unitPrice:(NSString*)aUnitPrice
                        unitType:(NSInteger)aUnitTypeID
                        imageIDs:(NSArray *) aImageIDsArray
                       longitude:(NSString*)aLongitude
                        latitude:(NSString*)aLatitude
                      roomNumber:(NSString*) aRoomNumber
                           space:(NSString *) aSpace
                            area:(NSString *) aArea
                          mobile:(NSString *) aMobileNum
                      phoneNumer:(NSString *) aPhoneNumer
                    withDelegate:(id <PostAdDelegate>) del {
    
    //1- set the delegate
    self.postAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        // [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@";
    NSString * fullURLString = [NSString stringWithFormat:post_rent_ad_url,
                                [NSString stringWithFormat:@"%i", categoryID],
                                [NSString stringWithFormat:@"%i", cityID],
                                1, //the fromPhone is 1 for iOS
                                usermail,
                                aRoomNumber,
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        //NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@",
                              1003,aTitle,
                              1004,aDescription,
                              1005,aPeriodID,
                              1007,aServiceID,
                              1013,aPrice,
                              1014,aCurrencyValueID,
                              1015,aUnitTypeID,
                              1016,aUnitPrice,
                              -100,usermail,
                              //-99,cityID,
                              IMAGES_ID_POST_KEY,aImageIDsArray,
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              1050,aSpace,
                              1012,aArea,
                              1006,aMobileNum,
                              1010,aPhoneNumer];
        
        /*
         NSString * prePost = @"524=text&523=نص&507=987123&502=1189&520=3210987456&508=1235&505=830&509=1207&518=321789&528=&868=&907=1&1076=2675&952=1553&ImagesID=7730822,7730862";
         */
        
        
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
        
        postAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.postAdDel)
            [self.postAdDel adDidFailPostingWithError:error];
        return ;
    }
    
}

- (void) postStoreAdForSaleOfCategory:(NSUInteger) categoryID
                       myStore:(NSInteger) StoreID
                        InCity:(NSUInteger) cityID
                     userEmail:(NSString *) usermail
                         title:(NSString *) aTitle
                   description:(NSString *) aDescription
                      adPeriod:(NSInteger)aPeriodID
                requireService:(NSInteger)aServiceID
                         price:(NSString *) aPrice
               currencyValueID:(NSInteger) aCurrencyValueID
                     unitPrice:(NSString*)aUnitPrice
                      unitType:(NSInteger)aUnitTypeID
                      imageIDs:(NSArray *) aImageIDsArray
                     longitude:(NSString*)aLongitude
                      latitude:(NSString*)aLatitude
                    roomNumber:(NSString*) aRoomNumber
                         space:(NSString *) aSpace
                          area:(NSString *) aArea
                        mobile:(NSString *) aMobileNum
                    phoneNumer:(NSString *) aPhoneNumer
                  withDelegate:(id <StorePostAdDelegate>) del {
    
    //1- set the delegate
    self.storePostAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@";
    NSString * fullURLString = [NSString stringWithFormat:post_sale_store_ad_url,
                                [NSString stringWithFormat:@"%i", categoryID],
                                [NSString stringWithFormat:@"%i", cityID],
                                [NSString stringWithFormat:@"%i", StoreID],
                                aRoomNumber,
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        //NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%i",
                              205,aTitle,
                              216,aDescription,
                              405,aPeriodID,
                              209,aServiceID,
                              211,aPrice,
                              212,aCurrencyValueID,
                              698,aUnitTypeID,
                              700,aUnitPrice,
                              895,1,
                              -100,usermail,
                              IMAGES_ID_POST_KEY,([aImageIDsArray count] == 0 ? @"" : aImageIDsArray),
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              847,aRoomNumber,
                              1049,aSpace,
                              1002,aArea,
                              222,aMobileNum,
                              867,aPhoneNumer,
                              10091,@"",
                              -98,categoryID];
        
        /*
         NSString * prePost = @"524=text&523=نص&507=987123&502=1189&520=3210987456&508=1235&505=830&509=1207&518=321789&528=&868=&907=1&1076=2675&952=1553&ImagesID=7730822,7730862";
         */
        
        
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
        
        storePostAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.storePostAdDel)
            [self.storePostAdDel storeAdDidFailPostingWithError:error];
        return ;
    }
    
}

- (void) postStoreAdForRentOfCategory:(NSUInteger) categoryID
                              myStore:(NSInteger) StoreID
                               InCity:(NSUInteger) cityID
                            userEmail:(NSString *) usermail
                                title:(NSString *) aTitle
                          description:(NSString *) aDescription
                             adPeriod:(NSInteger)aPeriodID
                       requireService:(NSInteger)aServiceID
                                price:(NSString *) aPrice
                      currencyValueID:(NSInteger) aCurrencyValueID
                            unitPrice:(NSString*)aUnitPrice
                             unitType:(NSInteger)aUnitTypeID
                             imageIDs:(NSArray *) aImageIDsArray
                            longitude:(NSString*)aLongitude
                             latitude:(NSString*)aLatitude
                           roomNumber:(NSString *) aRoomNumber
                                space:(NSString *) aSpace
                                 area:(NSString *) aArea
                               mobile:(NSString *) aMobileNum
                           phoneNumer:(NSString *) aPhoneNumer
                         withDelegate:(id <StorePostAdDelegate>) del {
    
    //1- set the delegate
    self.storePostAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@";
    NSString * fullURLString = [NSString stringWithFormat:post_rent_store_ad_url,
                                [NSString stringWithFormat:@"%i", categoryID],
                                [NSString stringWithFormat:@"%i", cityID],
                                [NSString stringWithFormat:@"%i", StoreID],
                                aRoomNumber,
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        //NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%i&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@",
                              1003,aTitle,
                              1004,aDescription,
                              1005,aPeriodID,
                              1007,aServiceID,
                              1013,aPrice,
                              1014,aCurrencyValueID,
                              1015,aUnitTypeID,
                              1016,aUnitPrice,
                              -98,categoryID,
                              -180,cityID,
                              -181,0,
                              -100,usermail,
                              IMAGES_ID_POST_KEY,([aImageIDsArray count] == 0 ? @"" : aImageIDsArray),
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              1050,aSpace,
                              1012,aArea,
                              1006,aMobileNum,
                              1010,aPhoneNumer,
                              10092,@""];
        
        /*
         NSString * prePost = @"524=text&523=نص&507=987123&502=1189&520=3210987456&508=1235&505=830&509=1207&518=321789&528=&868=&907=1&1076=2675&952=1553&ImagesID=7730822,7730862";
         */
        
        
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
        
        storePostAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.storePostAdDel)
            [self.storePostAdDel storeAdDidFailPostingWithError:error];
        return ;
    }
    
}


- (void) requestToEditAdsOfEditID:(NSString*) EditID WithDelegate:(id <RequestEditAdDelegate>) del {
    
    //1- set the delegate
    self.requestEditAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:request_edit_ads_url,EditID];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSString * correctURLstring = @"http://gfctest.edanat.com/v1.0/json/searchads?pageNo=1&pageSize=50&cityId=13&textTerm=&brandId=208&modelId=2008&minPrice=&maxPrice=&destanceRange=&fromYear=&toYear=&adsWithImages=&adsWithPrice=&area=&orderby=";
    
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
        requestEditAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.requestEditAdDel)
            [self.requestEditAdDel RequestToEditFailWithError:error];
        return ;
    }
    
}

- (void) requestToEditStoreAdsOfEditID:(NSString*) EditID andStore:(NSString*)StoreID WithDelegate:(id <RequestEditStoreDelegate>) del {
    
    //1- set the delegate
    self.requestEditStoreDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:request_edit_store_ads_url,EditID,StoreID];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSString * correctURLstring = @"http://gfctest.edanat.com/v1.0/json/searchads?pageNo=1&pageSize=50&cityId=13&textTerm=&brandId=208&modelId=2008&minPrice=&maxPrice=&destanceRange=&fromYear=&toYear=&adsWithImages=&adsWithPrice=&area=&orderby=";
    
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
        requestEditStoreMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.requestEditStoreDel)
            [self.requestEditStoreDel RequestToEditStoreFailWithError:error];
        return ;
    }
    
}


- (void) editAdForSaleOfEditadID:(NSString*) editADID
                      OfCategory:(NSUInteger) categoryID
                    inCountryID :(NSInteger)countryID
                          InCity:(NSUInteger) cityID
                       userEmail:(NSString *) usermail
                           title:(NSString *) aTitle
                     description:(NSString *) aDescription
                        adPeriod:(NSInteger)aPeriodID
                  requireService:(NSInteger)aServiceID
                           price:(NSString *) aPrice
                 currencyValueID:(NSInteger) aCurrencyValueID
                       unitPrice:(NSString*)aUnitPrice
                        unitType:(NSInteger)aUnitTypeID
                        imageIDs:(NSArray *) aImageIDsArray
                       longitude:(NSString*)aLongitude
                        latitude:(NSString*)aLatitude
                      roomNumber:(NSString*) aRoomNumber
                           space:(NSString *) aSpace
                            area:(NSString *) aArea
                          mobile:(NSString *) aMobileNum
                      phoneNumer:(NSString *) aPhoneNumer
                    withDelegate:(id <PostAdDelegate>) del {
    
    //1- set the delegate
    self.postAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@;
    ///country=%@&city=%@&enceditid=%@&collection=%@;
    NSString * fullURLString = [NSString stringWithFormat:edit_sale_id_url,
                                [NSString stringWithFormat:@"%i", countryID],
                                [NSString stringWithFormat:@"%i", cityID],
                                editADID,
                                aRoomNumber,
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        // NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%i&%i=%i&%i=%i",
                              205,aTitle,
                              216,aDescription,
                              405,aPeriodID,
                              209,aServiceID,
                              211,aPrice,
                              212,aCurrencyValueID,
                              698,aUnitTypeID,
                              700,aUnitPrice,
                              -100,usermail,
                              //-99,cityID,
                              IMAGES_ID_POST_KEY,aImageIDsArray,
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              1049,aSpace,
                              1002,aArea,
                              222,aMobileNum,
                              867,aPhoneNumer,
                              895,1,
                              -98,categoryID,
                              -99,cityID];

        
        
        
        
        /*
         NSString * prePost = @"524=text&523=نص&507=987123&502=1189&520=3210987456&508=1235&505=830&509=1207&518=321789&528=&868=&907=1&1076=2675&952=1553&ImagesID=7730822,7730862";
         */
        
        
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
        
        editAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.postAdDel)
            [self.postAdDel adDidFailEditingWithError:error];
        return ;
    }
    
}

- (void) editAdForRentOfEditadID:(NSString*) editADID
                      OfCategory:(NSUInteger)categoryID
                    inCountryID :(NSInteger)countryID
                          InCity:(NSUInteger) cityID
                       userEmail:(NSString *) usermail
                           title:(NSString *) aTitle
                     description:(NSString *) aDescription
                        adPeriod:(NSInteger)aPeriodID
                  requireService:(NSInteger)aServiceID
                           price:(NSString *) aPrice
                 currencyValueID:(NSInteger) aCurrencyValueID
                       unitPrice:(NSString*)aUnitPrice
                        unitType:(NSInteger)aUnitTypeID
                        imageIDs:(NSArray *) aImageIDsArray
                       longitude:(NSString*)aLongitude
                        latitude:(NSString*)aLatitude
                      roomNumber:(NSString*) aRoomNumber
                           space:(NSString *) aSpace
                            area:(NSString *) aArea
                          mobile:(NSString *) aMobileNum
                      phoneNumer:(NSString *) aPhoneNumer
                    withDelegate:(id <PostAdDelegate>) del {
    
    //1- set the delegate
    self.postAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@;
    ///country=%@&city=%@&enceditid=%@&collection=%@;
    NSString * fullURLString = [NSString stringWithFormat:edit_rent_id_url,
                                [NSString stringWithFormat:@"%i", countryID],
                                [NSString stringWithFormat:@"%i", cityID],
                                editADID,
                                aRoomNumber,
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        // NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%i&%i=%i&%i=%i",
                              1003,aTitle,
                              1004,aDescription,
                              1005,aPeriodID,
                              1007,aServiceID,
                              1013,aPrice,
                              1014,aCurrencyValueID,
                              1015,aUnitTypeID,
                              1016,aUnitPrice,
                              -100,usermail,
                              //-99,cityID,
                              IMAGES_ID_POST_KEY,aImageIDsArray,
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              1050,aSpace,
                              1012,aArea,
                              1006,aMobileNum,
                              1010,aPhoneNumer,
                              1017,1,
                              -98,categoryID,
                              -99,cityID];
        
        
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
        
        editAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.postAdDel)
            [self.postAdDel adDidFailEditingWithError:error];
        return ;
    }
    
}


- (void) editAdStoreForSaleOfEditadID:(NSString*) editADID
                              myStore:(NSInteger) StoreID
                           OfCategory:(NSUInteger) categoryID
                         inCountryID :(NSInteger)countryID
                               InCity:(NSUInteger) cityID
                            userEmail:(NSString *) usermail
                                title:(NSString *) aTitle
                          description:(NSString *) aDescription
                             adPeriod:(NSInteger)aPeriodID
                       requireService:(NSInteger)aServiceID
                                price:(NSString *) aPrice
                      currencyValueID:(NSInteger) aCurrencyValueID
                            unitPrice:(NSString*)aUnitPrice
                             unitType:(NSInteger)aUnitTypeID
                             imageIDs:(NSArray *) aImageIDsArray
                            longitude:(NSString*)aLongitude
                             latitude:(NSString*)aLatitude
                           roomNumber:(NSString*) aRoomNumber
                                space:(NSString *) aSpace
                                 area:(NSString *) aArea
                               mobile:(NSString *) aMobileNum
                           phoneNumer:(NSString *) aPhoneNumer
                         withDelegate:(id <StorePostAdDelegate>) del {
    
    //1- set the delegate
    self.storePostAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@;
    ///country=%@&city=%@&enceditid=%@&collection=%@;
    NSString * fullURLString = [NSString stringWithFormat:edit_store_sale_ad_id_url,
                                editADID,
                                [NSString stringWithFormat:@"%i", StoreID],
                                aRoomNumber];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        // NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%i&%i=%i&%i=%i",
                              205,aTitle,
                              216,aDescription,
                              405,aPeriodID,
                              209,aServiceID,
                              211,aPrice,
                              212,aCurrencyValueID,
                              698,aUnitTypeID,
                              700,aUnitPrice,
                              -100,usermail,
                              //-99,cityID,
                              IMAGES_ID_POST_KEY,aImageIDsArray,
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              1049,aSpace,
                              1002,aArea,
                              222,aMobileNum,
                              867,aPhoneNumer,
                              895,1,
                              -98,categoryID,
                              -99,cityID];
        
        
        
        
        
        /*
         NSString * prePost = @"524=text&523=نص&507=987123&502=1189&520=3210987456&508=1235&505=830&509=1207&518=321789&528=&868=&907=1&1076=2675&952=1553&ImagesID=7730822,7730862";
         */
        
        
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
        
        editStoreAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.storePostAdDel)
            [self.storePostAdDel storeAdDidFailEditingWithError:error];
        return ;
    }
    
}

- (void) editAdStoreForRentOfEditadID:(NSString*) editADID
                              myStore:(NSInteger) StoreID
                           OfCategory:(NSUInteger) categoryID
                         inCountryID :(NSInteger)countryID
                               InCity:(NSUInteger) cityID
                            userEmail:(NSString *) usermail
                                title:(NSString *) aTitle
                          description:(NSString *) aDescription
                             adPeriod:(NSInteger)aPeriodID
                       requireService:(NSInteger)aServiceID
                                price:(NSString *) aPrice
                      currencyValueID:(NSInteger) aCurrencyValueID
                            unitPrice:(NSString*)aUnitPrice
                             unitType:(NSInteger)aUnitTypeID
                             imageIDs:(NSArray *) aImageIDsArray
                            longitude:(NSString*)aLongitude
                             latitude:(NSString*)aLatitude
                           roomNumber:(NSString*) aRoomNumber
                                space:(NSString *) aSpace
                                 area:(NSString *) aArea
                               mobile:(NSString *) aMobileNum
                           phoneNumer:(NSString *) aPhoneNumer
                         withDelegate:(id <StorePostAdDelegate>) del {
    
    //1- set the delegate
    self.storePostAdDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@;
    ///country=%@&city=%@&enceditid=%@&collection=%@;
    NSString * fullURLString = [NSString stringWithFormat:edit_store_rent_ad_id_url,
                                [NSString stringWithFormat:@"%i", countryID],
                                [NSString stringWithFormat:@"%i", cityID],
                                aRoomNumber,
                                editADID,
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        // NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost = [NSString stringWithFormat:@"%i=%@&%i=%@&%i=%i&%i=%i&%i=%@&%i=%i&%i=%i&%i=%@&%i=%@&%@=%@&%@=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%i&%i=%i&%i=%i",
                              1003,aTitle,
                              1004,aDescription,
                              1005,aPeriodID,
                              1007,aServiceID,
                              1013,aPrice,
                              1014,aCurrencyValueID,
                              1015,aUnitTypeID,
                              1016,aUnitPrice,
                              -100,usermail,
                              //-99,cityID,
                              IMAGES_ID_POST_KEY,aImageIDsArray,
                              @"Longituted",aLongitude,
                              @"Latitude",aLatitude,
                              1050,aSpace,
                              1012,aArea,
                              1006,aMobileNum,
                              1010,aPhoneNumer,
                              1017,1,
                              -98,categoryID,
                              -99,cityID];
        
        
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
        
        editStoreAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.storePostAdDel)
            [self.storePostAdDel storeAdDidFailEditingWithError:error];
        return ;
    }
    
}



- (void) uploadImage:(UIImage *) image WithDelegate:(id <UploadImageDelegate>) del {
    
    //1- set the delegate
    self.uploadImageDel = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
       // [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"file";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:upload_image_url];
    
    //upload image
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval: 300];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    NSData *tempImageData = UIImageJPEGRepresentation(image, 1.0);
    NSData *imageData;
    
    if (tempImageData.length <= (1000 * 1000)) //if size is smaller than 1MB, no need for compression
        imageData = tempImageData;
    else {
        
        //with compression
        //UIImage *small = [UIImage imageWithCGImage:image.CGImage scale:0.25 orientation:image.imageOrientation];
        
        //imageData = UIImageJPEGRepresentation(small, 0.15);
        imageData = UIImageJPEGRepresentation(image, 0.15);
    }
    
    if ((imageData) && (imageData.length > (5 * 1024 * 1024)))
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"لا يمكنك تحميل صورة بحجم يتجاوز ٥ ميغا بايت "];
        
        if (self.uploadImageDel)
            [self.uploadImageDel imageDidFailUploadingWithError:error];
        return ;
    }
    if (imageData) {
        //if (imageData.length)
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    if (requestURL)
    {
        // set URL
        [request setURL:requestURL];
        
        uploadImageMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.uploadImageDel)
            [self.uploadImageDel imageDidFailUploadingWithError:error];
        return ;
    }
    
    
}

-(void) GetSubCategoriesCountForCategory:(NSString*)categoryName andCity:(NSInteger)cityID andServiceType:(NSString*)serviceType WithDelegate:(id <CategoriesCountDelegate>) del{
    
    //1- set the delegate
    self.categoriesCountDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:categories_count_id_url,
                                categoryName,cityID,serviceType];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSString * correctURLstring = @"http://gfctest.edanat.com/v1.0/json/searchads?pageNo=1&pageSize=50&cityId=13&textTerm=&brandId=208&modelId=2008&minPrice=&maxPrice=&destanceRange=&fromYear=&toYear=&adsWithImages=&adsWithPrice=&area=&orderby=";
    
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
        categoriesCountMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.categoriesCountDelegate)
            [self.categoriesCountDelegate subCategoriesDidFailLoadingWithError:error];
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

- (NSInteger) getIndexOfAd:(NSUInteger) adID inArray:(NSArray *) adsArray {
    
    if (!adsArray)
        return -1;
    
    for (int index = 0; index < adsArray.count; index ++)
    {
        Ad * obj = [adsArray objectAtIndex:index];
        if (obj.adID == adID)
            return index;
    }
    return -1;
}


- (NSArray *) getCategoriesForstatus:(BOOL) forSaleStatus {
    if (forSaleStatus) {
        if (!categoriesForSaleArray) {
            
            categoriesForSaleArray = [[NSMutableArray alloc] init];
            //1- load categories
            NSData * catsData = [NSData dataWithContentsOfFile:[[StaticAttrsLoader sharedInstance] getJsonFilePathInDocumentsForFile:CATEGORIES_FOR_SALE_FILE_NAME]];
            
            NSArray * catsParsedArray = [[JSONParser sharedInstance] parseJSONData:catsData];
            
            for (NSDictionary * catDict in catsParsedArray) {
                Category1 * cat = [[Category1 alloc]
                                  initWithcategoryIDString:[catDict objectForKey:CAT_ID]
                                    categoryName:[catDict objectForKey:CAT_NAME]
                                    categoryNameEn:[catDict objectForKey:CAT_NAME_EN]
                                  ];
                [categoriesForSaleArray addObject:cat];
            }
        }
        return [NSArray arrayWithArray:categoriesForSaleArray];
    }
    else {
        if (!categoriesForRentArray) {
            categoriesForRentArray = [[NSMutableArray alloc] init];
            //1- load categories
            NSData * catsData = [NSData dataWithContentsOfFile:[[StaticAttrsLoader sharedInstance] getJsonFilePathInDocumentsForFile:CATEGORIES_FOR_RENT_FILE_NAME]];
            
            NSArray * catsParsedArray = [[JSONParser sharedInstance] parseJSONData:catsData];
            
            for (NSDictionary * catDict in catsParsedArray) {
                Category1 * cat = [[Category1 alloc]
                                  initWithcategoryIDString:[catDict objectForKey:CAT_ID]
                                  categoryName:[catDict objectForKey:CAT_NAME]
                                  categoryNameEn:[catDict objectForKey:CAT_NAME_EN]
                                  ];
                [categoriesForRentArray addObject:cat];
            }
        }
        return [NSArray arrayWithArray:categoriesForRentArray];
    }
}

- (NSArray * ) createCarAdsArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSArray * dataAdsArray = [totalDict objectForKey:LISTING_DATA_JKEY];
            if ((dataAdsArray) && (![@"" isEqualToString:(NSString *)dataAdsArray]) && (dataAdsArray.count))
            {
                for (NSDictionary * adDict in dataAdsArray)
                {
                    
                    Ad * ad;
                    ad = [[Ad alloc]initWithAdIDString:[adDict objectForKey:AD_AD_ID_JKEY] ownerIDString:[adDict objectForKey:AD_OWNER_ID_JKEY] storeIDString:[adDict objectForKey:AD_STORE_ID_JKEY] isFeaturedString:[adDict objectForKey:AD_IS_FEATURED_JKEY] thumbnailURLString:[adDict objectForKey:AD_THUMBNAIL_URL_JKEY] titleString:[adDict objectForKey:AD_TITLE_JKEY] priceString:[adDict objectForKey:AD_PRICE_JKEY] currencyString:[adDict objectForKey:AD_CURRENCY_JKEY] postedOnDateString:[adDict objectForKey:AD_POSTED_ON_JKEY] viewCountString:[adDict objectForKey:AD_VIEW_COUNT_JKEY] isFavoriteString:[adDict objectForKey:AD_IS_FAVORITE_JKEY] storeNameString:[adDict objectForKey:AD_STORE_NAME_JKEY] storeLogoURLString:[adDict objectForKey:AD_STORE_LOGO_URL_JKEY] countryIDString:[adDict objectForKey:AD_COUNTRY_ID_JKEY] EncEditIDString:[adDict objectForKey:AD_ENC_EDIT_ID_JKEY] longitudeString:[adDict objectForKey:AD_LONGITUDE_JKEY] latitudeString:[adDict objectForKey:AD_LATITUDE_JKEY] areaString:[adDict objectForKey:AD_AREA_JKEY] postedFromCityIDString:[adDict objectForKey:AD_POSTED_FROM_CITY_ID_JKEY] categoryIDString:[adDict objectForKey:AD_CAT_ID_JKEY] mainCategoryIDString:[adDict objectForKey:AD_MAIN_CAT_ID_JKEY] roomsString:[adDict objectForKey:AD_ROOMS_JKEY] roomsCountString:[adDict objectForKey:AD_ROOMS_COUNT_JKEY] adURLString:[adDict objectForKey:AD_AD_URL_JKEY]];
                    
                    
                    [adsArray addObject:ad];
                    
                }
            }
        }
        return adsArray;
    }
    return [NSArray new];
}


- (NSArray * ) createEditAdsArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSDictionary * dataAdsArray = [totalDict objectForKey:LISTING_DATA_JKEY];
            //NSArray * adImagesArray = [dataAdsArray objectForKey:@"AdImages"];
            
            if ((dataAdsArray) && (![@"" isEqualToString:(NSString *)dataAdsArray]) && (dataAdsArray.count))
            {
                NSDictionary * adDict = [dataAdsArray objectForKey:@"AdData"];
                //for (NSDictionary * adDict in dataAdsArray)
                // {
                AdDetails *ad = [[AdDetails alloc] init];
                ad.title = [adDict objectForKey:@"205"];
                if (!ad.title)
                    ad.title = [adDict objectForKey:@"1003"];
                
                ad.price = [[adDict objectForKey:@"211"] floatValue];
                if (!ad.price)
                    ad.price = [[adDict objectForKey:@"1013"] floatValue];
                
                ad.description = [adDict objectForKey:@"216"];
                if (!ad.description)
                    ad.description = [adDict objectForKey:@"1004"];
                
                ad.mobileNumber = [adDict objectForKey:@"222"];
                if (!ad.mobileNumber)
                    ad.mobileNumber = [adDict objectForKey:@"1006"];
                
                ad.UnitPriceString = [adDict objectForKey:@"700"];
                if (!ad.UnitPriceString)
                    ad.UnitPriceString = [adDict objectForKey:@"1016"];
               
                ad.landlineNumber = [adDict objectForKey:@"867"];
                if (!ad.landlineNumber)
                    ad.landlineNumber = [adDict objectForKey:@"1010"];
               
                ad.area = [adDict objectForKey:@"1002"];
                if (!ad.area)
                    ad.area = [adDict objectForKey:@"1012"];
                
                ad.SpaceString = [adDict objectForKey:@"1049"];
                if (!ad.SpaceString)
                    ad.SpaceString = [adDict objectForKey:@"1050"];
              
                ad.currencyString = [adDict objectForKey:@"212"];
                if (!ad.currencyString)
                    ad.currencyString=[adDict objectForKey:@"1014"];
                
                ad.PeriodString = [adDict objectForKey:@"405"];
                if (!ad.PeriodString)
                    ad.PeriodString=[adDict objectForKey:@"1005"];
                
                ad.cityID = [[adDict objectForKey:@"-99"] integerValue];
                ad.CategoryID = [[adDict objectForKey:@"-98"] integerValue];
                ad.emailAddress = [adDict objectForKey:@"-100"];
            
                
                [adsArray addObject:ad];
                
                //}
            }
        }
        return adsArray;
    }
    return [NSArray new];
}

- (NSArray * ) createEditStoreAdsArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSDictionary * dataAdsArray = [totalDict objectForKey:LISTING_DATA_JKEY];
            //NSArray * adImagesArray = [dataAdsArray objectForKey:@"AdImages"];
            
            if ((dataAdsArray) && (![@"" isEqualToString:(NSString *)dataAdsArray]) && (dataAdsArray.count))
            {
                NSDictionary * adDict = [dataAdsArray objectForKey:@"AdData"];
                //for (NSDictionary * adDict in dataAdsArray)
                // {
                AdDetails *ad = [[AdDetails alloc] init];
                ad.title = [adDict objectForKey:@"205"];
                if (!ad.title)
                    ad.title = [adDict objectForKey:@"1003"];
                
                ad.price = [[adDict objectForKey:@"211"] floatValue];
                if (!ad.price)
                    ad.price = [[adDict objectForKey:@"1013"] floatValue];
                
                ad.description = [adDict objectForKey:@"216"];
                if (!ad.description)
                    ad.description = [adDict objectForKey:@"1004"];
                
                ad.mobileNumber = [adDict objectForKey:@"222"];
                if (!ad.mobileNumber)
                    ad.mobileNumber = [adDict objectForKey:@"1006"];
                
                ad.UnitPriceString = [adDict objectForKey:@"700"];
                if (!ad.UnitPriceString)
                    ad.UnitPriceString = [adDict objectForKey:@"1016"];
                
                ad.landlineNumber = [adDict objectForKey:@"867"];
                if (!ad.landlineNumber)
                    ad.landlineNumber = [adDict objectForKey:@"1010"];
                
                ad.area = [adDict objectForKey:@"1002"];
                if (!ad.area)
                    ad.area = [adDict objectForKey:@"1012"];
                
                ad.SpaceString = [adDict objectForKey:@"1049"];
                if (!ad.SpaceString)
                    ad.SpaceString = [adDict objectForKey:@"1050"];
                
                
                ad.cityID = [[adDict objectForKey:@"-99"] integerValue];
                ad.CategoryID = [[adDict objectForKey:@"-98"] integerValue];
                ad.emailAddress = [adDict objectForKey:@"-100"];

                
                
                [adsArray addObject:ad];
                
                //}
            }
        }
        return adsArray;
    }
    return [NSArray new];
}


- (NSArray * ) createImageIDArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSDictionary * dataAdsArray = [totalDict objectForKey:LISTING_DATA_JKEY];
            NSArray * adImagesArray = [dataAdsArray objectForKey:@"AdImages"];
            
            if ((dataAdsArray) && (![@"" isEqualToString:(NSString *)dataAdsArray]) && (dataAdsArray.count))
            {
                // NSDictionary * adDict = [dataAdsArray objectForKey:@"AdData"];
                for (NSDictionary * adImgDict in adImagesArray)
                {
                    
                    
                    
                    NSString* temp = [NSString stringWithFormat:@"%@", [adImgDict objectForKey:@"ImageID"]];
                    Ad* myImage = [[Ad alloc]initWithImageID:temp andImageURL:[adImgDict objectForKey:@"ImageURL"]];
                    
                    [adsArray addObject:myImage];
                    
                }
            }
        }
        return adsArray;
    }
    return [NSArray new];
}

#pragma mark - data Delegate methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    
    if (manager == browseAdsMngr)
    {
        if (self.browseAdsDel)
            [self.browseAdsDel adsDidFailLoadingWithError:error];
    }
    else if (manager == uploadImageMngr)
    {
        if (self.uploadImageDel)
            [self.uploadImageDel imageDidFailUploadingWithError:error];
    }
    else if (manager == requestEditAdMngr)
    {
        if (self.requestEditAdDel)
            [self.requestEditAdDel RequestToEditFailWithError:error];
    }
    else if (manager == requestEditStoreMngr)
    {
        if (self.requestEditStoreDel)
            [self.requestEditStoreDel RequestToEditStoreFailWithError:error];
    }
    else if (manager == postAdMngr)
    {
        if (self.postAdDel)
            [self.postAdDel adDidFailPostingWithError:error];
    }
    else if (manager == storePostAdMngr)
    {
        if (self.storePostAdDel)
            [self.storePostAdDel storeAdDidFailPostingWithError:error];
    }
    else if (manager == editAdMngr)
    {
        if (self.postAdDel)
            [self.postAdDel adDidFailEditingWithError:error];
    }
    else if (manager == editStoreAdMngr)
    {
        if (self.storePostAdDel)
            [self.storePostAdDel storeAdDidFailEditingWithError:error];
    }
    
    else if (manager == sendEmailMngr)
    {
        if (self.sendEmailDel)
            [self.sendEmailDel EmailDidFailSendingWithError:error];
    }
    else if (manager == categoriesCountMngr)
    {
        if (self.categoriesCountDelegate)
            [self.categoriesCountDelegate subCategoriesDidFailLoadingWithError:error];
    }
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
    
    if (!result) {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (manager == browseAdsMngr)
        {
            if (self.browseAdsDel)
                [self.browseAdsDel adsDidFailLoadingWithError:error];
        }
        else if (manager == uploadImageMngr)
        {
            if (self.uploadImageDel)
                [self.uploadImageDel imageDidFailUploadingWithError:error];
        }
        else if (manager == requestEditAdMngr)
        {
            if (self.requestEditAdDel)
                [self.requestEditAdDel RequestToEditFailWithError:error];
        }
        else if (manager == requestEditStoreMngr)
        {
            if (self.requestEditStoreDel)
                [self.requestEditStoreDel RequestToEditStoreFailWithError:error];
        }
        else if (manager == postAdMngr)
        {
            if (self.postAdDel)
                [self.postAdDel adDidFailPostingWithError:error];
        }
        else if (manager == storePostAdMngr)
        {
            if (self.storePostAdDel)
                [self.storePostAdDel storeAdDidFailPostingWithError:error];
        }
        else if (manager == editAdMngr)
        {
            if (self.postAdDel)
                [self.postAdDel adDidFailEditingWithError:error];
        }
        else if (manager == editStoreAdMngr)
        {
            if (self.storePostAdDel)
                [self.storePostAdDel storeAdDidFailEditingWithError:error];
        }
        
        else if (manager == sendEmailMngr)
        {
            if (self.sendEmailDel)
                [self.sendEmailDel EmailDidFailSendingWithError:error];
        }
        else if (manager == categoriesCountMngr)
        {
            if (self.categoriesCountDelegate)
                [self.categoriesCountDelegate subCategoriesDidFailLoadingWithError:error];
        }
    }
    else {
        
        if (manager == browseAdsMngr)
        {
            if (self.browseAdsDel) {
                NSArray * adsArray = [self createAdsArrayWithData:(NSArray *)result];
                [self.browseAdsDel adsDidFinishLoadingWithData:adsArray];
            }
            
        }
        else if (manager == uploadImageMngr)
        {
            if (self.uploadImageDel)
            {
                NSArray * data = (NSArray *)result;
                if ((data) && (data.count > 0))
                {
                    NSDictionary * totalDict = [data objectAtIndex:0];
                    NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
                    NSInteger statusCode = statusCodeString.integerValue;
                    
                    NSString * statusMessageProcessed = [[[totalDict objectForKey:LISTING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                    
                    if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                    {
                        NSDictionary * attrsDict = [totalDict objectForKey:LISTING_DATA_JKEY];
                        NSString * urlString = [attrsDict objectForKey:UPLOAD_IMAGE_URL_JKEY];
                        NSString * idString = [attrsDict objectForKey:UPLOAD_IMAGE_CREATIVE_ID_JKEY];
                        
                        NSInteger imageID = [idString integerValue];
                        NSURL * imageURL = [NSURL URLWithString:urlString];
                        
                        [self.uploadImageDel imageDidFinishUploadingWithURL:imageURL CreativeID:imageID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.uploadImageDel)
                            [self.uploadImageDel imageDidFailUploadingWithError:error];
                    }
                    
                }
            }
        }
        else if (manager == requestEditAdMngr)
        {
            if (self.requestEditAdDel)
            {
                    NSArray * adsArray = [self createEditAdsArrayWithData:(NSArray *)result];
                    NSArray * imgIDArray = [self createImageIDArrayWithData:(NSArray*) result];
                    [self.requestEditAdDel RequestToEditFinishWithData:adsArray imagesArray:imgIDArray];
                
            }
        }
        else if (manager == requestEditStoreMngr)
        {
            if (self.requestEditStoreDel)
            {
                NSArray * adsArray = [self createEditAdsArrayWithData:(NSArray *)result];
                NSArray * imgIDArray = [self createImageIDArrayWithData:(NSArray*) result];
                [self.requestEditStoreDel RequestToEditStoreFinishWithData:adsArray imagesArray:imgIDArray];
            }
        }
        else if (manager == postAdMngr)
        {
            if (self.postAdDel)
            {
                NSArray * data = (NSArray *)result;
                if ((data) && (data.count > 0))
                {
                    NSDictionary * totalDict = [data objectAtIndex:0];
                    NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
                    NSInteger statusCode = statusCodeString.integerValue;
                    
                    NSString * statusMessageProcessed = [[[totalDict objectForKey:LISTING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                    
                    if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"success"]))
                    {
                        NSDictionary * dataDict = [totalDict objectForKey:LISTING_DATA_JKEY];
                        NSString * adIdString = [dataDict objectForKey:@"AdID"];
                        
                        NSInteger adID = [adIdString integerValue];
                        
                        [self.postAdDel adDidFinishPostingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.postAdDel)
                            [self.postAdDel adDidFailPostingWithError:error];
                    }
                    
                }
            }
        }
        else if (manager == storePostAdMngr)
        {
            if (self.storePostAdDel)
            {
                NSArray * data = (NSArray *)result;
                if ((data) && (data.count > 0))
                {
                    NSDictionary * totalDict = [data objectAtIndex:0];
                    NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
                    NSInteger statusCode = statusCodeString.integerValue;
                    
                    NSString * statusMessageProcessed = [[[totalDict objectForKey:LISTING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                    
                    if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"success"]))
                    {
                        NSDictionary * dataDict = [totalDict objectForKey:LISTING_DATA_JKEY];
                        NSString * adIdString = [dataDict objectForKey:AD_AD_ID_JKEY];
                        
                        NSInteger adID = [adIdString integerValue];
                        
                        [self.storePostAdDel storeAdDidFinishPostingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.storePostAdDel)
                            [self.storePostAdDel storeAdDidFailPostingWithError:error];
                    }
                    
                }
            }
        }
        else if (manager == editAdMngr)
        {
            if (self.postAdDel)
            {
                NSArray * data = (NSArray *)result;
                if ((data) && (data.count > 0))
                {
                    NSDictionary * totalDict = [data objectAtIndex:0];
                    NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
                    NSInteger statusCode = statusCodeString.integerValue;
                    
                    NSString * statusMessageProcessed = [[[totalDict objectForKey:LISTING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                    
                    if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"success"]))
                    {
                        NSDictionary * dataDict = [totalDict objectForKey:LISTING_DATA_JKEY];
                        NSString * adIdString = [dataDict objectForKey:@"AdID"];
                        
                        NSInteger adID = [adIdString integerValue];
                        
                        [self.postAdDel adDidFinishEditingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.postAdDel)
                            [self.postAdDel adDidFailEditingWithError:error];
                    }
                    
                }
            }
        }
        else if (manager == editStoreAdMngr)
        {
            if (self.storePostAdDel)
            {
                NSArray * data = (NSArray *)result;
                if ((data) && (data.count > 0))
                {
                    NSDictionary * totalDict = [data objectAtIndex:0];
                    NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
                    NSInteger statusCode = statusCodeString.integerValue;
                    
                    NSString * statusMessageProcessed = [[[totalDict objectForKey:LISTING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                    
                    if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"success"]))
                    {
                        NSDictionary * dataDict = [totalDict objectForKey:LISTING_DATA_JKEY];
                        NSString * adIdString = [dataDict objectForKey:@"AdID"];
                        
                        NSInteger adID = [adIdString integerValue];
                        
                        [self.storePostAdDel storeAdDidFinishEditingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.storePostAdDel)
                            [self.storePostAdDel storeAdDidFailEditingWithError:error];
                    }
                    
                }
            }
        }
        
        else if (manager == sendEmailMngr)
        {
            {
                NSArray * data = (NSArray *) result;
                if ((data) && (data.count > 0))
                {
                    NSDictionary * totalDict = [data objectAtIndex:0];
                    NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
                    NSInteger statusCode = statusCodeString.integerValue;
                    
                    NSString * statusMessageProcessed = [[[totalDict objectForKey:LISTING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                    
                    if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                    {
                        if (self.sendEmailDel)
                            [self.sendEmailDel EmailDidFinishSendingWithStatus:YES];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.sendEmailDel)
                            [self.sendEmailDel EmailDidFailSendingWithError:error];
                    }
                }
            }
        }
        else if (manager == categoriesCountMngr)
        {
            if (self.categoriesCountDelegate)
            {
                NSArray * data = (NSArray *)result;
                
                NSDictionary * totalDict = [data objectAtIndex:0];
                NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
                NSInteger statusCode = statusCodeString.integerValue;
                
                NSString * statusMessageProcessed = [[[totalDict objectForKey:LISTING_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                
                if ((data) && (data.count > 0))
                {
                    
                    NSArray* resultArray = [self createCategoriesArrayWithData:data];
                    
                        [self.categoriesCountDelegate subCategoriesDidFinishLoadingWithStatus:resultArray];
                    
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    if (self.categoriesCountDelegate)
                        [self.categoriesCountDelegate subCategoriesDidFailLoadingWithError:error];
                }
            }
        }
    }
}


#pragma mark - helper methods

- (NSArray * ) createAdsArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSArray * dataAdsArray = [totalDict objectForKey:DATA_JKEY];
            if ((dataAdsArray) && (![@"" isEqualToString:(NSString *)dataAdsArray]) && (dataAdsArray.count))
            {
                for (NSDictionary * adDict in dataAdsArray)
                {
                    
                    Ad * ad =
                    [[Ad alloc]
                     initWithAdIDString:[adDict objectForKey:AD_AD_ID_JKEY]
                     ownerIDString:[adDict objectForKey:AD_OWNER_ID_JKEY]
                     storeIDString:[adDict objectForKey:AD_STORE_ID_JKEY]
                     isFeaturedString:[adDict objectForKey:AD_IS_FEATURED_JKEY]
                     thumbnailURLString:[adDict objectForKey:AD_THUMBNAIL_URL_JKEY]
                     titleString:[adDict objectForKey:AD_TITLE_JKEY]
                     priceString:[adDict objectForKey:AD_PRICE_JKEY]
                     currencyString:[adDict objectForKey:AD_CURRENCY_JKEY]
                     postedOnDateString:[adDict objectForKey:AD_POSTED_ON_JKEY]
                     viewCountString:[adDict objectForKey:AD_VIEW_COUNT_JKEY]
                     isFavoriteString:[adDict objectForKey:AD_IS_FAVORITE_JKEY]
                     storeNameString:[adDict objectForKey:AD_STORE_NAME_JKEY]
                     storeLogoURLString:[adDict objectForKey:AD_STORE_LOGO_URL_JKEY]
                     countryIDString:[adDict objectForKey:AD_COUNTRY_ID_JKEY]
                     EncEditIDString:[adDict objectForKey:AD_ENC_EDIT_ID_JKEY]
                     longitudeString:[adDict objectForKey:AD_LONGITUDE_JKEY]
                     latitudeString:[adDict objectForKey:AD_LATITUDE_JKEY]
                     areaString:[adDict objectForKey:AD_AREA_JKEY]
                     postedFromCityIDString:[adDict objectForKey:AD_POSTED_FROM_CITY_ID_JKEY]
                     categoryIDString:[adDict objectForKey:AD_CAT_ID_JKEY]
                     mainCategoryIDString:[adDict objectForKey:AD_MAIN_CAT_ID_JKEY]
                     roomsString:[adDict objectForKey:AD_ROOMS_JKEY]
                     roomsCountString:[adDict objectForKey:AD_ROOMS_COUNT_JKEY]
                     adURLString:[adDict objectForKey:AD_AD_URL_JKEY]
                     ];
                    
                    ad.adDetails = [adDict objectForKey:@"Description"];
                    
                    [adsArray addObject:ad];
                    
                }
            }
        }
        return adsArray;
    }
    return [NSArray new];
}

- (NSArray * ) createCategoriesArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSArray * dataAdsArray = [totalDict objectForKey:DATA_JKEY];
            if ((dataAdsArray) && (![@"" isEqualToString:(NSString *)dataAdsArray]) && (dataAdsArray.count))
            {
                for (NSDictionary * adDict in dataAdsArray)
                {
                    
                    Category1* cat = [[Category1 alloc] init];
                    cat.categoryID = [[adDict objectForKey:@"CategoryID"] integerValue];
                    cat.categoryNameEn = [adDict objectForKey:@"CategoryName"];
                    cat.ActiveAdsCount = [[adDict objectForKey:@"ActiveAdsCount"] integerValue];
                    [adsArray addObject:cat];
                    
                }
            }
        }
        return adsArray;
    }
    return [NSArray new];
}

- (BOOL) cacheDataFromArray:(NSArray *) dataArr forSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForSubCategory:subCatID InCity:cityID];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    //2- check if file exists
    //BOOL cahcedFileExists = [GenericMethods fileExistsInDocuments:cacheFileName];
    
    //3- create the dictionary to be serialized to JSON
    NSMutableDictionary * dictToBeWritten = [NSMutableDictionary new];
    [dictToBeWritten setObject:[NSNumber numberWithUnsignedInteger:tillPageNum] forKey:@"pageNo"];
    [dictToBeWritten setObject:[NSNumber numberWithUnsignedInteger:pSize] forKey:@"pageSize"];
    [dictToBeWritten setObject:dataArr forKey:@"dataArray"];
    
    //4- convert dictionary to NSData
    NSError  *error;
    NSData * dataToBeWritten = [NSKeyedArchiver archivedDataWithRootObject:dictToBeWritten];
    if (![dataToBeWritten writeToFile:cacheFilePath options:NSDataWritingAtomic error:&error])
        return NO;
    else
        return YES;
    
}

- (NSArray *) getCahedDataForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForSubCategory:subCatID InCity:cityID];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    //check if the file expiration date
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attrs = [fm attributesOfItemAtPath:cacheFilePath error:nil];
    
    if (attrs) {
        
        NSDate * today = [NSDate date];
        //NSDate * fileCreationDate = (NSDate*)[attrs objectForKey: NSFileCreationDate];
        NSDate * fileModificationDate = [attrs fileModificationDate];
        
        NSInteger minutesDiff = [GenericMethods dateDifferenceInMinutesFrom:fileModificationDate To:today];
        
        /*
         NSLog(@"File last modified on: %@", fileModificationDate);
         NSLog(@"today is: %@", today);
         NSLog(@"difference in minutes is: %i", minutesDiff);
         */
        
        if (minutesDiff > 10) {
            NSError *error;
            if ([fm removeItemAtPath:cacheFilePath error:&error] == YES)
                //NSLog(@"File exceeded expiration limit, file has been deleted");
                
                return nil;
        }
        
    }
    
    NSData *archiveData = [NSData dataWithContentsOfFile:cacheFilePath];
    if (!archiveData)
        return nil;
    
    NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    
    if (!dataDict)
        return nil;
    
    NSArray * resultArr = [dataDict objectForKey:@"dataArray"];
    return resultArr;
}

- (NSUInteger) getCahedPageNumForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForSubCategory:subCatID InCity:cityID];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    
    NSData *archiveData = [NSData dataWithContentsOfFile:cacheFilePath];
    if (!archiveData)
        return -1;
    
    NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    
    if (!dataDict)
        return -1;
    
    NSNumber * dataNum = [dataDict objectForKey:@"pageNo"];
    return [dataNum unsignedIntegerValue];
    
}

- (NSUInteger) getCahedPageSizeForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForSubCategory:subCatID InCity:cityID];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    NSData *archiveData = [NSData dataWithContentsOfFile:cacheFilePath];
    if (!archiveData)
        return -1;
    
    NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    
    if (!dataDict)
        return -1;
    
    NSNumber * dataNum = [dataDict objectForKey:@"pageSize"];
    return [dataNum unsignedIntegerValue];
    
}

- (void) clearCachedDataForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForSubCategory:subCatID InCity:cityID];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    //3- check if file exists
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath];
    if (fileExists)
    {
        [[NSFileManager defaultManager] removeItemAtPath:cacheFilePath error:NULL];
    }
}


- (NSString *) getCacheFileNameForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID  {
    
    //the file name is the string of listing URL without the page number and page size
    NSString * fullURLString = [NSString stringWithFormat:ads_url,
                                @"",
                                @"",
                                cityID,
                                @"",
                                [NSString stringWithFormat:@"%@", (subCatID == -1 ? @"" : [NSString stringWithFormat:@"%i", subCatID])],
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
                                @"",
                                @"",@""];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
    
    return [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}

- (NSArray * ) createStoreOrderArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LISTING_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSArray * dataAdsArray = [totalDict objectForKey:LISTING_DATA_JKEY];
            if ((dataAdsArray) && (![@"" isEqualToString:(NSString *)dataAdsArray]) && (dataAdsArray.count))
            {
                for (NSDictionary * storeDic in dataAdsArray)
                {
                    
                    StoreOrder *storeOrder = [[StoreOrder alloc] init];
                    storeOrder.StoreID = [storeDic[@"StoreID"] integerValue];
                    storeOrder.StoreName = storeDic[@"StoreName"];
                    storeOrder.StoreImageURL = storeDic[@"StoreImageURL"];
                    storeOrder.OrderID = [storeDic[@"OrderID"] integerValue];
                    storeOrder.CountryID = [storeDic[@"CountryID"] integerValue];
                    storeOrder.SchemeFee = [storeDic[@"SchemeFee"] integerValue];
                    storeOrder.PaymentMethod = [storeDic[@"PaymentMethod"] integerValue];
                    storeOrder.OrderStatus = [storeDic[@"OrderStatus"] integerValue];
                    storeOrder.StorePaymentSchemeID = [storeDic[@"StorePaymentSchemeID"] integerValue];
                    storeOrder.StorePaymentSchemeName = storeDic[@"StorePaymentSchemeName"];
                    storeOrder.IsApproved = [storeDic[@"IsApproved"] boolValue];
                    
                    storeOrder.IsRejected = [storeDic[@"IsRejected"] boolValue];
                    storeOrder.LastModifiedOn = [GenericMethods NSDateFromDotNetJSONString:storeDic[@"LastModifiedOn"]];
                    
                    
                    [adsArray addObject:storeOrder];
                    
                }
            }
        }
        return adsArray;
    }
    return [NSArray new];
}

@end
