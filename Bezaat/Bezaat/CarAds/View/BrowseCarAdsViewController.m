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
    bool searchWithImage;
    float lastContentOffset;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 * loadingHUD;
    NSMutableArray * carAdsArray;
    HJObjManager* asynchImgManager;   //asynchronous image loading manager
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
        searchWithImage=false;
        lastContentOffset=0;
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
    
    //init the image load manager
    asynchImgManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	asynchImgManager.fileCache = fileCache;
    
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
    
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    //ad with image
    if (carAdObject.thumbnailURL)
    {
        //store ad - with image
        if (carAdObject.storeID > 0)
            return 300;
        
        //individual ad - with image
        else
            return 270;
            
    }
    //ad with no image
    else
    {
        //store ad - no image
        if (carAdObject.storeID > 0)
            return 270; //IMPORTANT _ COME BACK HERE!!!
        //individual - no image
        else
            return 110;
    }
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
    
    //UITableViewCell * cell;
    
    CarAdCell * cell = (CarAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdCell" owner:self options:nil] objectAtIndex:0];
    
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    
    
    [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    //customize the carAdCell with actual data
    cell.carInfoLabel.text = carAdObject.title;
    cell.carPriceLabel.text = [NSString stringWithFormat:@"%f %@", carAdObject.price, carAdObject.currencyString];
    cell.adTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
    cell.yearLabel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
    cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
    cell.carMileageLabel.text = [NSString stringWithFormat:@"%i", carAdObject.distanceRangeInKm];
    
    //load image as URL
    [cell.carImage clear];
    cell.carImage.url = carAdObject.thumbnailURL;
    
    [cell.carImage showLoadingWheel];
    [asynchImgManager manage:cell.carImage];
    
    //customize favoriteButton according to carAdObject.isFavorite
    //customize carAdObject.storeName
    //load carAdObject.storeLogoURL
    
    /*
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    
    
    //ad with image
    if (carAdObject.thumbnailURL)
    {
        //store ad - with image
        if (carAdObject.storeID > 0)
        {
            cell = (CarAdWithStoreCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdWithStoreCell" owner:self options:nil] objectAtIndex:0];
            
            [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            
            
            //customize the carAdCell with actual data
            cell.carInfoLabel.text = carAdObject.title;
            cell.carPriceLabel.text = [NSString stringWithFormat:@"%f %@", carAdObject.price, carAdObject.currencyString];
            cell.adTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            cell.yearLabel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            cell.carMileageLabel.text = [NSString stringWithFormat:@"%i", carAdObject.distanceRangeInKm];
        }
        
        //individual ad - with image
        else
        {
            cell = (CarAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdCell" owner:self options:nil] objectAtIndex:0];
        }
        
    }
    //ad with no image
    else
    {
        //store ad - no image
        if (carAdObject.storeID > 0)
        {
            //IMPORTANT _ COME BACK HERE!!!
        }

        //individual - no image
        else
        {
            cell = (CarAdNoImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdNoImageCell" owner:self options:nil] objectAtIndex:0];
        }

    }
    
    
    if (carAdObject.thumbnailURL)
    {
        //load image as URL
        [cell.carImage clear];
        cell.carImage.url = carAdObject.thumbnailURL;
        
        [cell.carImage showLoadingWheel];
        [asynchImgManager manage:cell.carImage];
    }

    //customize favoriteButton according to carAdObject.isFavorite
    //customize carAdObject.storeName
    //load carAdObject.storeLogoURL
    */
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
   // Scroll up
    if (( lastContentOffset> sender.contentOffset.y)||(sender.contentOffset.y == 0))
    {
        [self showNotificationBar];
        [self showFiltersBar];
        [self showTopBar];
    }
    
    //Scroll down
    else {
       
        [self hideTopBar];
        [self hideFiltersBar];
        [self hideNotificationBar];
        
    }
    lastContentOffset=sender.contentOffset.y;
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
                         self.filtersView.frame = CGRectMake(2,self.topBarView.frame.size.height-2,self.filtersView.frame.size.width,self.filtersView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) hideFiltersBar{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.filtersView.frame = CGRectMake(2,-self.topBarView.frame.size.height,self.filtersView.frame.size.width,self.filtersView.frame.size.height);
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
    if (searchBtnFlag==false){
        searchBtnFlag=true;
    }
    else{
        searchBtnFlag=false;
    }
    if (searchBtnFlag){
        [self.searchPanelView setHidden:NO];
        [self.searchImageButton setHidden:NO];
        [self showSearchPanel];
    }
    
    else {
        [self.searchPanelView setHidden:YES];
        [self.searchImageButton setHidden:YES];
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
    [self.filtersView setHidden:NO];
    [self.searchImageButton setHidden:YES];
    [self showFiltersBar];
 //   [self showNotificationBar];
    
}

- (IBAction)clearInPanelBtnPrss:(id)sender {
}

- (IBAction)adWithImageBtnPrss:(id)sender {
    if(searchWithImage==false){
        [self.checkAdImage setAlpha:1.0];
        searchWithImage=true;
        
    }
    else{
        [self.checkAdImage setAlpha:0.2];
        searchWithImage=false;
        
    }
}

- (IBAction)kiloFilterBtnPrss:(id)sender {
    [self.kiloFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button_over.png"] forState:UIControlStateNormal];
     [self.priceFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button.png"] forState:UIControlStateNormal];
     [self.dateFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button.png"] forState:UIControlStateNormal];
}

- (IBAction)priceFilterBtnPrss:(id)sender {
    [self.priceFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button_over.png"] forState:UIControlStateNormal];
    [self.kiloFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button.png"] forState:UIControlStateNormal];
     [self.dateFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button.png"] forState:UIControlStateNormal];
}

- (IBAction)dateFilterBtnPrss:(id)sender {
    [self.dateFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button_over.png"] forState:UIControlStateNormal];
    [self.kiloFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button.png"] forState:UIControlStateNormal];
    [self.priceFilterBtn setImage:[UIImage imageNamed:@"Listing_navigation_button.png"] forState:UIControlStateNormal];
}

- (IBAction)okNotificationBtnPrss:(id)sender {
    [self.okNotificationBtnImg setAlpha:1.0];
    [self.notificationView setHidden:YES];
}

- (IBAction)cancelNotificationBtnPrss:(id)sender {
    [self.notificationView setHidden:YES];
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
