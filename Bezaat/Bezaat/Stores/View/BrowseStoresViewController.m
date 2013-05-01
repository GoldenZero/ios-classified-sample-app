//
//  BrowseStoresViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrowseStoresViewController.h"
#import "StoreTableViewCell.h"
#import "StoreDetailsViewController.h"
#import "ChooseActionViewController.h"

@interface BrowseStoresViewController () {
    NSArray *allUserStores;
    MBProgressHUD2 *loadingHUD;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UITableView *tableView;
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
    
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getUserStores];
    [self showLoadingIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)backBtnPress:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Private Methods

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

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allUserStores count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreTableViewCell *cell = (StoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:storeTableCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoreTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Store *store = [allUserStores objectAtIndex:indexPath.row];
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
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreDetailsViewController *vc = [[StoreDetailsViewController alloc] initWithNibName:@"StoreDetailsViewController" bundle:nil];
    vc.currentStore = allUserStores[indexPath.row];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
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

@end
