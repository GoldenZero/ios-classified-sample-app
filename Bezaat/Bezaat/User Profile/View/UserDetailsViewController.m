//
//  UserDetailsViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "ModelsViewController.h"
#import "labelAdViewController.h"
#import "CarAdDetailsViewController.h"
#import "AddNewCarAdViewController_iPad.h"

@interface UserDetailsViewController (){
    
    bool searchBtnFlag;
    bool filtersShown;
    bool searchWithImage;
    float lastContentOffset;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 * loadingHUD;
    NSMutableArray * carAdsArray;
    HJObjManager* asynchImgManager;   //asynchronous image loading manager
    BOOL dataLoadedFromCache;
    BOOL isRefreshing;
    
    CarAd * myAdObject;
    float xForShiftingTinyImg;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    BOOL iPad_buyCarSegmentBtnChosen;
    BOOL iPad_addCarSegmentBtnChosen;
    BOOL iPad_browseGalleriesSegmentBtnChosen;
    BOOL iPad_addStoreSegmentBtnChosen;
}

@end

@implementation UserDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.adsTable.delegate = self;
        self.adsTable.dataSource = self;
        searchBtnFlag=false;
        filtersShown=false;
        searchWithImage=false;
        lastContentOffset=0;
        
        
        // Show notification bar
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.filterAllBtn setHighlighted:YES];
    //[self.noAdsLbl setHidden:YES];
    [self.noAdsImage setHidden:YES];
    
    //initialize the user to get info
    CurrentUser = [[UserProfile alloc]init];
    locationMngr = [LocationManager sharedInstance];
    locationMngr = [LocationManager sharedInstance];
    CurrentUser = [[ProfileManager sharedInstance] getSavedUserProfile];
    defaultCityID =  [[SharedUser sharedInstance] getUserCityID];
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    //init the array if it is still nullable
    if (!carAdsArray)
        carAdsArray = [NSMutableArray new];
    
    //init the image load manager
    asynchImgManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	asynchImgManager.fileCache = fileCache;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        iPad_buyCarSegmentBtnChosen = YES;
        iPad_addCarSegmentBtnChosen = NO;
        iPad_browseGalleriesSegmentBtnChosen = NO;
        iPad_addStoreSegmentBtnChosen = NO;
    }
    
    //hide the scrolling indicator
    [self.adsTable setShowsVerticalScrollIndicator:NO];
    //[self.tableView setScrollEnabled:NO];
    
    dataLoadedFromCache = NO;
    isRefreshing = NO;
    currentStatus = @"active";
    //load the first page of data
    [self loadFirstDataOfStatus:currentStatus andPage:1];
    
    // Do any additional setup after loading the view from its nib.
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"User my ads screen"];
    [TestFlight passCheckpoint:@"User my ads screen"];
    //end GA
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.adsTable setNeedsDisplay];
    [self.adsTable reloadData];
    self.adsTable.contentSize=CGSizeMake(320, self.adsTable.contentSize.height);
}

- (void) loadFirstDataOfStatus:(NSString*)status andPage:(NSInteger)pageNumb {
    
    //refresh table data
    [self.adsTable reloadData];
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.adsTable setContentOffset:CGPointZero animated:YES];
    dataLoadedFromCache = NO;
    [[CarAdsManager sharedInstance] setCurrentPageNum:1];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    [self loadPageOfAdsOfStatus:status andPage:pageNumb];
    
}
- (void) loadPageOfAdsOfStatus:(NSString*)status andPage:(NSInteger)pageNum {
    dataLoadedFromCache = NO;
    
    //show loading indicator
    [self showLoadingIndicator];
    NSInteger page;
    if (!pageNum) {
        //load a page of data
        page = [[CarAdsManager sharedInstance] nextPage];
    }else{
        page = pageNum;
    }
    
    //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
    
    [[CarAdsManager sharedInstance] loadUserAdsOfStatus:status forPage:page andSize:[[CarAdsManager sharedInstance] getCurrentPageSize] WithDelegate:self];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //4- cache the data
    
    //   [[CarAdsManager sharedInstance] loadUserAdsOfStatus:@"all" forPage:[[CarAdsManager sharedInstance] getCurrentPageNum] andSize:[[CarAdsManager sharedInstance] getCurrentPageSize] WithDelegate:self];
    
}

