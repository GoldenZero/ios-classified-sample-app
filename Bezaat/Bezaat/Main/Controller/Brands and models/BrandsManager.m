//
//  BrandsManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrandsManager.h"

#pragma mark - file names
#define BRANDS_FILE_NAME         @"Brands.json"
#define MODELS_FILE_NAME         @"Models.json"
#define BRANDS_ORDER_FILE_NAME   @"BrandsOrder.json"
#define DISTANCE_RANGES_FILE_NAME @"DistanceRanges.json"

//the file which should be loaded for brands UI
#define POST_MODELS_FILE_NAME       @"post_models.json"

#pragma mark - Brand json keys

#define BRAND_ID_JSONK           @"BrandID"
#define BRAND_NAME_AR_JSONK      @"BrandNameAr"
#define BRAND_URL_NAME_JSONK     @"UrlName"

#pragma mark - Model json keys

#define MODEL_ID_JSONK           @"ModelID"
#define MODEL_BRAND_ID_JSONK     @"BrandID"
#define MODEL_NAME_JSONK           @"ModelName"


#pragma mark - brandsOrder json keys

#define BORDER_ALL_COUNTRIES_JSONK          @"countries"
#define BORDER_PARENT_COUNTRY_JSONK         @"country"
#define BORDER_DEFAULT_COUNTRY_JSONK        @"default"
#define BORDER_COUNTRY_ID_JSONK             @"id"
#define BORDER_ALL_BRANDS_JSONK             @"brands"
#define BORDER_DISPLAY_ORDER_JSONK          @"displayOrder"
#define BORDER_BRAND_ID_JSONK               @"BrandID"

#pragma mark - distance ranges json keys

#define DISTANCE_RANGES_STATUS_CODE_JKEY    @"StatusCode"
#define DISTANCE_RANGES_STATUS_MSG_JKEY     @"StatusMessage"
#define DISTANCE_RANGES_DATA_JKEY           @"Data"

#define RANGE_ID_JKEY                       @"RangeId"
#define RANGE_NAME_JKEY                     @"RangeName"
#define RANGE_DISPLAY_ORDER_JKEY            @"DisplayOrder"

#pragma mark -

#pragma mark - BrandOrderPair struct definition
// This struct is used to store temporal displayOrder, brandID pair data after parsing the BrandsOrder json file

@interface BrandOrderPair : NSObject
@property (nonatomic) int displayOrder;
@property (nonatomic) int brandID;
@end

@implementation BrandOrderPair
@synthesize displayOrder, brandID;
@end

@interface BrandsManager ()
{
    NSFileManager * fileMngr;
    NSDictionary * brandsOrderDict;
    NSUInteger defaultCountryIDForOrdering;
    NSArray * totalBrands;
    NSArray * totalBrandsForPostAd;
    NSArray * distanceRanges;
    BOOL sortedOnce;
    BOOL isLoadingForPostAd;
}
@end

@implementation BrandsManager
@synthesize delegate;

- (id) init {
    
    self = [super init];
    if (self) {
        fileMngr = [NSFileManager defaultManager];
        brandsOrderDict = nil;              //initial value
        defaultCountryIDForOrdering = -1;   //initial value
        totalBrands = nil;
        totalBrandsForPostAd = nil;
        distanceRanges = nil;
        sortedOnce = NO;
        isLoadingForPostAd = NO;
    }
    return self;
}

+ (BrandsManager *) sharedInstance {
    static BrandsManager * instance = nil;
    if (instance == nil) {
        instance = [[BrandsManager alloc] init];
    }
    return instance;
}



