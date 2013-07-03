//
//  CarsGallery.h
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarsGallery : NSObject

#pragma mark - Properties 

@property  NSInteger *StoreID;
@property  NSString *StoreName;
@property  NSString *StoreOwnerEmail;
@property  NSURL *StoreImageURL;
@property  NSInteger *CountryID;
@property  NSInteger *ActiveAdsCount;
@property  NSInteger *StoreStatus;
@property  NSInteger *StoreContactNo;
@property  NSInteger *RemainingFreeFeatureAds;
@property  NSDate *SubscriptionExpiryDate;
@property  NSInteger *RemainingDays;
@end
