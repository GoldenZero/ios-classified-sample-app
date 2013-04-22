//
//  StaticAttrsLoader.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StaticAttrsLoader.h"

#pragma mark - file names

#define ADD_PERIOD_FILE_NAME        @"add_period.json"
#define BRAND_MODELS_FILE_NAME      @"brand_models_key.json" //The arrtibute key for chosen brand.
#define CAT_ATTRS_FILE_NAME         @"category_attributes.json"
#define CURRENCY_FILE_NAME          @"currency.json"
#define KM_MILE_FILE_NAME           @"km_mile.json"
#define MODEL_YEAR_FILE_NAME        @"model_year.json"
#define SERVICE_FILE_NAME           @"service.json"

//<BRAND_MODELS_ID --> ModelsKey : POST_MODELS --> ModelsID>

#pragma mark - ADD_PERIOD json keys

#define ADD_PERIOD_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define ADD_PERIOD_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define ADD_PERIOD_DISPLAY_ORDER_JKEY                @"DisplayOrder"

//-----------------------------------
#pragma mark - BRAND_MODELS json keys

#define BRAND_MODELS_MODEL_KEY_JKEY     @"ModelKey"
#define BRAND_MODELS_BRAND_ID_JKEY      @"BrandID"

//-----------------------------------
#pragma mark - CAT_ATTRS json keys

#define CAT_ATTRS_CAT_ATTR_ID_JKEY      @"CategoryAttributeID"
#define CAT_ATTRS_CAT_ATTR_NAME_JKEY    @"CategoryAttributeName"
#define CAT_ATTRS_DISPLAY_ORDER_JKEY    @"DisplayOrder"
#define CAT_ATTRS_IS_REQUIRED_JKEY      @"IsRequired"
#define CAT_ATTRS_ATTR_NAME_JKEY        @"AttributeName"

//-----------------------------------
#pragma mark - CURRENCY json keys

#define CURRENCY_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define CURRENCY_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define CURRENCY_DISPLAY_ORDER_JKEY                @"DisplayOrder"

//-----------------------------------
#pragma mark - KM_MILE json keys

#define KM_MILE_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define KM_MILE_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define KM_MILE_DISPLAY_ORDER_JKEY                @"DisplayOrder"

//-----------------------------------
#pragma mark - MODEL_YEAR json keys

#define MODEL_YEAR_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define MODEL_YEAR_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define MODEL_YEAR_DISPLAY_ORDER_JKEY                @"DisplayOrder"

//-----------------------------------
#pragma mark - SERVICE json keys

#define SERVICE_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define SERVICE_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define SERVICE_DISPLAY_ORDER_JKEY                @"DisplayOrder"

@implementation SingleValue
@synthesize valueID, valueString, displayOrder;

- (id) initWithValueIDString:(NSString *) aValueIdString
                 valueString:(NSString *) aValueString
          displayOrderString:(NSString *) aDisplayOrderString {
    
    self = [super init];
    
    if (self) {
        //valueID
        self.valueID = [aValueIdString integerValue];
        
        //valueString
        self.valueString = aValueString;
        
        //displayOrder
        self.displayOrder = [aDisplayOrderString integerValue];
    }
    return self;
}

- (NSString *) description {

    return [NSString stringWithFormat:@"value ID: %i, MasterValue: %@, displayOrder: %i", self.valueID, self.valueString, self.displayOrder];
}

@end
//-------------------------------------------------------------

@interface StaticAttrsLoader () {
    NSFileManager * fileMngr;
    NSArray * addPeriodValues;
    NSArray * currencyValues;
    NSArray * distanceValues;
    NSArray * modelYearValues;
    NSArray * serviceValues;
}
@end

@implementation StaticAttrsLoader

- (id) init {
    
    self = [super init];
    if (self) {
        fileMngr = [NSFileManager defaultManager];
        addPeriodValues = nil;
        currencyValues = nil;
        distanceValues = nil;
        modelYearValues = nil;
        serviceValues = nil;
    }
    return self;
}

+ (StaticAttrsLoader *) sharedInstance {
    static StaticAttrsLoader * instance = nil;
    if (instance == nil) {
        instance = [[StaticAttrsLoader alloc] init];
    }
    return instance;
}

- (NSArray *) loadAddPeriodValues {
    
    if (!addPeriodValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:ADD_PERIOD_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create model object
            SingleValue * val = [[SingleValue alloc]
                             initWithValueIDString:[dict objectForKey:ADD_PERIOD_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:ADD_PERIOD_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:ADD_PERIOD_DISPLAY_ORDER_JKEY]
                             ];
            [result addObject:val];
        }
        NSArray * temp = [NSArray arrayWithArray:[self sortValuesArray:result]];
        addPeriodValues = temp;
    }
    return addPeriodValues;
}

- (NSArray *) loadCurrencyValues {
    
    if (!currencyValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:CURRENCY_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create model object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:CURRENCY_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:CURRENCY_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:CURRENCY_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [NSArray arrayWithArray:[self sortValuesArray:result]];
        currencyValues = temp;
    }
    return currencyValues;
}

- (NSArray *) loadDistanceValues {
    
    if (!distanceValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:KM_MILE_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create model object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:KM_MILE_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:KM_MILE_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:KM_MILE_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [NSArray arrayWithArray:[self sortValuesArray:result]];
        distanceValues = temp;
        
    }
    return distanceValues;
}

- (NSArray *) loadModelYearValues {
    
    if (!modelYearValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:MODEL_YEAR_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create model object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:MODEL_YEAR_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:MODEL_YEAR_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:MODEL_YEAR_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [NSArray arrayWithArray:[self sortValuesArray:result]];
        modelYearValues = temp;
        
    }
    return modelYearValues;
}

- (NSArray *) loadServiceValues {
    if (!addPeriodValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:SERVICE_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create model object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:SERVICE_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:SERVICE_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:SERVICE_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [NSArray arrayWithArray:[self sortValuesArray:result]];
        serviceValues = temp;
    }
    return serviceValues;
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

- (NSArray *) sortValuesArray:(NSArray *) valuesArray {
    
    NSArray * sortedArray;
    sortedArray = [valuesArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [(SingleValue *)a displayOrder];
        NSInteger second = [(SingleValue *)b displayOrder];
        return (first >= second);
    }];
    
    return sortedArray;
}

@end