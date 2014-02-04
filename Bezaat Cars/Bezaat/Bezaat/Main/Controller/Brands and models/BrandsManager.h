//
//  BrandsManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"
#import "Brand.h"
#import "SharedUser.h"
#import "DistanceRange.h"

@protocol BrandManagerDelegate <NSObject>
@required
- (void) brandsDidFinishLoadingWithData:(NSArray*) resultArray;
@end

@interface BrandsManager : NSObject

#pragma mark - properties
@property (strong, nonatomic) id <BrandManagerDelegate> delegate;

#pragma mark - methods

// get the shared instance of BarndsManager
+ (BrandsManager *) sharedInstance;

// load brands & models
- (void) getBrandsAndModelsWithDelegate:(id <BrandManagerDelegate>) del;

//load brands & models for posting an ad
- (void) getBrandsAndModelsForPostAdWithDelegate:(id<BrandManagerDelegate>)del;

//load distance ranges
- (NSArray *) getDistanceRangesArray;

//load years
- (NSArray *) getYearsArray;

//get the image of a brand
- (UIImage *) loadImageOfBrand:(NSInteger) aBrandID imageState:(BOOL) inverted;

@end
