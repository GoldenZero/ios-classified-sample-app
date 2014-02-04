//
//  labelStoreAdViewController_iPad.h
//  Bezaat
//
//  Created by Noor Alssarraj on 4/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "FeaturingManager.h"
#import "StoreManager.h"
#import "Store.h"
#import "AddNewCarAdViewController.h"
#import "AddNewCarAdViewController_iPad.h"
#import "ChooseActionViewController.h"

@interface labelStoreAdViewController_iPad : UIViewController <UITableViewDataSource,UITableViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, PricingOptionsDelegate, FeaturingOrderDelegate, StoreManagerDelegate>

#pragma mark - actions
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)laterBtnPressed:(id)sender;
- (IBAction)labelAdBtnPressed:(id)sender;
- (IBAction)explainAdBtnPrss:(id)sender;
- (IBAction)noServiceBackBtnPrss:(id)sender;

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic) NSInteger currentAdID;
@property (nonatomic) NSInteger countryAdID;
@property (weak, nonatomic) IBOutlet UIButton *laterBtn;
@property (weak, nonatomic) IBOutlet UIButton *nowBtn;
@property (strong, nonatomic) IBOutlet UIView *noServiceView;
@property (strong, nonatomic) IBOutlet UIButton *bankTransBtn;
@property (strong, nonatomic) IBOutlet UIImageView *whiteRectImg;

@property (strong, nonatomic) AddNewCarAdViewController * parentNewCarVC;
@property (strong, nonatomic) AddNewCarAdViewController_iPad * iPad_parentNewCarVC;
@property (nonatomic) BOOL currentAdHasImages;
@property BOOL isReturn;
#pragma mark - iPad properties
@property (weak, nonatomic) IBOutlet SSLabel *iPad_titleLabel;
@property (weak, nonatomic) IBOutlet UIView *iPad_storeDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *iPad_storeCountOfRemainingFeaturedAds;
@property (weak, nonatomic) IBOutlet UILabel *iPad_storeCountOfRemainingDays;
@property (weak, nonatomic) IBOutlet UIView *iPad_pricingtableContainerView;

@property (strong, nonatomic) Store * iPad_currentStore;

@end