- (void) getBrandsAndModelsWithDelegate:(id<BrandManagerDelegate>)del {
    
    isLoadingForPostAd = NO;
    
    if (del)
        self.delegate = del;
    
    //check if brands has been loaded before
    if (!totalBrands)
    {
        //1- load models
        NSData * modelsData = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:MODELS_FILE_NAME]];
        
        NSArray * modelsParsedArray = [[JSONParser sharedInstance] parseJSONData:modelsData];
        
        //2- store models in a dictionary with brandID as key
        NSString * brandIdKey;
        NSMutableDictionary * modelsDictionary = [NSMutableDictionary new];
        for (NSDictionary * modelDict in modelsParsedArray)
        {
            //create model object
            Model * model = [[Model alloc]
                             initWithModelIDString:[modelDict objectForKey:MODEL_ID_JSONK]
                             brandIDString:[modelDict objectForKey:MODEL_BRAND_ID_JSONK]
                             modelName:[modelDict objectForKey:MODEL_NAME_JSONK]
                             ];
            
            brandIdKey = [NSString stringWithFormat:@"%i", model.brandID];
            
            //add model to models dictionary
            if (![modelsDictionary objectForKey:brandIdKey])
                [modelsDictionary setObject:[NSMutableArray new] forKey:brandIdKey];
            [(NSMutableArray *)[modelsDictionary objectForKey:brandIdKey] addObject:model];
            
        }
        
        //3- load brands
        NSData * brandsData = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:BRANDS_FILE_NAME]];
        NSArray * brandsParsedArray = [[JSONParser sharedInstance] parseJSONData:brandsData];
        
        //4- store brands in array (This array holds countries and their models **INSIDE**)
        NSMutableArray * resultBrands = [NSMutableArray new];
        for (NSDictionary * brandDict in brandsParsedArray)
        {
            NSString * brandIdStr = [brandDict objectForKey:BRAND_ID_JSONK];
            NSUInteger theBrandID = brandIdStr.integerValue;
            
            UIImage * theBrandImage = [self loadImageOfBrand:theBrandID imageState:NO];
            UIImage * theBrandInvertedImage = [self loadImageOfBrand:theBrandID imageState:YES];
            
            //create brand object
            Brand * brand = [[Brand alloc]
                             initWithBrandIDString:brandIdStr
                             brandNameAr:[brandDict objectForKey:BRAND_NAME_AR_JSONK]
                             urlName:[brandDict objectForKey:BRAND_URL_NAME_JSONK]
                             brandImage:theBrandImage
                             brandInvertedImage:theBrandInvertedImage
                             ];
            brandIdKey = [NSString stringWithFormat:@"%i", brand.brandID];
            
            //get array of models
            NSArray * modelsOfBrand = [NSArray arrayWithArray:[modelsDictionary objectForKey:brandIdKey]];
            
            //set models of brand
            brand.models = modelsOfBrand;
            
            //add brand
            [resultBrands addObject:brand];
        }
        totalBrands = resultBrands;
    }
    
    //if ((!sortedOnce) && ([[SharedUser sharedInstance] getUserCountryID] > -1))
    if ([[SharedUser sharedInstance] getUserCountryID] > -1)
    {
        //sort brands according to chosen country
        NSArray * temp = [NSArray arrayWithArray:[self sortBrandsArray:totalBrands]];
        totalBrands = temp;
    }
    
    if (del)
        [self.delegate brandsDidFinishLoadingWithData:totalBrands];
}

