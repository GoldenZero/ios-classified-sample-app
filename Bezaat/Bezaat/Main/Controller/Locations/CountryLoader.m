//
//  CountryLoader.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

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
