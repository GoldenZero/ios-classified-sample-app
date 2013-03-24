//
//  CountryManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AubadaLibrary/JSONParser.h>
#import "Country.h"

@protocol CountryManagerDelegate <NSObject>
@required
- (void) countriesDidFinishLoadingWithData:(NSArray*) resultArray;
@end


@interface CountryManager : NSObject

#pragma mark - properties
@property (strong, nonatomic) id <CountryManagerDelegate> delegate;

#pragma mark - methods
- (id) initWithDelegate:(id <CountryManagerDelegate>) del;

// load countries & cities
- (void) loadCountries;

// get the default selected country index in countries result array
- (NSUInteger) getDefaultSelectedCountryIndex;

// get the default selected city index in cities result array
- (NSUInteger) getDefaultSelectedCityIndexForCountry:(NSUInteger) countryID;

@end