- (void) getBrandsAndModelsForPostAdWithDelegate:(id<BrandManagerDelegate>)del {
    
    isLoadingForPostAd = YES;
    
    if (del)
        self.delegate = del;
    
    //check if brands has been loaded before
    if (!totalBrandsForPostAd)
    {
        //1- load models
        NSData * modelsData = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:POST_MODELS_FILE_NAME]];
        
        NSArray * modelsParsedArray = [[JSONParser sharedInstance] parseJSONData:modelsData];
        
        //2- store models in a dictionary with brandID as key
        NSString * brandIdKey;
        NSMutableDictionary * modelsDictionary = [NSMutableDictionary new];
        for (NSDictionary * modelDict in modelsParsedArray)
        {
            //create model object
            Model * model = [[Model alloc]
                             initWithModelIDString:[modelDict objectForKey:MODEL_ID_JSONK]
                             brandIDString:[modelDict objectForKey:MODEL_BRAND_ID_JSONK]
                             modelName:[modelDict objectForKey:MODEL_NAME_JSONK]
                             ];
            
            brandIdKey = [NSString stringWithFormat:@"%i", model.brandID];
            
            //add model to models dictionary
            if (![modelsDictionary objectForKey:brandIdKey])
                [modelsDictionary setObject:[NSMutableArray new] forKey:brandIdKey];
            [(NSMutableArray *)[modelsDictionary objectForKey:brandIdKey] addObject:model];
            
        }
        
        //3- load brands
        NSData * brandsData = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:BRANDS_FILE_NAME]];
        NSArray * brandsParsedArray = [[JSONParser sharedInstance] parseJSONData:brandsData];
        
        //4- store brands in array (This array holds countries and their models **INSIDE**)
        NSMutableArray * resultBrands = [NSMutableArray new];
        for (NSDictionary * brandDict in brandsParsedArray)
        {
            NSString * brandIdStr = [brandDict objectForKey:BRAND_ID_JSONK];
            NSUInteger theBrandID = brandIdStr.integerValue;
            
            UIImage * theBrandImage = [self loadImageOfBrand:theBrandID imageState:NO];
            UIImage * theBrandInvertedImage = [self loadImageOfBrand:theBrandID imageState:YES];
            
            //create brand object
            Brand * brand = [[Brand alloc]
                             initWithBrandIDString:brandIdStr
                             brandNameAr:[brandDict objectForKey:BRAND_NAME_AR_JSONK]
                             urlName:[brandDict objectForKey:BRAND_URL_NAME_JSONK]
                             brandImage:theBrandImage
                             brandInvertedImage:theBrandInvertedImage
                             ];
            brandIdKey = [NSString stringWithFormat:@"%i", brand.brandID];
            
            //get array of models
            NSArray * modelsOfBrand = [NSArray arrayWithArray:[modelsDictionary objectForKey:brandIdKey]];
            
            //set models of brand
            brand.models = modelsOfBrand;
            
            //add brand
            [resultBrands addObject:brand];
        }
        
        totalBrandsForPostAd = resultBrands;
        NSArray * temp;
        if ([[SharedUser sharedInstance] getUserCountryID] > -1)
        {
            //sort brands according to chosen country
            temp = [NSArray arrayWithArray:[self sortBrandsArray:resultBrands]];
            totalBrandsForPostAd = temp;
        }
    }
    if (del)
        [self.delegate brandsDidFinishLoadingWithData:totalBrandsForPostAd];
}

- (NSArray *) getDistanceRangesArray {
    
    if (!distanceRanges)
    {
        //1- load distance range
        NSData * distanceRangesData = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:DISTANCE_RANGES_FILE_NAME]];
        
        NSArray * distanceRangeParsedArray = [[JSONParser sharedInstance] parseJSONData:distanceRangesData];
        
        NSDictionary * totalDict = [distanceRangeParsedArray objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:DISTANCE_RANGES_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        NSMutableArray * resultRangesArray = [NSMutableArray new];
        if (statusCode == 200)
        {
            NSArray * dataRangesArray = [totalDict objectForKey:DISTANCE_RANGES_DATA_JKEY];
            if ((dataRangesArray) && (dataRangesArray.count))
            {
                for (NSDictionary * rangeDict in dataRangesArray)
                {
                    DistanceRange * range =
                    [[DistanceRange alloc]
                     initWithRangeIDString:[rangeDict objectForKey:RANGE_ID_JKEY]
                     rangeName:[rangeDict objectForKey:RANGE_NAME_JKEY]
                     displayOrderString:[rangeDict objectForKey:RANGE_DISPLAY_ORDER_JKEY]
                     
                     ];
                    [resultRangesArray addObject:range];
                }
            }
        }
        
        NSArray * sortedRanges = [self sortDistanceRangesArray:resultRangesArray];
        distanceRanges = [NSArray arrayWithArray:sortedRanges];
    }
    
    return distanceRanges;
}

