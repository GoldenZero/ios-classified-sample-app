//
//  DistanceRange.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/9/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistanceRange : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger rangeID;
@property (strong, nonatomic) NSString * rangeName;
@property (nonatomic) NSUInteger displayOrder;

#pragma mark - methods

- (id) initWithRangeIDString:(NSString *) aRangeIDString
                   rangeName:(NSString *) aRangeName
          displayOrderString:(NSString *) aDisplayOrderString;

@end
