//
//  AdsManager.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ad.h"
#import "Category1.h"

#pragma mark - FILTERS LITERALS

#define YEAR_FILTER_LITERAL @"PostedOn"
#define PRICE_FILTER_LITERAL @"Price"

@protocol BrowseAdsDelegate <NSObject>
@required

//load, search & filter
- (void) adsDidFailLoadingWithError:(NSError *) error;
- (void) adsDidFinishLoadingWithData:(NSArray*) resultArray;
@end
//-------------------------------------------------------------

@protocol RequestEditAdDelegate <NSObject>
@required

- (void) RequestToEditFailWithError:(NSError *) error;
- (void) RequestToEditFinishWithData:(NSArray*) resultArray imagesArray:(NSArray *)resultIDs;
@end
//-------------------------------------------------------------

@protocol RequestEditStoreDelegate <NSObject>

- (void) RequestToEditStoreFailWithError:(NSError *) error;
- (void) RequestToEditStoreFinishWithData:(NSArray*) resultArray imagesArray:(NSArray *)resultIDs;
@end
//-------------------------------------------------------------

@protocol UploadImageDelegate <NSObject>
@required

- (void) imageDidFailUploadingWithError:(NSError *) error;
- (void) imageDidFinishUploadingWithURL:(NSURL*) url CreativeID:(NSInteger) ID;
@end
//-------------------------------------------------------------

@protocol PostAdDelegate <NSObject>
@required

- (void) adDidFailPostingWithError:(NSError *) error;
- (void) adDidFinishPostingWithAdID:(NSInteger) adID;

- (void) adDidFailEditingWithError:(NSError *) error;
- (void) adDidFinishEditingWithAdID:(NSInteger) adID;
@end
//-------------------------------------------------------------

@protocol StorePostAdDelegate <NSObject>
@required

- (void) storeAdDidFailPostingWithError:(NSError *) error;
- (void) storeAdDidFinishPostingWithAdID:(NSInteger) adID;

- (void) storeAdDidFailEditingWithError:(NSError *) error;
- (void) storeAdDidFinishEditingWithAdID:(NSInteger) adID;
@end
//-------------------------------------------------------------

@protocol SendEmailDelegate <NSObject>
@required

- (void) EmailDidFailSendingWithError:(NSError *) error;
- (void) EmailDidFinishSendingWithStatus:(BOOL) Status;
@end
//-------------------------------------------------------------

@protocol CategoriesCountDelegate <NSObject>
@required

- (void) subCategoriesDidFailLoadingWithError:(NSError *) error;
- (void) subCategoriesDidFinishLoadingWithStatus:(NSArray*) resultArray;
@end

@interface AdsManager : NSObject <DataDelegate>

#pragma mark - properties

@property (strong, nonatomic) id <BrowseAdsDelegate> browseAdsDel;
@property (strong, nonatomic) id <RequestEditAdDelegate> requestEditAdDel;
@property (strong, nonatomic) id <RequestEditStoreDelegate> requestEditStoreDel;
@property (strong, nonatomic) id <UploadImageDelegate> uploadImageDel;
@property (strong, nonatomic) id <PostAdDelegate> postAdDel;
@property (strong, nonatomic) id <StorePostAdDelegate> storePostAdDel;
@property (strong, nonatomic) id <SendEmailDelegate> sendEmailDel;
@property (strong, nonatomic) id <CategoriesCountDelegate> categoriesCountDelegate;

@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) NSUInteger pageSize;

#pragma mark - methods

+ (AdsManager *) sharedInstance;

- (NSUInteger) nextPage;

- (NSUInteger) getCurrentPageNum;
- (NSUInteger) getCurrentPageSize;

- (void) setCurrentPageNum:(NSUInteger) pNum;
- (void) setCurrentPageSize:(NSUInteger) pSize;
- (void) setPageSizeToDefault;

//load
- (void) loadAdsOfPage:(NSUInteger) pageNum forSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID andPurpose:(NSString*)purpose WithServiceType:(NSString*)serviceType WithDelegate:(id <BrowseAdsDelegate>) del;