#pragma mark - LocationMGR delegate

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countriesArray = resultArray;
    for (int i =0; i <= [countriesArray count] - 1; i++) {
        chosenCountry=[countriesArray objectAtIndex:i];
        citiesArray=[chosenCountry cities];
        for (City* cit in citiesArray) {
            if (cit.cityID == defaultCityID)
            {
                defaultCityName = cit.cityName;
                defaultCountryName = chosenCountry.countryName;
                break;
                
            }
        }
    }
    
    self.userNameTitle.text = CurrentUser.userName;
    self.userCityTitle.text = [NSString stringWithFormat:@"%@, %@",defaultCountryName,defaultCityName];
    self.iPad_userEmail.text = CurrentUser.emailAddress;
    
}


#pragma mark - CarAdsManager Delegate methods

- (void) adsDidFailLoadingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
}

- (void) adsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    
    if ([resultArray count] == 0) {
        NSLog(@"%i",[self.adsTable numberOfRowsInSection:0]);
        if ([self.adsTable numberOfRowsInSection:0] == 0) {
            //[self.noAdsLbl setHidden:NO];
            [self.noAdsImage setHidden:NO];
        }
        dataLoadedFromCache = YES;
    }else{
        //[self.noAdsLbl setHidden:YES];
        [self.noAdsImage setHidden:YES];
    }
    //2- append the newly loaded ads
    if (resultArray && [resultArray count]!=0)
    {
        for (CarAd * newAd in resultArray)
        {
            NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:newAd.adID inArray:carAdsArray];
            if (index == -1)
                [carAdsArray addObject:newAd];
        }
        
    }
    
    //3- refresh table data
    [self.adsTable reloadData];
    /*
     if ([carAdsArray count] <= 10 && [carAdsArray count] != 0) {
     [self.adsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
     [self.adsTable setContentOffset:CGPointZero animated:YES];
     }
     */
    //1- hide the loading indicator
    [self hideLoadingIndicator];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)filterAll:(id)sender {
    //emptying the table and the Array
    [carAdsArray removeAllObjects];
    [self.adsTable setNeedsDisplay];
    [self.adsTable reloadData];
    
    [[CarAdsManager sharedInstance] setCurrentPageNum:1];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    
    dataLoadedFromCache = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        //show loading indicator
        //[self showLoadingIndicator];
        
        //load a page of data
        //NSInteger page = 1;
        //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
        //    [[CarAdsManager sharedInstance] loadUserAdsOfStatus:@"active" forPage:page andSize:size WithDelegate:self];
        currentStatus = @"active";
        [self loadFirstDataOfStatus:@"active" andPage:1];
    }
    else {
        //update appearance
        [self.iPad_allAdsBtn setImage:[UIImage imageNamed:@"tb_view_all_ads_on.png"] forState:UIControlStateNormal];
        [self.iPad_specialAdsBtn setImage:[UIImage imageNamed:@"tb_special_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_favoriteAdsBtn setImage:[UIImage imageNamed:@"tb_watchlist_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_terminatedAdsBtn setImage:[UIImage imageNamed:@"tb_not_effective_ads_off.png"] forState:UIControlStateNormal];
        
        [self.iPad_allAdsImgV setHidden:NO];
        [self.iPad_specialAdsImgV setHidden:YES];
        [self.iPad_favoriteAdsImgV setHidden:YES];
        [self.iPad_terminatedAdsImgV setHidden:YES];
        
        //show loading indicator
        //[self showLoadingIndicator];
        
        //load a page of data
        //NSInteger page = 1;
        //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
        //    [[CarAdsManager sharedInstance] loadUserAdsOfStatus:@"all" forPage:page andSize:size WithDelegate:self];
        currentStatus = @"all";
        [self loadFirstDataOfStatus:@"all" andPage:1];
    }
    
}

