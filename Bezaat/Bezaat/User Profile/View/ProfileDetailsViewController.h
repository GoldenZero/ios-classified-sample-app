//
//  ProfileDetailsViewController.h
//  Bezaat
//
//  Created by GALMarei on 4/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryListViewController.h"
#import "UserProfile.h"
#import "ProfileCell.h"
#import "ChangePasswordViewController.h"
#import "ChangeNameViewController.h"


@interface ProfileDetailsViewController : UIViewController<ProfileManagerDelegate,ProfileUpdateDelegate,UITableViewDataSource,UITableViewDelegate,LocationManagerDelegate>
{
    UserProfile* CurrentUser;
    MBProgressHUD2 * loadingHUD;
    
    NSInteger defaultCityID;
    NSString* defaultCityName;
     LocationManager * locationMngr;
    Country* chosenCountry;
    NSArray * countriesArray;
    NSArray * citiesArray;

}

@property (weak, nonatomic) IBOutlet UILabel *usrNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *usrNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *usrEmailTxt;

@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property BOOL ButtonCheck;

- (IBAction)choseCityInvoked:(id)sender;
- (IBAction)backInvoked:(id)sender;
- (IBAction)logoutInvoked:(id)sender;
- (IBAction)changePwdInvoked:(id)sender;

@end
