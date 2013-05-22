//
//  CarAdsManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarAdsManager.h"
#import "SBJSON.h"

#pragma mark - JSON Keys

#define LISTING_STATUS_CODE_JKEY    @"StatusCode"
#define LISTING_STATUS_MSG_JKEY     @"StatusMessage"
#define LISTING_DATA_JKEY           @"Data"

#define UPLOAD_IMAGE_URL_JKEY           @"URL"
#define UPLOAD_IMAGE_CREATIVE_ID_JKEY   @"CreativeID"

#define LISTING_ADD_ID_JKEY         @"AdID"
#define LISTING_OWNER_ID_JKEY       @"OwnerID"
#define LISTING_STORE_ID_JKEY       @"StoreID"
#define LISTING_IS_FEATURED_JKEY    @"IsFeatured"
#define LISTING_THUMBNAIL_URL_JKEY  @"ThumbnailURL"
#define LISTING_TITLE_JKEY          @"Title"
#define LISTING_PRICE_JKEY          @"Price"
#define LISTING_CURRENCY_JKEY       @"Currency"
#define LISTING_POSTED_ON_JKEY      @"PostedOn"
#define LISTING_MODEL_YEAR_JKEY     @"ModelYear"
#define LISTING_DISTANCE_KM_JKEY    @"DistanceRangeInKm"
#define LISTING_VIEW_COUNT_JKEY     @"ViewCount"
#define LISTING_IS_FAVORITE_JKEY    @"IsFavorite"
#define LISTING_STORE_NAME_JKEY     @"StoreName"
#define LISTING_STORE_LOGO_URL_JKEY @"StoreLogoURL"
#define LISTING_CONDITION_JKEY      @"10097"
#define LISTING_GEAR_JKEY           @"10098"
#define LISTING_TYPE_JKEY           @"10101"
#define LISTING_BODY_JKEY           @"10100"

#pragma mark - literals

#define DEFAULT_PAGE_SIZE           50
//#define DEFAULT_PAGE_SIZE           10
#define ARABIC_BEFORE_TEXT          @"قبل"
#define ARABIC_SECOND_TEXT          @"ثانية"
#define ARABIC_MINUTE_TEXT          @"دقيقة"
#define ARABIC_LESS_MINUTE_TEXT     @"قبل دقيقة"
#define ARABIC_HOUR_TEXT            @"ساعة"
#define ARABIC_DAY_TEXT             @"يوم"
#define ARABIC_WEEK_TEXT            @"أسبوع"
#define ARABIC_MONTH_TEXT           @"شهر"
#define ARABIC_YEAR_TEXT            @"سنة"

@interface CarAdsManager ()
{
    InternetManager * internetMngr;
    InternetManager * imageMngr;
    InternetManager * postAdManager;
    InternetManager * storePostAdManager;
    InternetManager * requestEditMngr;
    InternetManager * requestEditStoreMngr;
    InternetManager * EditMngr;
    InternetManager * EditStoreAdMngr;
    InternetManager * SendingMngr;
    

}
@end

@implementation CarAdsManager
@synthesize delegate;
@synthesize imageDelegate;
@synthesize adPostingDelegate;
@synthesize storeaAdPostingDelegate;
@synthesize pageNumber;
@synthesize pageSize;


static NSString * ads_url = @"/json/searchads?pageNo=%@&pageSize=%@&cityId=%i&textTerm=%@&brandId=%@&modelId=%@&minPrice=%@&maxPrice=%@&destanceRange=%@&fromYear=%@&toYear=%@&adsWithImages=%@&adsWithPrice=%@&area=%@&orderby=%@&lastRefreshed=%@";

static NSString * upload_image_url = @"/json/upload-image?theFile=";
static NSString * post_ad_url = @"/json/post-an-ad?brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@";
static NSString * post_store_ad_url = @"/json/post-a-store-ad?brandid=%@&cityId=%@&storeid=%@&collection=%@";
static NSString * user_ads_url = @"/json/myads?status=%@&pageNo=%@&pageSize=%@";
static NSString * request_edit_ads_url = @"/json/request-to-edit?enceditid=%@";
static NSString * request_edit_store_ads_url = @"/json/request-to-edit-store-ad?encadid=%@&storeid=%@";
static NSString * edit_id_url = @"/json/update-ad?country=%@&city=%@&enceditid=%@&collection=%@";
static NSString * edit_store_ad_id_url = @"/json/update-store-ad?enceditid=%@&storeid=%i";
static NSString * sending_email_id_url = @"/json/send-an-email";

static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = nil;
        self.imageDelegate = nil;
        self.adPostingDelegate = nil;
        self.pageNumber = 0;
        self.pageSize = DEFAULT_PAGE_SIZE;
        ads_url = [API_MAIN_URL stringByAppendingString:ads_url];
        upload_image_url = [API_MAIN_URL stringByAppendingString:upload_image_url];
        post_ad_url = [API_MAIN_URL stringByAppendingString:post_ad_url];
        post_store_ad_url = [API_MAIN_URL stringByAppendingString:post_store_ad_url];
        user_ads_url = [API_MAIN_URL stringByAppendingString:user_ads_url];
        request_edit_ads_url = [API_MAIN_URL stringByAppendingString:request_edit_ads_url];
        request_edit_store_ads_url = [API_MAIN_URL stringByAppendingString:request_edit_store_ads_url];
        edit_id_url = [API_MAIN_URL stringByAppendingString:edit_id_url];
        edit_store_ad_id_url = [API_MAIN_URL stringByAppendingString:edit_store_ad_id_url];
        sending_email_id_url = [API_MAIN_URL stringByAppendingString:sending_email_id_url];
        
    }
    return self;
}

