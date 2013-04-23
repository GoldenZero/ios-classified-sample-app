//
//  PricingOption.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "PricingOption.h"

@implementation PricingOption

@synthesize pricingID;
@synthesize countryID;
@synthesize categoryID;
@synthesize adPeriodDays;
@synthesize price;
@synthesize currencyID;
@synthesize currencyName;
@synthesize currencyNameEn;


- (id) initWithPricingIDString:(NSString *) aPricingIDString
                     countryID:(NSString *) aCountryIDString
                    categoryID:(NSString *) aCategoryIDString
                  adPeriodDays:(NSString *) aAdPeriodDays
                         price:(NSString *) aPriceString
                    currencyID:(NSString *) aCurrencyIDString
                  currencyName:(NSString *) aCurrencyName
                currencyNameEn:(NSString *) aCurrencyNameEn {
    self = [super init];
    if (self) {
        // pricingID
        self.pricingID = [aPricingIDString integerValue];
        
        // countryID
        self.countryID = [aCountryIDString integerValue];
        
        // categoryID
        self.categoryID = [aCategoryIDString integerValue];
        
        // adPeriodDays
        self.adPeriodDays = adPeriodDays;
        
        // price
        self.price = [aPriceString floatValue];
        
        // currencyID
        self.currencyID = [aCurrencyIDString integerValue];
        
        // currencyName
        self.currencyName = aCurrencyName;
        
        // currencyNameEn
        self.currencyNameEn = aCurrencyNameEn;
    }
    
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"pricingID:%i, countryID:%i, categoryID:%i, adPeriodDays:%@, price:%f, currencyID:%i, currencyName:%@, currencyNameEn:%@",
            self.pricingID,
            self.countryID,
            self.categoryID,
            self.adPeriodDays,
            self.price,
            self.currencyID,
            self.currencyName,
            self.currencyNameEn
            ];
}



@end
