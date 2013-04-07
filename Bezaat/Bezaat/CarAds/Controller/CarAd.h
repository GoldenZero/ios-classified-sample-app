//
//  CarAd.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarAd : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger adID;
@property (nonatomic) NSUInteger ownerID;
@property (nonatomic) NSUInteger storeID;
@property (nonatomic) BOOL isFeatured;
@property (strong, nonatomic) NSURL * thumbnailURL;
@property (strong, nonatomic) NSString * title;
@property (nonatomic) NSUInteger price;
@property (strong, nonatomic) NSString * currencyString;
@property (strong, nonatomic) NSDate * postedOnDate;
@property (nonatomic) NSUInteger modelYear;
@property (nonatomic) NSUInteger distanceRangeInKm;
@property (nonatomic) NSUInteger viewCount;
@property (nonatomic) BOOL isFavorite;
@property (strong, nonatomic) NSString * storeName;
@property (strong, nonatomic) NSURL * storeLogoURL;

#pragma mark - actions

- (id) initWithAdIDString:(NSString *) aAdIDString
            ownerIDString:(NSString *) aOwnerIDString
            storeIDString:(NSString *) aStoreIDString
         isFeaturedString:(NSString *) aIsFeaturedString
             thumbnailURL:(NSString *) aThumbnailURLString
                    title:(NSString *) aTitle
              priceString:(NSString *) aPriceString
           currencyString:(NSString *) aCurrencyString
       postedOnDateString:(NSString *) aPostedOnDateString
          modelYearString:(NSString *) aModelYearString
  distanceRangeInKmString:(NSString *) aDistanceRangeInKmString
          viewCountString:(NSString *) aViewCountString
         isFavoriteString:(NSString *) aIsFavoriteString
                storeName:(NSString *) aStoreName
             storeLogoURL:(NSString *) aStoreLogoURLString;

@end
