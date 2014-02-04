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

@protocol TableInPopUpChoosingYearFromDelegate <NSObject>
- (void) didChooseYearFromTableItemWithObject:(NSString*) obj;
@end

@protocol TableInPopUpChoosingYearToDelegate <NSObject>
- (void) didChooseYearToTableItemWithObject:(NSString*) obj;
@end

@interface TableInPopUpTableViewController : UITableViewController

@property (strong, nonatomic) NSArray * arrayValues;
@property (strong, nonatomic) id <TableInPopUpChoosingDelegate> choosingDelegate;
@property (strong, nonatomic) id <TableInPopUpChoosingYearFromDelegate> choosingYearFromDelegate;
@property (strong, nonatomic) id <TableInPopUpChoosingYearToDelegate> choosingYearToDelegate;

@property (nonatomic) BOOL showingPeriodRangeObjects;
@property (nonatomic) BOOL showingRoomsObjects;
@property (nonatomic) BOOL showingUnitsObjects;
@property (nonatomic) BOOL showingFromYearObjects;
@property (nonatomic) BOOL showingToYearObjects;
@property (nonatomic) BOOL showingSingleValueObjects;
@property (nonatomic) BOOL showingStores;

@end
