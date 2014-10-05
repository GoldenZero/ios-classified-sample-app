//
//  StaticAttrsLoader.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - attribute IDs for posting an ad

#define TITLE_ATTR_ID               524
#define DESCRIPTION_ATTR_ID         523
#define PRICE_ATTR_ID               507
#define ADVERTISING_PERIOD_ATTR_ID  502
#define MOBILE_NUMBER_ATTR_ID       520
#define CURRENCY_NAME_ATTR_ID       508
#define SERVICE_NAME_ATTR_ID        505
#define MANUFACTURE_YEAR_ATTR_ID    509
#define DISTANCE_VALUE_ATTR_ID      518
#define COLOR_ATTR_ID               528
#define PHONE_NUMBER_ATTR_ID        -100
#define PHONE_ATTR_ID               868
#define ADCOMMENTS_EMAIL_ATTR_ID    907
#define KM_MILES_ATTR_ID            1076
#define CAR_CONDITION_ATTR_ID       10097
#define GEAR_TYPE_ATTR_ID           10098
#define CAR_TYPE_ATTR_ID            10101
#define CAR_BODY_ATTR_ID            10100
#define CAR_ENGINE_ATTR_ID          10099
#define CAR_CD_ATTR_ID              10102
#define CAR_HEADS_ATTR_ID           10103

#define BRAND_ATTR_ID               -98
#define MY_ATTR_ID                  -99
#define CITY_ATTR_ID                -180
#define IMAGES_ID_POST_KEY          @"ImagesID"

#pragma mark -

@interface SingleValue : NSObject

@property (nonatomic) NSInteger valueID;
@property (strong, nonatomic) NSString * valueString;
@property (nonatomic) NSInteger displayOrder;

- (id) initWithValueIDString:(NSString *) aValueIdString
                 valueString:(NSString *) aValueString
          displayOrderString:(NSString *) aDisplayOrderString;
@end

//----------------------------------------------------------
@interface StaticAttrsLoader : NSObject

// get the shared instance of BarndsManager
+ (StaticAttrsLoader *) sharedInstance;

//load ADD_PERIOD file (No need to load them in UI)
- (NSArray *) loadAddPeriodValues;

//load CURRENCY file
- (NSArray *) loadCurrencyValues;

//load KM_MILE file
- (NSArray *) loadDistanceValues;

//load MODEL_YEAR file
- (NSArray *) loadModelYearValues;

//load PERIOD_file file
- (NSArray *) loadPeriodValues;

//load PERIOD_file file
- (NSArray *) loadRoomsValues;

- (NSArray *) loadRoomsValuesForSale;


//load SERVICE file (No need to load them in UI)
- (NSArray *) loadServiceValues;

//load BRAND_MODELS file
- (NSDictionary *) loadBrandKeys;

//load CAR_CONDITION file
- (NSArray *) loadConditionValues;

//load UNIT_TYPE file
- (NSArray *) loadUnitValues;

//load CAR_BODY file
- (NSArray *) loadBodyValues;

//load CAR_TYPE file
- (NSArray *) loadCarTypeValues;

//load CAT_ATTRS file
//category attributes would be fixed in code without parsing the JSON file

//This method retuns -1 for error
- (NSInteger) getCurrencyIdOfCountry:(NSInteger) countryID;

- (NSString *) getJsonFilePathInDocumentsForFile:(NSString *) aFileName;
@end