+ (CarAdsManager *) sharedInstance {
    static CarAdsManager * instance = nil;
    if (instance == nil) {
        instance = [[CarAdsManager alloc] init];
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

- (void) loadCarAdsOfPage:(NSUInteger) pageNum forBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID WithDelegate:(id <CarAdsManagerDelegate>) del {

    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
        return ;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:ads_url,
                                [NSString stringWithFormat:@"%i", pageNum],
                                [NSString stringWithFormat:@"%i", self.pageSize],
                                cityID,
                                @"",
                                [NSString stringWithFormat:@"%@", (brandID == -1 ? @"" : [NSString stringWithFormat:@"%i", brandID])],
                                [NSString stringWithFormat:@"%@", (modelID == -1 ? @"" : [NSString stringWithFormat:@"%i", modelID])],
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
        internetMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
        return ;
    }
    
}

- (void) requestToEditAdsOfEditID:(NSString*) EditID WithDelegate:(id <CarAdsManagerDelegate>) del {
    
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate RequestToEditFailWithError:error];
        return ;
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
        requestEditMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate RequestToEditFailWithError:error];
        return ;
    }
    
}

- (void) requestToEditStoreAdsOfEditID:(NSString*) EditID andStore:(NSString*)StoreID WithDelegate:(id <CarAdsManagerDelegate>) del {
    
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate RequestToEditStoreFailWithError:error];
        return ;
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
        
        if (self.delegate)
            [self.delegate RequestToEditStoreFailWithError:error];
        return ;
    }
    
}


- (void) loadUserAdsOfStatus:(NSString*) status forPage:(NSUInteger) pageNum andSize:(NSInteger) pageSize WithDelegate:(id <CarAdsManagerDelegate>) del {
    
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
        return ;
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
        internetMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
        return ;
    }
    
}

- (void) sendEmailofName:(NSString*) UserName withEmail:(NSString*) emailAddress phoneNumber:(NSInteger) phone message:(NSString*) SubjectMessage withAdID:(NSInteger)AdID WithDelegate:(id <SendEmailDelegate>) del {
    
    //1- set the delegate
    self.EmailSendingDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.EmailSendingDelegate)
            [self.EmailSendingDelegate EmailDidFailSendingWithError:error];
        return ;
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
        
        SendingMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
        
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.EmailSendingDelegate)
            [self.EmailSendingDelegate EmailDidFailSendingWithError:error];
        return ;
    }
    
}




- (BOOL) cacheDataFromArray:(NSArray *) dataArr forBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForBrand:brandID Model:modelID InCity:cityID];
    
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

- (NSArray *) getCahedDataForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForBrand:brandID Model:modelID InCity:cityID];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    NSData *archiveData = [NSData dataWithContentsOfFile:cacheFilePath];
    if (!archiveData)
        return nil;
    
    NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    
    if (!dataDict)
        return nil;
    
    NSArray * resultArr = [dataDict objectForKey:@"dataArray"];
    return resultArr;
}

- (NSUInteger) getCahedPageNumForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForBrand:brandID Model:modelID InCity:cityID];
    
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

- (NSUInteger) getCahedPageSizeForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForBrand:brandID Model:modelID InCity:cityID];
    
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

- (void) clearCachedDataForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForBrand:brandID Model:modelID InCity:cityID];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    //3- check if file exists
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath];
    if (fileExists)
    {
        [[NSFileManager defaultManager] removeItemAtPath:cacheFilePath error:NULL];
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
        CarAd * obj = [adsArray objectAtIndex:index];
        if (obj.adID == adID)
            return index;
    }
    return -1;
}

- (void) searchCarAdsOfPage:(NSUInteger) pageNum
                   forBrand:(NSUInteger) brandID
                      Model:(NSInteger) modelID
                     InCity:(NSUInteger) cityID
                   textTerm:(NSString *) aTextTerm
                   minPrice:(NSString *) aMinPrice
                   maxPrice:(NSString *) aMaxPrice
            distanceRangeID:(NSInteger) aDistanceRangeID
                   fromYear:(NSString *) aFromYear
                     toYear:(NSString *) aToYear
              adsWithImages:(BOOL) aAdsWithImages
               adsWithPrice:(BOOL) aAdsWithPrice
                       area:(NSString *) aArea
                    orderby:(NSString *) aOrderby
              lastRefreshed:(NSString *)aLastRefreshed
               WithDelegate:(id <CarAdsManagerDelegate>) del  {
    
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
        return ;
    }
    
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:ads_url,
                                [NSString stringWithFormat:@"%i", pageNum],
                                [NSString stringWithFormat:@"%i", self.pageSize],
                                cityID,
                                aTextTerm,
                                [NSString stringWithFormat:@"%@", (brandID == -1 ? @"" : [NSString stringWithFormat:@"%i", brandID])],
                                [NSString stringWithFormat:@"%@", (modelID == -1 ? @"" : [NSString stringWithFormat:@"%i", modelID])],
                                aMinPrice,
                                aMaxPrice,
                                [NSString stringWithFormat:@"%@", (aDistanceRangeID == -1 ? @"" : [NSString stringWithFormat:@"%i", aDistanceRangeID])],
                                aFromYear,
                                aToYear,
                                (aAdsWithImages ? [NSString stringWithFormat:@"%i", aAdsWithImages]: @""),
                                (aAdsWithPrice ? [NSString stringWithFormat:@"%i", aAdsWithPrice] : @""),
                                aArea,
                                aOrderby,
                                aLastRefreshed
                                ];
    
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
        internetMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
        return ;
    }
    
}

