//
//  City.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

#pragma mark - properties
@property (nonatomic) NSUInteger cityID;
@property (strong, nonatomic) NSString * cityName;
@property (strong, nonatomic) NSString * cityNameEn;
@property (nonatomic) NSUInteger countryID;
@property (nonatomic) NSUInteger displayOrder;


#pragma mark - methods
- (id) initWithCityIDString:(NSString *) aCityIDString
                   cityName:(NSString *) aCityName
                 cityNameEn:(NSString *) aCityNameEn
            countryIDString:(NSString *) aCountryIDString
         displayOrderString:(NSString *)aDisplayOrderString;

@end

