//
//  UserDetailsViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreAdsCell.h"
#import "BrowseStoresViewController.h"
#import "CarAdDetailsViewController.h"
#import "CarAdsManager.h"
#import "ProfileDetailsViewController.h"
#import "AddNewCarAdViewController.h"


@interface UserDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CarAdsManagerDelegate,LocationManagerDelegate>
{
    UserProfile* CurrentUser;
    LocationManager * locationMngr;
    
    NSInteger defaultCityID;
    NSString* defaultCityName;
    NSString* defaultCountryName;
    Country* chosenCountry;
    NSArray * countriesArray;
    NSArray * citiesArray;
}

- (IBAction)backInvoked:(id)sender;
- (IBAction)filterAll:(id)sender;
- (IBAction)filterSpecial:(id)sender;
- (IBAction)filterTerminated:(id)sender;
- (IBAction)filterFavourite:(id)sender;
- (IBAction)EditInvoked:(id)sender;
- (IBAction)AddingAdsInvoked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *noAdsLbl;
@property (weak, nonatomic) IBOutlet UITableView *adsTable;
@property (weak, nonatomic) IBOutlet UIButton *filterAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *userCityTitle;
@end
