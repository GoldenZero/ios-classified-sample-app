//
//  CarAdsManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarAd.h"
#import "CustomError.h"
#import "StaticAttrsLoader.h"
#import "CarDetailsManager.h"
#import "StoreOrder.h"

#pragma mark - FILTERS LITERALS

#define YEAR_FILTER_LITERAL @"PostedOn"
#define PRICE_FILTER_LITERAL @"Price"
#define DISTANCE_FILTER_LITERAL @"DistanceRangeInKm"

@protocol CarAdsManagerDelegate <NSObject>
@required
//load, search & filter
- (void) adsDidFailLoadingWithError:(NSError *) error;
- (void) adsDidFinishLoadingWithData:(NSArray*) resultArray;

- (void) RequestToEditFailWithError:(NSError *) error;
- (void) RequestToEditFinishWithData:(NSArray*) resultArray imagesArray:(NSArray *)resultIDs;

- (void) RequestToEditStoreFailWithError:(NSError *) error;
- (void) RequestToEditStoreFinishWithData:(NSArray*) resultArray imagesArray:(NSArray *)resultIDs;


@end

@protocol UploadImageDelegate <NSObject>
@required

- (void) imageDidFailUploadingWithError:(NSError *) error;
- (void) imageDidFinishUploadingWithURL:(NSURL*) url CreativeID:(NSInteger) ID;
@end

@protocol PostAdDelegate <NSObject>
@required

- (void) adDidFailPostingWithError:(NSError *) error;
- (void) adDidFinishPostingWithAdID:(NSInteger) adID;

- (void) adDidFailEditingWithError:(NSError *) error;
- (void) adDidFinishEditingWithAdID:(NSInteger) adID;



@end

@protocol StorePostAdDelegate <NSObject>
@required

- (void) storeAdDidFailPostingWithError:(NSError *) error;
- (void) storeAdDidFinishPostingWithAdID:(NSInteger) adID;

- (void) storeAdDidFailEditingWithError:(NSError *) error;
- (void) storeAdDidFinishEditingWithAdID:(NSInteger) adID;

@end


@protocol SendEmailDelegate <NSObject>
@required

- (void) EmailDidFailSendingWithError:(NSError *) error;
- (void) EmailDidFinishSendingWithStatus:(BOOL) Status;
@end


@interface CarAdsManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <CarAdsManagerDelegate> delegate;
@property (strong, nonatomic) id <UploadImageDelegate> imageDelegate;
@property (strong, nonatomic) id <PostAdDelegate> adPostingDelegate;
@property (strong, nonatomic) id <StorePostAdDelegate> storeaAdPostingDelegate;
@property (strong, nonatomic) id <SendEmailDelegate> EmailSendingDelegate;

@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) NSUInteger pageSize;

#pragma mark - methods

+ (CarAdsManager *) sharedInstance;

- (NSUInteger) nextPage;

- (NSUInteger) getCurrentPageNum;
- (NSUInteger) getCurrentPageSize;

- (void) setCurrentPageNum:(NSUInteger) pNum;
- (void) setCurrentPageSize:(NSUInteger) pSize;
- (void) setPageSizeToDefault;

//load
- (void) loadCarAdsOfPage:(NSUInteger) pageNum forBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID WithDelegate:(id <CarAdsManagerDelegate>) del;

- (void) loadUserAdsOfStatus:(NSString*) status forPage:(NSUInteger) pageNum andSize:(NSInteger) pageSize WithDelegate:(id <CarAdsManagerDelegate>) del;

//request to edit ad
- (void) requestToEditAdsOfEditID:(NSString*) EditID WithDelegate:(id <CarAdsManagerDelegate>) del;


//request to edit store ad
- (void) requestToEditStoreAdsOfEditID:(NSString*) EditID andStore:(NSString*)StoreID WithDelegate:(id <CarAdsManagerDelegate>) del;

//Sending email
- (void) sendEmailofName:(NSString*) UserName withEmail:(NSString*) emailAddress phoneNumber:(NSInteger) phone message:(NSString*) SubjectMessage withAdID:(NSInteger)AdID WithDelegate:(id <SendEmailDelegate>) del;

//cache
- (BOOL) cacheDataFromArray:(NSArray *) dataArr forBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize ;

- (NSArray *) getCahedDataForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID;

- (NSUInteger) getCahedPageNumForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID;

- (NSUInteger) getCahedPageSizeForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID;

- (void) clearCachedDataForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize;

//helpers
- (NSString *) getDateDifferenceStringFromDate:(NSDate *) input;

- (NSInteger) getIndexOfAd:(NSUInteger) adID inArray:(NSArray *) adsArray;

- (NSArray * ) createCarAdsArrayWithData:(NSArray *) data;
- (NSArray * ) createStoreOrderArrayWithData:(NSArray *) data;

//search & filter
- (void) searchCarAdsOfPage:(NSUInteger) pageNum
                   forBrand:(NSUInteger) brandID
                      Model:(NSInteger) modelID
                     InCity:(NSUInteger) cityID
                   textTerm:(NSString *) aTextTerm
                   minPrice:(NSString *) aMinPrice
                   maxPrice:(NSString *) aMaxPrice
            distanceRangeID:(NSInteger) aDistanceRangeID
                   fromYear:(NSString *) aFromYear
                     toYear:(NSString *) aToYear
              adsWithImages:(BOOL) aAdsWithImages
               adsWithPrice:(BOOL) aAdsWithPrice
                       area:(NSString *) aArea
                    orderby:(NSString *) aOrderby
              lastRefreshed:(NSString *)aLastRefreshed
               WithDelegate:(id <CarAdsManagerDelegate>) del;

