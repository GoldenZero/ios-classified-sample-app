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

@protocol FeaturingOrderDelegate <NSObject>
@required
- (void) orderDidFailCreationWithError:(NSError *) error;
- (void) orderDidFinishCreationWithID:(NSString *) orderID;

- (void) orderDidFailConfirmingWithError:(NSError *) error;
- (void) orderDidFinishConfirmingWithStatus:(BOOL) status;

- (void) orderDidFailCancellingWithError:(NSError *) error;
- (void) orderDidFinishCancellingWithStatus:(BOOL) status;
@end

@interface FeaturingManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <PricingOptionsDelegate> pricingDelegate;
@property (strong, nonatomic) id <FeaturingOrderDelegate> orderDelegate;

#pragma mark - methods
+ (FeaturingManager *) sharedInstance;

- (void) loadPricingOptionsForCountry:(NSInteger) countryID withDelegate:(id <PricingOptionsDelegate>) del;

- (void) createOrderForFeaturingAdID:(NSInteger) adID withPricingID:(NSInteger) pricingID WithDelegate:(id <FeaturingOrderDelegate>) del;

- (void) confirmOrderID:(NSString *) orderID gatewayResponse:(NSString *) aGatewayResponse withDelegate:(id <FeaturingOrderDelegate>) del;

- (void) cancelOrderID:(NSString *) orderID withDelegate:(id <FeaturingOrderDelegate>) del;
@end
