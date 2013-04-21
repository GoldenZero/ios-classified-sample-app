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
#pragma mark - NSCoding methods

- (id)initWithCoder:(NSCoder *)decoder  {
    
    self = [super init];
    
    if (self) {
        self.adID = [decoder decodeIntegerForKey:@"adID"];
        self.ownerID = [decoder decodeIntegerForKey:@"ownerID"];
        self.storeID = [decoder decodeIntegerForKey:@"storeID"];
        self.isFeatured = [decoder decodeBoolForKey:@"isFeatured"];
        self.thumbnailURL = [decoder decodeObjectForKey:@"thumbnailURL"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.price = [decoder decodeFloatForKey:@"price"];
        self.currencyString = [decoder decodeObjectForKey:@"currencyString"];
        self.postedOnDate = [decoder decodeObjectForKey:@"postedOnDate"];
        self.modelYear = [decoder decodeIntegerForKey:@"modelYear"];
        self.distanceRangeInKm = [decoder decodeIntegerForKey:@"distanceRangeInKm"];
        self.viewCount = [decoder decodeIntegerForKey:@"viewCount"];
        self.isFavorite = [decoder decodeBoolForKey:@"isFavorite"];
        self.storeName = [decoder decodeObjectForKey:@"storeName"];
        self.storeLogoURL = [decoder decodeObjectForKey:@"storeLogoURL"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {

    [encoder encodeInteger:self.adID forKey:@"adID"];
    [encoder encodeInteger:self.ownerID forKey:@"ownerID"];
    [encoder encodeInteger:self.storeID forKey:@"storeID"];
    [encoder encodeBool:self.isFeatured forKey:@"isFeatured"];
    [encoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeFloat:self.price forKey:@"price"];
    [encoder encodeObject:self.currencyString forKey:@"currencyString"];
    [encoder encodeObject:self.postedOnDate forKey:@"postedOnDate"];
    [encoder encodeInteger:self.modelYear forKey:@"modelYear"];
    [encoder encodeInteger:self.distanceRangeInKm forKey:@"distanceRangeInKm"];
    [encoder encodeInteger:self.viewCount forKey:@"viewCount"];
    [encoder encodeBool:self.isFavorite forKey:@"isFavorite"];
    [encoder encodeObject:self.storeName forKey:@"storeName"];
    [encoder encodeObject:self.storeLogoURL forKey:@"storeLogoURL"];
        
}

- (NSString *) description {
    return [NSString stringWithFormat:@"adID:%i, ownerID:%i, storeID:%i, isFeatured:%i, thumbnailURL:%@, title:%@, price:%f, currencyString:%@, postedOnDate:%@, modelYear:%i, distanceRangeInKm:%i, viewCount:%i, isFavorite:%i, storeName:%@, storeLogoURL:%@",
            self.adID,
            self.ownerID,
            self.storeID,
            self.isFeatured,
            self.thumbnailURL,
            self.title,
            self.price,
            self.currencyString,
            self.postedOnDate,
            self.modelYear,
            self.distanceRangeInKm,
            self.viewCount,
            self.isFavorite,
            self.storeName,
            self.storeLogoURL
            ];
}
@end
