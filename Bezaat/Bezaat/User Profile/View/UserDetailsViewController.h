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
#import "CarAdsManager.h"
#import "ProfileDetailsViewController.h"
#import "AddNewCarAdViewController.h"
#import "GAI.h"

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
    NSString* currentStatus;
}

- (IBAction)backInvoked:(id)sender;
- (IBAction)filterAll:(id)sender;
- (IBAction)filterSpecial:(id)sender;
- (IBAction)filterTerminated:(id)sender; //non-active ads
- (IBAction)filterFavourite:(id)sender;
- (IBAction)EditInvoked:(id)sender;
- (IBAction)AddingAdsInvoked:(id)sender;

- (IBAction)iPad_filterNonTerminated:(id)sender; //active ads
- (IBAction)iPad_addNewAd:(id)sender;

- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *noAdsImage;
@property (weak, nonatomic) IBOutlet UILabel *noAdsLbl;
@property (weak, nonatomic) IBOutlet UITableView *adsTable;
@property (weak, nonatomic) IBOutlet UIButton *filterAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *userCityTitle;

@property (weak, nonatomic) IBOutlet UILabel *iPad_userEmail;
@property (weak, nonatomic) IBOutlet UIButton *iPad_buyCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_browseGalleriesSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addStoreSegmentBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iPad_favoriteAdsImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iPad_terminatedAdsImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iPad_specialAdsImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iPad_allAdsImgV;


@property (weak, nonatomic) IBOutlet UIButton *iPad_favoriteAdsBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_terminatedAdsBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_specialAdsBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_allAdsBtn;


- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState;
- (void) removeAdWithAdID:(NSUInteger) adID;
@end