- (void) uploadImage:(UIImage *) image WithDelegate:(id <UploadImageDelegate>) del {
    
    //1- set the delegate
    self.imageDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.imageDelegate)
            [self.imageDelegate imageDidFailUploadingWithError:error];
        return ;
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
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if ((imageData) && (imageData.length > (5 * 1024 * 1024)))
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"لا يمكنك تحميل صورة بحجم يتجاوز ٥ ميغا بايت "];
        
        if (self.imageDelegate)
            [self.imageDelegate imageDidFailUploadingWithError:error];
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
        
        imageMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.imageDelegate)
            [self.imageDelegate imageDidFailUploadingWithError:error];
        return ;
    }
    
    
}

- (void) postAdOfBrand:(NSUInteger) brandID
                 Model:(NSInteger) modelID
                InCity:(NSUInteger) cityID
             userEmail:(NSString *) usermail
                 title:(NSString *) aTitle
           description:(NSString *) aDescription
                 price:(NSString *) aPrice
         periodValueID:(NSInteger) aPeriodValueID
                mobile:(NSString *) aMobileNum
       currencyValueID:(NSInteger) aCurrencyValueID
        serviceValueID:(NSInteger) aServiceValueID
      modelYearValueID:(NSInteger) aModelYearValueID
              distance:(NSString *) aDistance
                 color:(NSString *) aColor
            phoneNumer:(NSString *) aPhoneNumer
       adCommentsEmail:(BOOL) aAdCommentsEmail
      kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
              imageIDs:(NSArray *) aImageIDsArray
          withDelegate:(id <PostAdDelegate>) del {
    
    //1- set the delegate
    self.adPostingDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.adPostingDelegate)
            [self.adPostingDelegate adDidFailPostingWithError:error];
        return ;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@";
    NSString * fullURLString = [NSString stringWithFormat:post_ad_url,
                                [NSString stringWithFormat:@"%i", brandID],
                                [NSString stringWithFormat:@"%i", cityID],
                                1, //the fromPhone is 1 for iOS
                                usermail,
                                @""
                                ];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost =[NSString stringWithFormat:@"%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%@=%@",
                             TITLE_ATTR_ID, aTitle,
                             DESCRIPTION_ATTR_ID, aDescription,
                             PRICE_ATTR_ID, aPrice,
                             ADVERTISING_PERIOD_ATTR_ID, [NSString stringWithFormat:@"%i", aPeriodValueID],
                             MOBILE_NUMBER_ATTR_ID, aMobileNum,
                             CURRENCY_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aCurrencyValueID],
                             SERVICE_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aServiceValueID],
                             MANUFACTURE_YEAR_ATTR_ID, [NSString stringWithFormat:@"%i",aModelYearValueID],
                             DISTANCE_VALUE_ATTR_ID, aDistance,
                             COLOR_ATTR_ID, aColor,
                             PHONE_NUMBER_ATTR_ID, usermail,
                             ADCOMMENTS_EMAIL_ATTR_ID, [NSString stringWithFormat:@"%i",aAdCommentsEmail],
                             KM_MILES_ATTR_ID, [NSString stringWithFormat:@"%i",aKmVSmilesValueID],
                             brandKeyForModel.integerValue, [NSString stringWithFormat:@"%i",modelID],
                             IMAGES_ID_POST_KEY, [self getIDsStringFromArray:aImageIDsArray]
                             ];

        
        
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
        
        postAdManager = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.adPostingDelegate)
            [self.adPostingDelegate adDidFailPostingWithError:error];
        return ;
    }
    
}

