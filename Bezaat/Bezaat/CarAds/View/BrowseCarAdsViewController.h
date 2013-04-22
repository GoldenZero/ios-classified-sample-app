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
#import "CarAdNoImageCell.h"
#import "CarAdWithStoreCell.h"
#import "CarAdWithStoreNoImageCell.h"
#import "DropDownView.h"

#import "Model.h"
#import "Brand.h"
#import "CarAdsManager.h"

@interface BrowseCarAdsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, CarAdsManagerDelegate, FavoritesDelegate,UITextFieldDelegate,DropDownViewDelegate>

#pragma mark - properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (strong, nonatomic) Model *currentModel;
@property (strong, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *adWithImageButton;
@property (strong, nonatomic) IBOutlet UIView *searchPanelView;
@property (strong, nonatomic) IBOutlet UITextField *carNameText;
@property (strong, nonatomic) IBOutlet UITextField *lowerPriceText;
@property (strong, nonatomic) IBOutlet UITextField *higherPriceText;
@property (strong, nonatomic) IBOutlet UIView *filtersView;
@property (strong, nonatomic) IBOutlet UIView *notificationView;
@property (strong, nonatomic) IBOutlet UIImageView *searchImageButton;

@property (strong, nonatomic) IBOutlet UIButton *kiloFilterBtn;
@property (strong, nonatomic) IBOutlet UIButton *priceFilterBtn;
@property (strong, nonatomic) IBOutlet UIButton *dateFilterBtn;
@property (strong, nonatomic) IBOutlet UIButton *okNotificationBtnImg;

@property (strong, nonatomic) IBOutlet UIButton *distanceButton;
@property (strong, nonatomic) IBOutlet UIButton *fromYearButton;
@property (strong, nonatomic) IBOutlet UIButton *toYearButton;
@property (strong, nonatomic) IBOutlet UILabel *distanceRangeLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromYearLabel;
@property (strong, nonatomic) IBOutlet UILabel *toYearLabel;


#pragma mark - actions
- (IBAction)homeBtnPress:(id)sender;
- (IBAction)searchBtnPress:(id)sender;
- (IBAction)modelBtnPress:(id)sender;
- (IBAction)searchInPanelBtnPrss:(id)sender;
- (IBAction)clearInPanelBtnPrss:(id)sender;
- (IBAction)adWithImageBtnPrss:(id)sender;
- (IBAction)kiloFilterBtnPrss:(id)sender;
- (IBAction)priceFilterBtnPrss:(id)sender;
- (IBAction)dateFilterBtnPrss:(id)sender;
- (IBAction)okNotificationBtnPrss:(id)sender;
- (IBAction)cancelNotificationBtnPrss:(id)sender;
- (IBAction)distanceBtnPrss:(id)sender;
- (IBAction)fromYearBtnPrss:(id)sender;
- (IBAction)toYearBtnPrss:(id)sender;

@end