//upload image
- (void) uploadImage:(UIImage *) image WithDelegate:(id <UploadImageDelegate>) del;

//post an ad
- (void) postAdOfBrand:(NSUInteger) brandID
                 Model:(NSInteger) modelID
                InCity:(NSUInteger) cityID
             userEmail:(NSString *) usermail
                 title:(NSString *) aTitle
           description:(NSString *) aDescription
                 price:(NSString *) aPrice
         periodValueID:(NSInteger) aPeriodValueID
                mobile:(NSString *) aMobileNum
       currencyValueID:(NSInteger) aCurrencyValueID
        serviceValueID:(NSInteger) aServiceValueID
      modelYearValueID:(NSInteger) aModelYearValueID
              distance:(NSString *) aDistance
                 color:(NSString *) aColor
            phoneNumer:(NSString *) aPhoneNumer
       adCommentsEmail:(BOOL) aAdCommentsEmail
      kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
              imageIDs:(NSArray *) aImageIDsArray
          withDelegate:(id <PostAdDelegate>) del;


//edit an ad
- (void) editAdOfEditadID:(NSString*) editADID
             inCountryID :(NSInteger)countryID
                   InCity:(NSUInteger) cityID
                userEmail:(NSString *) usermail
                    title:(NSString *) aTitle
              description:(NSString *) aDescription
                    price:(NSString *) aPrice
            periodValueID:(NSInteger) aPeriodValueID
                   mobile:(NSString *) aMobileNum
          currencyValueID:(NSInteger) aCurrencyValueID
           serviceValueID:(NSInteger) aServiceValueID
         modelYearValueID:(NSInteger) aModelYearValueID
                 distance:(NSString *) aDistance
                    color:(NSString *) aColor
               phoneNumer:(NSString *) aPhoneNumer
          adCommentsEmail:(BOOL) aAdCommentsEmail
         kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
                   nine52:(NSInteger)anine52
                   five06:(NSInteger)afive06
                   five02:(NSInteger)afive02
                   nine06:(NSString*)anine06
                    one01:(NSString*)aone01
                   ninty8:(NSInteger)aninty8
                 imageIDs:(NSArray *) aImageIDsArray
             withDelegate:(id <PostAdDelegate>) del;



//edit an store ad
- (void) editStoreAdOfEditadID:(NSString*) editADID
             inCountryID :(NSInteger)countryID
                   InCity:(NSUInteger) cityID
                userEmail:(NSString *) usermail
                    title:(NSString *) aTitle
              description:(NSString *) aDescription
                    price:(NSString *) aPrice
            periodValueID:(NSInteger) aPeriodValueID
                   mobile:(NSString *) aMobileNum
          currencyValueID:(NSInteger) aCurrencyValueID
           serviceValueID:(NSInteger) aServiceValueID
         modelYearValueID:(NSInteger) aModelYearValueID
                 distance:(NSString *) aDistance
                    color:(NSString *) aColor
               phoneNumer:(NSString *) aPhoneNumer
          adCommentsEmail:(BOOL) aAdCommentsEmail
         kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
                   nine52:(NSInteger)anine52
                   five06:(NSInteger)afive06
                   advPeriod:(NSInteger)aAdvPeriod
                   nine06:(NSString*)anine06
                    one01:(NSString*)aone01
                   ninty8:(NSInteger)aninty8
                   serviceName:(NSString*)aServiceName
               adCommentsEmail:(NSInteger)aAdcommentsEmail
                  carCondition:(NSInteger)aCondition
                      gearType:(NSInteger)aGearType
                     carEngine:(NSInteger)aCarEngine
                       carType:(NSInteger)aCarType
                       carBody:(NSInteger)aCarBody
                         carCD:(NSInteger)aCarCD
                      carHeads:(NSInteger)aCarHeads
                      storeID:(NSInteger)aStoreID
                      imageIDs:(NSArray *) aImageIDsArray
             withDelegate:(id <StorePostAdDelegate>) del;


//post store ad
- (void) postStoreAdOfBrand:(NSInteger) brandID
                    myStore:(NSInteger) StoreID
                      Model:(NSInteger) modelID
                     InCity:(NSInteger) cityID
                  userEmail:(NSString *) usermail
                      title:(NSString *) aTitle
                description:(NSString *) aDescription
                      price:(NSString *) aPrice
              periodValueID:(NSInteger) aPeriodValueID
                     mobile:(NSString *) aMobileNum
            currencyValueID:(NSInteger) aCurrencyValueID
             serviceValueID:(NSInteger) aServiceValueID
           modelYearValueID:(NSInteger) aModelYearValueID
                   distance:(NSString *) aDistance
                      color:(NSString *) aColor
                 phoneNumer:(NSString *) aPhoneNumer
            adCommentsEmail:(BOOL) aAdCommentsEmail
           kmVSmilesValueID:(NSInteger) aKmVSmilesValueID
                   imageIDs:(NSArray *) aImageIDsArray
                conditionID:(NSInteger) carConditionID      //new
                 gearTypeID:(NSInteger) gearTypeID          //new
                  carTypeID:(NSInteger)carTypeID            //new
                  carBodyID:(NSInteger)carBodyID
               withCategory:(NSInteger)brand
                  withCity1:(NSInteger)city
               withDelegate:(id <StorePostAdDelegate>) del;
@end