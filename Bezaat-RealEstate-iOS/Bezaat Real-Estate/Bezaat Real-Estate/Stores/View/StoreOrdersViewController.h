//
//  StoreOrdersViewController.h
//  Bezaat
//
//  Created by GALMarei on 7/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdsManager.h"
#import "GAI.h"
#import "StoreOrderCell.h"
#import "StoreManager.h"
#import "gallariesManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FeatureStoreAdViewController.h"
#import "BankTransferPaymentVC.h"


@interface StoreOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StoreManagerDelegate>
{
    UserProfile* CurrentUser;
    LocationManager * locationMngr;
    
    NSInteger defaultCityID;
    NSString* defaultCityName;
    NSString* defaultCountryName;
    Country* chosenCountry;
    NSArray * countriesArray;
    NSArray * citiesArray;
    NSString* currentStatus;
}

- (IBAction)backInvoked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *noAdsImage;
@property (weak, nonatomic) IBOutlet UITableView *adsTable;
@end
