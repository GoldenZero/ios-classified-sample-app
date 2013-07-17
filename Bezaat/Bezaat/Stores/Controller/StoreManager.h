//
//  StoreManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "StoreOrder.h"

@protocol StoreManagerDelegate <NSObject>
@optional
- (void) storeCreationDidFailWithError:(NSError *)error;
- (void) storeCreationDidSucceedWithStoreID:(NSInteger)storeID andUser:(UserProfile*)theUser;
- (void) storeLOGOUploadDidFailWithError:(NSError *)error;
- (void) storeLOGOUploadDidSucceedWithImageURL:(NSString *)imageURL;
- (void) userStoresRetrieveDidFailWithError:(NSError *)error;
- (void) userStoresRetrieveDidSucceedWithStores:(NSArray *)stores;
- (void) storeAdsRetrieveDidFailWithError:(NSError *)error;
- (void) storeAdsRetrieveDidSucceedWithAds:(NSArray *)ads;
- (void) storeStatusRetrieveDidFailWithError:(NSError *)error;
- (void) storeStatusRetrieveDidSucceedWithStatus:(Store *)store;
- (void) featureAdvDidFailWithError:(NSError *)error;
- (void) featureAdvDidSucceed;
- (void) unfeatureAdvDidFailWithError:(NSError *)error;
- (void) unfeatureAdvDidSucceed;

-(void)storeOrdersLoadDidFailLoadingWithError:(NSError*)error;
-(void)storeOrdersLoadDidFinishLoadingWithOrders:(NSArray*)orders;

@end

@interface StoreManager : NSObject <DataDelegate>

#pragma mark - properties

@property (nonatomic,weak) id<StoreManagerDelegate>delegate;

#pragma mark - methods

+ (StoreManager *)sharedInstance;

- (void)uploadLOGO:(UIImage *)image;

- (void)createStore:(Store *)store;

- (void)getUserStores;

- (void)getStoreAds:(NSInteger)storeID page:(NSInteger)pageNumber status:(NSString *)status;

- (void)getStoreOrdersForPage:(NSInteger)pageNumber andSize:(NSInteger)pageSize;

- (void)getStoreStatus:(Store *)store;

- (void)unfeatureAdv:(NSInteger)advID inStore:(NSInteger)storeID;

- (void)featureAdv:(NSInteger)advID inStore:(NSInteger)storeID featureDays:(NSInteger)featureDays;

@end
