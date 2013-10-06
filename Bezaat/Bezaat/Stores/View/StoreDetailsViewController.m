//
//  StoreDetailsViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "ModelsViewController.h"
#import "CarAdDetailsViewController.h"
#import "CarAd.h"
#import "ChooseActionViewController.h"
#import "AddNewStoreAdViewController_iPad.h"
#import "AddNewCarAdViewController_iPad.h"
#import "labelStoreAdViewController_iPad.h"
#import "ExhibitViewController.h"
#import "AddNewStoreViewController.h"

@interface StoreDetailsViewController () {
    StoreManager *storeStatusManager;
    StoreManager *advFeatureManager;
    DFPBannerView* bannerView;

    MBProgressHUD2 *loadingHUD;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *menueBtn1;
    IBOutlet UIButton *menueBtn2;
    IBOutlet UIButton *menueBtn3;
    IBOutlet UIButton *menueBtn4;
    IBOutlet UIImageView *noAdsImage;
    IBOutlet UIImageView *storeImage;
    IBOutlet UILabel *storeTitleLabel;
    IBOutlet UILabel *storeCityLabel;
    IBOutlet UILabel *remainingFeatureAdsLabel;
    IBOutlet UILabel *remainingDaysLabel;
    
    NSMutableArray *currentStoreAds;
    NSString *storeAdsCurrentStatus;
    BOOL loading;
    BOOL allAdsLoaded;
    NSInteger currentPage;
    
    NSInteger currentAdvID;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    BOOL iPad_buyCarSegmentBtnChosen;
    BOOL iPad_addCarSegmentBtnChosen;
    BOOL iPad_browseGalleriesSegmentBtnChosen;
    BOOL iPad_addStoreSegmentBtnChosen;
}

@end

@implementation StoreDetailsViewController

static NSString *storeAdsTableCellIdentifier = @"storeAdsTableCellIdentifier";

static NSString *StoreAdsStatusAll = @"all";
static NSString *StoreAdsStatusActive = @"active";
static NSString *StoreAdsStatusInactive = @"inactive";
static NSString *StoreAdsStatusFeaturedAds = @"featured-ads";

@synthesize currentStore;

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
    
    
    bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    bannerView.adUnitID = BANNER_HALFBANNER;
    bannerView.rootViewController = self;
    bannerView.delegate = self;
    [bannerView loadRequest:[GADRequest request]];
    
    bannerView.frame = CGRectMake(bannerView.frame.origin.x + 106, bannerView.frame.origin.y, bannerView.frame.size.width, bannerView.frame.size.height);
    
    iPad_buyCarSegmentBtnChosen = YES;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = NO;
    
    // Do any additional setup after loading the view from its nib.
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    storeAdsCurrentStatus = StoreAdsStatusAll;
    currentStoreAds = [NSMutableArray array];
    allAdsLoaded = NO;
    currentPage = 1;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [menueBtn1 setImage:[UIImage imageNamed:@"MyStore_menu1_select"] forState:UIControlStateNormal];
    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:currentStore.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            storeImage.image = [UIImage imageWithData:imageData];
            [storeImage setNeedsDisplay];
        });
    });
     */
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.hidden = NO;
    activityIndicator.center = CGPointMake(storeImage.frame.size.width /2, storeImage.frame.size.height/2);
    
    [storeImage addSubview:activityIndicator];
    
    NSURL *imageURL = [NSURL URLWithString:currentStore.imageURL];
    [activityIndicator startAnimating];
    [storeImage setImageWithURL:imageURL
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {  [activityIndicator stopAnimating];
                         [activityIndicator removeFromSuperview];}];

    
    
    
    advFeatureManager = [[StoreManager alloc] init];
    advFeatureManager.delegate = self;

    storeStatusManager = [[StoreManager alloc] init];
    storeStatusManager.delegate = self;
    [storeStatusManager getStoreStatus:currentStore];
    
    storeTitleLabel.text = currentStore.name;
    storeCityLabel.text = currentStore.countryName;
    
    
    noAdsImage.hidden = YES;

    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getStoreAds:currentStore.identifier page:currentPage status:storeAdsCurrentStatus];
    [self showLoadingIndicator];
    loading = YES;
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Manage store screen"];
    [TestFlight passCheckpoint:@"Manage store screen"];
    //end GA
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView reloadData];
}

#pragma mark - Actions

