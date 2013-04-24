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
@synthesize adPeriodDays;
@synthesize price;
@synthesize pricingName;
//@synthesize categoryID;
//@synthesize currencyID;
//@synthesize currencyName;
//@synthesize currencyNameEn;


- (id) initWithPricingIDString:(NSString *) aPricingIDString
                     countryID:(NSString *) aCountryIDString
            adPeriodDaysString:(NSString *) aAdPeriodDaysString
                         price:(NSString *) aPriceString
                   pricingName:(NSString *) aPricingName {
    self = [super init];
    if (self) {
        // pricingID
        self.pricingID = [aPricingIDString integerValue];
        
        // countryID
        self.countryID = [aCountryIDString integerValue];
        
        // categoryID
        //self.categoryID = [aCategoryIDString integerValue];
        
        // adPeriodDays
        self.adPeriodDays = [aAdPeriodDaysString integerValue];
        
        // price
        self.price = [aPriceString floatValue];
        
        //pricingName
        self.pricingName = aPricingName;
        
        /*
        // currencyID
        self.currencyID = [aCurrencyIDString integerValue];
        
        // currencyName
        self.currencyName = aCurrencyName;
        
        // currencyNameEn
        self.currencyNameEn = aCurrencyNameEn;
         */
    }
    
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"pricingID:%i, countryID:%i, adPeriodDays:%i, price:%f, pricingName:%@",
            self.pricingID,
            self.countryID,
            self.adPeriodDays,
            self.price,
            self.pricingName
            ];
}



@end
