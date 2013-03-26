//
//  LocationManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AubadaLibrary/JSONParser.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Country.h"

@protocol LocationManagerDelegate <NSObject>
@required
- (void) didFinishLoadingWithData:(NSArray*) resultArray;
@end


@interface LocationManager : NSObject <CLLocationManagerDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <LocationManagerDelegate> delegate;

#pragma mark - methods

// get the shared instance of LocationManager
+ (LocationManager *) sharedInstance;

// load countries & cities
- (void) loadCountriesAndCitiesWithDelegate:(id <LocationManagerDelegate>) del;

// get the default selected country index in countries result array
- (NSUInteger) getDefaultSelectedCountryIndex;

// get the default selected city index in cities result array
//- (NSUInteger) getDefaultSelectedCityIndexForCountry:(NSUInteger) countryID;

@end
