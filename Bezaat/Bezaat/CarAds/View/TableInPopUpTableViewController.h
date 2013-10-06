//
//  distanceRangeTableViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 8/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol TableInPopUpChoosingDelegate <NSObject>
- (void) didChooseTableItemWithObject:(id) obj;
@end

@interface TableInPopUpTableViewController : UITableViewController

@property (strong, nonatomic) NSArray * arrayValues;
@property (strong, nonatomic) id <TableInPopUpChoosingDelegate> choosingDelegate;

@property (nonatomic) BOOL showingDistanceRangeObjects;
@property (nonatomic) BOOL showingSingleValueObjects;
@property (nonatomic) BOOL showingStores;

@end
