//
//  GalleryAd.m
//  Bezaat
//
//  Created by Roula Misrabi on 7/14/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GalleryAd.h"

@implementation GalleryAd

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
@synthesize countryID;
@synthesize EncEditID;
@synthesize longitude;
@synthesize latitude;
@synthesize area;
@synthesize postedFromCityID;
@synthesize categoryID;
@synthesize mainCategoryID;
@synthesize rooms;
@synthesize roomsCount;
@synthesize adURL;

- (id) initWithAdIDString: (NSString *) aAdIDString
            ownerIDString: (NSString *) aOwnerIDString
            storeIDString: (NSString *) aStoreIDString
         isFeaturedString: (NSString *) aIsFeaturedString
       thumbnailURLString: (NSString *) aThumbnailURLString
              titleString: (NSString *) aTitleString
              priceString: (NSString *) aPriceString
           currencyString: (NSString *) aCurrencyString
       postedOnDateString: (NSString *) aPostedOnDateString
          modelYearString: (NSString *) aModelYearString
  distanceRangeInKmString: (NSString *) aDistanceRangeInKmString
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
        
        // modelYear
        self.modelYear = aModelYearString.integerValue;
        
        // distanceRangeInKm
        NSString * tempStr = [NSString stringWithFormat:@"%@", aDistanceRangeInKmString];
        
        if ( ([[tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) ||
            
            ([[[tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] isEqualToString:[@"null" lowercaseString]]) ) {
            self.distanceRangeInKm = -1;
        }
        else
            self.distanceRangeInKm = aDistanceRangeInKmString.integerValue;
        
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
@end
