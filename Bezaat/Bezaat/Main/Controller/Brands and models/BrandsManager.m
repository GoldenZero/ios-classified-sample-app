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

+ (BrandsManager *)sharedInstance {
    static BrandsManager * instance = nil;
    if (instance == nil) {
        instance = [[BrandsManager alloc] init];
    }
    return instance;
}



- (void) loadBrandsAndModelsWithDelegate:(id<BrandManagerDelegate>)del {
    self.delegate = del;
    
    //load JSON data
}

#pragma mark - helper methods

// This method gets the file path of brands file.
// This method checks if brands json file does not exist in documents --> that means we are
// launching the application the first time, so it copies it and returns its path in documents directory
- (NSString *) getBrandsFilePath {
    
    //1- search for "Countries.json" in documents
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

/*
// This method gets the file path of cities file.
// This method checks if countries json file does not exist in documents --> that means we are
// launching the application the first time, so it copies it and returns its path in documents directory
- (NSString *) getCitiesFilePath {
    
    //1- search for "Cities.json" in documents
    BOOL citiesExistInDocuments = [GenericMethods fileExistsInDocuments:CITIES_FILE_NAME];
    
    NSString * citiesDocumentPath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], CITIES_FILE_NAME];
    
    //2- if not found: --> copy initial to documents
    if (!citiesExistInDocuments)
    {
        
        NSString * citiesfile = [CITIES_FILE_NAME stringByReplacingOccurrencesOfString:@".json" withString:@""];
        
        NSString * sourcePath =  [[NSBundle mainBundle] pathForResource:citiesfile ofType:@"json"];
        
        NSError *error;
        [fileMngr copyItemAtPath:sourcePath toPath:citiesDocumentPath error:&error];
    }
    
    //3- return the path
    return citiesDocumentPath;
}*/

@end
