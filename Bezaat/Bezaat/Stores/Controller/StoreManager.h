//
//  StoreManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"

@protocol StoreManagerDelegate <NSObject>
@required
- (void) storeCreationDidFailWithError:(NSError *)error;
- (void) storeCreationDidSucceedWithStoreID:(NSString *)storeID;
- (void) storeLOGOUploadDidFailWithError:(NSError *)error;
- (void) storeLOGOUploadDidSucceedWithImageURL:(NSString *)imageURL;
@end

typedef enum {
    RequestInProgressCreateStore,
    RequestInProgressUploadLOGO
} RequestInProgress;

@interface StoreManager : NSObject <DataDelegate> {
    InternetManager *internetManager;
    RequestInProgress requestInProgress;
}

#pragma mark - properties

@property (nonatomic,weak) id<StoreManagerDelegate>delegate;

#pragma mark - methods

+ (StoreManager *)sharedInstance;

- (void)uploadLOGO:(UIImage *)image;

- (void)createStore:(Store *)store;

@end
