//
//  FeatureStoreAdViewController.h
//  Bezaat
//
//  Created by GALMarei on 4/30/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "FeaturingManager.h"
#import "StoreManager.h"

@interface FeatureStoreAdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, PricingOptionsDelegate,FeaturingOrderDelegate,StoreManagerDelegate>

#pragma mark - actions
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)laterBtnPressed:(id)sender;
- (IBAction)labelAdBtnPressed:(id)sender;
- (IBAction)explainAdBtnPrss:(id)sender;
- (IBAction)noServiceBackBtnPrss:(id)sender;
- (IBAction)bankTransferBtnPrss:(id)sender;

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic) NSInteger currentAdID;
@property (nonatomic) Store* storeID;
@property (weak, nonatomic) IBOutlet UIView *noServiceView;

@property (weak, nonatomic) IBOutlet UIButton *laterBtn;
@property (weak, nonatomic) IBOutlet UIButton *nowBtn;


@end
