//
//  distanceRangeTableViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 8/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceRange.h"

@protocol DistanceRangeChoosingDelegate <NSObject>
- (void) didChooseDistanceRangeWithObject:(DistanceRange *) obj;
@end

@interface DistanceRangeTableViewController : UITableViewController

@property (strong, nonatomic) NSArray * distanceRangeValues;
@property (strong, nonatomic) id <DistanceRangeChoosingDelegate> choosingDelegate;

@end
