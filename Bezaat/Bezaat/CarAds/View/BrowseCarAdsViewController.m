//
//  BrowseCarAdsViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 14/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrowseCarAdsViewController.h"
#import "CarAdDetailsViewController.h"
#import "ModelsViewController.h"
#import "ChooseActionViewController.h"
#import "labelAdViewController.h"

@interface BrowseCarAdsViewController (){
    bool searchBtnFlag;
    bool filtersShown;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 * loadingHUD;
    NSMutableArray * carAdsArray;
}

@end

@implementation BrowseCarAdsViewController
@synthesize tableView,currentModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        searchBtnFlag=false;
        filtersShown=false;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.searchPanelView setHidden:YES];
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.searchPanelView addGestureRecognizer:tap];
    
    [super viewDidLoad];
    [self setButtonsToToolbar];
    
    //init the array if it is still nullable
    if (!carAdsArray)
        carAdsArray = [NSMutableArray new];
    
    //load the first page of data
    [self loadPageOfAds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView handlig
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (carAdsArray)
        return carAdsArray.count;
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CarAdCell * cell = (CarAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdCell" owner:self options:nil] objectAtIndex:0];
    [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    
    //customize the carAdCell with actual data
    cell.carInfoLabel.text = carAdObject.title;
    cell.carPriceLabel.text = [NSString stringWithFormat:@"%i", carAdObject.price];
    cell.adTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
    cell.yearLabel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
    cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
    cell.carMileageLabel.text = [NSString stringWithFormat:@"%i", carAdObject.distanceRangeInKm];
    
    //customize favoriteButton according to carAdObject.isFavorite
    //customize carAdObject.storeName
    //load carAdObject.storeLogoURL
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarAdDetailsViewController *vc=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    //vc.carPhotos;
    //vc.carDetails;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == ([self.tableView numberOfRowsInSection:0] - 1))
        [self loadPageOfAds];
}

# pragma mark - hide bars while scrolling

- (void) scrollViewDidScroll:(UITableView *)sender {
    float filtersHieght=0;
    if (sender.contentOffset.y == 0){
        if(filtersShown)
        {
            [self showFiltersBar];
            filtersHieght=self.filtersView.frame.size.height;
        }
        [self showTopBar];
        [UIView animateWithDuration:.25
                         animations:^{
                             self.contentView.frame = CGRectMake(0,self.topBarView.frame.size.height+filtersHieght,self.tableView.frame.size.width,self.tableView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    
    else {
        if(filtersShown)
        {
            filtersHieght=self.filtersView.frame.size.height;
        }
        [self hideFiltersBar];
        [self hideNotificationBar];
        [self hideTopBar];
        [UIView animateWithDuration:.25
                         animations:^{
                             self.contentView.frame = CGRectMake(0,0,self.tableView.frame.size.width,self.tableView.frame.size.height+(self.topBarView.frame.size.height));
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}
# pragma mark - custom methods

- (void) addToFavoritePressed{
    // Code of add car ad to user favorite
}

- (void) distinguishButtonPressed{
    
    labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) setButtonsToToolbar{
    
    //  set the model label name
    [self.modelNameLabel setText:currentModel.modelName];
    
    //  add background to the toolbar
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Listing_navigation_bg.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
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

- (void) loadPageOfAds {
    //show loading indicator
    [self showLoadingIndicator];
    
    //load a page of data
    NSInteger page = [[CarAdsManager sharedInstance] nextPage];
    //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
    
    [[CarAdsManager sharedInstance] loadCarAdsOfPage:page forBrand:currentModel.brandID Model:currentModel.modelID InCity:[[SharedUser sharedInstance] getUserCityID] WithDelegate:self];
}


#pragma mark - keyboard handler
-(void)dismissKeyboard {
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];
}

#pragma mark - animatation

- (void) showFiltersBar{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.filtersView.frame = CGRectMake(0,self.topBarView.frame.size.height,self.filtersView.frame.size.width,self.filtersView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) hideFiltersBar{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.filtersView.frame = CGRectMake(0,-self.topBarView.frame.size.height,self.filtersView.frame.size.width,self.filtersView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) showSearchPanel{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.searchPanelView.frame = CGRectMake(0,self.topBarView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) hideSearchPanel{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.searchPanelView.frame = CGRectMake(0,-self.searchPanelView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) hideTopBar{
    [UIView animateWithDuration:.25
                     animations:^{
                         self.topBarView.frame = CGRectMake(0,-self.topBarView.frame.size.height,self.topBarView.frame.size.width,self.topBarView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) showTopBar{
    [UIView animateWithDuration:.25
                     animations:^{
                         self.topBarView.frame = CGRectMake(0,0,self.topBarView.frame.size.width,self.topBarView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) showNotificationBar{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.notificationView.frame = CGRectMake(0,self.topBarView.frame.size.height,self.notificationView.frame.size.width,self.notificationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];

    
}

- (void) hideNotificationBar{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.notificationView.frame = CGRectMake(0,-self.topBarView.frame.size.height,self.notificationView.frame.size.width,self.notificationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

#pragma mark - actions
- (IBAction)homeBtnPress:(id)sender {
    ChooseActionViewController *homeVC=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:homeVC animated:YES completion:nil];
}

- (IBAction)searchBtnPress:(id)sender {
    [self.searchPanelView setHidden:NO];
    if (searchBtnFlag==false){
        searchBtnFlag=true;
    }
    else{
        searchBtnFlag=false;
    }
    if (searchBtnFlag){
        [self showSearchPanel];
    }
    
    else {
        [self hideSearchPanel];
    }
    
}

- (IBAction)modelBtnPress:(id)sender {
    
    ModelsViewController *popover=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    [self presentViewController:popover animated:YES completion:nil];
    
}

- (IBAction)searchInPanelBtnPrss:(id)sender {
    filtersShown=true;
    [self hideSearchPanel];
    [self showFiltersBar];
    
}

- (IBAction)clearInPanelBtnPrss:(id)sender {
}

- (IBAction)adWithImageBtnPrss:(id)sender {
}

#pragma mark - CarAdsManager Delegate methods

- (void) adsDidFailLoadingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
}

- (void) adsDidFinishLoadingWithData:(NSArray *)resultArray {
    //1- hide the loading indicator
    [self hideLoadingIndicator];
    
    //2- append the newly loaded ads
    if (resultArray)
        [carAdsArray addObjectsFromArray:resultArray];
    
    //3- refresh table data
    [self.tableView reloadData];
    
    //4- cache the resultArray data
    //... (COME BACK HERE LATER) ...
    
}

@end
