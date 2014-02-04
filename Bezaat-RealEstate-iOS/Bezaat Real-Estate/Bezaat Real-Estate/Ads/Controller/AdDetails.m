//
//  CarDetails.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AdDetails.h"


@implementation AdDetailsAttribute

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

@implementation AdDetailsImage

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
        else {
            NSString * newUrl = [aImageURLString stringByReplacingOccurrencesOfString:@"http://content.bezaat.com" withString:@"http://content.bezaat.com.s3-external-3.amazonaws.com"];
            
            //self.imageURL = [NSURL URLWithString:aImageURLString];
            self.imageURL = [NSURL URLWithString:newUrl];
        }
        
        // thumbnailID
        self.thumbnailID = aThumbnailIDString.integerValue;
        
        // thumbnailImageURL
        if ([aThumbnailImageURLString isEqualToString:@""])
            self.thumbnailImageURL = nil;
        else {
            NSString * newThumbUrl = [aThumbnailImageURLString stringByReplacingOccurrencesOfString:@"http://content.bezaat.com" withString:@"http://content.bezaat.com.s3-external-3.amazonaws.com"];
            
            //self.thumbnailImageURL = [NSURL URLWithString:aThumbnailImageURLString];
            self.thumbnailImageURL = [NSURL URLWithString:newThumbUrl];
        }
    }
    return self;
}

@end
//------------------------------------------------------

@implementation AdDetails

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
@synthesize countryID;

//For estate Details


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
               adCountryID:(NSString *)aCountryID
              adCategoryID:(NSString *)aCategoryID
          adMainCategoryID:(NSString *)aMainCategoryID
                   adRooms:(NSString *)aRooms
              adRoomsCount:(NSString *)aRoomsCount{
    
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
        self.area = [aArea stringByReplacingOccurrencesOfString:@"&quot;" withString:@"'"];
        
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
        //NSLog(@"aDistanceRangeInKmString = %@", aDistanceRangeInKmString);
        NSString * tempStr = [NSString stringWithFormat:@"%@", aDistanceRangeInKmString];
        
        if ( ([[tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) ||
            
            ([[[tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] isEqualToString:[@"null" lowercaseString]]) ) {
            
            self.distanceRangeInKm = -1;
        }
        else
            self.distanceRangeInKm = aDistanceRangeInKmString.integerValue;
        
        //EncEditID
        self.EncEditID = aEndEditID;
        
        // viewCount
        self.viewCount = aViewCountString.integerValue;
        
        // isFavorite
        self.isFavorite = aIsFavoriteString.boolValue;
        
        // storeName
        self.storeName = aStoreName;
        
        self.countryID = aCountryID.integerValue;
        
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
        
        self.CategoryID = aCategoryID.integerValue;
        
        self.MainCategoryID = aMainCategoryID.integerValue;
        
        self.Rooms = aRooms;
        
        self.RoomsCount = aRoomsCount.integerValue;
    }
    return self;
}


@end
