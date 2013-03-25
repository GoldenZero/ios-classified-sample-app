//
//  Country.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//


#import "Country.h"

@implementation Country

@synthesize countryID;
@synthesize countryName;
@synthesize countryNameEn;
@synthesize currencyID;
@synthesize displayOrder;
@synthesize countryCode;
@synthesize cities;
@synthesize xCoord;
@synthesize yCoord;

- (id) initWithCountryIDString:(NSString *) aCountryIDString
                   countryName:(NSString *) aCountryName
                 countryNameEn:(NSString *) aCountryNameEn
              currencyIDString:(NSString *) aCurrencyIDString
            displayOrderString:(NSString *) aDisplayOrderString
             countryCodeString:(NSString *) aCountryCode;
{
    self = [super init];
    if (self) {
        // countryID
        self.countryID = aCountryIDString.integerValue;
        
        // countryName
        self.countryName = aCountryName;
        
        // countryNameEn
        self.countryNameEn = aCountryNameEn;
        
        // currencyID
        self.currencyID = aCurrencyIDString.integerValue;
        
        // displayOrder
        self.displayOrder = aDisplayOrderString.integerValue;
        
        // countryCode
        self.countryCode = aCountryCode;
        
        // cities
        // self.cities = [NSArray new];
        
        // xCoord
        self.xCoord = -1; //initial
        
        // yCoord
        self.yCoord = -1;//initial
    }
    return self;
}

- (void) setCoordinatesWithX:(NSInteger) xVal y:(NSInteger) yVal {
    
    self.xCoord = xVal;
    self.yCoord = yVal;
}

@end
