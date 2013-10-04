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
@property (nonatomic) float price;
@property (strong, nonatomic) NSString * currencyString;
@property (strong, nonatomic) NSDate * postedOnDate;
@property (nonatomic) NSUInteger modelYear;
@property (nonatomic) NSInteger distanceRangeInKm;
@property (nonatomic) NSUInteger viewCount;
@property (nonatomic) BOOL isFavorite;
@property (strong, nonatomic) NSString * storeName;
@property (strong, nonatomic) NSURL * storeLogoURL;
@property (strong, nonatomic) NSString * emailAddress;
@property (strong, nonatomic) NSString * desc;
@property (strong, nonatomic) NSString * cityName;
@property (strong, nonatomic) NSString * distance;
@property (strong, nonatomic) NSString * mobileNum;
@property (strong, nonatomic) NSString * thumbnailID;
@property (strong, nonatomic) NSString * ImageURL;
@property (strong, nonatomic) NSString* EncEditID;

@property (nonatomic) NSUInteger nine52;
@property (nonatomic) NSUInteger five06;
@property (nonatomic) NSUInteger five02; //adv period
@property (strong, nonatomic) NSString * nine06;
@property (strong, nonatomic) NSString * one01;
@property (nonatomic) NSUInteger ninty8;

@property (strong, nonatomic) NSString * serviceName;
@property (nonatomic) NSUInteger adComments;
@property (nonatomic) NSUInteger carCondition;
@property (nonatomic) NSUInteger gearType;
@property (nonatomic) NSUInteger carEngine;
@property (nonatomic) NSUInteger carType;
@property (nonatomic) NSUInteger carBody;
@property (nonatomic) NSUInteger carCD;
@property (nonatomic) NSUInteger carHeads;

@property (nonatomic) NSUInteger countryID;
@property (nonatomic) NSUInteger categoryID;

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
             storeLogoURL:(NSString *) aStoreLogoURLString
          EncryptedEditID: (NSString*)aEncEditID
                countryID:(NSString*)aCountryID
               categoryID:(NSString *) aCategoryID;


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
                  ninty8:(NSString*)aninty8;


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
                     carHeads:(NSString*)aCarHeads;


- (id)initWithImageID: (NSString *)aImageID andImageURL:(NSString*)aImageURL;

@end
