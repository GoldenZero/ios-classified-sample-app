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

#pragma mark - literals

//#define DEFAULT_PAGE_SIZE           20
#define DEFAULT_PAGE_SIZE           10
#define ARABIC_BEFORE_TEXT          @"قبل"
#define ARABIC_SECOND_TEXT          @"ثانية"
#define ARABIC_MINUTE_TEXT          @"دقيقة"
#define ARABIC_HOUR_TEXT            @"ساعة"
#define ARABIC_DAY_TEXT             @"يوم"
#define ARABIC_WEEK_TEXT            @"أسبوع"
#define ARABIC_MONTH_TEXT           @"شهر"
#define ARABIC_YEAR_TEXT            @"سنة"

@interface CarAdsManager ()
{
    InternetManager * internetMngr;
}
@end

@implementation CarAdsManager

@synthesize delegate;
@synthesize pageNumber;
@synthesize pageSize;

static NSString * ads_url = @"http://gfctest.edanat.com/v1.0/json/searchads?pageNo=%@&pageSize=%@&cityId=%i&textTerm=%@&brandId=%i&modelId=%@&minPrice=%@&maxPrice=%@&destanceRange=%@&fromYear=%@&toYear=%@&adsWithImages=%@&adsWithPrice=%@&area=%@&orderby=%@";

static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = nil;
        self.pageNumber = 0;
        self.pageSize = DEFAULT_PAGE_SIZE;
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
                                brandID,
                                [NSString stringWithFormat:@"%@", (modelID == -1 ? @"" : [NSString stringWithFormat:@"%i", modelID])],
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"1",   //by default, load images
                                @"1",   //by default, load images
                                @"",
                                @""
                                ];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSString * correctURLstring = @"http://gfctest.edanat.com/v1.0/json/searchads?pageNo=1&pageSize=10&cityId=13&textTerm=&brandId=208&modelId=2008&minPrice=&maxPrice=&destanceRange=&fromYear=&toYear=&adsWithImages=&adsWithPrice=&area=&orderby=";
    
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
        result = [NSString stringWithFormat:@"%@ %i %@", ARABIC_BEFORE_TEXT, (int)diffInSeconds, ARABIC_SECOND_TEXT];

    return result;
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
#pragma mark - Data delegate methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {

    if (self.delegate)
        [delegate adsDidFailLoadingWithError:error];
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
    
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
    }
    else
    {
        if (self.delegate)
        {
            NSArray * adsArray = [self createCarAdsArrayWithData:(NSArray *)result];
            [delegate adsDidFinishLoadingWithData:adsArray];
        }
    }
}

#pragma mark - helper methods

- (NSArray * ) createCarAdsArrayWithData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [totalDict objectForKey:LISTING_STATUS_CODE_JKEY];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * adsArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSArray * dataAdsArray = [totalDict objectForKey:LISTING_DATA_JKEY];
            if ((dataAdsArray) && (dataAdsArray.count))
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
                     ];
                    
                    [adsArray addObject:ad];
                    
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
                                brandID,
                                [NSString stringWithFormat:@"%@", (modelID == -1 ? @"" : [NSString stringWithFormat:@"%i", modelID])],
                                @"",
                                @"",
                                @"",
                                @"",
                                @"",
                                @"1",   //by default, load images
                                @"1",   //by default, load images
                                @"",
                                @""
                                ];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
    
    return [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}

@end
