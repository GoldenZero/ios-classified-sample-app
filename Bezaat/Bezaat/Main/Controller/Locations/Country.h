//
//  Country.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

/*
#import <Foundation/Foundation.h>
#import "City.h"

@interface Country : NSObject

#pragma mark - properties
@property (nonatomic)         NSUInteger    countryID;
@property (strong, nonatomic) NSString *    countryName;
@property (strong, nonatomic) NSString *    geoName;
@property (nonatomic)         NSUInteger    displayOrder;
@property (strong, nonatomic) NSURL *       jsonBigFlagFN;
@property (        nonatomic) BOOL          jsonDisplayMe;
@property (strong, nonatomic) NSURL *       jsonSmallFlagFN;
@property (        nonatomic) NSUInteger    currencyID;
@property (strong, nonatomic) NSString *    countryNameEn;
@property (strong, nonatomic) NSArray *     cities;
@property (strong, nonatomic) NSString *    currency;


#pragma mark - methods
- (id) initWithCountryIDString:(NSString * ) aCountryIDString
                countryName:(NSString * ) aCountryName
                geoName:(NSString * ) aGeoName
                displayOrderString:(NSString * ) aDisplayOrderString
                jsonBigFlagFNString:(NSString * ) aJsonBigFlagFNString
                jsonDisplayMeString:(NSString * ) aJsonDisplayMeString
                jsonSmallFlagFNString:(NSString * ) aJsonSmallFlagFNString
                currencyIDString:(NSString * ) aCurrencyIDString
                countryNameEn:(NSString * ) aCountryNameEn
                currency:(NSString * ) aCurrency;

@end
*/


#import <Foundation/Foundation.h>
#import "City.h"

@interface Country : NSObject

#pragma mark - properties
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSArray * citiesArray;

#pragma mark - methods
- (id) initWithName:(NSString *) aName citiesArray:(NSArray *)aCitiesArray;
@end

