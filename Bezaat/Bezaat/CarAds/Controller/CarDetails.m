//
//  CarDetails.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarDetails.h"


@implementation CarDetailsAttribute

@synthesize adAttributeID;
@synthesize attributeValue;
@synthesize categoryAttributeID;
@synthesize displayName;

- (id) initWithAdAttributeIDString:(NSString *) aAdAttributeIDString
                    attributeValue:(NSString *) aAttributeValueString
               categoryAttributeID:(NSString *) aCategoryAttributeIDString
                       displayName:(NSString *) aDisplayName {
    self = [super init];
    if (self) {
        // adAttributeID
        self.adAttributeID = aAdAttributeIDString.integerValue;
        
        // attributeValue
        self.attributeValue = aAttributeValueString;
        
        // categoryAttributeID
        self.categoryAttributeID = aCategoryAttributeIDString.integerValue;
        
        // displayName
        self.displayName = aDisplayName;
    }
    return self;
}

@end
//------------------------------------------------------

@implementation CarDetailsImage

@synthesize imageID;
@synthesize imageURL;
@synthesize thumbnailID;
@synthesize thumbnailImageURL;

- (id) initWithImageIDString:(NSString *)aImageIDString
              imageURLString:(NSString *)aImageURLString
           thumbnailIDString:(NSString *)aThumbnailIDString
     thumbnailImageURLString:(NSString *)aThumbnailImageURLString {
    
    self = [super init];
    if (self) {
        // imageID
        self.imageID = aImageIDString.integerValue;
        
        // imageURL
        if ([aImageURLString isEqualToString:@""])
            self.imageURL = nil;
        else
            self.imageURL = [NSURL URLWithString:aImageURLString];
        
        // thumbnailID
        self.thumbnailID = aThumbnailIDString.integerValue;
        
        // thumbnailImageURL
        if ([aThumbnailImageURLString isEqualToString:@""])
            self.thumbnailImageURL = nil;
        else
            self.thumbnailImageURL = [NSURL URLWithString:aThumbnailImageURLString];
    }
    return self;
}

@end
//------------------------------------------------------

@implementation CarDetails

@synthesize description;
@synthesize adImages;
@synthesize attributes;
@synthesize mobileNumber;
@synthesize landlineNumber;
@synthesize longitude;
@synthesize latitude;
@synthesize area;
@synthesize emailAddress;
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
@synthesize EncEditID;
@synthesize viewCount;
@synthesize isFavorite;
@synthesize storeName;
@synthesize storeLogoURL;
@synthesize adURL;

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
                     adURL:(NSString *) aAdURLString {
    
    self = [super init];
    if (self) {
        
        // description
        self.description = aDescription;
        
        // adImages
        self.adImages = aAdImages;
        
        // attributes
        self.attributes = aAttributes;
        
        // mobileNumber
        self.mobileNumber = aMobileNumber;
        
        // landlineNumber
        self.landlineNumber = aLandlineNumber;
        
        // longitude
        self.longitude = aLongitudeString.doubleValue;
        
        // latitude
        self.latitude = aLatitudeString.doubleValue;
        
        // area
        self.area = aArea;
        
        // emailAddress
        self.emailAddress = aEmailAddress;

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
        
        //EncEditID
        self.EncEditID = aEndEditID;
        
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
        
        //adURL
        if ([aAdURLString isEqualToString:@""])
            self.adURL = nil;
        else
            self.adURL = [NSURL URLWithString:aAdURLString];
    }
    return self;
}


@end