- (IBAction)filterSpecial:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.filterAllBtn setHighlighted:NO];
    }
    else {
        [self.iPad_allAdsBtn setImage:[UIImage imageNamed:@"tb_view_all_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_specialAdsBtn setImage:[UIImage imageNamed:@"tb_special_ads_on.png"] forState:UIControlStateNormal];
        [self.iPad_favoriteAdsBtn setImage:[UIImage imageNamed:@"tb_watchlist_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_terminatedAdsBtn setImage:[UIImage imageNamed:@"tb_not_effective_ads_off.png"] forState:UIControlStateNormal];
        
        [self.iPad_allAdsImgV setHidden:YES];
        [self.iPad_specialAdsImgV setHidden:NO];
        [self.iPad_favoriteAdsImgV setHidden:YES];
        [self.iPad_terminatedAdsImgV setHidden:YES];
    }
    //emptying the table and the Array
    [carAdsArray removeAllObjects];
    [self.adsTable setNeedsDisplay];
    [self.adsTable reloadData];
    
    [[CarAdsManager sharedInstance] setCurrentPageNum:1];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    
    dataLoadedFromCache = NO;
    
    //show loading indicator
    //[self showLoadingIndicator];
    
    //load a page of data
    //NSInteger page = 0;
    //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
    //[[CarAdsManager sharedInstance] loadUserAdsOfStatus:@"inactive" forPage:page andSize:size WithDelegate:self];
    currentStatus = @"featured-ads";
    [self loadFirstDataOfStatus:@"featured-ads" andPage:1];
    
    
}

- (IBAction)filterTerminated:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.filterAllBtn setHighlighted:NO];
    }
    else {
        [self.iPad_allAdsBtn setImage:[UIImage imageNamed:@"tb_view_all_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_specialAdsBtn setImage:[UIImage imageNamed:@"tb_special_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_favoriteAdsBtn setImage:[UIImage imageNamed:@"tb_watchlist_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_terminatedAdsBtn setImage:[UIImage imageNamed:@"tb_not_effective_ads_on.png"] forState:UIControlStateNormal];
        
        [self.iPad_allAdsImgV setHidden:YES];
        [self.iPad_specialAdsImgV setHidden:YES];
        [self.iPad_favoriteAdsImgV setHidden:YES];
        [self.iPad_terminatedAdsImgV setHidden:NO];
    }
    
    //emptying the table and the Array
    [carAdsArray removeAllObjects];
    [self.adsTable setNeedsDisplay];
    [self.adsTable reloadData];
    
    [[CarAdsManager sharedInstance] setCurrentPageNum:1];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    
    dataLoadedFromCache = NO;
    
    //show loading indicator
    //[self showLoadingIndicator];
    
    //load a page of data
    //NSInteger page = 1;
    //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
    //[[CarAdsManager sharedInstance] loadUserAdsOfStatus:@"featured-ads" forPage:page andSize:size WithDelegate:self];
    currentStatus = @"inactive";
    [self loadFirstDataOfStatus:@"inactive" andPage:1];
    
}


- (IBAction)filterFavourite:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.filterAllBtn setHighlighted:NO];
    }
    else {
        [self.iPad_allAdsBtn setImage:[UIImage imageNamed:@"tb_view_all_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_specialAdsBtn setImage:[UIImage imageNamed:@"tb_special_ads_off.png"] forState:UIControlStateNormal];
        [self.iPad_favoriteAdsBtn setImage:[UIImage imageNamed:@"tb_watchlist_ads_on.png"] forState:UIControlStateNormal];
        [self.iPad_terminatedAdsBtn setImage:[UIImage imageNamed:@"tb_not_effective_ads_off.png"] forState:UIControlStateNormal];
        
        [self.iPad_allAdsImgV setHidden:YES];
        [self.iPad_specialAdsImgV setHidden:YES];
        [self.iPad_favoriteAdsImgV setHidden:NO];
        [self.iPad_terminatedAdsImgV setHidden:YES];
    }
    //emptying the table and the Array
    [carAdsArray removeAllObjects];
    [self.adsTable setNeedsDisplay];
    [self.adsTable reloadData];
    
    [[CarAdsManager sharedInstance] setCurrentPageNum:1];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    
    dataLoadedFromCache = NO;
    
    //show loading indicator
    //[self showLoadingIndicator];
    
    //load a page of data
    // NSInteger page = 1;
    // NSInteger size = [[CarAdsManager sharedInstance] pageSize];
    
    //[[CarAdsManager sharedInstance] loadUserAdsOfStatus:@"favorites" forPage:page andSize:size WithDelegate:self];
    currentStatus = @"favorites";
    [self loadFirstDataOfStatus:@"favorites" andPage:1];
    
    
    
}

- (IBAction)EditInvoked:(id)sender {
    ProfileDetailsViewController* vc = [[ProfileDetailsViewController alloc]initWithNibName:@"ProfileDetailsViewController" bundle:nil];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.ButtonCheck = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)AddingAdsInvoked:(id)sender {
    
    
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=2;
    [self presentViewController:vc animated:YES completion:nil];
    /*
     AddNewCarAdViewController* vc = [[AddNewCarAdViewController alloc]initWithNibName:@"AddNewCarAdViewController" bundle:nil];
     vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     //vc.ButtonCheck = YES;
     [self presentViewController:vc animated:YES completion:nil];*/
}

- (IBAction)iPad_addNewAd:(id)sender {
    AddNewCarAdViewController_iPad * vc = [[AddNewCarAdViewController_iPad alloc] initWithNibName:@"AddNewCarAdViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)scrollToTheBottom
{
    if (self.adsTable.contentSize.height > self.adsTable.frame.size.height)
    {
        CGPoint offset = CGPointMake(0,self.adsTable.contentSize.height-self.adsTable.frame.size.height);
        [self.adsTable setContentOffset:offset animated:YES];
    }
}

#pragma mark - tableView handlig
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    
    //ad with image
    int separatorHeight = 6;//extra value for separating
    if (carAdObject.thumbnailURL)
    {
        //store ad - with image
        if (carAdObject.storeID > 0)
            return 105 + separatorHeight;
        
        //individual ad - with image
        else
            return 105 + separatorHeight;
        
    }
    //ad with no image
    else
    {
        //store ad - no image
        if (carAdObject.storeID > 0)
            return 105 + separatorHeight;
        //individual - no image
        else
            return 105 + separatorHeight;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (carAdsArray)
    {
        //[self scrollToTheBottom];
        return carAdsArray.count;
    }
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    xForShiftingTinyImg = 0;
    CarAd * carAdObject;
    if ((carAdsArray) && (carAdsArray.count)){
        carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
        myAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    }
    else
        return [UITableViewCell new];
    
    //ad with image
    if (carAdObject.thumbnailURL)
    {
        //store ad - with image
        if (carAdObject.storeID > 0)
        {
            
            StoreAdsCell * cell = (StoreAdsCell *)[[[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreAdsCell" : @"StoreAdsCell_iPad") owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            //customize the carAdCell with actual data
            cell.carTitle.text = carAdObject.title;
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPrice.text = priceStr;
            else
                cell.carPrice.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            if (carAdObject.price < 1.0) {
                cell.carPrice.text = @"";
            }
            
            cell.adTime.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            
            /*
             cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
             
             if (carAdObject.viewCount > 0)
             cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
             else
             {
             cell.adViews.text = @"";
             //[cell.countOfViewsTinyImg setHidden:YES];
             }
             
             cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
             */
            
            
            //hiding & shifting
            if (carAdObject.modelYear > 0)
                cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            else {
                xForShiftingTinyImg = cell.carModelTinyImg.frame.origin.x;
                
                cell.carModel.hidden = YES;
                cell.carModelTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.carDistance.frame;
                CGRect tempImgFrame = cell.carDistanceTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.carDistanceTinyImg setFrame:tempImgFrame];
                    [cell.carDistance setFrame:tempLabelFrame];
                }];
                
                xForShiftingTinyImg = tempLabelFrame.origin.x - 5 - cell.adViewsTinyImg.frame.size.width;
            }
            
            if (carAdObject.distanceRangeInKm != -1)
                //if (carAdObject.distanceRangeInKm != 0)
                cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            else {
                xForShiftingTinyImg = cell.carDistanceTinyImg.frame.origin.x;
                
                cell.carDistance.hidden = YES;
                cell.carDistanceTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.adViews.frame;
                CGRect tempImgFrame = cell.adViewsTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.adViewsTinyImg setFrame:tempImgFrame];
                    [cell.adViews setFrame:tempLabelFrame];
                }];
            }
            
            if (carAdObject.viewCount > 0)
                cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.adViews.text = @"";
                [cell.adViewsTinyImg setHidden:YES];
            }
            
            //load image as URL
            [cell.carImage clear];
            cell.carImage.url = carAdObject.thumbnailURL;
            
            [cell.carImage showLoadingWheel];
            [asynchImgManager manage:cell.carImage];
            [cell.carImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage.imageView setClipsToBounds:YES];
            
            cell.isFeatured = carAdObject.isFeatured;
            cell.featureButton.tag = indexPath.row;
            [cell.featureButton addTarget:self action:@selector(featureTheAd:) forControlEvents:UIControlEventTouchUpInside];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if (cell.isFeatured) {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_orange_box"]];
                    [cell.featureButton setHidden:YES];
                    
                }
                else {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_box.png"]];
                    [cell.featureButton setHidden:NO];
                    
                }
                
            }
            //check owner
            UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
            
            // Not logged in
            if(!savedProfile){
                [self.favouriteBtn setHidden:YES];
            }
            
            
            return cell;
        }
        
        //individual ad - with image
        else
        {
            StoreAdsCell * cell = (StoreAdsCell *)[[[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreAdsCell" : @"StoreAdsCell_iPad") owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            //customize the carAdCell with actual data
            
            //customize the carAdCell with actual data
            cell.carTitle.text = carAdObject.title;
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPrice.text = priceStr;
            else
                cell.carPrice.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            if (carAdObject.price < 1.0) {
                cell.carPrice.text = @"";
            }
            
            cell.adTime.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            
            /*
             cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
             
             if (carAdObject.viewCount > 0)
             cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
             else
             {
             cell.adViews.text = @"";
             //[cell.countOfViewsTinyImg setHidden:YES];
             }
             
             cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
             */
            
            //hiding & shifting
            if (carAdObject.modelYear > 0)
                cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            else {
                xForShiftingTinyImg = cell.carModelTinyImg.frame.origin.x;
                
                cell.carModel.hidden = YES;
                cell.carModelTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.carDistance.frame;
                CGRect tempImgFrame = cell.carDistanceTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.carDistanceTinyImg setFrame:tempImgFrame];
                    [cell.carDistance setFrame:tempLabelFrame];
                }];
                
                xForShiftingTinyImg = tempLabelFrame.origin.x - 5 - cell.adViewsTinyImg.frame.size.width;
            }
            
            if (carAdObject.distanceRangeInKm != -1)
                //if (carAdObject.distanceRangeInKm != 0)
                cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            else {
                xForShiftingTinyImg = cell.carDistanceTinyImg.frame.origin.x;
                
                cell.carDistance.hidden = YES;
                cell.carDistanceTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.adViews.frame;
                CGRect tempImgFrame = cell.adViewsTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.adViewsTinyImg setFrame:tempImgFrame];
                    [cell.adViews setFrame:tempLabelFrame];
                }];
            }
            
            if (carAdObject.viewCount > 0)
                cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.adViews.text = @"";
                [cell.adViewsTinyImg setHidden:YES];
            }
            
            //load image as URL
            [cell.carImage clear];
            cell.carImage.url = carAdObject.thumbnailURL;
            
            [cell.carImage showLoadingWheel];
            [asynchImgManager manage:cell.carImage];
            [cell.carImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage.imageView setClipsToBounds:YES];
            cell.isFeatured = carAdObject.isFeatured;
            if (carAdObject.isFeatured && ![currentStatus isEqualToString:@"favorites"]) {
                [cell.featureButton setHidden:NO];
            }else{
                [cell.featureButton setHidden:YES];
                
            }
            cell.featureButton.tag = indexPath.row;
            [cell.featureButton addTarget:self action:@selector(featureTheAd:) forControlEvents:UIControlEventTouchUpInside];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if (cell.isFeatured) {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_orange_box"]];
                    [cell.featureButton setHidden:YES];
                    
                }
                else {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_box.png"]];
                    [cell.featureButton setHidden:NO];
                    
                }
                
            }
            //check owner
            UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
            
            // Not logged in
            if(!savedProfile){
                [self.favouriteBtn setHidden:YES];
            }
            
            
            return cell;
        }
        
    }
    //ad with no image
    else
    {
        //store ad - no image
        if (carAdObject.storeID > 0)
        {
            StoreAdsCell * cell = (StoreAdsCell *)[[[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreAdsCell" : @"StoreAdsCell_iPad") owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            //customize the carAdCell with actual data
            
            //customize the carAdCell with actual data
            cell.carTitle.text = carAdObject.title;
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPrice.text = priceStr;
            else
                cell.carPrice.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            if (carAdObject.price < 1.0) {
                cell.carPrice.text = @"";
            }
            
            cell.adTime.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            
            /*
             cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
             
             if (carAdObject.viewCount > 0)
             cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
             else
             {
             cell.adViews.text = @"";
             //[cell.countOfViewsTinyImg setHidden:YES];
             }
             
             cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
             */
            
            //hiding & shifting
            if (carAdObject.modelYear > 0)
                cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            else {
                xForShiftingTinyImg = cell.carModelTinyImg.frame.origin.x;
                
                cell.carModel.hidden = YES;
                cell.carModelTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.carDistance.frame;
                CGRect tempImgFrame = cell.carDistanceTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.carDistanceTinyImg setFrame:tempImgFrame];
                    [cell.carDistance setFrame:tempLabelFrame];
                }];
                
                xForShiftingTinyImg = tempLabelFrame.origin.x - 5 - cell.adViewsTinyImg.frame.size.width;
            }
            
            if (carAdObject.distanceRangeInKm != -1)
                //if (carAdObject.distanceRangeInKm != 0)
                cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            else {
                xForShiftingTinyImg = cell.carDistanceTinyImg.frame.origin.x;
                
                cell.carDistance.hidden = YES;
                cell.carDistanceTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.adViews.frame;
                CGRect tempImgFrame = cell.adViewsTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.adViewsTinyImg setFrame:tempImgFrame];
                    [cell.adViews setFrame:tempLabelFrame];
                }];
            }
            
            if (carAdObject.viewCount > 0)
                cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.adViews.text = @"";
                [cell.adViewsTinyImg setHidden:YES];
            }
            
            
            //load image as URL
            [cell.carImage clear];
            [cell.carImage setImage:[UIImage imageNamed:@"default-car.jpg"]];
            [cell.carImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage.imageView setClipsToBounds:YES];
            
            cell.isFeatured = carAdObject.isFeatured;
            cell.featureButton.tag = indexPath.row;
            [cell.featureButton addTarget:self action:@selector(featureTheAd:) forControlEvents:UIControlEventTouchUpInside];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if (cell.isFeatured) {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_orange_box"]];
                    [cell.featureButton setHidden:YES];
                    
                }
                else {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_box.png"]];
                    [cell.featureButton setHidden:NO];
                    
                }
                
            }
            //check owner
            UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
            
            // Not logged in
            if(!savedProfile){
                [self.favouriteBtn setHidden:YES];
            }
            
            return cell;
            
        }
        
        //individual - no image
        else
        {
            StoreAdsCell * cell = (StoreAdsCell *)[[[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"StoreAdsCell" : @"StoreAdsCell_iPad") owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            //customize the carAdCell with actual data
            
            //customize the carAdCell with actual data
            cell.carTitle.text = carAdObject.title;
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPrice.text = priceStr;
            else
                cell.carPrice.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            if (carAdObject.price < 1.0) {
                cell.carPrice.text = @"";
            }
            
            cell.adTime.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            
            /*
             cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
             
             if (carAdObject.viewCount > 0)
             cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
             else
             {
             cell.adViews.text = @"";
             //[cell.countOfViewsTinyImg setHidden:YES];
             }
             
             cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
             */
            
            //hiding & shifting
            if (carAdObject.modelYear > 0)
                cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            else {
                xForShiftingTinyImg = cell.carModelTinyImg.frame.origin.x;
                
                cell.carModel.hidden = YES;
                cell.carModelTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.carDistance.frame;
                CGRect tempImgFrame = cell.carDistanceTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.carDistanceTinyImg setFrame:tempImgFrame];
                    [cell.carDistance setFrame:tempLabelFrame];
                }];
                
                xForShiftingTinyImg = tempLabelFrame.origin.x - 5 - cell.adViewsTinyImg.frame.size.width;
            }
            
            if (carAdObject.distanceRangeInKm != -1)
                //if (carAdObject.distanceRangeInKm != 0)
                cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            else {
                xForShiftingTinyImg = cell.carDistanceTinyImg.frame.origin.x;
                
                cell.carDistance.hidden = YES;
                cell.carDistanceTinyImg.hidden = YES;
            }
            
            if (xForShiftingTinyImg > 0) {
                CGRect tempLabelFrame = cell.adViews.frame;
                CGRect tempImgFrame = cell.adViewsTinyImg.frame;
                
                
                tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
                tempImgFrame.origin.x = xForShiftingTinyImg;
                
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [cell.adViewsTinyImg setFrame:tempImgFrame];
                    [cell.adViews setFrame:tempLabelFrame];
                }];
            }
            
            if (carAdObject.viewCount > 0)
                cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.adViews.text = @"";
                [cell.adViewsTinyImg setHidden:YES];
            }
            
            //load image as URL
            [cell.carImage clear];
            [cell.carImage setImage:[UIImage imageNamed:@"default-car.jpg"]];
            [cell.carImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage.imageView setClipsToBounds:YES];
            cell.isFeatured = carAdObject.isFeatured;
            cell.featureButton.tag = indexPath.row;
            [cell.featureButton addTarget:self action:@selector(featureTheAd:) forControlEvents:UIControlEventTouchUpInside];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if (cell.isFeatured) {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_orange_box"]];
                    [cell.featureButton setHidden:YES];
                    
                }
                else {
                    [cell.bgImageView setImage:[UIImage imageNamed:@"tb_ads_view_box.png"]];
                    [cell.featureButton setHidden:NO];
                    
                }
                
            }
            
            //check owner
            UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
            
            // Not logged in
            if(!savedProfile){
                [self.favouriteBtn setHidden:YES];
            }
            
            return cell;
            
        }
        
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    CarAdDetailsViewController * vc;
    
    if (carAdObject.thumbnailURL) {   //ad with image
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
    
    vc.currentAdID =  carAdObject.adID;
    vc.userDetailsParentVC = self;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == ([self.adsTable numberOfRowsInSection:0] - 1))
    {
        if (!dataLoadedFromCache)
            [self loadPageOfAdsOfStatus:currentStatus andPage:nil];
    }
}