- (IBAction)backBtnPress:(id)sender {
    if (self.fromSubscribtion) {
        ChooseActionViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
        else
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addNewAdvBtnPress:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        ModelsViewController *vc = [[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
        vc.tagOfCallXib = 2;
        vc.sentStore = self.currentStore;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        AddNewStoreAdViewController_iPad *adNewCar=[[AddNewStoreAdViewController_iPad alloc] initWithNibName:@"AddNewStoreAdViewController_iPad" bundle:nil];
        
        adNewCar.currentStore = self.currentStore;
        [self presentViewController:adNewCar animated:YES completion:nil];
    }
}

- (IBAction)menueBtnPress:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self resetButtonsImages];
        
        if (sender == menueBtn1) {
            [((UIButton *)sender) setImage:[UIImage imageNamed:@"MyStore_menu1_select"] forState:UIControlStateNormal];
            storeAdsCurrentStatus = StoreAdsStatusAll;
        }
        else if (sender == menueBtn2) {
            [((UIButton *)sender) setImage:[UIImage imageNamed:@"MyStore_menu2_select"] forState:UIControlStateNormal];
            storeAdsCurrentStatus = StoreAdsStatusFeaturedAds;
        }
        else if (sender == menueBtn3) {
            [((UIButton *)sender) setImage:[UIImage imageNamed:@"MyStore_menu3_select"] forState:UIControlStateNormal];
            storeAdsCurrentStatus = StoreAdsStatusActive;
        }
        else if (sender == menueBtn4) {
            [((UIButton *)sender) setImage:[UIImage imageNamed:@"MyStore_menu4_select"] forState:UIControlStateNormal];
            storeAdsCurrentStatus = StoreAdsStatusInactive;
        }
    }
    else {
        
        if (sender == menueBtn1) {
            [menueBtn1 setImage:[UIImage imageNamed:@"tb_view_all_ads_on.png"] forState:UIControlStateNormal];
            [menueBtn2 setImage:[UIImage imageNamed:@"tb_special_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn3 setImage:[UIImage imageNamed:@"tb_effective_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn4 setImage:[UIImage imageNamed:@"tb_not_effective_ads_off.png"] forState:UIControlStateNormal];
            
            [self.iPad_allAdsImgV setHidden:NO];
            [self.iPad_specialAdsImgV setHidden:YES];
            [self.iPad_nonTerminatedAdsImgV setHidden:YES];
            [self.iPad_terminatedAdsImgV setHidden:YES];
            
            storeAdsCurrentStatus = StoreAdsStatusAll;
        }
        else if (sender == menueBtn2) {
            [menueBtn1 setImage:[UIImage imageNamed:@"tb_view_all_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn2 setImage:[UIImage imageNamed:@"tb_special_ads_on.png"] forState:UIControlStateNormal];
            [menueBtn3 setImage:[UIImage imageNamed:@"tb_effective_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn4 setImage:[UIImage imageNamed:@"tb_not_effective_ads_off.png"] forState:UIControlStateNormal];
            
            [self.iPad_allAdsImgV setHidden:YES];
            [self.iPad_specialAdsImgV setHidden:NO];
            [self.iPad_nonTerminatedAdsImgV setHidden:YES];
            [self.iPad_terminatedAdsImgV setHidden:YES];
            
            storeAdsCurrentStatus = StoreAdsStatusFeaturedAds;
        }
        else if (sender == menueBtn3) {
            [menueBtn1 setImage:[UIImage imageNamed:@"tb_view_all_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn2 setImage:[UIImage imageNamed:@"tb_special_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn3 setImage:[UIImage imageNamed:@"tb_effective_ads_on.png"] forState:UIControlStateNormal];
            [menueBtn4 setImage:[UIImage imageNamed:@"tb_not_effective_ads_off.png"] forState:UIControlStateNormal];
            
            [self.iPad_allAdsImgV setHidden:YES];
            [self.iPad_specialAdsImgV setHidden:YES];
            [self.iPad_nonTerminatedAdsImgV setHidden:NO];
            [self.iPad_terminatedAdsImgV setHidden:YES];
            
            storeAdsCurrentStatus = StoreAdsStatusActive;
        }
        else if (sender == menueBtn4) {
            [menueBtn1 setImage:[UIImage imageNamed:@"tb_view_all_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn2 setImage:[UIImage imageNamed:@"tb_special_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn3 setImage:[UIImage imageNamed:@"tb_effective_ads_off.png"] forState:UIControlStateNormal];
            [menueBtn4 setImage:[UIImage imageNamed:@"tb_not_effective_ads_on.png"] forState:UIControlStateNormal];
            
            [self.iPad_allAdsImgV setHidden:YES];
            [self.iPad_specialAdsImgV setHidden:YES];
            [self.iPad_nonTerminatedAdsImgV setHidden:YES];
            [self.iPad_terminatedAdsImgV setHidden:NO];
            
            storeAdsCurrentStatus = StoreAdsStatusInactive;
        }
    }
    
    currentStoreAds = [NSMutableArray array];
    currentPage = 1;
    allAdsLoaded = NO;
    [[StoreManager sharedInstance] getStoreAds:currentStore.identifier page:currentPage status:storeAdsCurrentStatus];
    [self showLoadingIndicator];
}

- (void) updateAd:(NSInteger) theAdID WithFeaturedStatus:(BOOL) status{
    if (currentStoreAds && currentStoreAds.count)
    {
        for (int i = 0; i < currentStoreAds.count; i++)
        {
            if (((CarAd *) currentStoreAds[i]).adID == theAdID)
            {
                [(CarAd *)[currentStoreAds objectAtIndex:i] setIsFeatured:status];
            }
        }
    }
    [tableView reloadData];
}

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState {
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:currentStoreAds];
    if (index > -1)
    {
        [(CarAd *)[currentStoreAds objectAtIndex:index] setIsFavorite:favState];
    }
    [tableView reloadData];
}

- (void) removeAdWithAdID:(NSUInteger) adID {
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:currentStoreAds];
    [currentStoreAds removeObjectAtIndex:index];
    [tableView reloadData];
}

#pragma mark - Private Methods

- (void) resetButtonsImages {
    [menueBtn1 setImage:[UIImage imageNamed:@"MyStore_menu1"] forState:UIControlStateNormal];
    [menueBtn2 setImage:[UIImage imageNamed:@"MyStore_menu2"] forState:UIControlStateNormal];
    [menueBtn3 setImage:[UIImage imageNamed:@"MyStore_menu3"] forState:UIControlStateNormal];
    [menueBtn4 setImage:[UIImage imageNamed:@"MyStore_menu4"] forState:UIControlStateNormal];
}

-(void) refereshRemainingFreeFreatureAdsLabel {
    remainingFeatureAdsLabel.text = [NSString stringWithFormat:@"%d إعلانات مميزة باقية",currentStore.remainingFreeFeatureAds];
}

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

- (void)loadNextPage {
    currentPage++;
    
    [[StoreManager sharedInstance] getStoreAds:currentStore.identifier page:currentPage status:storeAdsCurrentStatus];
    loading = YES;
}

#pragma mark - UITableViewDataSource Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }else
        return 85;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    if ([currentStoreAds count] != 0) {
            return [currentStoreAds count] + 1;
    }else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifierAdBanner = @"Banner_Cell";
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierAdBanner];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierAdBanner];
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bannerView];
        return cell;
        
    }
    
    StoreAdvTableViewCell *cell = (StoreAdvTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:storeAdsTableCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:
                        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreAdvTableViewCell" : @"StoreAdvTableViewCell_iPad") owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    
    CarAd *adv;
    if (indexPath.row >= 1)
        adv = currentStoreAds[indexPath.row - 1];
    else
        adv = currentStoreAds[indexPath.row];
    
    cell.advID = adv.adID;
    cell.imageURL = adv.thumbnailURL;
    
        cell.title = adv.title;
    NSString * priceStr = [GenericMethods formatPrice:adv.price];
    if ([priceStr isEqualToString:@""])
        cell.priceLabel.text = priceStr;
    else
        cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, adv.currencyString];
    
    cell.postedSinceLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:adv.postedOnDate];
    cell.modelYear = adv.modelYear;
    cell.distanceRange = adv.distance.integerValue;
    cell.viewCount = adv.viewCount;
    cell.isFeatured = adv.isFeatured;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void) tableView:(UITableView *)_tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (allAdsLoaded || loading) {
        return;
    }
    if (indexPath.row == ([_tableView numberOfRowsInSection:0] - 1)) {
        [self loadNextPage];
    }
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    //CarAdDetailsViewController *vc = [[CarAdDetailsViewController alloc] initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    CarAdDetailsViewController *vc;
    CarAd * adv;
    if (indexPath.row >= 1)
        adv = currentStoreAds[indexPath.row - 1];
    else
        adv = currentStoreAds[indexPath.row];

    if (adv.thumbnailURL) {   //ad with image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        else
            vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
    }
    else {                            //ad with no image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
        else
            vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
    }
    
    vc.currentAdID = adv.adID;
    vc.currentStore = self.currentStore;
    vc.parentStoreDetailsView = self;
    vc.storeParentVC = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - FeatureingDelegate Methods

