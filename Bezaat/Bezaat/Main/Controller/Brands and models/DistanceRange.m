//
//  DistanceRange.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/9/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "DistanceRange.h"

@implementation DistanceRange

@synthesize rangeID;
@synthesize rangeName;
@synthesize displayOrder;

#pragma mark - methods

- (id) initWithRangeIDString:(NSString *) aRangeIDString
                   rangeName:(NSString *) aRangeName
          displayOrderString:(NSString *) aDisplayOrderString {
    
    self = [super init];
    if (self) {
        
        // rangeID
        self.rangeID = aRangeIDString.integerValue;
        
        // rangeName
        self.rangeName = aRangeName;
        
        // displayOrder
        self.displayOrder = aDisplayOrderString.integerValue;
        
    }
    return self;
}

@end
