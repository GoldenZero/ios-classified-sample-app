//
//  gallariesManager.h
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryAd.h"

/*
@protocol GallariesManagerDelegate <NSObject>
@required
- (void) didFinishLoadingWithData:(NSArray*) resultArray;
@end
*/

@protocol GalleriesDelegate <NSObject>
@required

- (void) galleriesDidFailLoadingWithError:(NSError *) error;
- (void) galleriesDidFinishLoadingWithData:(NSArray*) resultArray;

@end

@protocol CarsInGalleryDelegate <NSObject>
@required

- (void) carsDidFailLoadingWithError:(NSError *) error;
- (void) carsDidFinishLoadingWithData:(NSArray*) resultArray;

@end

@interface gallariesManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <GalleriesDelegate> galleriesDel;
@property (strong, nonatomic) id <CarsInGalleryDelegate> carsDel;

@property (nonatomic) NSUInteger carsPageNumber;
@property (nonatomic) NSUInteger carsPageSize;

#pragma mark - methods

+ (gallariesManager *) sharedInstance;

- (NSUInteger) nextPage;

- (NSUInteger) getCurrentPageNum;
- (NSUInteger) getCurrentPageSize;

- (void) setCurrentPageNum:(NSUInteger) pNum;
- (void) setCurrentPageSize:(NSUInteger) pSize;
- (void) setPageSizeToDefault;


- (void) getGallariesInCountry:(NSInteger) countryID WithDelegate:(id <GalleriesDelegate>) del;

- (void) getCarAdsOfPage:(NSUInteger) pageNum forStore:(NSUInteger) storeID InCountry:(NSUInteger) countryID  WithDelegate:(id <CarsInGalleryDelegate>) del;

/*
- (NSArray*) getCarsInGalleryWithDelegateOfPage:(NSUInteger) pageNum forStore:(NSUInteger) storeID Country:(NSInteger) counttryID pageSize:(NSUInteger) pageSize WithDelegate:(id <CarsInGalleryDelegate>) del;
*/
@end
