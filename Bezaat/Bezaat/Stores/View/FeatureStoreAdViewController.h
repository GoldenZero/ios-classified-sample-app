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

@interface FeatureStoreAdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, PricingOptionsDelegate,FeaturingOrderDelegate>

#pragma mark - actions
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)laterBtnPressed:(id)sender;
- (IBAction)labelAdBtnPressed:(id)sender;
- (IBAction)explainAdBtnPrss:(id)sender;

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic) NSInteger currentAdID;
@property (nonatomic) NSInteger storeID;



@end
