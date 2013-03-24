//
//  LocationManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "LocationManager.h"

#pragma mark - file names
#define COUNTRIES_FILE_NAME         @"Countries.json"
#define CITIES_FILE_NAME            @"Cities.json"
#define CURRENCIES_FILE_NAME        @"Currencies.json"

#pragma mark - Country json keys
#define COUNTRY_ID_JSONK            @"CountryID"
#define COUNTRY_NAME_JSONK          @"CountryName"
#define COUNTRY_NAME_EN_JSONK       @"CountryNameEn"
#define COUNTRY_CURRENCY_ID_JSONK   @"CurrencyID"
#define COUNTRY_DISPLAY_ORDER_JSONK @"DisplayOrder"
#define COUNTRY_CODE_JSONK          @"CountryCode"

#pragma mark - City json keys
#define CITY_ID_JSONK            @"CityID"
#define CITY_NAME_JSONK          @"CityName"
#define CITY_NAME_EN_JSONK       @"CityNameEn"
#define CITY_COUNTRY_ID_JSONK    @"CountryID"
#define CITY_DISPLAY_ORDER_JSONK @"DisplayOrder"

#pragma mark -

@interface LocationManager ()
{
    NSFileManager * fileMngr;
    CLLocationManager * cllocationMngr;
}
@end


@implementation LocationManager
@synthesize delegate;


- (id) init {
    
    self = [super init];
    if (self) {
        fileMngr = [NSFileManager defaultManager];
    }
    return self;
}

- (id) initWithDelegate:(id <LocationManagerDelegate>) del {
    self = [super init];
    if (self) {
        self.delegate = del;
        fileMngr = [NSFileManager defaultManager];
    }
    return self;
}

- (void) loadCountriesAndCities {
    
    //1- load cities
    NSData * citiesData = [NSData dataWithContentsOfFile:[self getCitiesFilePath]];
    NSArray * citiesParsedArray = [[JSONParser sharedInstance] parseJSONData:citiesData];
    
    //2- store cities in a dictionary with countryID as key
    NSString * countryIdKey;
    NSMutableDictionary * citiesDictionary = [NSMutableDictionary new];
    for (NSDictionary * cityDict in citiesParsedArray)
    {
        //create city object
        City * city = [[City alloc] initWithCityIDString:[cityDict objectForKey:CITY_ID_JSONK]
                                    cityName:[cityDict objectForKey:CITY_NAME_JSONK]
                                    cityNameEn:[cityDict objectForKey:CITY_NAME_EN_JSONK]
                                    countryIDString:[cityDict objectForKey:CITY_COUNTRY_ID_JSONK]
                                    displayOrderString:[cityDict objectForKey:CITY_DISPLAY_ORDER_JSONK]
                       ];
        countryIdKey = [NSString stringWithFormat:@"%i", city.countryID];
        
        //add city to cities dictionary
        if (![citiesDictionary objectForKey:countryIdKey])
            [citiesDictionary setObject:[NSMutableArray new] forKey:countryIdKey];
        [(NSMutableArray *)[citiesDictionary objectForKey:countryIdKey] addObject:city];
            
    }
    
    //3- load countries
    NSData * countriesData = [NSData dataWithContentsOfFile:[self getCountriesFilePath]];
    NSArray * countriesParsedArray = [[JSONParser sharedInstance] parseJSONData:countriesData];
    
    //4- store countries in array (This array holds countries and their cities **INSIDE**)
    NSMutableArray * resultCountries = [NSMutableArray new];
    for (NSDictionary * countryDict in countriesParsedArray)
    {
        //create country object
        Country * country = [[Country alloc]
                             initWithCountryIDString:[countryDict objectForKey:COUNTRY_ID_JSONK]
                             countryName:[countryDict objectForKey:COUNTRY_NAME_JSONK]
                             countryNameEn:[countryDict objectForKey:COUNTRY_NAME_EN_JSONK]
                             currencyIDString:[countryDict objectForKey:COUNTRY_CURRENCY_ID_JSONK]
                             displayOrderString:[countryDict objectForKey:COUNTRY_DISPLAY_ORDER_JSONK]
                             countryCodeString:[countryDict objectForKey:COUNTRY_CODE_JSONK]
                             ];
        countryIdKey = [NSString stringWithFormat:@"%i", country.countryID];
        //get array of cities
        NSArray * citiesOfCountry = [NSArray arrayWithArray:[citiesDictionary objectForKey:countryIdKey]];
        
        //sort cities and add them to country
        country.cities = [self sortCitiesArray:citiesOfCountry];
        
        //add country
        [resultCountries addObject:country];
    }
    
    [self.delegate didFinishLoadingWithData:[self sortCountriesArray:resultCountries]];
}

- (NSUInteger) getDefaultSelectedCountryIndex {
    return 0;
    /*
    if (!cllocationMngr)
        cllocationMngr = [[CLLocationManager alloc] init];
    cllocationMngr.delegate = self;
    cllocationMngr.distanceFilter = kCLDistanceFilterNone;
    cllocationMngr.desiredAccuracy = kCLLocationAccuracyBest;
    [cllocationMngr startUpdatingLocation];
      */  
}

- (NSUInteger) getDefaultSelectedCityIndexForCountry:(NSUInteger) countryID {
    return 0;
}


#pragma mark - helper methods

// This method gets the file path of countries file.
// This method checks if countries json file does not exist in documents --> that means we are
// launching the application the first time, so it copies it and returns its path in documents directory
- (NSString *) getCountriesFilePath {
    
    //1- search for "Countries.json" in documents
    BOOL countriesExistInDocuments = [GenericMethods fileExistsInDocuments:COUNTRIES_FILE_NAME];
    
    NSString * countriesDocumentPath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], COUNTRIES_FILE_NAME];
    
    //2- if not found: --> copy initial to documents
    if (!countriesExistInDocuments)
    {
        NSString * countriesfile = [COUNTRIES_FILE_NAME stringByReplacingOccurrencesOfString:@".json" withString:@""];
        
        NSString * sourcePath =  [[NSBundle mainBundle] pathForResource:countriesfile ofType:@"json"];
        
        NSError *error;
        [fileMngr copyItemAtPath:sourcePath toPath:countriesDocumentPath error:&error];
    }

    //3- return the path
    return countriesDocumentPath;
}


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

- (NSArray *) sortCitiesArray:(NSArray *) citiesArray {
    
    NSArray * sortedArray;
    sortedArray = [citiesArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSUInteger first = [(City *)a displayOrder];
        NSUInteger second = [(City *)b displayOrder];
        return (first >= second);
    }];
    
    return sortedArray;
}

#pragma  mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,                  NSError *error) {
        
        MKPlacemark * mark = [[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
        NSString * code = mark.countryCode;
        NSLog(@"%@", code);
    }];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}
@end

