//
//  ChooseCategoryViewController.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/13/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewCarAdViewController.h"
#import "AddNewStoreAdViewController.h"

@interface ChooseCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,CategoriesCountDelegate>

#pragma mark - properties
@property (nonatomic) BOOL browsingForSale;
@property int tagOfCallXib;

@property (weak, nonatomic) IBOutlet SSLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *offeredSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *wantedSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseAllBtn;
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (strong, nonatomic) Store* sentStore;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loaderActivity;
@property (strong, nonatomic) IBOutlet UIView *requireView;

#pragma mark - actions

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)browseAllBtnPressed:(id)sender;
- (IBAction)offeredSegmentBtnPressed:(id)sender;
- (IBAction)wantedSegmentBtnPressed:(id)sender;


@end
