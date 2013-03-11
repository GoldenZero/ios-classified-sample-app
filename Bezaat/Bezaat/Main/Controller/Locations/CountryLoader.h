//
//  CountryLoader.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

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
