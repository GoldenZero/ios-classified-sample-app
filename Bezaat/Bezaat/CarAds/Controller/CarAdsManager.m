//
//  CarAdsManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarAdsManager.h"

#pragma mark - JSON Keys

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
#define DEFAULT_PAGE_SIZE           20

@interface CarAdsManager ()
{
    InternetManager * internetMngr;
}
@end

@implementation CarAdsManager

@synthesize delegate;
@synthesize pageNumber;
@synthesize pageSize;

static NSString * ads_url = @"http://gfctest.edanat.com/v1.0/json/searchads?pageNo=%i&pageSize=%i&cityId=%i&textTerm=%@&brandId=%i&modelId=%i&minPrice=%@&maxPrice=%@&destanceRange=%@&fromYear=%@&toYear=%@&adsWithImages=%@&adsWithPrice=%@&area=%@&orderby=%@";

static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = nil;
        self.pageNumber = 1;
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

- (void) loadCarAdsOfPage:(NSUInteger) pageNum forBrand:(NSUInteger) brandID Model:(NSUInteger) modelID InCity:(NSUInteger) cityID WithDelegate:(id <CarAdsManagerDelegate>) del {
    
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
    
    //3- set user credentials in HTTP header
    NSString * fullURLString = [NSString stringWithFormat:ads_url,
                                pageNum,
                                self.pageSize,
                                cityID,
                                @"",
                                brandID,
                                modelID,
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
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        //4- send the request
        [request setURL:correctURL];
        internetMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل اتحميل البيانات"];
        
        if (self.delegate)
            [self.delegate adsDidFailLoadingWithError:error];
        return ;
    }
    
}

#pragma mark - Data delegate methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {

    NSLog(@"Failure!! X(");
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
    NSLog(@"data received!");
}

#pragma mark - helper methods

- (NSArray * ) createCarAdsArrayWithData:(NSArray *) data {
    
}

@end
