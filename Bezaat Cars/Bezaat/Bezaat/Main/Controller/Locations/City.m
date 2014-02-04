//
//  City.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//


#import "City.h"

@implementation City

@synthesize cityID;
@synthesize cityName;
@synthesize cityNameEn;
@synthesize countryID;
@synthesize displayOrder;

- (id) initWithCityIDString:(NSString *) aCityIDString
                   cityName:(NSString *) aCityName
                 cityNameEn:(NSString *) aCityNameEn
            countryIDString:(NSString *) aCountryIDString
         displayOrderString:(NSString *)aDisplayOrderString {
    
    self = [super init];
    if (self) {
        // cityID
        self.cityID = aCityIDString.integerValue;
        
        // cityName
        self.cityName = aCityName;
        
        // cityNameEn
        self.cityNameEn = aCityNameEn;
        
        // countryID
        self.countryID = aCountryIDString.integerValue;
        
        // displayOrder
        self.displayOrder = aDisplayOrderString.integerValue;
    }
    return self;
}

@end