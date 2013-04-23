//
//  FeaturingManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PricingOption.h"
#import "FeatutreOrder.h"

@protocol PricingOptionsDelegate <NSObject>
@required

- (void) optionsDidFailLoadingWithError:(NSError *) error;
- (void) optionsDidFinishLoadingWithData:(NSArray*) resultArray;
@end

@interface FeaturingManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <PricingOptionsDelegate> pricingDelegate;

#pragma mark - methods
+ (FeaturingManager *) sharedInstance;

- (void) loadPricingOptionsForCountry:(NSInteger) countryID withDelegate:(id <PricingOptionsDelegate>) del;

@end
