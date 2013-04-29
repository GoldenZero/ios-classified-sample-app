//
//  StoreDetailsViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "CarAd.h"

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
    IBOutlet UIImageView *storeImage;
    IBOutlet UILabel *storeTitleLabel;
    IBOutlet UILabel *storeCityLabel;
    IBOutlet UILabel *remainingFeatureAdsLabel;
    IBOutlet UILabel *remainingDaysLabel;
    
    NSArray *currentStoreAds;
    NSString *storeAdsCurrentStatus;
    BOOL loading;
    BOOL allAdsLoaded;
    NSInteger currentPage;
    
    NSInteger currentAdvID;
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
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    storeAdsCurrentStatus = StoreAdsStatusAll;
    currentStoreAds = [NSArray array];
    allAdsLoaded = NO;
    currentPage = 1;
    [menueBtn1 setImage:[UIImage imageNamed:@"MyStore_menu1_select"] forState:UIControlStateNormal];
    
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

    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getStoreAds:currentStore.identifier page:currentPage status:storeAdsCurrentStatus];
    [self showLoadingIndicator];
    loading = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)backBtnPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)menueBtnPress:(id)sender {
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
    
    currentStoreAds = [NSArray array];
    currentPage = 1;
    allAdsLoaded = NO;
    [[StoreManager sharedInstance] getStoreAds:currentStore.identifier page:currentPage status:storeAdsCurrentStatus];
    [self showLoadingIndicator];
}

#pragma mark - Private Methods

- (void) resetButtonsImages {
    [menueBtn1 setImage:[UIImage imageNamed:@"MyStore_menu1"] forState:UIControlStateNormal];
    [menueBtn2 setImage:[UIImage imageNamed:@"MyStore_menu2"] forState:UIControlStateNormal];
    [menueBtn3 setImage:[UIImage imageNamed:@"MyStore_menu3"] forState:UIControlStateNormal];
    [menueBtn4 setImage:[UIImage imageNamed:@"MyStore_menu4"] forState:UIControlStateNormal];
}

-(void) refereshRemainingFreeFreatureAdsLabel {
    remainingFeatureAdsLabel.text = [NSString stringWithFormat:@". %d إعلانات مميزة باقية",currentStore.remainingFreeFeatureAds];
}

- (void) showLoadingIndicator {
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
}

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
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
    
    CarAd *adv = currentStoreAds[indexPath.row];
    cell.advID = adv.adID;
    cell.imageURL = adv.thumbnailURL;
    cell.title = adv.title;
    cell.price = [NSString stringWithFormat:@"%f %@",adv.price,(adv.currencyString == nil)?@"":adv.currencyString];
    cell.isFeatured = adv.isFeatured;
    cell.viewCount = adv.viewCount;
    cell.distanceRange = adv.distanceRangeInKm;
    cell.modelYear = adv.modelYear;
    cell.postedSince = [[NSDate date] timeIntervalSinceDate:adv.postedOnDate]/3600;
    
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

#pragma mark - FeatureingDelegate Methods

- (void)featureAdv:(NSInteger)advID {
    if (currentStore.remainingFreeFeatureAds <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                        message:@"لقد تجاوزت عدد الإعلانات المحجوزة، بإمكانك إلغاء إعلان آخر ثم تمييز هذا الإعلان."
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (currentStore.remainingDays < 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                        message:@"عدد الأيام المتبقية لديك غير كاف، قم بتجديد اشتراكك لتستطيع تمييز هذا الإعلان."
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
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

- (void)unfeatureAdv:(NSInteger)advID {
    [advFeatureManager unfeatureAdv:advID inStore:currentStore.identifier];
    [self showLoadingIndicator];
}

#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (currentAdvID == 0) {
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
    currentStoreAds = [currentStoreAds arrayByAddingObjectsFromArray:ads];
    [tableView reloadData];
    [self hideLoadingIndicator];
    if ( ([ads count] == 0) && ([currentStoreAds count] == 0) ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لا يوجد إعلانات"
                                                        message:@"لا يوجد إعلانات في هذا المتجر!"
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
        allAdsLoaded = YES;
    }
    if ( ([ads count] == 0) && ([currentStoreAds count] != 0) ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لا يوجد إعلانات"
                                                        message:@"تم تحميل جميع االإعلانات"
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
        allAdsLoaded = YES;
    }
}

- (void) storeStatusRetrieveDidFailWithError:(NSError *)error {
    [storeStatusManager getStoreStatus:currentStore];
}

- (void) storeStatusRetrieveDidSucceedWithStatus:(Store *)store {
    currentStore = store;
    [self refereshRemainingFreeFreatureAdsLabel];
    remainingDaysLabel.text = [NSString stringWithFormat:@". %d أيام متبقية",currentStore.remainingDays];
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

@end