- (void) loadUserAdsOfStatus:(NSString*) status forPage:(NSUInteger) pageNum andSize:(NSInteger) pageSize WithDelegate:(id <BrowseAdsDelegate>) del;

//Sending email
- (void) sendEmailofName:(NSString*) UserName withEmail:(NSString*) emailAddress phoneNumber:(NSInteger) phone message:(NSString*) SubjectMessage withAdID:(NSInteger)AdID WithDelegate:(id <SendEmailDelegate>) del;

//search
- (void) searchCarAdsOfPage:(NSUInteger) pageNum
                forSubCategory:(NSInteger) subCatID
                     InCity:(NSUInteger) cityID
                   textTerm:(NSString *) aTextTerm
                serviceType:(NSString *) aServiceType
                   minPrice:(NSString *) aMinPrice
                   maxPrice:(NSString *) aMaxPrice
              adsWithImages:(BOOL) aAdsWithImages
               adsWithPrice:(BOOL) aAdsWithPrice
                       area:(NSString *) aArea
                    orderby:(NSString *) aOrderby
              lastRefreshed:(NSString *) aLastRefreshed
               numOfRoomsID:(NSString *) aNumOfRoomsIDString
                    purpose:(NSString *) aPurpose
                    withGeo:(NSString *) aWithGeo
                 longitute:(NSString *) aLongitute
                  latitute:(NSString *) aLatitute
                     radius:(NSString *) aRadius
                   currency:(NSString *) aCurrency
               WithDelegate:(id <BrowseAdsDelegate>) del;

//post an ad
- (void) postAdForSaleOfCategory:(NSUInteger) categoryID
                   InCity:(NSUInteger) cityID
                userEmail:(NSString *) usermail
                    title:(NSString *) aTitle
              description:(NSString *) aDescription
                 adPeriod:(NSInteger)aPeriodID
           requireService:(NSInteger)aServiceID
                    price:(NSString *) aPrice
          currencyValueID:(NSInteger) aCurrencyValueID
                unitPrice:(NSString*)aUnitPrice
                 unitType:(NSInteger)aUnitTypeID
                 imageIDs:(NSArray *) aImageIDsArray
                longitude:(NSString*)aLongitude
                 latitude:(NSString*)aLatitude
               roomNumber:(NSString*) aRoomNumber
                    space:(NSString *) aSpace
                     area:(NSString *) aArea
                   mobile:(NSString *) aMobileNum
               phoneNumer:(NSString *) aPhoneNumer
             withDelegate:(id <PostAdDelegate>) del;

//post an ad
- (void) postAdForRentOfCategory:(NSUInteger) categoryID
                          InCity:(NSUInteger) cityID
                       userEmail:(NSString *) usermail
                           title:(NSString *) aTitle
                     description:(NSString *) aDescription
                        adPeriod:(NSInteger)aPeriodID
                  requireService:(NSInteger)aServiceID
                           price:(NSString *) aPrice
                 currencyValueID:(NSInteger) aCurrencyValueID
                       unitPrice:(NSString*)aUnitPrice
                        unitType:(NSInteger)aUnitTypeID
                        imageIDs:(NSArray *) aImageIDsArray
                       longitude:(NSString*)aLongitude
                        latitude:(NSString*)aLatitude
                      roomNumber:(NSString*) aRoomNumber
                           space:(NSString *) aSpace
                            area:(NSString *) aArea
                          mobile:(NSString *) aMobileNum
                      phoneNumer:(NSString *) aPhoneNumer
                    withDelegate:(id <PostAdDelegate>) del;

