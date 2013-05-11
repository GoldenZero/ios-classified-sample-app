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

- (void) storeOptionsDidFailLoadingWithError:(NSError *) error;
- (void) storeOptionsDidFinishLoadingWithData:(NSArray*) resultArray;
@end

@protocol FeaturingOrderDelegate <NSObject>
@required
- (void) orderDidFailCreationWithError:(NSError *) error;
- (void) orderDidFinishCreationWithID:(NSString *) orderID;
//store
- (void) StoreOrderDidFailCreationWithError:(NSError *) error;
- (void) StoreOrderDidFinishCreationWithID:(NSString *) orderID;

//Bank
- (void) BankOrderDidFailCreationWithError:(NSError *) error;
- (void) BankOrderDidFinishCreationWithID:(NSString *) orderID;

//Bank store
- (void) BankStoreOrderDidFailCreationWithError:(NSError *) error;
- (void) BankStoreOrderDidFinishCreationWithID:(NSString *) orderID;


- (void) orderDidFailConfirmingWithError:(NSError *) error;
- (void) orderDidFinishConfirmingWithStatus:(BOOL) status;
//store
- (void) StoreOrderDidFailConfirmingWithError:(NSError *) error;
- (void) StoreOrderDidFinishConfirmingWithStatus:(BOOL) status;


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

- (void) loadStorePricingOptionsForCountry:(NSInteger) countryID withDelegate:(id <PricingOptionsDelegate>) del;

- (void) createOrderForFeaturingAdID:(NSInteger) adID withPricingID:(NSInteger) pricingID WithDelegate:(id <FeaturingOrderDelegate>) del;

- (void) createStoreOrderForStoreID:(NSInteger) storeID withcountryID:(NSInteger) countryID withShemaName:(NSInteger)shemaID WithDelegate:(id <FeaturingOrderDelegate>) del;

- (void) createOrderForBankWithAdID:(NSInteger) AdID withShemaName:(NSInteger)shemaID WithDelegate:(id <FeaturingOrderDelegate>) del;

-(void) createOrderForBankWithStoreID:(NSInteger)storeID withcountryID:(NSInteger)countryID withShemaName:(NSInteger)schemaID WithDelegate:(id <FeaturingOrderDelegate>) del;

- (void) confirmOrderID:(NSString *) orderID gatewayResponse:(NSString *) aGatewayResponse withDelegate:(id <FeaturingOrderDelegate>) del;

- (void) confirmStoreOrderID:(NSString *) orderID withAppName:(NSString*)appName gatewayResponse:(NSString *) aGatewayResponse withDelegate:(id <FeaturingOrderDelegate>) del;

- (void) cancelOrderID:(NSString *) orderID withDelegate:(id <FeaturingOrderDelegate>) del;
@end
