//
//  CarAd.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarAd.h"

@implementation CarAd
@synthesize adID;
@synthesize ownerID;
@synthesize storeID;
@synthesize isFeatured;
@synthesize thumbnailURL;
@synthesize title;
@synthesize price;
@synthesize currencyString;
@synthesize postedOnDate;
@synthesize modelYear;
@synthesize distanceRangeInKm;
@synthesize viewCount;
@synthesize isFavorite;
@synthesize storeName;
@synthesize storeLogoURL;

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
             storeLogoURL:(NSString *) aStoreLogoURLString {
    
    self = [super init];
    if (self) {
    
        // adID
        self.adID = aAdIDString.integerValue;
        
        // ownerID
        self.ownerID = aOwnerIDString.integerValue;
        
        // storeID
        self.storeID = aStoreIDString.integerValue;
        
        // isFeatured
        self.isFeatured = aIsFeaturedString.boolValue;
        
        // thumbnailURL
        if ([aThumbnailURLString isEqualToString:@""])
            self.thumbnailURL = nil;
        else
            self.thumbnailURL = [NSURL URLWithString:aThumbnailURLString];
        
        // title
        self.title = aTitle;
        
        // price
        self.price = aPriceString.floatValue;
        
        // currencyString
        self.currencyString = aCurrencyString;
        
        // postedOnDate
        // the JSON date has the style of "\/Date(1356658797343)\/", so it needs custom parsing
        self.postedOnDate = [GenericMethods NSDateFromDotNetJSONString:aPostedOnDateString];
        
        // modelYear
        self.modelYear = aModelYearString.integerValue;
        
        // distanceRangeInKm
        self.distanceRangeInKm = aDistanceRangeInKmString.integerValue;

        // viewCount
        self.viewCount = aViewCountString.integerValue;
        
        // isFavorite
        self.isFavorite = aIsFavoriteString.boolValue;
        
        // storeName
        self.storeName = aStoreName;
        
        // storeLogoURL
        if ([aStoreLogoURLString isEqualToString:@""])
            self.storeLogoURL = nil;
        else
            self.storeLogoURL = [NSURL URLWithString:aStoreLogoURLString];
    }
    return self;
}
@end