- (void) editAdOfEditadID:(NSString*) editADID
             inCountryID :(NSInteger)countryID
                InCity:(NSUInteger) cityID
             userEmail:(NSString *) usermail
                 title:(NSString *) aTitle
           description:(NSString *) aDescription
                 price:(NSString *) aPrice
         periodValueID:(NSInteger) aPeriodValueID
                mobile:(NSString *) aMobileNum
       currencyValueID:(NSInteger) aCurrencyValueID
        serviceValueID:(NSInteger) aServiceValueID
      modelYearValueID:(NSInteger) aModelYearValueID
              distance:(NSString *) aDistance
                 color:(NSString *) aColor
            phoneNumer:(NSString *) aPhoneNumer
       adCommentsEmail:(BOOL) aAdCommentsEmail
      kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
                   nine52:(NSInteger)anine52
                   five06:(NSInteger)afive06
                   five02:(NSInteger)afive02
                   nine06:(NSString*)anine06
                    one01:(NSString*)aone01
                   ninty8:(NSInteger)aninty8
              imageIDs:(NSArray *) aImageIDsArray
          withDelegate:(id <PostAdDelegate>) del {
    
    //1- set the delegate
    self.adPostingDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.adPostingDelegate)
            [self.adPostingDelegate adDidFailEditingWithError:error];
        return ;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@;
    ///country=%@&city=%@&enceditid=%@&collection=%@;
    NSString * fullURLString = [NSString stringWithFormat:edit_id_url,
                                [NSString stringWithFormat:@"%i", countryID],
                                [NSString stringWithFormat:@"%i", cityID],
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
        NSString * prePost =[NSString stringWithFormat:@"%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%@=%@",
                             TITLE_ATTR_ID, aTitle,
                             DESCRIPTION_ATTR_ID, aDescription,
                             PRICE_ATTR_ID, aPrice,
                             ADVERTISING_PERIOD_ATTR_ID, [NSString stringWithFormat:@"%i", aPeriodValueID],
                             MOBILE_NUMBER_ATTR_ID, aMobileNum,
                             CURRENCY_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aCurrencyValueID],
                             SERVICE_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aServiceValueID],
                             MANUFACTURE_YEAR_ATTR_ID, [NSString stringWithFormat:@"%i",aModelYearValueID],
                             DISTANCE_VALUE_ATTR_ID, aDistance,
                             PHONE_ATTR_ID,aPhoneNumer,
                             PHONE_NUMBER_ATTR_ID, usermail,
                             ADCOMMENTS_EMAIL_ATTR_ID, [NSString stringWithFormat:@"%i",aAdCommentsEmail],
                             KM_MILES_ATTR_ID, [NSString stringWithFormat:@"%i",aKmVSmilesValueID],
                             952,[NSString stringWithFormat:@"%i",anine52],
                             //528,[NSString stringWithFormat:@"%i",anine52],
                             506,aPrice,
                             906,anine06,
                             -101,aone01,
                             -98,[NSString stringWithFormat:@"%i",aninty8],
                             MY_ATTR_ID,[NSString stringWithFormat:@"%i",cityID],
                             IMAGES_ID_POST_KEY, [self getIDsStringFromArray:aImageIDsArray]
                             ];
        
        
        
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
        
        EditMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.adPostingDelegate)
            [self.adPostingDelegate adDidFailEditingWithError:error];
        return ;
    }
    
}

- (void) editStoreAdOfEditadID:(NSString*) editADID
                  inCountryID :(NSInteger)countryID
                        InCity:(NSUInteger) cityID
                     userEmail:(NSString *) usermail
                         title:(NSString *) aTitle
                   description:(NSString *) aDescription
                         price:(NSString *) aPrice
                 periodValueID:(NSInteger) aPeriodValueID
                        mobile:(NSString *) aMobileNum
               currencyValueID:(NSInteger) aCurrencyValueID
                serviceValueID:(NSInteger) aServiceValueID
              modelYearValueID:(NSInteger) aModelYearValueID
                      distance:(NSString *) aDistance
                         color:(NSString *) aColor
                    phoneNumer:(NSString *) aPhoneNumer
               adCommentsEmail:(BOOL) aAdCommentsEmail
              kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
                        nine52:(NSInteger)anine52
                        five06:(NSInteger)afive06
                     advPeriod:(NSInteger)aAdvPeriod
                        nine06:(NSString*)anine06
                         one01:(NSString*)aone01
                        ninty8:(NSInteger)aninty8
                   serviceName:(NSString*)aServiceName
               adCommentsEmail:(NSInteger)aAdcommentsEmail
                  carCondition:(NSInteger)aCondition
                      gearType:(NSInteger)aGearType
                     carEngine:(NSInteger)aCarEngine
                       carType:(NSInteger)aCarType
                       carBody:(NSInteger)aCarBody
                         carCD:(NSInteger)aCarCD
                      carHeads:(NSInteger)aCarHeads
                       storeID:(NSInteger)aStoreID
                      imageIDs:(NSArray *) aImageIDsArray
                  withDelegate:(id <StorePostAdDelegate>) del {
    
    //1- set the delegate
    self.storeaAdPostingDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.storeaAdPostingDelegate)
            [self.storeaAdPostingDelegate storeAdDidFailEditingWithError:error];
        return ;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@;
    ///country=%@&city=%@&enceditid=%@&collection=%@;
    NSString * fullURLString = [NSString stringWithFormat:edit_store_ad_id_url,editADID,aStoreID];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        // NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        // NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        
        //post keys
        NSString * prePost =[NSString stringWithFormat:@"%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%@=%@",
                             TITLE_ATTR_ID, aTitle,
                             DESCRIPTION_ATTR_ID, aDescription,
                             PRICE_ATTR_ID, aPrice,
                             ADVERTISING_PERIOD_ATTR_ID, [NSString stringWithFormat:@"%i", aPeriodValueID],
                             MOBILE_NUMBER_ATTR_ID, aMobileNum,
                             CURRENCY_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aCurrencyValueID],
                             SERVICE_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aServiceValueID],
                             MANUFACTURE_YEAR_ATTR_ID, [NSString stringWithFormat:@"%i",aModelYearValueID],
                             DISTANCE_VALUE_ATTR_ID, aDistance,
                             PHONE_ATTR_ID,aPhoneNumer,
                             PHONE_NUMBER_ATTR_ID, usermail,
                             ADCOMMENTS_EMAIL_ATTR_ID, [NSString stringWithFormat:@"%i",aAdCommentsEmail],
                             KM_MILES_ATTR_ID, [NSString stringWithFormat:@"%i",aKmVSmilesValueID],
                             952,[NSString stringWithFormat:@"%i",anine52],
                             //528,[NSString stringWithFormat:@"%i",anine52],
                             506,aPrice,
                             906,anine06,
                             -101,aone01,
                             -98,[NSString stringWithFormat:@"%i",aninty8],
                             MY_ATTR_ID,[NSString stringWithFormat:@"%i",cityID],
                             //SERVICE_NAME_ATTR_ID,aServiceName,
                             //ADCOMMENTS_EMAIL_ATTR_ID,[NSString stringWithFormat:@"%i",aAdcommentsEmail],
                             CAR_CONDITION_ATTR_ID,[NSString stringWithFormat:@"%i",aCondition],
                             GEAR_TYPE_ATTR_ID,[NSString stringWithFormat:@"%i",aGearType],
                             CAR_ENGINE_ATTR_ID,[NSString stringWithFormat:@"%i",aCarEngine],
                             CAR_TYPE_ATTR_ID,[NSString stringWithFormat:@"%i",aCarType],
                             CAR_BODY_ATTR_ID,[NSString stringWithFormat:@"%i",aCarBody],
                             CAR_CD_ATTR_ID,[NSString stringWithFormat:@"%i",aCarCD],
                             CAR_HEADS_ATTR_ID,[NSString stringWithFormat:@"%i",aCarHeads],
                             COLOR_ATTR_ID, aColor,
                             IMAGES_ID_POST_KEY, [self getIDsStringFromArray:aImageIDsArray]];
        
        
        
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
        
        EditStoreAdMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.storeaAdPostingDelegate)
            [self.storeaAdPostingDelegate storeAdDidFailEditingWithError:error];
        return ;
    }
    
}


