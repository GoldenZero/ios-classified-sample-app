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
@synthesize serviceName;
@synthesize adComments;
@synthesize carCondition;
@synthesize gearType;
@synthesize carEngine;
@synthesize carType;
@synthesize carBody;
@synthesize carCD;
@synthesize carHeads;

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
             storeLogoURL:(NSString *) aStoreLogoURLString
EncryptedEditID: (NSString*)aEncEditID
{
    
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
        
        self.EncEditID = aEncEditID;
        
        // storeLogoURL
        if ([aStoreLogoURLString isEqualToString:@""])
            self.storeLogoURL = nil;
        else
            self.storeLogoURL = [NSURL URLWithString:aStoreLogoURLString];
    }
    return self;
}

- (id) initWithAdIDTitle:(NSString *) aAdIDTitle                //524
             EmailString:(NSString *) aEmailString              //-100
       descriptionString:(NSString *) aDescriptionString        //523
             priceString:(NSString *) aPriceString              //507
              cityString:(NSString *) aCityString               //-99
          currencyString:(NSString *) aCurrencyString           //508
 distanceRangeInKmString:(NSString *) aDistanceRangeInKmString  //1076
         modelYearString:(NSString *) aModelYearString          //509
          distanceString:(NSString*) aDistanceString            //518
      mobileNumberString:(NSString *) aMobileString             //520
            thumbnailURL:(NSString *) aThumbnailURLString
                  nine52:(NSString*)anine52
                  five06:(NSString*)afive06
                  five02:(NSString*)afive02
                  nine06:(NSString*)anine06
                   one01:(NSString*)aone01
ninty8:(NSString*)aninty8

{
    self = [super init];
    if (self) {
        
        // title
        self.title = aAdIDTitle;
        
        // email
        self.emailAddress = aEmailString;
        
        // description
        self.desc = aDescriptionString;
        
        // price
        self.price = aPriceString.floatValue;
        
        // city
        self.cityName = aCityString;
        
        // currencyString
        self.currencyString = aCurrencyString;
        
        // distanceRangeInKm
        self.distanceRangeInKm = aDistanceRangeInKmString.integerValue;
        
        // modelYear
        self.modelYear = aModelYearString.integerValue;

        // currencyString
        self.currencyString = aCurrencyString;
        
        // distance
        self.distance = aDistanceString;

        // mobile number
        self.mobileNum = aMobileString;
        
        self.nine52 = anine52.integerValue;

        self.five06 = afive06.integerValue;
        self.five02 = afive02.integerValue;
        
        self.nine06 = anine06;
        self.one01 = aone01;
        self.ninty8 = aninty8.integerValue;
        
        // thumbnailURL
        if ([aThumbnailURLString isEqualToString:@""])
            self.thumbnailURL = nil;
        else
            self.thumbnailURL = [NSURL URLWithString:aThumbnailURLString];
        
    }
    return self;
}

- (id) initWithStoreAdIDTitle:(NSString *) aStoreAdIDTitle      //524
                  EmailString:(NSString *) aEmailString              //-100
            descriptionString:(NSString *) aDescriptionString        //523
                  priceString:(NSString *) aPriceString              //507
                   cityString:(NSString *) aCityString               //-99
               currencyString:(NSString *) aCurrencyString           //508
      distanceRangeInKmString:(NSString *) aDistanceRangeInKmString  //1076
              modelYearString:(NSString *) aModelYearString          //509
               distanceString:(NSString*) aDistanceString            //518
           mobileNumberString:(NSString *) aMobileString             //520
                 thumbnailURL:(NSString *) aThumbnailURLString
                       nine52:(NSString*)anine52
                       five06:(NSString*)afive06
                    advPeriod:(NSString*)aAdvPeriod
                       nine06:(NSString*)anine06
                        one01:(NSString*)aone01
                       ninty8:(NSString*)aninty8
                  serviceName:(NSString*)aServiceName
              adCommentsEmail:(NSString*)aAdcommentsEmail
                 carCondition:(NSString*)aCondition
                     gearType:(NSString*)aGearType
                    carEngine:(NSString*)aCarEngine
                      carType:(NSString*)aCarType
                      carBody:(NSString*)aCarBody
                        carCD:(NSString*)aCarCD
                     carHeads:(NSString*)aCarHeads

{
    self = [super init];
    if (self) {
        
        // title
        self.title = aStoreAdIDTitle;
        
        // email
        self.emailAddress = aEmailString;
        
        // description
        self.desc = aDescriptionString;
        
        // price
        self.price = aPriceString.floatValue;
        
        // city
        self.cityName = aCityString;
        
        // currencyString
        self.currencyString = aCurrencyString;
        
        // distanceRangeInKm
        self.distanceRangeInKm = aDistanceRangeInKmString.integerValue;
        
        // modelYear
        self.modelYear = aModelYearString.integerValue;
        
        // currencyString
        self.currencyString = aCurrencyString;
        
        // distance
        self.distance = aDistanceString;
        
        // mobile number
        self.mobileNum = aMobileString;
        
        self.nine52 = anine52.integerValue;
        
        self.five06 = afive06.integerValue;
        self.five02 = aAdvPeriod.integerValue;
        
        self.nine06 = anine06;
        self.one01 = aone01;
        self.ninty8 = aninty8.integerValue;
        
        self.serviceName = aServiceName;
        self.adComments = aAdcommentsEmail.integerValue;
        self.carCondition = aCondition.integerValue;
        self.gearType = aGearType.integerValue;
        self.carEngine = aCarEngine.integerValue;
        self.carType = aCarType.integerValue;
        self.carBody = aCarBody.integerValue;
        self.carCD = aCarCD.integerValue;
        self.carHeads = aCarHeads.integerValue;
        
        // thumbnailURL
        if ([aThumbnailURLString isEqualToString:@""])
            self.thumbnailURL = nil;
        else
            self.thumbnailURL = [NSURL URLWithString:aThumbnailURLString];
        
    }
    return self;
}


- (id)initWithImageID: (NSString *)aImageID andImageURL:(NSString*)aImageURL
{
    self = [super init];
    if (self) {
        self.thumbnailID = aImageID;
        self.ImageURL = aImageURL;
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
    return [NSString stringWithFormat:@"adID:%i, ownerID:%i, storeID:%i, isFeatured:%i, thumbnailURL:%@, title:%@, price:%f, currencyString:%@, postedOnDate:%@, modelYear:%i, distanceRangeInKm:%i, viewCount:%i, isFavorite:%i, storeName:%@, storeLogoURL:%@, Email:%@, details:%@, cityName:%@, distance:%@, mobileNumber:%@",
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
            self.storeLogoURL,
            self.emailAddress,
            self.desc,
            self.cityName,
            self.distance,
            self.mobileNum
            ];
}
@end
