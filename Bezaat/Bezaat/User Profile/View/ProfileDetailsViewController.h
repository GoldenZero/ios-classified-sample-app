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
#import "ChooseActionViewController.h"
#import "GAI.h"

@interface ProfileDetailsViewController : BaseViewController<ProfileManagerDelegate,UITableViewDataSource,UITableViewDelegate,LocationManagerDelegate>
{
    UserProfile* CurrentUser;
    MBProgressHUD2 * loadingHUD;
    
    NSInteger defaultCityID;
    NSString* defaultCityName;
     LocationManager * locationMngr;
    Country* chosenCountry;
    City * iPad_chosenCity;
    NSArray * countriesArray;
    NSArray * citiesArray;

}

@property (weak, nonatomic) IBOutlet UILabel *usrNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *usrNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *usrEmailTxt;

@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property BOOL ButtonCheck;

#pragma mark - iPad properties

@property (weak, nonatomic) IBOutlet UIView *iPad_changeNameView;
@property (weak, nonatomic) IBOutlet UIView *iPad_changePasswordView;
@property (weak, nonatomic) IBOutlet UIView *iPad_changeCountryView;

@property (weak, nonatomic) IBOutlet UITextField *iPad_userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *iPad_oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *iPad_newPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *iPad_confirmPwdTextField;

@property (weak, nonatomic) IBOutlet UITableView *iPad_countriesTable;

- (IBAction)choseCityInvoked:(id)sender;
- (IBAction)backInvoked:(id)sender;
- (IBAction)logoutInvoked:(id)sender;
- (IBAction)changePwdInvoked:(id)sender;

- (IBAction)iPad_saveNameInvoked:(id)sender;
- (IBAction)iPad_savePwdInvoked:(id)sender;

@end