- (void) postStoreAdOfBrand:(NSInteger) brandID
                    myStore:(NSInteger) StoreID
                      Model:(NSInteger) modelID
                     InCity:(NSInteger) cityID
                  userEmail:(NSString *) usermail
                      title:(NSString *) aTitle
                description:(NSString *) aDescription
                      price:(NSString *) aPrice
              periodValueID:(NSInteger) aPeriodValueID
                     mobile:(NSString *) aMobileNum
            currencyValueID:(NSInteger) aCurrencyValueID
             serviceValueID:(NSInteger) aServiceValueID
           modelYearValueID:(NSInteger) aModelYearValueID
                   distance:(NSString *) aDistance
                      color:(NSString *) aColor
                 phoneNumer:(NSString *) aPhoneNumer
            adCommentsEmail:(BOOL) aAdCommentsEmail
           kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
                   imageIDs:(NSArray *) aImageIDsArray
                conditionID:(NSInteger) carConditionID      //new
                 gearTypeID:(NSInteger) gearTypeID          //new
                  carTypeID:(NSInteger)carTypeID            //new
                  carBodyID:(NSInteger)carBodyID
               withCategory:(NSInteger)brand
                  withCity1:(NSInteger)city
               withDelegate:(id <StorePostAdDelegate>) del
{
    //1- set the delegate
    self.storeaAdPostingDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.storeaAdPostingDelegate)
            [self.storeaAdPostingDelegate storeAdDidFailPostingWithError:error];
        return ;
    }
    
    //brandId=%@&cityId=%@&fromPhone=%i&userEmail=%@&collection=%@";
    //brandid=%@&cityId=%@&storeid=%@&collection=%@
    NSString * fullURLString = [NSString stringWithFormat:post_store_ad_url,
                                [NSString stringWithFormat:@"%i", brandID],
                                [NSString stringWithFormat:@"%i", cityID],
                                [NSString stringWithFormat:@"%i", StoreID],
                                @""];
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        NSDictionary * brandKeysDict = [[StaticAttrsLoader sharedInstance] loadBrandKeys];
        NSNumber * brandKeyForModel = [brandKeysDict objectForKey:[NSNumber numberWithInteger:brandID]];
        
        //post keys
        NSString * prePost =[NSString stringWithFormat:@"%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%@=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@&%i=%@",
                             TITLE_ATTR_ID, aTitle,
                             DESCRIPTION_ATTR_ID, aDescription,
                             PRICE_ATTR_ID, aPrice,
                             ADVERTISING_PERIOD_ATTR_ID, [NSString stringWithFormat:@"%i", aPeriodValueID],
                             MOBILE_NUMBER_ATTR_ID, aMobileNum,
                             CURRENCY_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aCurrencyValueID],
                             SERVICE_NAME_ATTR_ID, [NSString stringWithFormat:@"%i",aServiceValueID],
                             MANUFACTURE_YEAR_ATTR_ID, [NSString stringWithFormat:@"%i",aModelYearValueID],
                             DISTANCE_VALUE_ATTR_ID, aDistance,
                             COLOR_ATTR_ID, aColor,
                             PHONE_NUMBER_ATTR_ID, aPhoneNumer,
                             ADCOMMENTS_EMAIL_ATTR_ID, [NSString stringWithFormat:@"%i",aAdCommentsEmail],
                             KM_MILES_ATTR_ID, [NSString stringWithFormat:@"%i",aKmVSmilesValueID],
                             brandKeyForModel.integerValue, [NSString stringWithFormat:@"%i",modelID],
                             IMAGES_ID_POST_KEY, [self getIDsStringFromArray:aImageIDsArray],CAR_CONDITION_ATTR_ID,[NSString stringWithFormat:@"%i",carConditionID],GEAR_TYPE_ATTR_ID,[NSString stringWithFormat:@"%i",gearTypeID],CAR_TYPE_ATTR_ID,[NSString stringWithFormat:@"%i",carTypeID],CAR_BODY_ATTR_ID,[NSString stringWithFormat:@"%i",carBodyID],BRAND_ATTR_ID,[NSString stringWithFormat:@"%i",brandID],CITY_ATTR_ID,[NSString stringWithFormat:@"%i",cityID],10099,@"1000637",10102,@"1000667",10103,@"1000672"
                             ];
        /*BRAND_ATTR_ID
         NSString * prePost = @"524=text&523=نص&507=987123&502=1189&520=3210987456&508=1235&505=830&509=1207&518=321789&528=&868=&907=1&1076=2675&952=1553&ImagesID=\"7730822, 7730862\"";
         
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
        
        storePostAdManager = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.storeaAdPostingDelegate)
            [self.storeaAdPostingDelegate storeAdDidFailPostingWithError:error];
        return ;
    }
}


#pragma mark - Data delegate methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    
    if (manager == internetMngr)
    {
        if (self.delegate)
            [delegate adsDidFailLoadingWithError:error];
    }
    else if (manager == requestEditMngr)
    {
        if (self.delegate)
            [delegate RequestToEditFailWithError:error];
    }
    else if (manager == requestEditStoreMngr)
    {
        if (self.delegate)
            [delegate RequestToEditStoreFailWithError:error];
    }
    else if (manager == imageMngr)
    {
        if (self.imageDelegate)
            [imageDelegate imageDidFailUploadingWithError:error];
    }
    else if (manager == postAdManager)
    {
        if (self.adPostingDelegate)
            [adPostingDelegate adDidFailPostingWithError:error];
    }
    else if (manager == EditMngr)
    {
        if (self.adPostingDelegate)
            [adPostingDelegate adDidFailEditingWithError:error];
    }
    else if (manager == storePostAdManager)
    {
        if (self.storeaAdPostingDelegate)
            [storeaAdPostingDelegate storeAdDidFailPostingWithError:error];
    }
    else if (manager == EditStoreAdMngr)
    {
        if (self.storeaAdPostingDelegate)
            [storeaAdPostingDelegate storeAdDidFailEditingWithError:error];
    }
    else if (manager == SendingMngr)
    {
        if (self.EmailSendingDelegate)
            [self.EmailSendingDelegate EmailDidFailSendingWithError:error];
    }
}
- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
    
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (manager == internetMngr)
        {
            if (self.delegate)
                [delegate adsDidFailLoadingWithError:error];
        }
        else if (manager == requestEditMngr)
        {
            if (self.delegate)
                [delegate RequestToEditFailWithError:error];
        }
        else if (manager == requestEditStoreMngr)
        {
            if (self.delegate)
                [delegate RequestToEditStoreFailWithError:error];
        }
        else if (manager == imageMngr)
        {
            if (self.imageDelegate)
                [imageDelegate imageDidFailUploadingWithError:error];
        }
        else if (manager == postAdManager)
        {
            if (self.adPostingDelegate)
                [adPostingDelegate adDidFailPostingWithError:error];
        }
        else if (manager == postAdManager)
        {
            if (self.adPostingDelegate)
                [adPostingDelegate adDidFailEditingWithError:error];
        }
        else if (manager == storePostAdManager)
        {
            if (self.storeaAdPostingDelegate)
                [storeaAdPostingDelegate storeAdDidFailPostingWithError:error];
        }
        else if (manager == EditStoreAdMngr)
        {
            if (self.storeaAdPostingDelegate)
                [storeaAdPostingDelegate storeAdDidFailEditingWithError:error];
        }
        else if (manager == SendingMngr)
        {
            if (self.EmailSendingDelegate)
                [self.EmailSendingDelegate EmailDidFailSendingWithError:error];
        }
    }
    else
    {
        if (manager == internetMngr)
        {
            if (self.delegate)
            {
                NSArray * adsArray = [self createCarAdsArrayWithData:(NSArray *)result];
                [delegate adsDidFinishLoadingWithData:adsArray];
            }
            
        }
        else if (manager == requestEditMngr)
        {
            if (self.delegate)
            {
                NSArray * adsArray = [self createEditAdsArrayWithData:(NSArray *)result];
                NSArray * imgIDArray = [self createImageIDArrayWithData:(NSArray*) result];
                [delegate RequestToEditFinishWithData:adsArray imagesArray:imgIDArray];
            }
            
        }
        else if (manager == requestEditStoreMngr)
        {
            if (self.delegate)
            {
                NSArray * adsArray = [self createEditStoreAdsArrayWithData:(NSArray *)result];
                NSArray * imgIDArray = [self createImageIDArrayWithData:(NSArray*) result];
                [delegate RequestToEditStoreFinishWithData:adsArray imagesArray:imgIDArray];
            }
            
        }
        else if (manager == imageMngr)
        {
            if (self.imageDelegate)
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
                        
                        [imageDelegate imageDidFinishUploadingWithURL:imageURL CreativeID:imageID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.imageDelegate)
                            [imageDelegate imageDidFailUploadingWithError:error];
                    }
                    
                }
            }
        }
        else if (manager == postAdManager)
        {
            if (self.adPostingDelegate)
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
                        NSString * adIdString = [dataDict objectForKey:LISTING_ADD_ID_JKEY];
                        
                        NSInteger adID = [adIdString integerValue];
                        
                        [adPostingDelegate adDidFinishPostingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.adPostingDelegate)
                            [adPostingDelegate adDidFailPostingWithError:error];
                    }
                    
                }
            }
        }else if (manager == EditMngr)
        {
            if (self.adPostingDelegate)
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
                        NSString * adIdString = [dataDict objectForKey:LISTING_ADD_ID_JKEY];
                        
                        NSInteger adID = [adIdString integerValue];
                        
                        [adPostingDelegate adDidFinishEditingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.adPostingDelegate)
                            [adPostingDelegate adDidFailEditingWithError:error];
                    }
                    
                }
            }
        }
        else if (manager == EditStoreAdMngr)
        {
            if (self.storeaAdPostingDelegate)
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
                        NSString * adIdString = [dataDict objectForKey:LISTING_ADD_ID_JKEY];
                        
                        NSInteger adID = [adIdString integerValue];
                        
                        [storeaAdPostingDelegate storeAdDidFinishEditingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.storeaAdPostingDelegate)
                            [storeaAdPostingDelegate storeAdDidFailEditingWithError:error];
                    }
                    
                }
            }
        }
        else if (manager == SendingMngr)
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
                    if (self.EmailSendingDelegate)
                        [self.EmailSendingDelegate EmailDidFinishSendingWithStatus:YES];
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    if (self.EmailSendingDelegate)
                        [self.EmailSendingDelegate EmailDidFailSendingWithError:error];
                }
            }
        }
        else if (manager == storePostAdManager)
        {
            if (self.storeaAdPostingDelegate)
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
                        NSString * adIdString = [dataDict objectForKey:LISTING_ADD_ID_JKEY];
                        
                          NSInteger adID = [adIdString integerValue];
                        
                        [storeaAdPostingDelegate storeAdDidFinishPostingWithAdID:adID];
                    }
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                        [error setDescMessage:statusMessageProcessed];
                        if (self.storeaAdPostingDelegate)
                            [storeaAdPostingDelegate storeAdDidFailPostingWithError:error];
                    }
                    
                }
            }
        }
    }
}

#pragma mark - helper methods

//This method returns a string if IDs seperated by comma for an array of integer values
- (NSString *) getIDsStringFromArray:(NSArray *) input {
    
    if (!input)
        return @"";
    
    if (input.count == 0)
        return @"";
    
    NSString * output = @"";
    for (int i = 0; i < input.count; i++)
    {
        NSNumber * value = (NSNumber *) input[i];
        output = [output stringByAppendingFormat:@"%i,", value.integerValue];
    }
    
    output = [output substringToIndex:(output.length - 1)];
    return output;
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
                    
                    CarAd * ad =
                    [[CarAd alloc]
                     initWithAdIDString:[adDict objectForKey:LISTING_ADD_ID_JKEY]
                     ownerIDString:[adDict objectForKey:LISTING_OWNER_ID_JKEY]
                     storeIDString:[adDict objectForKey:LISTING_STORE_ID_JKEY]
                     isFeaturedString:[adDict objectForKey:LISTING_IS_FEATURED_JKEY]
                     thumbnailURL:[adDict objectForKey:LISTING_THUMBNAIL_URL_JKEY]
                     title:[adDict objectForKey:LISTING_TITLE_JKEY]
                     priceString:[adDict objectForKey:LISTING_PRICE_JKEY]
                     currencyString:[adDict objectForKey:LISTING_CURRENCY_JKEY]
                     postedOnDateString:[adDict objectForKey:LISTING_POSTED_ON_JKEY]
                     modelYearString:[adDict objectForKey:LISTING_MODEL_YEAR_JKEY]
                     distanceRangeInKmString:[adDict objectForKey:LISTING_DISTANCE_KM_JKEY]
                     viewCountString:[adDict objectForKey:LISTING_VIEW_COUNT_JKEY]
                     isFavoriteString:[adDict objectForKey:LISTING_IS_FAVORITE_JKEY]
                     storeName:[adDict objectForKey:LISTING_STORE_NAME_JKEY]
                     storeLogoURL:[adDict objectForKey:LISTING_STORE_LOGO_URL_JKEY]
                     EncryptedEditID:[adDict objectForKey:@"EncEditID"]
                     ];
                    
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
               
                    
                
                    
                    CarAd *ad = [[CarAd alloc] initWithAdIDTitle:[adDict objectForKey:[NSString stringWithFormat:@"%i",TITLE_ATTR_ID]]
                                                     EmailString:[adDict objectForKey:[NSString stringWithFormat:@"%i",PHONE_NUMBER_ATTR_ID]]
                                               descriptionString:[adDict objectForKey:[NSString stringWithFormat:@"%i",DESCRIPTION_ATTR_ID]]
                                                     priceString:[adDict objectForKey:[NSString stringWithFormat:@"%i",PRICE_ATTR_ID]]
                                                      cityString:[adDict objectForKey:[NSString stringWithFormat:@"%i",MY_ATTR_ID]]
                                                  currencyString:[adDict objectForKey:[NSString stringWithFormat:@"%i",CURRENCY_NAME_ATTR_ID]] distanceRangeInKmString:[adDict objectForKey:[NSString stringWithFormat:@"%i",KM_MILES_ATTR_ID]] modelYearString:[adDict objectForKey:[NSString stringWithFormat:@"%i",MANUFACTURE_YEAR_ATTR_ID]] distanceString:[adDict objectForKey:[NSString stringWithFormat:@"%i",DISTANCE_VALUE_ATTR_ID]] mobileNumberString:[adDict objectForKey:[NSString stringWithFormat:@"%i",MOBILE_NUMBER_ATTR_ID]]
                                                    thumbnailURL:@""
                                                          nine52:[adDict objectForKey:[NSString stringWithFormat:@"%i",952]]
                                                          five06:[adDict objectForKey:[NSString stringWithFormat:@"%i",506]]
                                                          five02:[adDict objectForKey:[NSString stringWithFormat:@"%i",502]]
                                                          nine06:[adDict objectForKey:[NSString stringWithFormat:@"%i",906]]
                                                           one01:[adDict objectForKey:[NSString stringWithFormat:@"%i",-101]]
                                                          ninty8:[adDict objectForKey:[NSString stringWithFormat:@"%i",-98]]];
                    
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
                
                
                
                
                CarAd *ad = [[CarAd alloc] initWithStoreAdIDTitle:[adDict objectForKey:[NSString stringWithFormat:@"%i",TITLE_ATTR_ID]]
                                                      EmailString:[adDict objectForKey:[NSString stringWithFormat:@"%i",PHONE_NUMBER_ATTR_ID]]
                                                descriptionString:[adDict objectForKey:[NSString stringWithFormat:@"%i",DESCRIPTION_ATTR_ID]]
                                                      priceString:[adDict objectForKey:[NSString stringWithFormat:@"%i",PRICE_ATTR_ID]]
                                                       cityString:[adDict objectForKey:[NSString stringWithFormat:@"%i",MY_ATTR_ID]]
                                                   currencyString:[adDict objectForKey:[NSString stringWithFormat:@"%i",CURRENCY_NAME_ATTR_ID]] distanceRangeInKmString:[adDict objectForKey:[NSString stringWithFormat:@"%i",KM_MILES_ATTR_ID]] modelYearString:[adDict objectForKey:[NSString stringWithFormat:@"%i",MANUFACTURE_YEAR_ATTR_ID]] distanceString:[adDict objectForKey:[NSString stringWithFormat:@"%i",DISTANCE_VALUE_ATTR_ID]] mobileNumberString:[adDict objectForKey:[NSString stringWithFormat:@"%i",MOBILE_NUMBER_ATTR_ID]]
                                                     thumbnailURL:@""
                                                           nine52:[adDict objectForKey:[NSString stringWithFormat:@"%i",952]]
                                                           five06:[adDict objectForKey:[NSString stringWithFormat:@"%i",506]]
                                                        advPeriod:[adDict objectForKey:[NSString stringWithFormat:@"%i",502]]
                                                           nine06:[adDict objectForKey:[NSString stringWithFormat:@"%i",906]]
                                                            one01:[adDict objectForKey:[NSString stringWithFormat:@"%i",-101]]
                                                           ninty8:[adDict objectForKey:[NSString stringWithFormat:@"%i",-98]]
                                                      serviceName:[adDict objectForKey:[NSString stringWithFormat:@"%i",SERVICE_NAME_ATTR_ID]]
                                                  adCommentsEmail:[adDict objectForKey:[NSString stringWithFormat:@"%i",ADCOMMENTS_EMAIL_ATTR_ID]]
                                                     carCondition:[adDict objectForKey:[NSString stringWithFormat:@"%i",CAR_CONDITION_ATTR_ID]]
                                                         gearType:[adDict objectForKey:[NSString stringWithFormat:@"%i",GEAR_TYPE_ATTR_ID]]
                                                        carEngine:[adDict objectForKey:[NSString stringWithFormat:@"%i",CAR_ENGINE_ATTR_ID]]
                                                          carType:[adDict objectForKey:[NSString stringWithFormat:@"%i",CAR_TYPE_ATTR_ID]]
                                                          carBody:[adDict objectForKey:[NSString stringWithFormat:@"%i",CAR_BODY_ATTR_ID]]
                                                            carCD:[adDict objectForKey:[NSString stringWithFormat:@"%i",CAR_CD_ATTR_ID]]
                                                         carHeads:[adDict objectForKey:[NSString stringWithFormat:@"%i",CAR_HEADS_ATTR_ID]]];
                
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
                     CarAd* myImage = [[CarAd alloc]initWithImageID:temp andImageURL:[adImgDict objectForKey:@"ImageURL"]];
                    
                    [adsArray addObject:myImage];
                
                }
            }
        }
        return adsArray;
    }
    return [NSArray new];
}


- (NSString *) getCacheFileNameForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  {
    
    //the file name is the string of listing URL without the page number and page size
    NSString * fullURLString = [NSString stringWithFormat:ads_url,
                                @"",
                                @"",
                                cityID,
                                @"",
                                [NSString stringWithFormat:@"%@", (brandID == -1 ? @"" : [NSString stringWithFormat:@"%i", brandID])],
                                [NSString stringWithFormat:@"%@", (modelID == -1 ? @"" : [NSString stringWithFormat:@"%i", modelID])],
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @""
                                ];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
    
    return [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}



@end