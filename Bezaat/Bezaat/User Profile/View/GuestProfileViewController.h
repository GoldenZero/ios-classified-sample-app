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


@interface GuestProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LocationManagerDelegate>
{
    MBProgressHUD2 * loadingHUD;
    
    NSInteger defaultCityID;
    NSString* defaultCityName;
    LocationManager * locationMngr;
    Country* chosenCountry;
    NSArray * countriesArray;
    NSArray * citiesArray;
}

@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property BOOL ButtonCheck;

- (IBAction)backInvoked:(id)sender;


@end
