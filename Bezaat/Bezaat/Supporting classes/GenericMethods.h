//
//  GenericMethods.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
//This is a class that provides some generic static methods

#import <Foundation/Foundation.h>
#import "Countries.h"
#import "Constants.h"

@interface GenericMethods : NSObject

#pragma mark - countries and cities

+ (NSString *) countryName:(enum Country) theCountry;

+(NSString*) SaudiArabiaCityName:(enum SaudiArabiaCities) theCity;
+(NSString*) EmiratesCityName:(enum EmiratesCities) theCity;
+(NSString*) KuwaitCityName:(enum KuwaitCities) theCity;

@end
