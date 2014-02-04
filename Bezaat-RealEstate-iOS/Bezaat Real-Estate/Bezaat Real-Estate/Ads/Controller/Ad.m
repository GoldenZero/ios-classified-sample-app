//
//  Ad.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "Ad.h"

@implementation Ad

- (id) initWithAdIDString: (NSString *) aAdIDString
            ownerIDString: (NSString *) aOwnerIDString
            storeIDString: (NSString *) aStoreIDString
         isFeaturedString: (NSString *) aIsFeaturedString
       thumbnailURLString: (NSString *) aThumbnailURLString
              titleString: (NSString *) aTitleString
              priceString: (NSString *) aPriceString
           currencyString: (NSString *) aCurrencyString
       postedOnDateString: (NSString *) aPostedOnDateString
          viewCountString: (NSString *) aViewCountString
         isFavoriteString: (NSString *) aIsFavoriteString
          storeNameString: (NSString *) aStoreNameString
       storeLogoURLString: (NSString *) aStoreLogoURLString
          countryIDString: (NSString *) aCountryIDString
          EncEditIDString: (NSString *) aEncEditIDString
          longitudeString: (NSString *) aLongitudeString
           latitudeString: (NSString *) aLatitudeString
               areaString: (NSString *) aAreaString
   postedFromCityIDString: (NSString *) aPostedFromCityIDString
         categoryIDString: (NSString *) aCategoryIDString
     mainCategoryIDString: (NSString *) aMainCategoryIDString
              roomsString: (NSString *) aRoomsString
         roomsCountString: (NSString *) aRoomsCountString
              adURLString: (NSString *) aAdURLString {
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
        else {
            NSString * newUrlString = [aThumbnailURLString stringByReplacingOccurrencesOfString:@"http://content.bezaat.com" withString:@"http://content.bezaat.com.s3-external-3.amazonaws.com"];
            
            //self.thumbnailURL = [NSURL URLWithString:aThumbnailURLString];
            self.thumbnailURL = [NSURL URLWithString:newUrlString];
        }
        
        // title
        self.title = aTitleString;
        
        // price
        self.price = aPriceString.floatValue;
        
        // currencyString
        self.currencyString = aCurrencyString;
        
        // postedOnDate
        // the JSON date has the style of "\/Date(1356658797343)\/", so it needs custom parsing
        self.postedOnDate = [GenericMethods NSDateFromDotNetJSONString:aPostedOnDateString];
        
        // viewCount
        self.viewCount = aViewCountString.integerValue;
        
        // isFavorite
        self.isFavorite = aIsFavoriteString.boolValue;
        
        // storeName
        self.storeName = aStoreNameString;
        
        // EncEditID
        self.EncEditID = aEncEditIDString;
        
        // countryID
        self.countryID = aCountryIDString.integerValue;
        
        // storeLogoURL
        if ([aStoreLogoURLString isEqualToString:@""])
            self.storeLogoURL = nil;
        else
            self.storeLogoURL = [NSURL URLWithString:aStoreLogoURLString];
        
        // longitude
        self.longitude = aLongitudeString.doubleValue;
        
        // latitude
        self.latitude = aLatitudeString.doubleValue;
        
        // area
        self.area = aAreaString;
        
        // postedFromCityID
        self.postedFromCityID = aPostedFromCityIDString.integerValue;
        
        // categoryID
        self.categoryID = aCategoryIDString.integerValue;
        
        // mainCategoryID
        self.mainCategoryID = aMainCategoryIDString.integerValue;
        
        // rooms
        self.rooms = aRoomsString;
        
        // roomsCount
        self.roomsCount = aRoomsCountString.integerValue;
        
        // adURL
        if ([aAdURLString isEqualToString:@""])
            self.adURL = nil;
        else
            self.adURL = [NSURL URLWithString:aAdURLString];
        
    }
    
    return self;
}

- (id)initWithImageID: (NSString *)aImageID andImageURL:(NSString*)aImageURL
{
    self = [super init];
    if (self) {
        self.thumbnailID = aImageID;
        
        NSString * newImageUrl = [aImageURL stringByReplacingOccurrencesOfString:@"http://content.bezaat.com" withString:@"http://content.bezaat.com.s3-external-3.amazonaws.com"];
        
        //self.ImageURL = aImageURL;
        self.ImageURL = newImageUrl;
    }
    return self;
}
/*
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

 */

- (NSString *) description {
 
    return [NSString stringWithUTF8String:
    [[NSString stringWithFormat:@"adID:%i, ownerID:%i, storeID:%i, isFeatured:%i, thumbnailURL:%@, title:%@, price:%f, currencyString:%@, postedOnDate:%@, viewCount:%i, isFavorite:%i, storeName:%@, storeLogoURL:%@, countryID:%i, EncEditID:%@, longitude:%f, latitude:%f, area:%@, postedFromCityID:%i, categoryID:%i, mainCategoryID:%i, rooms:%@, roomsCount:%i, adURL:%@",
            self.adID,
            self.ownerID,
            self.storeID,
            self.isFeatured,
            self.thumbnailURL.absoluteString,
            self.title,
            self.price,
            self.currencyString,
            self.postedOnDate,
            self.viewCount,
            self.isFavorite,
            self.storeName,
            self.storeLogoURL.absoluteString,
            self.countryID,
            self.EncEditID,
            self.longitude,
            self.latitude,
            self.area,
            self.postedFromCityID,
            self.categoryID,
            self.mainCategoryID,
            self.rooms,
            self.roomsCount,
            self.adURL.absoluteString ] UTF8String]
            ];
}

@end
