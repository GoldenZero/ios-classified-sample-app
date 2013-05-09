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
#define CAR_CONDITION_FILE_NAME     @"car_condition.json"
#define GEAR_TYPE_FILE_NAME         @"gear_type.json"
#define CAR_TYPE_FILE_NAME          @"car_type.json"
#define CAR_BODY_FILE_NAME          @"car_body.json"
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

//-----------------------------------
#pragma mark - CAR_CONDITION json keys

#define CAR_CONDITION_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define CAR_CONDITION_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define CAR_CONDITION_DISPLAY_ORDER_JKEY                @"DisplayOrder"

//-----------------------------------
#pragma mark - GEAR_TYPE json keys

#define GEAR_TYPE_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define GEAR_TYPE_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define GEAR_TYPE_DISPLAY_ORDER_JKEY                @"DisplayOrder"

//-----------------------------------
#pragma mark - CAR_BODY json keys

#define CAR_BODY_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define CAR_BODY_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define CAR_BODY_DISPLAY_ORDER_JKEY                @"DisplayOrder"

//-----------------------------------
#pragma mark - CAR_TYPE json keys

#define CAR_TYPE_CAT_ATTR_MASTER_VALUE_ID_JKEY     @"CategoryAttributeMasterValueID"
#define CAR_TYPE_MASTER_VALUE_JKEY                 @"MasterValue" //the display name
#define CAR_TYPE_DISPLAY_ORDER_JKEY                @"DisplayOrder"


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
    NSDictionary * brandKeys;
    NSArray * conditionValues;
    NSArray * gearValues;
    NSArray * bodyValues;
    NSArray * typeValues;
    
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
        brandKeys = nil;
        conditionValues = nil;
        gearValues = nil;
        bodyValues = nil;
        typeValues = nil;
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
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:ADD_PERIOD_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:ADD_PERIOD_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:ADD_PERIOD_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
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
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:CURRENCY_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:CURRENCY_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:CURRENCY_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
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
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:KM_MILE_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:KM_MILE_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:KM_MILE_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
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
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:MODEL_YEAR_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:MODEL_YEAR_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:MODEL_YEAR_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
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
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:SERVICE_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:SERVICE_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:SERVICE_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
        serviceValues = temp;
    }
    return serviceValues;
}

- (NSDictionary *) loadBrandKeys {
    if (!brandKeys) {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:BRAND_MODELS_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableDictionary * result = [NSMutableDictionary new];
        for (NSDictionary * dict in parsedArray)
        {
            //create brandKey object
            NSString * brandIdString = [dict objectForKey: BRAND_MODELS_BRAND_ID_JKEY];
            NSString * modelKeyString = [dict objectForKey:BRAND_MODELS_MODEL_KEY_JKEY];
            
            NSNumber * brandID = [NSNumber numberWithInteger:[brandIdString integerValue]];
            NSNumber * modelKey = [NSNumber numberWithInteger:[modelKeyString integerValue]];
            
            [result setObject:modelKey forKey:brandID];
        }
        brandKeys = result;
    }
    return brandKeys;
}

- (NSArray *) loadConditionValues {
    
    if (!conditionValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:CAR_CONDITION_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:CAR_CONDITION_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:CAR_CONDITION_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:CAR_CONDITION_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
        conditionValues = temp;
        
    }
    return conditionValues;
}

- (NSArray *) loadGearValues {
    
    if (!gearValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:GEAR_TYPE_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:GEAR_TYPE_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:GEAR_TYPE_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:GEAR_TYPE_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
        gearValues = temp;
        
    }
    return gearValues;
}

- (NSArray *) loadBodyValues {
    
    if (!bodyValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:CAR_BODY_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:CAR_BODY_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:CAR_BODY_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:CAR_BODY_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
        bodyValues = temp;
    }
    return bodyValues;
}

- (NSArray *) loadCarTypeValues {
    
    if (!typeValues)
    {
        NSData * data = [NSData dataWithContentsOfFile:[self getJsonFilePathInDocumentsForFile:CAR_TYPE_FILE_NAME]];
        
        NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:data];
        NSMutableArray * result = [NSMutableArray new];
        for (NSDictionary * dict in parsedArray)
        {
            //create value object
            SingleValue * val = [[SingleValue alloc]
                                 initWithValueIDString:[dict objectForKey:CAR_TYPE_CAT_ATTR_MASTER_VALUE_ID_JKEY]
                                 valueString:[dict objectForKey:CAR_TYPE_MASTER_VALUE_JKEY]
                                 displayOrderString:[dict objectForKey:CAR_TYPE_DISPLAY_ORDER_JKEY]
                                 ];
            [result addObject:val];
        }
        NSArray * temp = [self sortValuesArray:result];
        typeValues = temp;
        
    }
    return typeValues;
}


- (NSInteger) getCurrencyIdOfCountry:(NSInteger) countryID {
    
    if ((!currencyValues) || (!currencyValues.count))
        return -1;
    
    if (countryID == -1)
        return -1;
    
    NSArray * allCountries = [[LocationManager sharedInstance] getTotalCountries];
    if (!allCountries)
        return -1;
    else
    {
        Country * cntry = [[LocationManager sharedInstance] getCountryByID:countryID];
        return cntry.currencyID;
    }
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
