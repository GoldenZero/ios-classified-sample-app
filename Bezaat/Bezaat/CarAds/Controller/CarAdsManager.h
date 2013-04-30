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

#pragma mark - FILTERS LITERALS

#define YEAR_FILTER_LITERAL @"PostedOn"
#define PRICE_FILTER_LITERAL @"Price"
#define DISTANCE_FILTER_LITERAL @"DistanceRangeInKm"

@protocol CarAdsManagerDelegate <NSObject>
@required
//load, search & filter
- (void) adsDidFailLoadingWithError:(NSError *) error;
- (void) adsDidFinishLoadingWithData:(NSArray*) resultArray;
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
@end

@protocol StorePostAdDelegate <NSObject>
@required

- (void) storeAdDidFailPostingWithError:(NSError *) error;
- (void) storeAdDidFinishPostingWithAdID:(NSInteger) adID;
@end
@interface CarAdsManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <CarAdsManagerDelegate> delegate;
@property (strong, nonatomic) id <UploadImageDelegate> imageDelegate;
@property (strong, nonatomic) id <PostAdDelegate> adPostingDelegate;
@property (strong, nonatomic) id <StorePostAdDelegate> storeaAdPostingDelegate;
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


//cache
- (BOOL) cacheDataFromArray:(NSArray *) dataArr forBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize ;

- (NSArray *) getCahedDataForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID;

- (NSUInteger) getCahedPageNumForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID;

- (NSUInteger) getCahedPageSizeForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID;

- (void) clearCachedDataForBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize;

//helpers
- (NSString *) getDateDifferenceStringFromDate:(NSDate *) input;

- (NSInteger) getIndexOfAd:(NSUInteger) adID inArray:(NSArray *) adsArray;


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
                  carBodyID:(NSInteger)carBodyID            //new
               withDelegate:(id <StorePostAdDelegate>) del;
@end