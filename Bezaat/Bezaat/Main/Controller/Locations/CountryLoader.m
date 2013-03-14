//
//  CountryLoader.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
/*
#import "CountryLoader.h"

#pragma mark - json keys

#define COUNTRY_ID_JSONK        @"CountryID"
#define COUNTRY_NAME_JSONK      @"CountryName"
#define GEONAME_JSONK           @"GeoName"
#define DISPLAY_ORDER_JSONK     @"DisplayOrder"
#define JSON_BIG_FLAG_FN_JSONK  @"JsonBigFlagFN"
#define JSON_DISPLAY_ME_JSONK   @"JsonDisplayMe"
#define JSON_SMALL_FLAG_FN_JSONK @"JsonSmallFlagFN"
#define CURRENCY_ID_JSONK       @"CurrencyID"
#define COUNTRY_NAME_EN_JSONK   @"CountryNameEn"
#define CITIES_JSONK            @"Cities"
#define CURRENCY_JSONK          @"Currency"

#pragma mark -

@interface CountryLoader ()
{
    InternetManager * internetMngr;
}
@end


@implementation CountryLoader
@synthesize delegate;

static NSString * countries_url = @"http://api.bezaat.com/home/Countries";//returns JSON
//static NSString * countries_url = @"http://myapp-cp.com/syrisoft_apps/yarmook_association/api/index.php?type=branch";//returns JSON

static NSString * internetMngrTempFileName = @"bezaatTmp";

- (id) init {

    self = [super init];
    if (self) {
        //..
    }
    return self;
}

- (id) initWithDelegate:(id <CountryLoaderDelegate>) del {
    self = [super init];
    if (self) {
        self.delegate = del;
    }
    return self;
}

- (void) loadCountries {
    internetMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName url:countries_url delegate:self startImmediately:YES responseType:@"JSON"];
}

#pragma mark - Data delegate methods
- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    
    [delegate countriesDidFailLoadingWithError:error];
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*)result {
    
    NSArray * countries = [self createCountriesArrayWithData:(NSArray *)result];
    NSArray * sortedCountries = [self sortCountriesArray:countries];
    [delegate countriesDidSucceedLoadingWithData:sortedCountries];
}

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

@end
*/

#import "CountryLoader.h"

@implementation CountryLoader

- (NSArray *) loadCountriesFromPlistFileWithName:(NSString *)plistFileName {
    //The array that will contain all CarModel objects loaded from plist file
    NSMutableArray * resultArray = [NSMutableArray new];
    
    //Plist file path
    NSString * plistFilePath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];
    
    //The dictionary holding all plist file
    NSDictionary * allCountriesDic = [[NSDictionary alloc] initWithContentsOfFile:plistFilePath];
    
    //loop
    for (int index = 0; index < allCountriesDic.count ; index ++)
    {
        //keys array
        NSArray * countryNamesArray = [allCountriesDic allKeys];
        
        //1- model name from keys array
        NSString * currentCountryName = [countryNamesArray objectAtIndex:index];
        
        //the distionary of current model
        NSDictionary * countryDic = [allCountriesDic objectForKey:currentCountryName];
        
        //create array of City objects
        NSMutableArray * currentCities = [NSMutableArray new];
        for (NSDictionary * cityDic in [countryDic objectForKey:CITIES_PLIST_KEY])
        {
            //city name
            NSString * cityName = [cityDic objectForKey:CITY_NAME_PLIST_KEY];
            
            //city image
            NSString * cityImageFileName = [cityDic objectForKey:IMAGE_FILE_NAME_PLIST_KEY];
            
            [currentCities addObject:[[City alloc] initWithName:cityName imageFileName:cityImageFileName]];
        }
        
        //create the Country object
        Country * aCountry = [[Country alloc] initWithName:currentCountryName citiesArray:currentCities];
        
        //add CarModel object to result array
        [resultArray addObject:aCountry];
    }
    
    return resultArray;
    
}

@end