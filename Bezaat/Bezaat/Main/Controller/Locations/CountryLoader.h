//
//  CountryLoader.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

/*
#import <Foundation/Foundation.h>
#import <AubadaLibrary/JSONParser.h>
#import <AubadaLibrary/InternetManager.h>
#import "Country.h"

@protocol CountryLoaderDelegate <NSObject>
@required
- (void) countriesDidFailLoadingWithError:(NSError*) error;
- (void) countriesDidSucceedLoadingWithData:(NSArray*) resultArray;
@end


@interface CountryLoader : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <CountryLoaderDelegate> delegate;

#pragma mark - methods
- (id) initWithDelegate:(id <CountryLoaderDelegate>) del;
- (void) loadCountries;
//- (void) loadCitiesOfCountry:(NSUInteger) countryID;

@end
*/

#import <Foundation/Foundation.h>
#import "Country.h"

#define CITY_NAME_PLIST_KEY @"name"
#define IMAGE_FILE_NAME_PLIST_KEY @"imageFileName"
#define CITIES_PLIST_KEY @"cities"

@interface CountryLoader : NSObject

//The plistFileName should relate to a file added to application resources
- (NSArray *) loadCountriesFromPlistFileWithName:(NSString *)plistFileName;

@end