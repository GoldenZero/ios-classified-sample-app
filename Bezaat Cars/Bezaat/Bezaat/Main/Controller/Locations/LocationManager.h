//
//  LocationManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"
#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>
#import <MapKit/MapKit.h>
#import "Country.h"
#import "KeychainItemWrapper.h"


@protocol LocationManagerDelegate <NSObject>
@required
- (void) didFinishLoadingWithData:(NSArray*) resultArray;
@end


@interface LocationManager : NSObject

#pragma mark - properties
@property (strong, nonatomic) id <LocationManagerDelegate> delegate;
@property (strong, nonatomic) NSString * deviceLocationCountryCode;
#pragma mark - methods

// get the shared instance of LocationManager
+ (LocationManager *) sharedInstance;

// get the instance of keychain item to store location of user
+ (KeychainItemWrapper *) locationKeyChainItemSharedInstance;

// load countries & cities
- (void) loadCountriesAndCitiesWithDelegate:(id <LocationManagerDelegate>) del;

// get the default selected country index in countries result array
- (NSUInteger) getDefaultSelectedCountryIndex;

// get the default selected city index in cities result array
//- (NSUInteger) getDefaultSelectedCityIndexForCountry:(NSUInteger) countryID;

// store the data of chosen country and city inside
- (void) storeDataOfCountry:(NSUInteger) countryID city:(NSUInteger) cityID;

// get the stored country from keyChain
- (NSInteger) getSavedUserCountryID;

// get the stored city from keyChain
- (NSInteger) getSavedUserCityID;

//get country by ID
- (Country *) getCountryByID:(NSInteger) cID;

//get index of country
- (NSInteger) getIndexOfCountry:(NSInteger) cID;

//get index of city
- (NSInteger) getIndexOfCity:(NSInteger) cID inCountry:(Country *) country ;

//get all previously loaded countries
- (NSArray *) getTotalCountries;
@end