- (NSArray *) getYearsArray {
    
    NSMutableArray * resultArray = [NSMutableArray new];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    NSInteger currentYear = [yearString integerValue];
    NSInteger year = currentYear;
    
    while (year > 2002) {
        [resultArray addObject:[NSString stringWithFormat:@"%i", year]];
        year = year - 1;
    }
    
    [resultArray addObject:[NSString stringWithFormat:@"قبل %i", 2003]];
    
    return resultArray;
}

#pragma mark - helper methods

// This method gets the file path ofthe specified file.
// This method checks if the json file does not exist in documents --> that means we are
// launching the application the first time, so it copies it and returns its path in documents directory
// aFileName should be the file name with .json suffix
- (NSString *) getJsonFilePathInDocumentsForFile:(NSString *) aFileName {
    
    //1- search for json file in documents
    BOOL fileExistInDocs = [GenericMethods fileExistsInDocuments:aFileName];
    
    NSString * fileDocumentPath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], aFileName];
    
    //2- if not found: --> copy initial to documents
    if (!fileExistInDocs)
    {
        NSString * file = [aFileName stringByReplacingOccurrencesOfString:@".json" withString:@""];
        
        NSString * sourcePath =  [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
        
        NSError *error;
        [fileMngr copyItemAtPath:sourcePath toPath:fileDocumentPath error:&error];
    }
    
    //3- return the path
    return fileDocumentPath;
}

- (UIImage *) loadImageOfBrand:(NSInteger) aBrandID imageState:(BOOL) inverted {
    
    NSString * imageFileName;
    if (inverted)
        imageFileName = [NSString stringWithFormat:@"%i_inverted.png", aBrandID];
    else
        imageFileName = [NSString stringWithFormat:@"%i.png", aBrandID];
    
    //search for file in documents
    BOOL imageExistsInDocuments = [GenericMethods fileExistsInDocuments:imageFileName];
    
    NSString * imageDocumentPath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], imageFileName];
    
    //if not found: --> copy initial to documents
    if (!imageExistsInDocuments)
    {
        NSString * imageName = [imageFileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        
        NSString * sourcePath =  [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        
        //if image is not added initialy to sources and not found in documents
        // --> NO Image found at all!!
        if (!sourcePath)
            return nil;
        
        NSError * error;
        [fileMngr copyItemAtPath:sourcePath toPath:imageDocumentPath error:&error];
    }
    
    UIImage * resultImage = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageDocumentPath])
        resultImage = [UIImage imageWithContentsOfFile:imageDocumentPath];
    
    return resultImage;
    
}

