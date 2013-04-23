//
//  PricingOption.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PricingOption : NSObject

@property (nonatomic) NSInteger pricingID;
@property (nonatomic) NSInteger countryID;
@property (nonatomic) NSInteger categoryID;
@property (strong, nonatomic) NSString * adPeriodDays;
@property (nonatomic) float price;
@property (nonatomic) NSInteger currencyID;
@property (strong, nonatomic) NSString * currencyName;
@property (strong, nonatomic) NSString * currencyNameEn;

- (id) initWithPricingIDString:(NSString *) aPricingIDString
                     countryID:(NSString *) aCountryIDString
                    categoryID:(NSString *) aCategoryIDString
                  adPeriodDays:(NSString *) aAdPeriodDays
                         price:(NSString *) aPriceString
                    currencyID:(NSString *) aCurrencyIDString
                  currencyName:(NSString *) aCurrencyName
                currencyNameEn:(NSString *) aCurrencyNameEn;

@end