- (void)featureAdv:(NSInteger)advID {
    currentAdvID = advID;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (currentStore.remainingFreeFeatureAds <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                            message:@"لقد تجاوزت عدد الإعلانات المحجوزة، بإمكانك إلغاء إعلان آخر ثم تمييز هذا الإعلان."
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:nil];
            alert.tag = 100;
            [alert show];
        }
        else if (currentStore.remainingDays < 3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                            message:@"عدد الأيام المتبقية لديك غير كاف، قم بتجديد اشتراكك لتستطيع تمييز هذا الإعلان."
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:nil];
            alert.tag = 100;
            [alert show];
        }
        else {
            UIActionSheet *actionSheet = nil;
            currentAdvID = advID;
            if (currentStore.remainingDays < 7) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                          delegate:self
                                                 cancelButtonTitle:@"إلغاء"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"٣ أيام", nil];
            }
            else if (currentStore.remainingDays < 28) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                          delegate:self
                                                 cancelButtonTitle:@"إلغاء"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"٣ أيام", @"اسبوع", nil];
            }
            else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                          delegate:self
                                                 cancelButtonTitle:@"إلغاء"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"٣ أيام", @"اسبوع", @"شهر", nil];
            }
            [actionSheet showInView:self.view];
        }
    }
    else { //iPad
        labelStoreAdViewController_iPad *vc=[[labelStoreAdViewController_iPad alloc] initWithNibName:@"labelStoreAdViewController_iPad" bundle:nil];
        vc.currentAdID = currentAdvID;
        vc.countryAdID = currentStore.countryID;
        vc.iPad_currentStore = currentStore;
        vc.currentAdHasImages = NO;
        int index = -1;
        for (int i =0; i < currentStoreAds.count; i++) {
            if ([(CarAd *)currentStoreAds[i] adID] == currentAdvID) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            
            if ([(CarAd *) currentStoreAds[index] thumbnailURL]) //ad with images
                vc.currentAdHasImages = YES;
        }
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        labelAdViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
        else
            vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
        vc.currentAdID = currentAdvID;
        vc.countryAdID = currentStore.countryID;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)unfeatureAdv:(NSInteger)advID {
    [advFeatureManager unfeatureAdv:advID inStore:currentStore.identifier];
    [self showLoadingIndicator];
}

