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

@property  NSInteger StoreID;
@property  NSString *StoreName;
@property  NSString *StoreOwnerEmail;
@property  NSURL *StoreImageURL;
@property  NSInteger CountryID;
@property  NSInteger ActiveAdsCount;
@property  NSInteger StoreStatus;
@property  NSString *StoreContactNo;
@property  NSInteger RemainingFreeFeatureAds;
@property  NSDate *SubscriptionExpiryDate;
@property (strong, nonatomic) NSString * Description;
@property  NSInteger RemainingDays;

#pragma mark - actions

- (id) initWithStoreIDString: (NSString *) aStoreIDString
             StoreNameString: (NSString *) aStoreNameString
       StoreOwnerEmailString: (NSString *) aStoreOwnerEmailString
         StoreImageURLString: (NSString *) aStoreImageURLString
             CountryIDString: (NSString *) aCountryIDString
        ActiveAdsCountString: (NSString *) aActiveAdsCountString
           StoreStatusString: (NSString *) aStoreStatusString
        StoreContactNoString: (NSString *) aStoreContactNoString
RemainingFreeFeatureAdsString:(NSString *) aRemainingFreeFeatureAdsString
SubscriptionExpiryDateString: (NSString *) aSubscriptionExpiryDateString
           DescriptionString:(NSString *) aDescriptionString
         RemainingDaysString: (NSString *) aRemainingDaysString;
@end
