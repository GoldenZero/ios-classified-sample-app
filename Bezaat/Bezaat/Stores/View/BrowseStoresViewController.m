//
//  BrowseStoresViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrowseStoresViewController.h"
#import "StoreTableViewCell.h"
#import "StoreExpiredTableViewCell.h"
#import "StoreCreatedTableViewCell.h"
#import "StoreRejectedTableViewCell.h"
#import "StoreDetailsViewController.h"
#import "ChooseActionViewController.h"
#import "FeatureStoreAdViewController.h"

@interface BrowseStoresViewController () {
    NSArray *allUserStores;
    MBProgressHUD2 *loadingHUD;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UITableView *tableView;
    LocationManager * locationMngr;

    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}

@end

@implementation BrowseStoresViewController

static NSString *storeTableCellIdentifier = @"storeTableCellIdentifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loadingHUD = [[MBProgressHUD2 alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    locationMngr = [LocationManager sharedInstance];
    
   
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getUserStores];
    [self showLoadingIndicator];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.iPad_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.iPad_titleLabel setTextAlignment:SSTextAlignmentCenter];
        [self.iPad_titleLabel setTextColor:[UIColor whiteColor]];
        [self.iPad_titleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:30.0] ];
        [self.iPad_titleLabel setText:@"قائمة المتاجر"];
    }
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"My Stores screen"];
    [TestFlight passCheckpoint:@"My Stores screen"];    
    //end GA
}
-(void)didFinishLoadingWithData:(NSArray *)resultArray
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)backBtnPress:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    ChooseActionViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    else
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void) showLoadingIndicator {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        loadingHUD.dimBackground = YES;
    }
    else {
        iPad_loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
        
        iPad_loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        iPad_loadingView.clipsToBounds = YES;
        iPad_loadingView.layer.cornerRadius = 10.0;
        iPad_loadingView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        
        iPad_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        iPad_activityIndicator.frame = CGRectMake(65, 40, iPad_activityIndicator.bounds.size.width, iPad_activityIndicator.bounds.size.height);
        [iPad_loadingView addSubview:iPad_activityIndicator];
        
        iPad_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        iPad_loadingLabel.backgroundColor = [UIColor clearColor];
        iPad_loadingLabel.textColor = [UIColor whiteColor];
        iPad_loadingLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        iPad_loadingLabel.adjustsFontSizeToFitWidth = YES;
        iPad_loadingLabel.textAlignment = NSTextAlignmentCenter;
        iPad_loadingLabel.text = @"جاري تحميل البيانات";
        [iPad_loadingView addSubview:iPad_loadingLabel];
        
        [self.view addSubview:iPad_loadingView];
        [iPad_activityIndicator startAnimating];
    }
}