#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
        return;
    }
    
    if (currentAdvID == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                        message:@"لم يتم تحديد إعلان."
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSInteger featureDays = 3;
    if ([@"٣ أيام" isEqualToString:buttonTitle]) {
        featureDays = 3;
    }
    else if ([@"اسبوع" isEqualToString:buttonTitle]) {
        featureDays = 7;
    }
    else if ([@"شهر" isEqualToString:buttonTitle]) {
        featureDays = 28;
    }
    [advFeatureManager featureAdv:currentAdvID
                          inStore:currentStore.identifier
                      featureDays:featureDays];
    [self showLoadingIndicator];
}

#pragma mark - StoreManagerDelegate Methods

- (void) storeAdsRetrieveDidFailWithError:(NSError *)error {
    loading = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تحميل المتاجر"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];

    [self hideLoadingIndicator];
}

- (void) storeAdsRetrieveDidSucceedWithAds:(NSArray *)ads {
    loading = NO;
    //currentStoreAds = [currentStoreAds arrayByAddingObjectsFromArray:ads];
    [currentStoreAds addObjectsFromArray:ads];
    [tableView reloadData];
    [self hideLoadingIndicator];
    noAdsImage.hidden = YES;
    if ( ([ads count] == 0) && ([currentStoreAds count] == 0) ) {
        noAdsImage.hidden = NO;
        allAdsLoaded = YES;
    }
    if ( ([ads count] == 0) && ([currentStoreAds count] != 0) ) {
        allAdsLoaded = YES;
    }
}

- (void) storeStatusRetrieveDidFailWithError:(NSError *)error {
    [storeStatusManager getStoreStatus:currentStore];
}

- (void) storeStatusRetrieveDidSucceedWithStatus:(Store *)store {
    currentStore = store;
    [self refereshRemainingFreeFreatureAdsLabel];
    remainingDaysLabel.text = [NSString stringWithFormat:@"%d أيام متبقية",currentStore.remainingDays];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.iPad_storeAdsCountLabel.text = [NSString stringWithFormat:@"%d إعلانات فعالة",currentStore.activeAdsCount];
    
}

- (void) featureAdvDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تمييز الإعلان"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
}

- (void) featureAdvDidSucceed {
    currentStore.remainingFreeFeatureAds--;
    for (CarAd *adv in currentStoreAds) {
        if (adv.adID == currentAdvID) {
            adv.isFeatured = YES;
        }
    }
    [tableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم تمييز الإعلان"
                                                    message:@"تم تمييز الإعلان بنجاح."
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
}

- (void) unfeatureAdvDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في إلغاء تمييز الإعلان"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
}