// This method takes the brands array as input and the array of ordering which contains the pairs objects
- (NSArray *) sortBrandsArray:(NSArray *) input {
    NSMutableArray * sorted = [NSMutableArray new];
    
    if ((!brandsOrderDict) || (defaultCountryIDForOrdering == -1))
    {
        
        //1- parse the BrandsOrder json file
        NSData * orderData = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:BRANDS_ORDER_FILE_NAME]];
        
        NSArray * orderParsedArray = [[JSONParser sharedInstance] parseJSONData:orderData];
        
        // The whole file is represented in a single dictionary with key of ("countries")
        // This root dictionary holds 2 keys:
        // 1- "country" --> array of (displayOrder, brandID) pairs inside,
        // 2- "default" --> the value of default country id for ordering brands.
        NSDictionary * rootCountriesDict = [orderParsedArray[0] objectForKey:BORDER_ALL_COUNTRIES_JSONK];
        
        // The array that holds country objects.
        NSArray * countriesArray = [rootCountriesDict objectForKey:BORDER_PARENT_COUNTRY_JSONK];
        
        NSString * countryIdKey;
        
        //The dictionary to store order data
        NSMutableDictionary * orderDictionary = [NSMutableDictionary new];
        
        // Each country contains an array of brand order pairs + country id
        for (NSDictionary * countryDict in countriesArray)
        {
            countryIdKey = [countryDict objectForKey:BORDER_COUNTRY_ID_JSONK];
            NSArray * brandsParsedArray = [countryDict objectForKey:BORDER_ALL_BRANDS_JSONK];
            
            NSMutableArray * brandOrderPairs = [NSMutableArray new];
            for (NSDictionary * brandOrderPairDict in brandsParsedArray)
            {
                NSString * displayOrderString = [brandOrderPairDict objectForKey:BORDER_DISPLAY_ORDER_JSONK];
                NSString * brandIDString = [brandOrderPairDict objectForKey:BORDER_BRAND_ID_JSONK];
                
                BrandOrderPair * pair = [[BrandOrderPair alloc] init];
                pair.displayOrder = displayOrderString.integerValue;
                pair.brandID = brandIDString.integerValue;
                
                //add to result array
                [brandOrderPairs addObject:pair];
            }
            //sort the array
            NSArray * sortedBrandOrderPairs = [self sortBrandsOrderArray:brandOrderPairs];
            
            //add to dictionary
            [orderDictionary setObject:sortedBrandOrderPairs forKey:countryIdKey];
        }
        
        
        // The default country id to be used for ordering brands array
        NSString * defaultCountryIDString = [rootCountriesDict objectForKey:BORDER_DEFAULT_COUNTRY_JSONK];
        
        defaultCountryIDForOrdering = defaultCountryIDString.integerValue;
        
        brandsOrderDict = orderDictionary;
        defaultCountryIDForOrdering = defaultCountryIDString.integerValue;
        
    }
    
    NSString * chosenCountryIdKey = [NSString stringWithFormat:@"%i", [[SharedUser sharedInstance] getUserCountryID]];
    
    if ([[SharedUser sharedInstance] getUserCountryID] != -1)
    {
        
        NSArray * orderingArray;
        if ([brandsOrderDict objectForKey:chosenCountryIdKey])
            orderingArray = [brandsOrderDict objectForKey:chosenCountryIdKey];
        else
            orderingArray = [brandsOrderDict objectForKey:[NSString stringWithFormat:@"%i", defaultCountryIDForOrdering]];
        
        for (int i = 0; i < orderingArray.count; i++)
        {
            BrandOrderPair * p = orderingArray[i];
            Brand * brand = [self getBrandByID:p.brandID brands:input];
            [sorted addObject:brand];
        }
        if (!isLoadingForPostAd)
            sortedOnce = YES;
    }
    
    return sorted;
}


//This method is to sort an array of (BrandOrderPair) objects
- (NSArray *) sortBrandsOrderArray:(NSArray *) input {
    
    NSArray * sortedArray;
    sortedArray = [input sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [(BrandOrderPair *)a displayOrder];
        NSInteger second = [(BrandOrderPair *)b displayOrder];
        return (first >= second);
    }];
    
    return sortedArray;
}

- (Brand *) getBrandByID:(NSUInteger) aBrandID brands:(NSArray *) brandsArray {
    for (Brand * currentBrand in brandsArray)
    {
        if (currentBrand.brandID == aBrandID)
        {
            
            Brand * result = [[Brand alloc]
                              initWithBrandIDString:[NSString stringWithFormat:@"%i", currentBrand.brandID]
                              brandNameAr:currentBrand.brandNameAr
                              urlName:currentBrand.urlName
                              brandImage:currentBrand.brandImage
                              brandInvertedImage:currentBrand.brandInvertedImage];
            result.models = [NSArray arrayWithArray:currentBrand.models];
            
            return result;
        }
    }
    return nil;
}

- (NSArray *) sortDistanceRangesArray:(NSArray *) rangesArray {
    
    NSArray * sortedArray;
    sortedArray = [rangesArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [(DistanceRange *)a displayOrder];
        NSInteger second = [(DistanceRange *)b displayOrder];
        return (first >= second);
    }];
    
    return sortedArray;
}

@end