//post an ad
- (void) postStoreAdForSaleOfCategory:(NSUInteger) categoryID
                       myStore:(NSInteger) StoreID
                        InCity:(NSUInteger) cityID
                     userEmail:(NSString *) usermail
                         title:(NSString *) aTitle
                   description:(NSString *) aDescription
                      adPeriod:(NSInteger)aPeriodID
                requireService:(NSInteger)aServiceID
                         price:(NSString *) aPrice
               currencyValueID:(NSInteger) aCurrencyValueID
                     unitPrice:(NSString*)aUnitPrice
                      unitType:(NSInteger)aUnitTypeID
                      imageIDs:(NSArray *) aImageIDsArray
                     longitude:(NSString*)aLongitude
                      latitude:(NSString*)aLatitude
                    roomNumber:(NSString*) aRoomNumber
                         space:(NSString *) aSpace
                          area:(NSString *) aArea
                        mobile:(NSString *) aMobileNum
                    phoneNumer:(NSString *) aPhoneNumer
                  withDelegate:(id <StorePostAdDelegate>) del;

- (void) postStoreAdForRentOfCategory:(NSUInteger) categoryID
                              myStore:(NSInteger) StoreID
                               InCity:(NSUInteger) cityID
                            userEmail:(NSString *) usermail
                                title:(NSString *) aTitle
                          description:(NSString *) aDescription
                             adPeriod:(NSInteger)aPeriodID
                       requireService:(NSInteger)aServiceID
                                price:(NSString *) aPrice
                      currencyValueID:(NSInteger) aCurrencyValueID
                            unitPrice:(NSString*)aUnitPrice
                             unitType:(NSInteger)aUnitTypeID
                             imageIDs:(NSArray *) aImageIDsArray
                            longitude:(NSString*)aLongitude
                             latitude:(NSString*)aLatitude
                           roomNumber:(NSString *) aRoomNumber
                                space:(NSString *) aSpace
                                 area:(NSString *) aArea
                               mobile:(NSString *) aMobileNum
                           phoneNumer:(NSString *) aPhoneNumer
                         withDelegate:(id <StorePostAdDelegate>) del;



//request to edit ad
- (void) requestToEditAdsOfEditID:(NSString*) EditID WithDelegate:(id <RequestEditAdDelegate>) del;


//request to edit store ad
- (void) requestToEditStoreAdsOfEditID:(NSString*) EditID andStore:(NSString*)StoreID WithDelegate:(id <RequestEditStoreDelegate>) del;

//edit an ad for sale
- (void) editAdForSaleOfEditadID:(NSString*) editADID
                      OfCategory:(NSUInteger) categoryID
             inCountryID :(NSInteger)countryID
                   InCity:(NSUInteger) cityID
                userEmail:(NSString *) usermail
                    title:(NSString *) aTitle
              description:(NSString *) aDescription
                 adPeriod:(NSInteger)aPeriodID
           requireService:(NSInteger)aServiceID
                    price:(NSString *) aPrice
          currencyValueID:(NSInteger) aCurrencyValueID
                unitPrice:(NSString*)aUnitPrice
                 unitType:(NSInteger)aUnitTypeID
                 imageIDs:(NSArray *) aImageIDsArray
                longitude:(NSString*)aLongitude
                 latitude:(NSString*)aLatitude
               roomNumber:(NSString*) aRoomNumber
                    space:(NSString *) aSpace
                     area:(NSString *) aArea
                   mobile:(NSString *) aMobileNum
               phoneNumer:(NSString *) aPhoneNumer
             withDelegate:(id <PostAdDelegate>) del;

//edit an ad for rent
- (void) editAdForRentOfEditadID:(NSString*) editADID
                      OfCategory:(NSUInteger) categoryID
                    inCountryID :(NSInteger)countryID
                          InCity:(NSUInteger) cityID
                       userEmail:(NSString *) usermail
                           title:(NSString *) aTitle
                     description:(NSString *) aDescription
                        adPeriod:(NSInteger)aPeriodID
                  requireService:(NSInteger)aServiceID
                           price:(NSString *) aPrice
                 currencyValueID:(NSInteger) aCurrencyValueID
                       unitPrice:(NSString*)aUnitPrice
                        unitType:(NSInteger)aUnitTypeID
                        imageIDs:(NSArray *) aImageIDsArray
                       longitude:(NSString*)aLongitude
                        latitude:(NSString*)aLatitude
                      roomNumber:(NSString*) aRoomNumber
                           space:(NSString *) aSpace
                            area:(NSString *) aArea
                          mobile:(NSString *) aMobileNum
                      phoneNumer:(NSString *) aPhoneNumer
                    withDelegate:(id <PostAdDelegate>) del;

