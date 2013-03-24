//
//  CountryManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CountryManager.h"

#pragma mark - file names
#define COUNTRIES_FILE_NAME         @"Countries.json"
#define CITIES_FILE_NAME            @"Cities.json"
#define CURRENCIES_FILE_NAME        @"Currencies.json"

#pragma mark - json keys

#define COUNTRY_ID_JSONK            @"CountryID"
#define COUNTRY_NAME_JSONK          @"CountryName"
#define COUNTRY_NAME_EN_JSONK       @"CountryNameEn"
#define CURRENCY_ID_JSONK           @"CurrencyID"
#define DISPLAY_ORDER_JSONK         @"DisplayOrder"
#define COUNTRY_CODE_JSONK          @"CountryCode"

#pragma mark -

@interface CountryManager ()
{
    JSONParser * jsonParser;
}
@end


@implementation CountryManager
@synthesize delegate;


- (id) init {
    
    self = [super init];
    if (self) {
        //..
    }
    return self;
}

- (id) initWithDelegate:(id <CountryManagerDelegate>) del {
    self = [super init];
    if (self) {
        self.delegate = del;
    }
    return self;
}

- (void) loadCountries {
    //locate countries file in device documents
}

- (NSUInteger) getDefaultSelectedCountryIndex {
    return 0;
}

- (NSUInteger) getDefaultSelectedCityIndexForCountry:(NSUInteger) countryID {
    return 0;
}


#pragma mark - helper methods

- (NSString *) getCountriesFilePath {
    //1- search for "Countries.json" in documents
    
    //2- if found --> return path
    
    //3- not found: --> copy initial to documents
}

/*
 - (NSArray *) createCountriesArrayWithData:(NSArray *) data {
 NSMutableArray * countriesArr = [[NSMutableArray alloc] init];
 
 for (NSDictionary * countryDict in data)
 {
 Country * ctr = [[Country alloc]
 initWithCountryIDString:[countryDict objectForKey:COUNTRY_ID_JSONK]
 countryName:[countryDict objectForKey:COUNTRY_NAME_JSONK]
 geoName:[countryDict objectForKey:GEONAME_JSONK]
 displayOrderString:[countryDict objectForKey:DISPLAY_ORDER_JSONK]
 jsonBigFlagFNString:[countryDict objectForKey:JSON_BIG_FLAG_FN_JSONK]
 jsonDisplayMeString:[countryDict objectForKey:JSON_DISPLAY_ME_JSONK]
 jsonSmallFlagFNString:[countryDict objectForKey:JSON_SMALL_FLAG_FN_JSONK]
 currencyIDString:[countryDict objectForKey:CURRENCY_ID_JSONK]
 countryNameEn:[countryDict objectForKey:COUNTRY_NAME_EN_JSONK]
 currency:[countryDict objectForKey:CURRENCY_JSONK]
 ];
 
 if (ctr)
 [countriesArr addObject:ctr];
 }
 return countriesArr;
 }
 
 - (NSArray *) sortCountriesArray:(NSArray *) countriesArray {
 
 NSArray * sortedArray;
 sortedArray = [countriesArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
 NSUInteger first = [(Country *)a displayOrder];
 NSUInteger second = [(Country *)b displayOrder];
 return (first >= second);
 }];
 
 return sortedArray;
 }
 */

@end
