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
    IBOutlet UIButton *menueBtn1;
    IBOutlet UIButton *menueBtn2;
    IBOutlet UIButton *menueBtn3;
    IBOutlet UIButton *menueBtn4;
    IBOutlet UIImageView *storeImage;
    IBOutlet UILabel *storeTitleLabel;
    IBOutlet UILabel *storeCityLabel;
    IBOutlet UILabel *storeMailLabel;
    NSArray *currentStoreAds;
    NSInteger pressedButtonIndex;
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
    storeAdsCurrentStatus = StoreAdsStatusAll;
    [menueBtn1 setImage:[UIImage imageNamed:@"MyStore_menu1_select"] forState:UIControlStateNormal];
    
    NSURL *imageURL = [NSURL URLWithString:currentStore.imageURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            storeImage.image = [UIImage imageWithData:imageData];
            [storeImage setNeedsDisplay];
        });
    });

    storeTitleLabel.text = currentStore.name;
    storeCityLabel.text = currentStore.countryName;
    storeMailLabel.text = currentStore.ownerEmail;

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
    
    
}

#pragma mark - Private Methods

- (void) resetButtonsImages {
    [menueBtn1 setImage:[UIImage imageNamed:@"MyStore_menu1"] forState:UIControlStateNormal];
    [menueBtn2 setImage:[UIImage imageNamed:@"MyStore_menu2"] forState:UIControlStateNormal];
    [menueBtn3 setImage:[UIImage imageNamed:@"MyStore_menu3"] forState:UIControlStateNormal];
    [menueBtn4 setImage:[UIImage imageNamed:@"MyStore_menu4"] forState:UIControlStateNormal];
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
