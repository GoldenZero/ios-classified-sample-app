//
//  BrandsManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AubadaLibrary/JSONParser.h>
#import "Brand.h"
#import "SharedUser.h"
#import "DistanceRange.h"

@protocol BrandManagerDelegate <NSObject>
@required
- (void) didFinishLoadingWithData:(NSArray*) resultArray;
@end

@interface BrandsManager : NSObject

#pragma mark - properties
@property (strong, nonatomic) id <BrandManagerDelegate> delegate;

#pragma mark - methods

// get the shared instance of BarndsManager
+ (BrandsManager *) sharedInstance;

// load brands & models
- (void) getBrandsAndModelsWithDelegate:(id <BrandManagerDelegate>) del;

//load distance ranges
- (NSArray *) getDistanceRangesArray;

//load years
- (NSArray *) getYearsArray;

@end