- (void) unfeatureAdvDidSucceed {
    currentStore.remainingFreeFeatureAds++;
    for (CarAd *adv in currentStoreAds) {
        if (adv.adID == currentAdvID) {
            adv.isFeatured = NO;
        }
    }
    [tableView reloadData];
    [self refereshRemainingFreeFreatureAdsLabel];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم إلغاء تمييز الإعلان"
                                                    message:@"تم إلغاء تمييز الإعلان بنجاح."
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
}

- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender {
    
    iPad_buyCarSegmentBtnChosen = YES;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
    
    BrowseCarAdsViewController *carAdsMenu=[[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController_iPad" bundle:nil];
    carAdsMenu.currentModel=nil;    //load all cars by default
    [self presentViewController:carAdsMenu animated:YES completion:nil];

}

- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender {
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = YES;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedProfile) {
        AddNewCarAdViewController_iPad * vc = [[AddNewCarAdViewController_iPad alloc] initWithNibName:@"AddNewCarAdViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (savedProfile.hasStores) {
        AddNewStoreAdViewController_iPad *adNewCar=[[AddNewStoreAdViewController_iPad alloc] initWithNibName:@"AddNewStoreAdViewController_iPad" bundle:nil];
        
        adNewCar.currentStore = self.currentStore;
        [self presentViewController:adNewCar animated:YES completion:nil];
    }
    else {
        AddNewCarAdViewController_iPad * vc = [[AddNewCarAdViewController_iPad alloc] initWithNibName:@"AddNewCarAdViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender {
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = YES;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
    
    ExhibitViewController *exVC;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        exVC=[[ExhibitViewController alloc] initWithNibName:@"ExhibitViewController" bundle:nil];
    else
        exVC=[[ExhibitViewController alloc] initWithNibName:@"ExhibitViewController_iPad" bundle:nil];
    //exVC.countryID=chosenCountry.countryID;
    [self presentViewController:exVC animated:YES completion:nil];
}

- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender {
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = YES;
    
    [self iPad_updateSegmentButtons];
    
    AddNewStoreViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController" bundle:nil];
    else
        vc =[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];

}

- (IBAction)iPad_addNewStoreAd:(id)sender {
    AddNewStoreAdViewController_iPad *adNewCar=[[AddNewStoreAdViewController_iPad alloc] initWithNibName:@"AddNewStoreAdViewController_iPad" bundle:nil];
    
    adNewCar.currentStore = self.currentStore;
    [self presentViewController:adNewCar animated:YES completion:nil];
}

#pragma mark - iPad helper methods
- (void) iPad_updateSegmentButtons {
    
    UIImage * iPad_buyCarSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_buy_car_btn_white.png"];
    UIImage * iPad_buyCarSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_buy_car_btn.png"];
    
    UIImage * iPad_addCarSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_sell_car_btn_white.png"];
    UIImage * iPad_addCarSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_sell_car_btn.png"];
    
    UIImage * iPad_browseGalleriesSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_list_exhibition_btn_white.png"];
    UIImage * iPad_browseGalleriesSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_list_exhibition_btn.png"];
    
    UIImage * iPad_addStoreSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_open_store_btn_white.png"];
    UIImage * iPad_addStoreSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_open_store_btn.png"];
    
    [self.iPad_buyCarSegmentBtn setBackgroundImage:(iPad_buyCarSegmentBtnChosen ? iPad_buyCarSegmentBtnSelectedImage : iPad_buyCarSegmentBtnUnselectedImage) forState:UIControlStateNormal];
    
    [self.iPad_addCarSegmentBtn setBackgroundImage:(iPad_addCarSegmentBtnChosen ?  iPad_addCarSegmentBtnSelectedImage: iPad_addCarSegmentBtnUnselectedImage) forState:UIControlStateNormal];
    
    [self.iPad_browseGalleriesSegmentBtn setBackgroundImage:(iPad_browseGalleriesSegmentBtnChosen ? iPad_browseGalleriesSegmentBtnSelectedImage :  iPad_browseGalleriesSegmentBtnUnselectedImage) forState:UIControlStateNormal];
    
    [self.iPad_addStoreSegmentBtn setBackgroundImage:(iPad_addStoreSegmentBtnChosen ? iPad_addStoreSegmentBtnSelectedImage : iPad_addStoreSegmentBtnUnselectedImage) forState:UIControlStateNormal];
}

@end
