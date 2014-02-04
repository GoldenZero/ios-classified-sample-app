//
//  HomePageViewController.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 7/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "GuestProfileViewController.h"
#import "ProfileDetailsViewController.h"
#import "SignInViewController.h"
#import "AddNewStoreViewController.h"
#import "UserDetailsViewController.h"
#import "ExhibitViewController.h"
#import "StoreOrdersViewController.h"
#import "AboutAppViewController.h"
#import "AddNewCarAdViewController_iPad.h"
#include <CommonCrypto/CommonCryptor.h>

@interface HomePageViewController : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate,LocationManagerDelegate,MFMailComposeViewControllerDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIView *content;

@property (weak, nonatomic) IBOutlet UIButton * countryBtn;

@property (weak, nonatomic) IBOutlet UIButton * browseEstateForRentBtn;
@property (weak, nonatomic) IBOutlet UIButton * browseEstateForSellBtn;

@property (weak, nonatomic) IBOutlet UIButton * rentYourEstateBtn;
@property (weak, nonatomic) IBOutlet UIButton * sellYourEstateBtn;

@property (weak, nonatomic) IBOutlet UIButton * becomeBrokerBtn;
@property (weak, nonatomic) IBOutlet UIButton * browseBrokersBtn;

@property (weak, nonatomic) IBOutlet UIButton * financeBtn;

//side menu
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet SSLabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet SSLabel * headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

//ipad
@property (weak, nonatomic) IBOutlet UIButton *iPad_signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_myAdsBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_storeOrdersBtn;
@property (strong, nonatomic) IBOutlet UIButton *iPad_manageStoreBtn;
@property (strong, nonatomic) IBOutlet UIImageView *iPad_background;

#pragma mark - actions

- (IBAction) countryBtnPressed:(id)sender;
- (IBAction) sideMenuBtnPressed:(id)sender;

- (IBAction) browseEstateForRentBtnPressed:(id)sender;
- (IBAction) browseEstateForSellBtnPressed:(id)sender;

- (IBAction) rentYourEstateBtnPressed:(id)sender;
- (IBAction) sellYourEstateBtnPressed:(id)sender;

- (IBAction) becomeBrokerBtnPressed:(id)sender;
- (IBAction) browseBrokersBtnPressed:(id)sender;

- (IBAction) financeBtnPressed:(id)sender;

//ipad
- (IBAction)iPad_signInBtnPressed:(id)sender;
- (IBAction)iPad_myAdsBtnPressed:(id)sender;
- (IBAction)iPad_storeOrdersBtnPressed:(id)sender;
- (IBAction)iPad_settingsBtnPressed:(id)sender;

- (IBAction)iPad_aboutAppBtnPressed:(id)sender;
- (IBAction)iPad_facebookBtnPressed:(id)sender;
- (IBAction)iPad_twitterBtnPressed:(id)sender;
- (IBAction)iPad_contactUsPressed:(id)sender;

- (void) iPad_userDidEndChoosingCountryFromPopOver;

@property (strong, nonatomic) UIPopoverController * countryPopOver;

@end
