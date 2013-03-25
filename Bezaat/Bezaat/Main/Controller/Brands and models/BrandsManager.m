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

#pragma mark - Brand json keys
#define BRAND_ID_JSONK           @"BrandID"
#define BRAND_NAME_AR_JSONK      @"BrandNameAr"
#define BRAND_URL_NAME_JSONK     @"UrlName"

#pragma mark - Model json keys

#define MODEL_ID_JSONK           @"ModelID"
#define MODEL_BRAND_ID_JSONK     @"BrandID"
#define MODEL_NAME_JSONK           @"ModelName"

#pragma mark -

@interface BrandsManager ()
{
        NSFileManager * fileMngr;
}
@end

@implementation BrandsManager
@synthesize delegate;

- (id) init {
    
    self = [super init];
    if (self) {
        fileMngr = [NSFileManager defaultManager];
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



- (void) loadBrandsAndModelsWithDelegate:(id<BrandManagerDelegate>)del {
    
    self.delegate = del;
    
    //1- load models
    NSData * modelsData = [NSData dataWithContentsOfFile:[self getModelsFilePath]];
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
    NSData * brandsData = [NSData dataWithContentsOfFile:[self getBrandsFilePath]];
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
    
    //sort brands according to chosen country
    [self.delegate didFinishLoadingWithData:resultBrands];//UNSORTED!!
    //[self.delegate didFinishLoadingWithData:[self sortBrandsArray:resultBrands]];
}

#pragma mark - helper methods

// This method gets the file path of brands file.
// This method checks if brands json file does not exist in documents --> that means we are
// launching the application the first time, so it copies it and returns its path in documents directory
- (NSString *) getBrandsFilePath {
    
    //1- search for "Brands.json" in documents
    BOOL brandsExistInDocuments = [GenericMethods fileExistsInDocuments:BRANDS_FILE_NAME];
    
    NSString * brandsDocumentPath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], BRANDS_FILE_NAME];
    
    //2- if not found: --> copy initial to documents
    if (!brandsExistInDocuments)
    {
        NSString * brandsfile = [BRANDS_FILE_NAME stringByReplacingOccurrencesOfString:@".json" withString:@""];
        
        NSString * sourcePath =  [[NSBundle mainBundle] pathForResource:brandsfile ofType:@"json"];
        
        NSError *error;
        [fileMngr copyItemAtPath:sourcePath toPath:brandsDocumentPath error:&error];
    }
    
    //3- return the path
    return brandsDocumentPath;
}


// This method gets the file path of models file.
// This method checks if models json file does not exist in documents --> that means we are
// launching the application the first time, so it copies it and returns its path in documents directory
- (NSString *) getModelsFilePath {
    
    //1- search for "Models.json" in documents
    BOOL modelsExistInDocuments = [GenericMethods fileExistsInDocuments:MODELS_FILE_NAME];
    
    NSString * modelsDocumentPath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], MODELS_FILE_NAME];
    
    //2- if not found: --> copy initial to documents
    if (!modelsExistInDocuments)
    {
        NSString * modelsfile = [MODELS_FILE_NAME stringByReplacingOccurrencesOfString:@".json" withString:@""];
        
        NSString * sourcePath =  [[NSBundle mainBundle] pathForResource:modelsfile ofType:@"json"];
        
        NSError *error;
        [fileMngr copyItemAtPath:sourcePath toPath:modelsDocumentPath error:&error];
    }
    
    //3- return the path
    return modelsDocumentPath;
}

- (UIImage *) loadImageOfBrand:(NSUInteger) aBrandID imageState:(BOOL) inverted {
    
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

@end
