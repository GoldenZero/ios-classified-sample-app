//
//  CarDetailsManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarDetails.h"

@protocol CarDetailsManagerDelegate <NSObject>
@required
- (void) detailsDidFailLoadingWithError:(NSError *) error;
- (void) detailsDidFinishLoadingWithData:(CarDetails *) resultObject;
@end

@interface CarDetailsManager : NSObject <DataDelegate>

#pragma mark - prperties
@property (strong, nonatomic) id <CarDetailsManagerDelegate> delegate;

#pragma mark - methods

+ (CarDetailsManager *) sharedInstance;

- (void) loadCarDetailsOfAdID:(NSUInteger) adID WithDelegate:(id <CarDetailsManagerDelegate>) del;

@end
