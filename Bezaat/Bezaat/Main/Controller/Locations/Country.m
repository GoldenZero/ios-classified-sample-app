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
@synthesize geoName;
@synthesize displayOrder;
@synthesize jsonBigFlagFN;
@synthesize jsonDisplayMe;
@synthesize jsonSmallFlagFN;
@synthesize currencyID;
@synthesize countryNameEn;
@synthesize cities;
@synthesize currency;

- (id) initWithCountryIDString:(NSString * ) aCountryIDString
                   countryName:(NSString * ) aCountryName
                       geoName:(NSString * ) aGeoName
            displayOrderString:(NSString * ) aDisplayOrderString
           jsonBigFlagFNString:(NSString * ) aJsonBigFlagFNString
           jsonDisplayMeString:(NSString * ) aJsonDisplayMeString
         jsonSmallFlagFNString:(NSString * ) aJsonSmallFlagFNString
              currencyIDString:(NSString * ) aCurrencyIDString
                 countryNameEn:(NSString * ) aCountryNameEn
                      currency:(NSString * ) aCurrency
{
    self = [super init];
    if (self) {
        //countryID
        self.countryID = [aCountryIDString integerValue];
        
        //countryName
        self.countryName = aCountryName;
        
        //geoName
        self.geoName = aGeoName;
        
        //displayOrder
        self.displayOrder = [aDisplayOrderString integerValue];
        
        //jsonBigFlagFN
        /*
        if ([GenericMethods validateUrl:aJsonBigFlagFNString])
            self.jsonBigFlagFN = [NSURL URLWithString:aJsonBigFlagFNString];
        else
            //The object is set to nil if any field is wrong after parsing
            return nil;
        */
        self.jsonBigFlagFN = [NSURL URLWithString:aJsonBigFlagFNString];
        if (!self.jsonBigFlagFN)
            //The object is set to nil if any field is wrong after parsing
            return nil;
        
        //jsonDisplayMe
        //self.jsonDisplayMe = [GenericMethods boolValueOfString:aJsonDisplayMeString];
        self.jsonDisplayMe = [aJsonDisplayMeString boolValue];
        
        //jsonSmallFlagFN
        /*
        if ([GenericMethods validateUrl:aJsonSmallFlagFNString])
            self.jsonSmallFlagFN = [NSURL URLWithString:aJsonSmallFlagFNString];
        else
            //The object is set to nil if any field is wrong after parsing
            return nil;
        */
        self.jsonSmallFlagFN = [NSURL URLWithString:aJsonSmallFlagFNString];
        if (!self.jsonSmallFlagFN)
            //The object is set to nil if any field is wrong after parsing
            return nil;
        //currencyID
        self.currencyID = [aCurrencyIDString integerValue];
        
        //countryNameEn
        self.countryNameEn = aCountryNameEn;
        
        //currency
        self.currency = aCurrency;
        
    }
    return self;
}

@end