- (void) hideLoadingIndicator {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (loadingHUD)
            [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
        loadingHUD = nil;
    }
    else {
        if ((iPad_activityIndicator) && (iPad_loadingView)) {
            [iPad_activityIndicator stopAnimating];
            [iPad_loadingView removeFromSuperview];
        }
        iPad_activityIndicator = nil;
        iPad_loadingView = nil;
        iPad_loadingLabel = nil;
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allUserStores count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     Store *store = [allUserStores objectAtIndex:indexPath.row];
    
    if (store.status == 2) {   //approved
        StoreTableViewCell *cell = (StoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:storeTableCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:
                            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreTableViewCell" : @"StoreTableViewCell_iPad") owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.myTag = 2;
        cell.name = store.name;
        cell.country = store.countryName;
        NSString *adsCount = [NSString stringWithFormat:@"%d",store.activeAdsCount];
        if (store.activeAdsCount != 0) {
            adsCount = [adsCount stringByAppendingString:@" إعلانات"];
        }
        else {
            adsCount = [adsCount stringByAppendingString:@" إعلان"];
        }
        cell.adsCount = adsCount;
        cell.logoURL = store.imageURL;
        cell.remainingFeaturesLabel.text = [NSString stringWithFormat:@"%i إعلان متميز متبقي",store.remainingFreeFeatureAds];
        cell.remainingDaysLabel.text = [NSString stringWithFormat:@"%i أيام متبقية",store.remainingDays];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (store.status == 0)    //created
    {
        StoreCreatedTableViewCell *cell = (StoreCreatedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:storeTableCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreCreatedTableViewCell" : @"StoreCreatedTableViewCell_iPad") owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.myTag = 0;
        cell.name = store.name;
        cell.country = store.countryName;
        NSString *adsCount = [NSString stringWithFormat:@"%d",store.activeAdsCount];
        if (store.activeAdsCount != 0) {
            adsCount = [adsCount stringByAppendingString:@" إعلانات"];
        }
        else {
            adsCount = [adsCount stringByAppendingString:@" إعلان"];
        }
        cell.adsCount = adsCount;
        cell.logoURL = store.imageURL;
        cell.remainingFeaturesLabel.text = [NSString stringWithFormat:@"%i إعلان متميز متبقي",store.remainingFreeFeatureAds];
        cell.remainingDaysLabel.text = [NSString stringWithFormat:@"%i أيام متبقية",store.remainingDays];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

     }else if (store.status == 3)    //rejected
     {
     StoreRejectedTableViewCell *cell = (StoreRejectedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:storeTableCellIdentifier];
     if (cell == nil)
     {
         NSArray *nib = [[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreRejectedTableViewCell" : @"StoreRejectedTableViewCell_iPad") owner:self options:nil];
     cell = [nib objectAtIndex:0];
     }
     
         cell.myTag = 3;
     cell.name = store.name;
     cell.country = store.countryName;
     NSString *adsCount = [NSString stringWithFormat:@"%d",store.activeAdsCount];
     if (store.activeAdsCount != 0) {
     adsCount = [adsCount stringByAppendingString:@" إعلانات"];
     }
     else {
     adsCount = [adsCount stringByAppendingString:@" إعلان"];
     }
     cell.adsCount = adsCount;
     cell.logoURL = store.imageURL;
     cell.remainingFeaturesLabel.text = [NSString stringWithFormat:@"%i إعلان متميز متبقي",store.remainingFreeFeatureAds];
     cell.remainingDaysLabel.text = [NSString stringWithFormat:@"%i أيام متبقية",store.remainingDays];
     
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
     
     }else if (store.status == 5)    //deactivated
     {
     StoreExpiredTableViewCell *cell = (StoreExpiredTableViewCell *)[tableView dequeueReusableCellWithIdentifier:storeTableCellIdentifier];
     if (cell == nil)
     {
         NSArray *nib = [[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreExpiredTableViewCell" :@"StoreExpiredTableViewCell_iPad") owner:self options:nil];
     cell = [nib objectAtIndex:0];
     }
     
         cell.myTag = 5;
     cell.name = store.name;
     cell.country = store.countryName;
     NSString *adsCount = [NSString stringWithFormat:@"%d",store.activeAdsCount];
     if (store.activeAdsCount != 0) {
     adsCount = [adsCount stringByAppendingString:@" إعلانات"];
     }
     else {
     adsCount = [adsCount stringByAppendingString:@" إعلان"];
     }
     cell.adsCount = adsCount;
     cell.logoURL = store.imageURL;
     cell.remainingFeaturesLabel.text = [NSString stringWithFormat:@"%i إعلان متميز متبقي",store.remainingFreeFeatureAds];
     cell.remainingDaysLabel.text = [NSString stringWithFormat:@"%i أيام متبقية",store.remainingDays];
     
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
     
     }/*
    StoreTableViewCell *cell = (StoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:storeTableCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoreTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
   
    cell.name = store.name;
    cell.country = store.countryName;
    NSString *adsCount = [NSString stringWithFormat:@"%d",store.activeAdsCount];
    if (store.activeAdsCount != 0) {
        adsCount = [adsCount stringByAppendingString:@" إعلانات"];
    }
    else {
        adsCount = [adsCount stringByAppendingString:@" إعلان"];
    }
    cell.adsCount = adsCount;
    cell.logoURL = store.imageURL;
    cell.remainingFeaturesLabel.text = [NSString stringWithFormat:@"%i إعلان متميز متبقي",store.remainingFreeFeatureAds];
    cell.remainingDaysLabel.text = [NSString stringWithFormat:@"%i أيام متبقية",store.remainingDays];
    
    
    return cell;*/
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StoreTableViewCell *cell = (StoreTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
   /* StoreExpiredTableViewCell *cell1 = (StoreExpiredTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    StoreRejectedTableViewCell *cell2 = (StoreRejectedTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    StoreCreatedTableViewCell *cell3 = (StoreCreatedTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];*/
    
    
    if (cell.myTag == 2) {

        StoreDetailsViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc= [[StoreDetailsViewController alloc] initWithNibName:@"StoreDetailsViewController" bundle:nil];
        else
            vc= [[StoreDetailsViewController alloc] initWithNibName:@"StoreDetailsViewController_iPad" bundle:nil];
        vc.currentStore = allUserStores[indexPath.row];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self presentViewController:vc animated:YES completion:nil];

    }else if (cell.myTag == 0){
        FeatureStoreAdViewController *vc = [[FeatureStoreAdViewController alloc] initWithNibName:@"FeatureStoreAdViewController" bundle:nil];
        vc.storeID = allUserStores[indexPath.row];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (cell.myTag == 5){
        FeatureStoreAdViewController *vc = [[FeatureStoreAdViewController alloc] initWithNibName:@"FeatureStoreAdViewController" bundle:nil];
        vc.storeID = allUserStores[indexPath.row];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (cell.myTag == 3){
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}

#pragma mark - StoreManagerDelegate Methods

- (void) userStoresRetrieveDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تحميل المتاجر"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
}

- (void) userStoresRetrieveDidSucceedWithStores:(NSArray *)stores {
    allUserStores = stores;
    [tableView reloadData];
    [self hideLoadingIndicator];
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationPortrait;
    else
        return UIInterfaceOrientationLandscapeLeft;
}
@end
