//
//  Ad.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ad : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger adID;
@property (nonatomic) NSUInteger ownerID;
@property (nonatomic) NSUInteger storeID;
@property (nonatomic) BOOL isFeatured;
@property (strong, nonatomic) NSURL * thumbnailURL;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * adDetails;
@property (nonatomic) float price;
@property (strong, nonatomic) NSString * currencyString;
@property (strong, nonatomic) NSDate * postedOnDate;
@property (nonatomic) NSUInteger viewCount;
@property (nonatomic) BOOL isFavorite;
@property (strong, nonatomic) NSString * storeName;
@property (strong, nonatomic) NSURL * storeLogoURL;
@property (nonatomic) NSUInteger countryID;
@property (strong, nonatomic) NSString * EncEditID;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (strong, nonatomic) NSString * area;
@property (nonatomic) NSUInteger postedFromCityID;
@property (nonatomic) NSUInteger categoryID;
@property (nonatomic) NSUInteger mainCategoryID;
@property (strong, nonatomic) NSString * rooms;
@property (nonatomic) NSUInteger roomsCount;
@property (strong, nonatomic) NSURL * adURL;
@property (strong, nonatomic) NSString * ImageURL;
@property (strong, nonatomic) NSString * thumbnailID;

#pragma mark - methods

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
              adURLString: (NSString *) aAdURLString;


- (id)initWithImageID: (NSString *)aImageID andImageURL:(NSString*)aImageURL;


@end
