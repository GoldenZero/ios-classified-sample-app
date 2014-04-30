//
//  StoreDetailsViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "ChooseCategoryViewController.h"
#import "CarAdDetailsViewController.h"
#import "Ad.h"
#import "HomePageViewController.h"

@interface StoreDetailsViewController () {
    StoreManager *storeStatusManager;
    StoreManager *advFeatureManager;
    
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
    // Do any additional setup after loading the view from its nib.
    [toolBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    storeAdsCurrentStatus = StoreAdsStatusAll;
    currentStoreAds = [NSMutableArray array];
    allAdsLoaded = NO;
    currentPage = 1;
    [menueBtn1 setImage:[UIImage imageNamed:@"tabeOnewhite.png"] forState:UIControlStateNormal];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:currentStore.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            storeImage.image = [UIImage imageWithData:imageData];
            [storeImage setNeedsDisplay];
        });
    });
    
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
    //[TestFlight passCheckpoint:@"Manage store screen"];
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
        HomePageViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
        else
            vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addNewAdvBtnPress:(id)sender {
    ChooseCategoryViewController *vc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
    vc.tagOfCallXib = 2;
    vc.sentStore = self.currentStore;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)menueBtnPress:(id)sender {
    [self resetButtonsImages];

    if (sender == menueBtn1) {
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"tabeOnewhite.png"] forState:UIControlStateNormal];
        storeAdsCurrentStatus = StoreAdsStatusAll;
    }
    else if (sender == menueBtn3) {
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"tabeTwoWhite"] forState:UIControlStateNormal];
        storeAdsCurrentStatus = StoreAdsStatusFeaturedAds;
    }
    else if (sender == menueBtn2) {
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"tabeThreeWhite"] forState:UIControlStateNormal];
        storeAdsCurrentStatus = StoreAdsStatusActive;
    }
    else if (sender == menueBtn4) {
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"tabeFourWhite"] forState:UIControlStateNormal];
        storeAdsCurrentStatus = StoreAdsStatusInactive;
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
            if (((Ad *) currentStoreAds[i]).adID == theAdID)
            {
                [(Ad *)[currentStoreAds objectAtIndex:i] setIsFeatured:status];
            }
        }
    }
    [tableView reloadData];
}

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState {
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:currentStoreAds];
    if (index > -1)
    {
        [(Ad *)[currentStoreAds objectAtIndex:index] setIsFavorite:favState];
    }
    [tableView reloadData];
}

- (void) removeAdWithAdID:(NSUInteger) adID {
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:currentStoreAds];
    [currentStoreAds removeObjectAtIndex:index];
    [tableView reloadData];
}

#pragma mark - Private Methods

- (void) resetButtonsImages {
    [menueBtn1 setImage:[UIImage imageNamed:@"tabeOneGray"] forState:UIControlStateNormal];
    [menueBtn3 setImage:[UIImage imageNamed:@"tabeTwoGray"] forState:UIControlStateNormal];
    [menueBtn2 setImage:[UIImage imageNamed:@"tabeThreeGray"] forState:UIControlStateNormal];
    [menueBtn4 setImage:[UIImage imageNamed:@"tabeFourGray"] forState:UIControlStateNormal];
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


- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    return [currentStoreAds count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreAdvTableViewCell *cell = (StoreAdvTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:storeAdsTableCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoreAdvTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    
    Ad *adv = currentStoreAds[indexPath.row];
    cell.advID = adv.adID;
    cell.imageURL = adv.thumbnailURL;
    cell.title = adv.title;
    NSString * priceStr = [GenericMethods formatPrice:adv.price];
    if ([priceStr isEqualToString:@""])
        cell.priceLabel.text = priceStr;
    else
        cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, adv.currencyString];
    cell.postedSinceLabel.text = [[AdsManager sharedInstance] getDateDifferenceStringFromDate:adv.postedOnDate];
    cell.modelYearLabel.text = [NSString
                                 stringWithFormat:@"%@%lu",adv.rooms,(unsigned long)adv.roomsCount];
    cell.distanceRangeLabel.text = [NSString
                                    stringWithFormat:@"%@%lu",adv.rooms,(unsigned long)adv.roomsCount];
    cell.viewCount = adv.viewCount;
    cell.isFeatured = adv.isFeatured;
    cell.areaLabel.text = adv.area;
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
    CarAdDetailsViewController *vc;
    Ad *adv = currentStoreAds[indexPath.row];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
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
    for (Ad *adv in currentStoreAds) {
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
    for (Ad *adv in currentStoreAds) {
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

@end