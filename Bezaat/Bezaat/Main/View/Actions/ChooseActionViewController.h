//
//  ChooseActionViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to choose on action button:
// - buy a car
// - add a car ad
// - open up a store
// The user here may be signed in or not.


#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface ChooseActionViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,LocationManagerDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIButton *AddStoreButton;
@property (strong, nonatomic) IBOutlet UIButton *AddCarButton;
@property (strong, nonatomic) IBOutlet UIButton *BuyCarButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *content;
@property (strong, nonatomic) IBOutlet UIButton *countryBtn;
@property (strong, nonatomic) IBOutlet UIButton *exihibiButton;
@property (weak, nonatomic) IBOutlet UIButton *iPad_signInBtn;

#pragma mark - actions
- (IBAction)AddNewCarAdBtnPressed:(id)sender;
- (IBAction)BuyCarBtnPressed:(id)sender;
- (IBAction)AddNewStoreBtnPressed:(id)sender;
- (IBAction)sideMenuBtnPressed:(id)sender;
- (IBAction)countryBtnPrss:(id)sender;
- (IBAction)exhibitBtnPrss:(id)sender;
- (IBAction)iPad_signInBtnPressed:(id)sender;
- (IBAction)iPad_myAdsBtnPressed:(id)sender;
- (IBAction)iPad_storeOrdersBtnPressed:(id)sender;
- (IBAction)iPad_settingsBtnPressed:(id)sender;

- (void) iPad_userDidEndChoosingCountryFromPopOver;

@property (strong, nonatomic) UIPopoverController * countryPopOver;

@end
