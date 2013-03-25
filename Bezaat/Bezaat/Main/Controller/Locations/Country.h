//
//  Country.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "City.h"

@interface Country : NSObject

#pragma mark - properties
@property (nonatomic)         NSUInteger    countryID;
@property (strong, nonatomic) NSString *    countryName;
@property (strong, nonatomic) NSString *    countryNameEn;
@property (        nonatomic) NSUInteger    currencyID;
@property (nonatomic)         NSUInteger    displayOrder;
@property (strong, nonatomic) NSString *    countryCode;
@property (strong, nonatomic) NSArray *     cities;

@property (nonatomic)         NSInteger    xCoord;
@property (nonatomic)         NSInteger    yCoord;


#pragma mark - methods
- (id) initWithCountryIDString:(NSString *) aCountryIDString
                   countryName:(NSString *) aCountryName
                 countryNameEn:(NSString *) aCountryNameEn
              currencyIDString:(NSString *) aCurrencyIDString
            displayOrderString:(NSString *) aDisplayOrderString
             countryCodeString:(NSString *) aCountryCode;

- (void) setCoordinatesWithX:(NSInteger) xVal y:(NSInteger) yVal;
@end

