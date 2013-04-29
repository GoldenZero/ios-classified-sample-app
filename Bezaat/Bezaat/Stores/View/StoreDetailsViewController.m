//
//  StoreDetailsViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "StoreAdvTableViewCell.h"
#import "CarAd.h"

@interface StoreDetailsViewController () {
    MBProgressHUD2 *loadingHUD;
    IBOutlet UITableView *tableView;
    IBOutlet UISegmentedControl *segmentedControl;
    NSArray *currentStoreAds;
    NSString *storeAdsCurrentStatus;
}

@end

@implementation StoreDetailsViewController

static NSString *storeAdsTableCellIdentifier = @"storeAdsTableCellIdentifier";
static NSString *backTableCellIdentifier = @"backTableCellIdentifier";
static NSString *forwardTableCellIdentifier = @"forwardTableCellIdentifier";

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
    CGRect frame = segmentedControl.frame;
    frame.size.height = 35;
    segmentedControl.frame = frame;
    storeAdsCurrentStatus = StoreAdsStatusAll;
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getStoreAds:currentStore.identifier page:1 status:storeAdsCurrentStatus];
    [self showLoadingIndicator];
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

- (IBAction)segmentedControllerValueChanged:(id)sender {
    [self resetSegmentedControlImages];
    
    NSString *imageName = [NSString stringWithFormat:@"MyStore_menu%d_select",segmentedControl.selectedSegmentIndex+1];
    [segmentedControl setImage:[UIImage imageNamed:imageName] forSegmentAtIndex:segmentedControl.selectedSegmentIndex];
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            storeAdsCurrentStatus = StoreAdsStatusAll;
            break;
        case 1:
            storeAdsCurrentStatus = StoreAdsStatusFeaturedAds;
            break;
        case 2:
            storeAdsCurrentStatus = StoreAdsStatusActive;
            break;
        case 3:
            storeAdsCurrentStatus = StoreAdsStatusInactive;
            break;
            
        default:
            break;
    }
}

#pragma mark - Private Methods

- (void) resetSegmentedControlImages {
    for (int i = 0; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"MyStore_menu%d",i+1];
        [segmentedControl setImage:[UIImage imageNamed:imageName] forSegmentAtIndex:i];
    }
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

#pragma mark - UITableViewDataSource

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
    }
    
    CarAd *adv = currentStoreAds[indexPath.row];
    cell.imageURL = adv.thumbnailURL;
    cell.title = adv.title;
    cell.price = [NSString stringWithFormat:@"%f %@",adv.price,(adv.currencyString == nil)?@"":adv.currencyString];
    cell.isFeatured = adv.isFeatured;
    
    return cell;
}

#pragma mark - StoreManagerDelegate

- (void) storeAdsRetrieveDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تحميل المتاجر"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];

    [self hideLoadingIndicator];
}

- (void) storeAdsRetrieveDidSucceedWithAds:(NSArray *)ads {
    currentStoreAds = ads;
    [tableView reloadData];
    [self hideLoadingIndicator];
    if ([ads count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لا يوجد إعلانات"
                                                        message:@"لا يوجد إعلانات في هذا المتجر!"
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
