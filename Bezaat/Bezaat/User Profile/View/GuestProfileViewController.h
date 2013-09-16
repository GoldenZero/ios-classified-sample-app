//
//  GuestProfileViewController.h
//  Bezaat
//
//  Created by GALMarei on 4/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryListViewController.h"
#import "ProfileCell.h"
#import "GAI.h"

@interface GuestProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LocationManagerDelegate>
{
    MBProgressHUD2 * loadingHUD;
    
    NSInteger defaultCityID;
    NSString* defaultCityName;
    LocationManager * locationMngr;
    Country* chosenCountry;
    City * iPad_chosenCity;
    NSArray * countriesArray;
    NSArray * citiesArray;
}

@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property BOOL ButtonCheck;

#pragma mark - iPad properties
@property (weak, nonatomic) IBOutlet UITableView *iPad_countriesTable;
- (IBAction)backInvoked:(id)sender;


@end
