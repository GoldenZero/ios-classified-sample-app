//
//  BrowseCarAdsViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to browse all ads of cars of a certain brand.

#import <UIKit/UIKit.h>
#import "CarAdCell.h"
#import "Model.h"

@interface BrowseCarAdsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

#pragma mark - properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (strong, nonatomic) Model *currentModel;

#pragma mark - actions
- (IBAction)homeBtnPress:(id)sender;

- (IBAction)searchBtnPress:(id)sender;
- (IBAction)modelBtnPress:(id)sender;

@end