//edit an ad for sale
- (void) editAdStoreForSaleOfEditadID:(NSString*) editADID
                              myStore:(NSInteger) StoreID
                      OfCategory:(NSUInteger) categoryID
                    inCountryID :(NSInteger)countryID
                          InCity:(NSUInteger) cityID
                       userEmail:(NSString *) usermail
                           title:(NSString *) aTitle
                     description:(NSString *) aDescription
                        adPeriod:(NSInteger)aPeriodID
                  requireService:(NSInteger)aServiceID
                           price:(NSString *) aPrice
                 currencyValueID:(NSInteger) aCurrencyValueID
                       unitPrice:(NSString*)aUnitPrice
                        unitType:(NSInteger)aUnitTypeID
                        imageIDs:(NSArray *) aImageIDsArray
                       longitude:(NSString*)aLongitude
                        latitude:(NSString*)aLatitude
                      roomNumber:(NSString*) aRoomNumber
                           space:(NSString *) aSpace
                            area:(NSString *) aArea
                          mobile:(NSString *) aMobileNum
                      phoneNumer:(NSString *) aPhoneNumer
                    withDelegate:(id <StorePostAdDelegate>) del;

//edit an ad for rent
- (void) editAdStoreForRentOfEditadID:(NSString*) editADID
                              myStore:(NSInteger) StoreID
                      OfCategory:(NSUInteger) categoryID
                    inCountryID :(NSInteger)countryID
                          InCity:(NSUInteger) cityID
                       userEmail:(NSString *) usermail
                           title:(NSString *) aTitle
                     description:(NSString *) aDescription
                        adPeriod:(NSInteger)aPeriodID
                  requireService:(NSInteger)aServiceID
                           price:(NSString *) aPrice
                 currencyValueID:(NSInteger) aCurrencyValueID
                       unitPrice:(NSString*)aUnitPrice
                        unitType:(NSInteger)aUnitTypeID
                        imageIDs:(NSArray *) aImageIDsArray
                       longitude:(NSString*)aLongitude
                        latitude:(NSString*)aLatitude
                      roomNumber:(NSString*) aRoomNumber
                           space:(NSString *) aSpace
                            area:(NSString *) aArea
                          mobile:(NSString *) aMobileNum
                      phoneNumer:(NSString *) aPhoneNumer
                    withDelegate:(id <StorePostAdDelegate>) del;



//upload image
- (void) uploadImage:(UIImage *) image WithDelegate:(id <UploadImageDelegate>) del;

-(void) GetSubCategoriesCountForCategory:(NSString*)categoryName andCity:(NSInteger)cityID andServiceType:(NSString*)serviceType WithDelegate:(id <CategoriesCountDelegate>) del;

//cache
- (BOOL) cacheDataFromArray:(NSArray *) dataArr forSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize ;

- (NSArray *) getCahedDataForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID;

- (NSUInteger) getCahedPageNumForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID;

- (NSUInteger) getCahedPageSizeForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID;

- (void) clearCachedDataForSubCategory:(NSInteger) subCatID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize;

//helpers
- (NSString *) getDateDifferenceStringFromDate:(NSDate *) input;
- (NSInteger) getIndexOfAd:(NSUInteger) adID inArray:(NSArray *) adsArray;

//categories
- (NSArray *) getCategoriesForstatus:(BOOL) forSaleStatus;//sale vs rent

- (NSArray * ) createCarAdsArrayWithData:(NSArray *) data;

- (NSArray * ) createStoreOrderArrayWithData:(NSArray *) data;


@end
