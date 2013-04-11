//
//  CarDetalisManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarDetalis.h"

@protocol CarDetailsManagerDelegate <NSObject>
@required
- (void) detailsDidFailLoadingWithError:(NSError *) error;
- (void) detailsDidFinishLoadingWithData:(CarDetalis *) resultArray;
@end

@interface CarDetalisManager : NSObject <DataDelegate>

#pragma mark - prperties
@property (strong, nonatomic) id <CarDetailsManagerDelegate> delegate;

#pragma mark - methods

+ (CarDetalisManager *) sharedInstance;

- (void) loadCarDetailsOfAdID:(NSUInteger) adID WithDelegate:(id <CarDetailsManagerDelegate>) del;

@end
