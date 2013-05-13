//
//  CarDetails.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarDetailsAttribute : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger adAttributeID;
@property (strong, nonatomic) NSString * attributeValue;
@property (nonatomic) NSUInteger categoryAttributeID;
@property (strong, nonatomic) NSString * displayName;

#pragma mark - methods

- (id) initWithAdAttributeIDString:(NSString *) aAdAttributeIDString
                    attributeValue:(NSString *) aAttributeValueString
               categoryAttributeID:(NSString *) aCategoryAttributeIDString
                       displayName:(NSString *) aDisplayName;
@end
//------------------------------------------------------

@interface CarDetailsImage : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger imageID;
@property (strong, nonatomic) NSURL * imageURL;
@property (nonatomic) NSUInteger thumbnailID;
@property (strong, nonatomic) NSURL * thumbnailImageURL;

#pragma mark - methods

- (id) initWithImageIDString:(NSString *)aImageIDString
              imageURLString:(NSString *)aImageURLString
           thumbnailIDString:(NSString *)aThumbnailIDString
     thumbnailImageURLString:(NSString *)aThumbnailImageURLString;
@end
//------------------------------------------------------

@interface CarDetails : NSObject

#pragma mark - properties

@property (strong, nonatomic) NSString * description;
@property (strong, nonatomic) NSArray * adImages;
@property (strong, nonatomic) NSArray * attributes;
@property (strong, nonatomic) NSString * mobileNumber;
@property (strong, nonatomic) NSString * landlineNumber;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (strong, nonatomic) NSString * area;
@property (strong, nonatomic) NSString * emailAddress;
@property (nonatomic) NSUInteger adID;
@property (nonatomic) NSUInteger ownerID;
@property (nonatomic) NSUInteger storeID;
@property (nonatomic) BOOL isFeatured;
@property (strong, nonatomic) NSURL * thumbnailURL;
@property (strong, nonatomic) NSString * title;
@property (nonatomic) float price;
@property (strong, nonatomic) NSString * currencyString;
@property (strong, nonatomic) NSDate * postedOnDate;
@property (nonatomic) NSUInteger modelYear;
@property (nonatomic) NSUInteger distanceRangeInKm;
@property (strong, nonatomic) NSString * EncEditID;
@property (nonatomic) NSUInteger viewCount;
@property (nonatomic) BOOL isFavorite;
@property (strong, nonatomic) NSString * storeName;
@property (strong, nonatomic) NSURL * storeLogoURL;
@property (strong, nonatomic) NSURL * adURL;

@property (nonatomic) NSUInteger countryID;

#pragma mark - methods

- (id) initWithDescription:(NSString *) aDescription
                  adImages:(NSArray *)aAdImages
                attributes:(NSArray *)aAttributes
              mobileNumber:(NSString *)aMobileNumber
            landlineNumber:(NSString *)aLandlineNumber
           longitudeString:(NSString *) aLongitudeString
            latitudeString:(NSString *) aLatitudeString
                      area:(NSString *)aArea
              emailAddress:(NSString *) aEmailAddress
                adIDString:(NSString *) aAdIDString
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
          EncryptedEditID :(NSString *) aEndEditID
           viewCountString:(NSString *) aViewCountString
          isFavoriteString:(NSString *) aIsFavoriteString
                 storeName:(NSString *) aStoreName
              storeLogoURL:(NSString *) aStoreLogoURLString
                       adURL:(NSString *) aAdURLString
               adCountryID:(NSString *)aCountryID;


@end
