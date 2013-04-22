//
//  StaticAttrsLoader.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brand.h"

@interface SingleValue : NSObject

@property (nonatomic) NSInteger valueID;
@property (strong, nonatomic) NSString * valueString;
@property (nonatomic) NSInteger displayOrder;

- (id) initWithValueIDString:(NSString *) aValueIdString
                 valueString:(NSString *) aValueString
          displayOrderString:(NSString *) aDisplayOrderString;
@end

//----------------------------------------------------------

@interface StaticAttrsLoader : NSObject

// get the shared instance of BarndsManager
+ (StaticAttrsLoader *) sharedInstance;

//load ADD_PERIOD file
- (NSArray *) loadAddPeriodValues;

//load CURRENCY file
- (NSArray *) loadCurrencyValues;

//load KM_MILE file
- (NSArray *) loadDistanceValues;

//load MODEL_YEAR file
- (NSArray *) loadModelYearValues;

//load SERVICE file
- (NSArray *) loadServiceValues;

//load BRAND_MODELS file

//load CAT_ATTRS file
@end
