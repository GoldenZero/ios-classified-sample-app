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
@property (nonatomic) NSInteger adPeriodDays;
@property (nonatomic) float price;
@property (strong, nonatomic) NSString * pricingName;
@property (nonatomic) NSInteger pricingTierID;

//@property (nonatomic) NSInteger categoryID;
//@property (nonatomic) NSInteger currencyID;
//@property (strong, nonatomic) NSString * currencyName;
//@property (strong, nonatomic) NSString * currencyNameEn;

- (id) initWithPricingIDString:(NSString *) aPricingIDString
                     countryID:(NSString *) aCountryIDString
            adPeriodDaysString:(NSString *) aAdPeriodDaysString
                         price:(NSString *) aPriceString
                   pricingName:(NSString *) aPricingName
                   pricingTier:(NSString*)aPricingTierID;
                    //categoryID:(NSString *) aCategoryIDString
                    //currencyID:(NSString *) aCurrencyIDString
                  //currencyName:(NSString *) aCurrencyName
                //currencyNameEn:(NSString *) aCurrencyNameEn;

@end
