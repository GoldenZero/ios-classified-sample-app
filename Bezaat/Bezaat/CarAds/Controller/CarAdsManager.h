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

@protocol CarAdsManagerDelegate <NSObject>
@required
- (void) adsDidFailLoadingWithError:(NSError *) error;
- (void) adsDidFinishLoadingWithData:(NSArray*) resultArray;
@end

@interface CarAdsManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <CarAdsManagerDelegate> delegate;
@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) NSUInteger pageSize;

#pragma mark - methods

+ (CarAdsManager *) sharedInstance;

- (NSUInteger) nextPage;

- (NSUInteger) getCurrentPageNum;

- (void) setCurrentPageNum:(NSUInteger) pageNum;

- (NSUInteger) getPageSize;

- (void) loadCarAdsOfPage:(NSUInteger) pageNum forBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID WithDelegate:(id <CarAdsManagerDelegate>) del;

- (NSString *) getDateDifferenceStringFromDate:(NSDate *) input;

- (BOOL) cacheDataFromArray:(NSArray *) dataArr forBrand:(NSUInteger) brandID Model:(NSInteger) modelID InCity:(NSUInteger) cityID  tillPageNum:(NSUInteger) tillPageNum forPageSize:(NSUInteger) pSize ;
@end
