//
//  CarsGallery.m
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarsGallery.h"

@implementation CarsGallery

@synthesize StoreID;
@synthesize StoreName;
@synthesize StoreOwnerEmail;
@synthesize StoreImageURL;
@synthesize CountryID;
@synthesize ActiveAdsCount;
@synthesize StoreStatus;
@synthesize StoreContactNo;
@synthesize RemainingFreeFeatureAds;
@synthesize SubscriptionExpiryDate;
@synthesize Description;
@synthesize RemainingDays;

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
         RemainingDaysString: (NSString *) aRemainingDaysString {
    
    self = [super init];
    
    if (self) {
        
        // StoreID
        self.StoreID = aStoreIDString.integerValue;
        
        // StoreName
        self.StoreName = aStoreNameString;
        
        // StoreOwnerEmail
        self.StoreOwnerEmail = aStoreOwnerEmailString;
        
        // StoreImageURL
        if ([aStoreImageURLString isEqualToString:@""])
            self.StoreImageURL = nil;
        else {
            NSString * newUrlString = [aStoreImageURLString stringByReplacingOccurrencesOfString:@"http://content.bezaat.com" withString:@"http://content.bezaat.com.s3-external-3.amazonaws.com"];
            
            self.StoreImageURL = [NSURL URLWithString:newUrlString];
        }
        
        // CountryID
        self.CountryID = aCountryIDString.integerValue;
        
        // ActiveAdsCount
        self.ActiveAdsCount = aActiveAdsCountString.integerValue;
        
        // StoreStatus
        self.StoreStatus = aStoreStatusString.integerValue;
        
        // StoreContactNo
        self.StoreContactNo = aStoreContactNoString;
        
        // RemainingFreeFeatureAds
        self.RemainingFreeFeatureAds = aRemainingFreeFeatureAdsString.integerValue;
        
        // SubscriptionExpiryDate
        self.SubscriptionExpiryDate = [GenericMethods NSDateFromDotNetJSONString:aSubscriptionExpiryDateString];
        
        // Description
        self.Description = aDescriptionString;
        
        // RemainingDays
        self.RemainingDays = aRemainingDaysString.integerValue;
        
    }
    return self;
    
}


@end