-(void)featureTheAd:(id)sender
{
    UIButton* Btn = (UIButton*)sender;
    myAdObject = (CarAd *)[carAdsArray objectAtIndex:Btn.tag];
    labelAdViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
    else
        vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
    // vc.currentAdID = [[self.adsTable cellForRowAtIndexPath:0] ];
    vc.currentAdID = myAdObject.adID;
    vc.countryAdID = myAdObject.countryID;
    vc.currentAdHasImages = NO;
    if (myAdObject.thumbnailURL)
        vc.currentAdHasImages = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

/*
 #pragma mark - Table view data source
 
 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 10;
 }
 
 
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 100;
 }
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 // Return the number of sections.
 return 4;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 // Return the number of rows in the section.
 return 1;
 }
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 static NSString *DropDownCellIdentifier = @"profileCell";
 
 
 StoreAdsCell *cell = (StoreAdsCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
 
 if (cell == nil){
 NSLog(@"New Cell Made");
 
 NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StoreAdsCell" owner:nil options:nil];
 
 for(id currentObject in topLevelObjects)
 {
 if([currentObject isKindOfClass:[StoreAdsCell class]])
 {
 cell = (StoreAdsCell *)currentObject;
 break;
 }
 }
 }
 
 //[cell.carImage setImage:[UIImage imageNamed:@"setting_user.png"]];
 //cell.carTitle.text = @"إسم المستخدم";
 
 return cell;
 
 
 }
 
 #pragma mark - Table view delegate
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 BrowseStoresViewController* vc = [[BrowseStoresViewController alloc]initWithNibName:@"BrowseStoresViewController" bundle:nil];
 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 [self presentViewController:vc animated:YES completion:nil];
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 }
 */
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

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState {
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:favState];
    }
    [self.adsTable reloadData];
}

- (void) removeAdWithAdID:(NSUInteger) adID {
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    [carAdsArray removeObjectAtIndex:index];
    [self.adsTable reloadData];
}

#pragma mark - iPad actions

- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender {
    
    iPad_buyCarSegmentBtnChosen = YES;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
}

- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender {
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = YES;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
    
    AddNewCarAdViewController_iPad * vc = [[AddNewCarAdViewController_iPad alloc] initWithNibName:@"AddNewCarAdViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender {
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = YES;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
}

- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender {
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = YES;
    
    [self iPad_updateSegmentButtons];
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
