//
//  BrowseAdsViewController.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrowseAdsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "AdWithStoreWithImageCell.h"
#import "AdWithImageCell.h"
#import "ChooseCategoryViewController.h"
#import "CarAdDetailsViewController.h"
#import "TableInPopUpTableViewController.h"
#import "ODRefreshControl.h"
#import "LocationManager.h"

@interface BrowseAdsViewController ()
{
    bool searchBtnFlag;
    float lastContentOffset;
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tapCloseSearch;
    
    MBProgressHUD2 * loadingHUD;
    DropDownView *dropDownRoom;
    DropDownView *dropDownCurrency;
    LocationManager * locationMngr;

    NSMutableArray * adsArray;
    NSMutableArray *roomsArray;
    NSArray *currunciesArray;
    NSArray * countriesArray;
    Country* chosenCountry;

    NSMutableArray * rowHeightsArray;

    BOOL dataLoadedFromCache;
    float xForShiftingTinyImg;
    BOOL isRefreshing;

    NSString *currentMinPriceString;
    NSString *currentMaxPriceString;
    NSString *currentroomsCountString;
    NSString *currentCurrenciesCountString;
    
    // Gestures
    UISwipeGestureRecognizer *rightRecognizer;
    UISwipeGestureRecognizer *leftRecognizer;
    
    //search parameters
    BOOL searchWithImages;
    BOOL searchWithPrice;
    BOOL isSearching;
    BOOL roomsBtnPressedOnce;
    bool dropDownRoomFlag;
    bool dropDoownCurrencyFlag;
    DFPBannerView* bannerView;

    ODRefreshControl *refreshControl;

}
@end

@implementation BrowseAdsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GAI sharedInstance].defaultTracker sendView:@"Browse Ads screen"];
    
     [self.adWithPriceButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg6.png"] forState:UIControlStateNormal];
    
    locationMngr = [LocationManager sharedInstance];

    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    chosenCountry = (Country*)[countriesArray objectAtIndex:0];

    
    bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView.adUnitID = BANNER_IPHONE_LISTING;
    bannerView.rootViewController = self;
    bannerView.delegate = self;
    
    [bannerView loadRequest:[GenericMethods createRequestWithCountry:chosenCountry.countryNameEn andSection:@"Browse Ads"]];
    [self.adBannerView addSubview:bannerView];
    
    //customize category label:
    [self.categoryTitleLabel setBackgroundColor:[UIColor clearColor]];
    [self.categoryTitleLabel setTextAlignment:SSTextAlignmentCenter];
    [self.categoryTitleLabel setTextColor:[UIColor whiteColor]];
    [self.categoryTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:16.0] ];
    self.categoryTitleLabel.text = self.currentTitle;
    
    //customize title label of side menu:
    [self.searchTitleLabel setBackgroundColor:[UIColor clearColor]];
    [self.searchTitleLabel setTextAlignment:SSTextAlignmentRight];
    [self.searchTitleLabel setTextColor:[UIColor whiteColor]];
    [self.searchTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:18.0] ];
    self.searchTitleLabel.text = @"البحث";
    
    //set up the refresher
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(refreshAds:) forControlEvents:UIControlEventValueChanged];
    
    roomsBtnPressedOnce = NO;
    dropDownRoomFlag = NO;
    dropDoownCurrencyFlag = NO;
    isSearching = NO;
    [self prepareDropDown];
    
    //add gestures
    [self customizeGestures];
    
    //init ads array
    adsArray = [NSMutableArray new];
    
    //search parameters
    searchWithImages = NO;
    searchWithPrice = NO;
    
    //temporary
    //self.currentSubCategoryID = -1;
    [self loadFirstData];
}

-(void)prepareDropDown
{
    roomsArray=[[NSMutableArray alloc]init];
    [roomsArray addObject:@"1"];
    [roomsArray addObject:@"2"];
    [roomsArray addObject:@"3"];
    [roomsArray addObject:@"4"];
    [roomsArray addObject:@"5"];
    [roomsArray addObject:@"6"];
    [roomsArray addObject:@"+6"];
    
    currunciesArray= [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    NSMutableArray* temp = [NSMutableArray new];
    for (SingleValue* currDict in currunciesArray) {
        NSString* value = currDict.valueString;
        [temp addObject:value];
    }
    dropDownRoom=[[DropDownView alloc] initWithArrayData:roomsArray imageData:nil checkMarkData:-1 cellHeight:30 heightTableView:100 paddingTop:0 paddingLeft:0 paddingRight:0 refView:self.roomsNumBtn animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2 _tag:1];
	dropDownRoom.delegate = self;
    
    dropDownCurrency=[[DropDownView alloc] initWithArrayData:temp imageData:nil checkMarkData:-1 cellHeight:30 heightTableView:100 paddingTop:0 paddingLeft:0 paddingRight:0 refView:self.currencyBtn animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2 _tag:2];
	dropDownCurrency.delegate = self;
    
	[self.view addSubview:dropDownCurrency.view];
	[self.view addSubview:dropDownRoom.view];
}

-(void)dropDownCellSelected:(NSInteger)returnIndex :(NSInteger)_tag{
    switch (_tag) {
        case 1:
        {
            [self.roomsNumBtn setTitle:[NSString stringWithFormat:@"  %@  ",[roomsArray objectAtIndex:returnIndex]] forState:UIControlStateNormal];
            currentroomsCountString = [roomsArray objectAtIndex:returnIndex];
            [dropDownRoom closeAnimation];
            dropDownRoomFlag = false;
            break;
        }
        case 2:
        {
            
            currentCurrenciesCountString = [(SingleValue*)[currunciesArray objectAtIndex:returnIndex] valueString];
            [self.currencyBtn setTitle:currentCurrenciesCountString forState:UIControlStateNormal];
            [dropDownCurrency closeAnimation];
            dropDoownCurrencyFlag = false;
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - LocationMGR delegate

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countriesArray = resultArray;
    NSInteger defaultIndex;
    
    defaultIndex = [locationMngr getIndexOfCountry:[[SharedUser sharedInstance] getUserCountryID]];
    chosenCountry = [countriesArray objectAtIndex:defaultIndex];

    
}


- (void) refreshAds:(ODRefreshControl *)refreshControl {
    
    
    //NSLog(@"refresher released!");
    //1- clear cache
   /* if (currentModel)
        [[CarAdsManager sharedInstance] clearCachedDataForBrand:currentModel.brandID
                                                          Model:currentModel.modelID
                                                         InCity:[[SharedUser sharedInstance] getUserCityID]
                                                    tillPageNum:[[CarAdsManager sharedInstance] getCurrentPageNum]
                                                    forPageSize: [[CarAdsManager sharedInstance] getCurrentPageSize]];
    else
        [[CarAdsManager sharedInstance] clearCachedDataForBrand:-1
                                                          Model:-1
                                                         InCity:[[SharedUser sharedInstance] getUserCityID]
                                                    tillPageNum:[[CarAdsManager sharedInstance] getCurrentPageNum]
                                                    forPageSize: [[CarAdsManager sharedInstance] getCurrentPageSize]];*/
    
    //2- reset page identifiers
    [[AdsManager sharedInstance] setCurrentPageNum:0];
    [[AdsManager sharedInstance] setPageSizeToDefault];
    
    
    //3- reset the array
    [adsArray removeAllObjects];
    
    //4- reload
    isRefreshing = YES;
    if (isSearching)
        [self performSearchBtnPressed:nil];
    else
        [self loadPageOfAds];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
  /*  if (adsArray && adsArray.count) {
        if (!dataLoadedFromCache) {
            [[AdsManager sharedInstance]
             cacheDataFromArray:adsArray
                    forSubCategory:self.currentSubCategoryID
                    InCity:[[SharedUser sharedInstance] getUserCityID]
                    tillPageNum:[[AdsManager sharedInstance] getCurrentPageNum]
                    forPageSize: [[AdsManager sharedInstance] getCurrentPageSize]];
        }
    }*/
    [dropDownCurrency closeAnimation];
    dropDoownCurrencyFlag = false;
    [dropDownRoom closeAnimation];
    dropDownRoomFlag = false;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableView Delegate methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (adsArray && adsArray.count)
        return adsArray.count;
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (adsArray && adsArray.count) {
        Ad * adObject = [adsArray objectAtIndex:indexPath.row];
        int separatorHeight = 0;//extra value for separating
        
        if (adObject.thumbnailURL) {
            //store ad - with image
            if (adObject.storeID > 0)
                return AD_WITH_STORE_WITH_IMAGE_CELL_HEIGHT + separatorHeight;
            
            //individual ad - with image
            else
                return AD_WITH_IMAGE_CELL_HEIGHT + separatorHeight;
            
        }
        //ad with no image
        else {
            //store ad - no image
            if (adObject.storeID > 0)
                return AD_WITH_STORE_WITH_IMAGE_CELL_HEIGHT + separatorHeight;
            
            //individual - no image
            else
                return AD_WITH_IMAGE_CELL_HEIGHT + separatorHeight;
        }
        
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    xForShiftingTinyImg = 0;
    
    if (adsArray && adsArray.count) {
        
        Ad * adObject = [adsArray objectAtIndex:indexPath.row];
        
        PlainAdCell * cell ;
        
        if (adObject.thumbnailURL) {
            //store ad - with image
            if (adObject.storeID > 0) {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"AdWithStoreWithImageCell"];
                if (!cell)
                    cell = (AdWithStoreWithImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"AdWithStoreWithImageCell" owner:self options:nil] objectAtIndex:0];
                AdWithStoreWithImageCell * customCell = (AdWithStoreWithImageCell *) cell;
                
                //load image as URL
                NSString* temp = [adObject.thumbnailURL absoluteString];
                
                if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                    customCell.adImage.image = [UIImage imageNamed:@"waitForApprove.png"];
                }
                else {
                    //[customCell.adImage setImageWithURL:adObject.thumbnailURL];
                    //placeholderImage:[UIImage imageNamed:@"***.jpg"]];
                    
                    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    activityIndicator.hidesWhenStopped = YES;
                    activityIndicator.hidden = NO;
                    activityIndicator.center = CGPointMake(customCell.adImage.frame.size.width /2, customCell.adImage.frame.size.height/2);
                    
                    [customCell.adImage addSubview:activityIndicator];
                    
                    [activityIndicator startAnimating];
                    [customCell.adImage setImageWithURL:adObject.thumbnailURL
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {  [activityIndicator stopAnimating];
                                                  [activityIndicator removeFromSuperview];}];
                }
                
                [customCell.adImage setContentMode:UIViewContentModeScaleToFill];
               // [customCell.adImage setClipsToBounds:YES];
                
                //store image
                if (adObject.storeLogoURL)
                {
                    [customCell.storeImage setHidden:NO];
                    
                    [customCell.storeImage setImageWithURL:adObject.storeLogoURL];
                    [customCell.storeImage setContentMode:UIViewContentModeScaleAspectFill];
                    [customCell.storeImage setClipsToBounds:YES];
                }
                else
                    [customCell.storeImage setHidden:YES];
                
                //store name
                customCell.storeNameLabel.text = adObject.storeName;
                
                if (adObject.isFeatured) {
                    [cell.backgoundImage setImage:[UIImage imageNamed:@"OrangeBkg_withfooter_store.png"]];
                }
            }
            
            //individual ad - with image
            else {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"AdWithImageCell"];
                if (!cell)
                    cell = (AdWithImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"AdWithImageCell" owner:self options:nil] objectAtIndex:0];
                AdWithImageCell * customCell = (AdWithImageCell *) cell;
                
                //load image as URL
                NSString* temp = [adObject.thumbnailURL absoluteString];
                
                if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                    customCell.adImage.image = [UIImage imageNamed:@"waitForApprove.png"];
                }
                else {
                    //[customCell.adImage setImageWithURL:adObject.thumbnailURL];
                                  //placeholderImage:[UIImage imageNamed:@"***.jpg"]];
                    
                    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    activityIndicator.hidesWhenStopped = YES;
                    activityIndicator.hidden = NO;
                    activityIndicator.center = CGPointMake(customCell.adImage.frame.size.width /2, customCell.adImage.frame.size.height/2);
                    
                    [customCell.adImage addSubview:activityIndicator];
                    
                    [activityIndicator startAnimating];
                    [customCell.adImage setImageWithURL:adObject.thumbnailURL
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {  [activityIndicator stopAnimating];
                                         [activityIndicator removeFromSuperview];}];
                }
                
                [customCell.adImage setContentMode:UIViewContentModeScaleToFill];
                //[customCell.adImage setClipsToBounds:YES];
                
                if (adObject.isFeatured) {
                    [cell.backgoundImage setImage:[UIImage imageNamed:@"OrangeBkg_withfooter_big.png"]];
                }
                else
                {
                    [cell.backgoundImage setImage:[UIImage imageNamed:@"whiteBkg_withfooter_big"]];
                }
            }
            
        }
        //ad with no image
        else {
            //store ad - no image
            if (adObject.storeID > 0) {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"AdWithStoreWithImageCell"];
                if (!cell)
                    cell = (AdWithStoreWithImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"AdWithStoreWithImageCell" owner:self options:nil] objectAtIndex:0];
                AdWithStoreWithImageCell * customCell = (AdWithStoreWithImageCell *) cell;
                
                //load image as URL
                NSString* temp = [adObject.thumbnailURL absoluteString];
                
                if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                    customCell.adImage.image = [UIImage imageNamed:@"waitForApprove.png"];
                }
                else {
                    
                    customCell.adImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"default-Cat-%i",adObject.categoryID]];
                }
                
                if (!customCell.adImage.image) {
                    customCell.adImage.image =[UIImage imageNamed:@"default-Cat-636.png"];
                }
                
                [customCell.adImage setContentMode:UIViewContentModeScaleToFill];
                //[customCell.adImage setClipsToBounds:YES];
                
                //store image
                if (adObject.storeLogoURL)
                {
                    [customCell.storeImage setHidden:NO];
                    
                    [customCell.storeImage setImageWithURL:adObject.storeLogoURL];
                    [customCell.storeImage setContentMode:UIViewContentModeScaleToFill];
                    [customCell.storeImage setClipsToBounds:YES];
                }
                else
                    [customCell.storeImage setHidden:YES];
                
                //store name
                customCell.storeNameLabel.text = adObject.storeName;
                
                if (adObject.isFeatured) {
                    [cell.backgoundImage setImage:[UIImage imageNamed:@"OrangeBkg_withfooter_store.png"]];
                }
            }
            
            //individual - no image
            else {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"AdWithImageCell"];
                if (!cell)
                    cell = (AdWithImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"AdWithImageCell" owner:self options:nil] objectAtIndex:0];
                AdWithImageCell * customCell = (AdWithImageCell *) cell;
                
                //load image as URL
                NSString* temp = [adObject.thumbnailURL absoluteString];
                
                if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                    customCell.adImage.image = [UIImage imageNamed:@"waitForApprove.png"];
                }
                else {
                    customCell.adImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"default-Cat-%i",adObject.categoryID]];
                }
                
                if (!customCell.adImage.image) {
                    customCell.adImage.image =[UIImage imageNamed:@"default-Cat-636.png"];
                }
                
                [customCell.adImage setContentMode:UIViewContentModeScaleToFill];
                //[customCell.adImage setClipsToBounds:YES];
            }
            if (adObject.isFeatured) {
                [cell.backgoundImage setImage:[UIImage imageNamed:@"OrangeBkg_withfooter_big.png"]];
            }
            
        }
        
        //customizing shared data of the cell:
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.favoriteBtn addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.labelBtn addTarget:self action:@selector(labelButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.detailsLabel.text = adObject.title;
        cell.detailLabel.text = adObject.title;
        NSArray* arraysofCountry  = [[LocationManager sharedInstance] getTotalCountries];
        int indexCountry = [[LocationManager sharedInstance] getIndexOfCountry:adObject.countryID];
        Country* areaCountry = [arraysofCountry objectAtIndex:indexCountry];
        
        
        cell.locationLabel.text = [NSString stringWithFormat:@"%@,%@",areaCountry.countryName,adObject.area];
        
        NSString * priceStr = [GenericMethods formatPrice:adObject.price];
        if ([priceStr isEqualToString:@""])
            cell.priceLabel.text = priceStr;
        else
            cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, adObject.currencyString];
        cell.timeLabel.text = [[AdsManager sharedInstance] getDateDifferenceStringFromDate:adObject.postedOnDate];
        
        
        //hiding & shifting
        if ([adObject.rooms integerValue] > 0)
            cell.roomsLabel.text = [NSString stringWithFormat:@"(%@) غرف", adObject.rooms];
        else {
            xForShiftingTinyImg = cell.roomsTinyImg.frame.origin.x;
            
            cell.roomsLabel.hidden = YES;
            cell.roomsTinyImg.hidden = YES;
        }
        
        if (xForShiftingTinyImg > 0) {
            CGRect tempLabelFrame = cell.areaLabel.frame;
            CGRect tempImgFrame = cell.areaTinyImg.frame;
            
            
            tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
            tempImgFrame.origin.x = xForShiftingTinyImg;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                [cell.areaTinyImg setFrame:tempImgFrame];
                [cell.areaLabel setFrame:tempLabelFrame];
            }];
            
            xForShiftingTinyImg = tempLabelFrame.origin.x - 5 - cell.viewCountTinyImg.frame.size.width;
        }
        
        if (adObject.area.integerValue != -1)
            //if (carAdObject.distanceRangeInKm != 0)
            cell.areaLabel.text = [NSString stringWithFormat:@"%@ قدم مربع", adObject.area];
        else {
            xForShiftingTinyImg = cell.areaTinyImg.frame.origin.x;
            
            cell.areaLabel.hidden = YES;
            cell.areaTinyImg.hidden = YES;
        }
        
        if (xForShiftingTinyImg > 0) {
            CGRect tempLabelFrame = cell.viewCountLabel.frame;
            CGRect tempImgFrame = cell.viewCountTinyImg.frame;
            
            
            tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
            tempImgFrame.origin.x = xForShiftingTinyImg;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                [cell.viewCountTinyImg setFrame:tempImgFrame];
                [cell.viewCountLabel setFrame:tempLabelFrame];
            }];
        }
        
        if (adObject.viewCount > 0) {
            cell.viewCountLabel.text = [NSString stringWithFormat:@"%i", adObject.viewCount];
            [cell.viewCountTinyImg setHidden:NO];
        }
        else
        {
            cell.viewCountLabel.text = @"";
            [cell.viewCountTinyImg setHidden:YES];
        }
        
        //
        
        //check featured
        if (adObject.isFeatured)
        {
            
            [cell.backgoundImage setImage:[UIImage imageNamed:@"OrangeBkg_withfooter_big.png"]];
            [cell.labelBtn setHidden:YES];
            [cell.priceLabel setTextColor:[UIColor orangeColor]];
            [cell.favoriteBtn setHidden:NO];
            [cell.separatorLine setHidden:NO];

        }else
        {
            [cell.backgoundImage setImage:[UIImage imageNamed:@"whiteBkg_withfooter_big.png"]];
            [cell.priceLabel setTextColor:[UIColor blackColor]];

        }
        
        //check owner
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        // Not logged in
        if(!savedProfile){
            [cell.favoriteBtn setHidden:YES];
            [cell.labelBtn setHidden:YES];
        }
        
        if (savedProfile)   //logged in
        {
            [cell.favoriteBtn setHidden:NO];
            
            if (savedProfile.userID == adObject.ownerID) //is owner
                [cell.labelBtn setHidden:NO];
            else {
                if (adObject.isFeatured) 
                    [cell.labelBtn setHidden:YES];
            }
            //check favorite
            if (adObject.isFavorite)
            {
                [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_bluelike_icon.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon.png"] forState:UIControlStateNormal];
            }
        }
        
        return cell;
    }
    return [UITableViewCell new];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index row :%i /table row :%i",indexPath.row,[self.tableView numberOfRowsInSection:0] - 1);
    if ((indexPath.row == ([self.tableView numberOfRowsInSection:0] - 1)))
    {
        if (adsArray && adsArray.count)
        {
            CGFloat heightDiff = self.tableView.contentSize.height - self.tableView.frame.size.height;
            //Ad * carAdObject = (Ad *)[adsArray objectAtIndex:indexPath.row];
            
            CGFloat minDiff;
            //ad with image
            int separatorHeight = 5;//extra value for separating
                //store ad - with image
                minDiff = 270 + separatorHeight;
            if (heightDiff > minDiff)//to prevent continue loading if the page has returned less than 10 objects
            {
                if (isSearching) {
                    [self performSearchBtnPressed:nil];
                }
                else {
                    [self loadPageOfAds];
                }
            }
        }
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Ad * AdObject = (Ad *)[adsArray objectAtIndex:indexPath.row];
    CarAdDetailsViewController * vc;
    
    if (AdObject.thumbnailURL) {   //ad with image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    }
    else {                            //ad with no image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
    }
    
    vc.currentAdID =  AdObject.adID;
    vc.parentVC = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - helper methods

- (void) loadFirstData {
    
    NSArray * cachedArray;
    isSearching = NO;
    
    
    cachedArray = [[AdsManager sharedInstance] getCahedDataForSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID]];
    
    if (cachedArray && cachedArray.count)
    {

        NSInteger cachedPageNum = [[AdsManager sharedInstance] getCahedPageNumForSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID]];
        
        NSInteger cachedPageSize = [[AdsManager sharedInstance] getCahedPageSizeForSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID]];
        
        [[AdsManager sharedInstance] setCurrentPageNum:cachedPageNum];
        [[AdsManager sharedInstance] setCurrentPageSize:cachedPageSize];
        [adsArray addObjectsFromArray:cachedArray];
        [self performSearchBtnPressed:nil];

            [self.tableView reloadData];
            //self.tableView.contentSize=CGSizeMake(320, self.tableView.contentSize.height);
            [self.tableView setContentOffset:CGPointZero animated:YES];
        

        
         dataLoadedFromCache = YES;
    }
    else {
        dataLoadedFromCache = NO;
        [[AdsManager sharedInstance] setPageNumber:0];
        [[AdsManager sharedInstance] setPageSizeToDefault];
        
        [self loadPageOfAds];
    }

}

- (void) loadPageOfAds {
    
    dataLoadedFromCache = NO;
   

    [self showLoadingIndicator];
    NSString* purpose;
    if (self.browsingForSale)
        purpose = @"sale";
    else
        purpose = @"rent";
    
    int page = [[AdsManager sharedInstance] nextPage];
    [[AdsManager sharedInstance] loadAdsOfPage:page forSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID] andPurpose:purpose WithDelegate:self];
}


- (void) showLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        // Add
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        
        loadingHUD.dimBackground = YES;
    }

}

- (void) hideLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (loadingHUD) {
            [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
        }
        loadingHUD = nil;
    }
    
}


- (void) showMenu {
    
    //slide the content view to the right to reveal the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         
                         [self.contentView setFrame:CGRectMake(-self.menuView.frame.size.width, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
                     }
     ];
    
}

- (void) hideMenu {
    
    //slide the content view to the left to hide the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         
                         [self.contentView setFrame:CGRectMake(0, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
                     }
     ];
}

- (void) customizeGestures {
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftRecognizer];
    
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightRecognizer];
    
}

- (void) handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    if(self.contentView.frame.origin.x == 0)
        [self showMenu];
}

- (void) handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(self.contentView.frame.origin.x != 0)
        [self hideMenu];
    
}

#pragma mark - BrowseAds Delegate methods

- (void) adsDidFailLoadingWithError:(NSError *)error {
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [self hideLoadingIndicator];
    if (isRefreshing)
    {
        isRefreshing = NO;
        [refreshControl endRefreshing];
    }
    [self.nocarImg setHidden:NO];
    [self.tableView setHidden:YES];


}

- (void) adsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    loadingHUD = nil;
    
    if (resultArray && resultArray.count) {
        [self.nocarImg setHidden:YES];
        [self.tableView setHidden:NO];
        if (resultArray.count == 0) {
            [GenericMethods throwAlertWithTitle:@"" message:@"لا يوجد نتائج" delegateVC:self];
        }else
        {
        [adsArray addObjectsFromArray:resultArray];
        NSMutableArray * URLsToPrefetch = [NSMutableArray new];
        for (Ad * newAd in resultArray)
        {
            NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:newAd.adID inArray:adsArray];
            if (index == -1)
                [adsArray addObject:newAd];
            
            if (newAd.thumbnailURL)
                [URLsToPrefetch addObject:[NSURL URLWithString:newAd.thumbnailURL.absoluteString]];
        }
        
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:URLsToPrefetch];
        [self.tableView reloadData];
        }
    }
    else
    {
        if ((!adsArray) || (adsArray.count == 0))
        {
            [self.nocarImg setHidden:NO];
            [self.tableView setHidden:YES];
           
            [self hideLoadingIndicator];
        }
    }
    if (isRefreshing)
    {
        isRefreshing = NO;
        [refreshControl endRefreshing];
    }

    
}



#pragma mark - favorites Delegate methods
- (void) FavoriteFailAddingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [adsArray objectAtIndex:index];
            if (carAdObject.thumbnailURL)
            {
                //store ad - with image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
                //individual ad - with image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
            }
            //ad with no image
            else
            {
                //store ad - no image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
                //individual - no image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
            }
        
    }
}

- (void) FavoriteDidAddWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [adsArray objectAtIndex:index];
            if (carAdObject.thumbnailURL)
            {
                
                //store ad - with image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//added successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                }
                //individual ad - with image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//added successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                }
            }
            //ad with no image
            else
            {
                //store ad - no image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//added successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                }
                //individual - no image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//added successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                }
            }
        
    }
}

- (void) FavoriteFailRemovingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [adsArray objectAtIndex:index];
            if (carAdObject.thumbnailURL)
            {
                //store ad - with image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
                //individual ad - with image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
            }
            //ad with no image
            else
            {
                //store ad - no image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
                //individual - no image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured)
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                    
                    
                }
            }
        
    }
    
}

- (void) FavoriteDidRemoveWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [adsArray objectAtIndex:index];
            if (carAdObject.thumbnailURL)
            {
                //store ad - with image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//removed successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
                //individual ad - with image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//removed successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
            }
            //ad with no image
            else
            {
                //store ad - no image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//removed successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
                //individual - no image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (resultStatus)//removed successfully
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:NO];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_like_icon"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:YES];
                        if (carAdObject.isFeatured)
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        else
                            [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
            }
        }
    
}


#pragma mark - actions

- (IBAction)homeBtnPressed:(id)sender {
    HomePageViewController *vc;
    vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)searchBtnPressed:(id)sender {
    [dropDownRoom closeAnimation];
    dropDownRoomFlag = false;
    [dropDownCurrency closeAnimation];
    dropDoownCurrencyFlag = false;
    //show the search side menu
    if(self.contentView.frame.origin.x == 0) //only show the menu if it is not already shown
        [self showMenu];
    else
        [self hideMenu];
    
}

- (IBAction)chooseCategoryBtnPressed:(id)sender {
    
    ChooseCategoryViewController * chooseCategoryVc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
    
    chooseCategoryVc.browsingForSale = self.browsingForSale;
    chooseCategoryVc.tagOfCallXib = 1;
    chooseCategoryVc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:chooseCategoryVc animated:YES completion:nil];
}

- (IBAction)performSearchBtnPressed:(id)sender {
    [dropDownRoom closeAnimation];
    dropDownRoomFlag = false;
    [dropDownCurrency closeAnimation];
    dropDoownCurrencyFlag = false;
    [self.searchTextField resignFirstResponder];
    [self.minPriceTextField resignFirstResponder];
    [self.maxPriceTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    [self.roomsCountTextField resignFirstResponder];

    if ([self.minPriceTextField.text isEqualToString:@""])
        currentMinPriceString = self.minPriceTextField.text;
    else
        currentMinPriceString = [NSString stringWithFormat:@"%i", self.minPriceTextField.text.integerValue];
    
    if ([self.maxPriceTextField.text isEqualToString:@""])
        currentMaxPriceString = self.maxPriceTextField.text;
    else
        currentMaxPriceString = [NSString stringWithFormat:@"%i", self.maxPriceTextField.text.integerValue];
    
    if (!isSearching) {
    //1- reset the pageNumber to 0 to start a new search
    [[AdsManager sharedInstance] setCurrentPageNum:0];
    [[AdsManager sharedInstance] setPageSizeToDefault];
    }
    NSInteger page = [[AdsManager sharedInstance] nextPage];
    //2- load search data
    if (self.currentSubCategoryID != -1)
    {
        if (!isSearching)
            [adsArray removeAllObjects];

        isSearching = YES;
        [self showLoadingIndicator];
        
        [self searchOfPage:page forSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:(self.searchTextField.text.length > 0 ? self.searchTextField.text : @"")minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:currentroomsCountString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@"" currency:currentCurrenciesCountString adsWithPrice:searchWithPrice];
    }
    else
    {
        if (!isSearching)
            [adsArray removeAllObjects];

        isSearching = YES;
        [self showLoadingIndicator];
        
        [self searchOfPage:page forSubCategory:-1 InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:(self.searchTextField.text.length > 0 ? self.searchTextField.text : @"")minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:currentroomsCountString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@"" currency:currentCurrenciesCountString adsWithPrice:searchWithPrice];
    }
    
    currentroomsCountString = @"";
    currentCurrenciesCountString = @"";
    [self.roomsNumBtn setTitle:@"" forState:UIControlStateNormal];
    
    
}

- (void) searchOfPage:(NSInteger) page
             forSubCategory:(NSInteger) subCategoryID
               InCity:(NSInteger) cityID
             textTerm:(NSString *) aTextTerm
             minPrice:(NSString *) aMinPriceString
             maxPrice:(NSString *) aMaxPriceString
          roomCountID:(NSString *) aRoomCount
                 area:(NSString *) aArea
              orderby:(NSString *) orderByString
        lastRefreshed:(NSString *) lasRefreshedString
             currency:(NSString *) aCurrency
         adsWithPrice:(BOOL) aAdsWithPrice
{
    
    [self hideMenu];
    
    [[AdsManager sharedInstance] searchCarAdsOfPage:page forSubCategory:subCategoryID InCity:cityID textTerm:aTextTerm serviceType:@"" minPrice:aMinPriceString maxPrice:aMaxPriceString adsWithImages:true adsWithPrice:aAdsWithPrice area:aArea orderby:orderByString lastRefreshed:lasRefreshedString numOfRoomsID:(aRoomCount) ? aRoomCount : @"" purpose:@"" withGeo:@"" longitute:@"" latitute:@"" radius:@"" currency:aCurrency WithDelegate:self];
    

}

- (void) showLoadingIndicatorOnImages {
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeCustomView2;
    loadingHUD.dimBackground = YES;
    loadingHUD.opacity = 0.5;
}

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState {
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    if (index > -1)
    {
        [(Ad *)[adsArray objectAtIndex:index] setIsFavorite:favState];
    }
}

- (void) removeAdWithAdID:(NSUInteger) adID {
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    [adsArray removeObjectAtIndex:index];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.tableView reloadData];
}


- (IBAction)cancelSearchBtnPressed:(id)sender {
    [self.searchTextField resignFirstResponder];
    [self.minPriceTextField resignFirstResponder];
    [self.maxPriceTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    [self.roomsCountTextField resignFirstResponder];
    
    [self.searchTextField setText:@""];
    [self.minPriceTextField setText:@""];
    [self.maxPriceTextField setText:@""];
    [self.areaTextField setText:@""];
    [self.roomsCountTextField setText:@""];
    [self.adWithPriceButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg6.png"] forState:UIControlStateNormal];
    
    [self hideMenu];
    searchWithPrice = NO;
    
}

- (IBAction)roomsBtnPressed:(id)sender {
    [self.searchTextField resignFirstResponder];
    [self.minPriceTextField resignFirstResponder];
    [self.maxPriceTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];

    if (dropDownRoomFlag==false) {
        dropDownRoomFlag=true;
        [dropDownRoom openAnimation];
        [dropDownCurrency closeAnimation];
        dropDoownCurrencyFlag = false;
    }
    else{
        dropDownRoomFlag=false;
        [dropDownRoom closeAnimation];
    }
}

- (IBAction)currencyBtnPressed:(id)sender {
    [self.searchTextField resignFirstResponder];
    [self.minPriceTextField resignFirstResponder];
    [self.maxPriceTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    
    if (dropDoownCurrencyFlag==false) {
        dropDoownCurrencyFlag=true;
        [dropDownCurrency openAnimation];
        [dropDownRoom closeAnimation];
        dropDownRoomFlag = false;
    }
    else{
        dropDoownCurrencyFlag=false;
        [dropDownCurrency closeAnimation];
    }
}

- (IBAction)adWithPriceBtnPress:(id)sender {
    
    UIImage * bgUncheckedImg;
    UIImage * bgCheckedImg;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        bgCheckedImg = [UIImage imageNamed:@"searchView_text_bg5.png"];
        bgUncheckedImg = [UIImage imageNamed:@"searchView_text_bg6.png"];
    }
    else {
        bgCheckedImg = [UIImage imageNamed:@"WithBut.png"];
        bgUncheckedImg = [UIImage imageNamed:@"WithOutBut.png"];
    }
    
    if(searchWithPrice==false){
        [self.adWithPriceButton setBackgroundImage:bgCheckedImg forState:UIControlStateNormal];
        searchWithPrice=true;
        
    }
    else{
        [self.adWithPriceButton setBackgroundImage:bgUncheckedImg forState:UIControlStateNormal];
        searchWithPrice=false;
        
    }
    
    
}


- (void) addToFavoritePressed:(id)sender event:(id)event {
    //get the tapping position on table to determine the tapped cell
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGPoint currentTouchPosition = [touch locationInView:self.tableView];
        //get the cell index path
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
        if (indexPath != nil) {
            [self handleAddToFavBtnForCellAtIndexPath:indexPath];
        }
    }
    else {
       /* CGPoint currentTouchPosition = [touch locationInView:self.iPad_collectionView];
        NSIndexPath *indexPath = [self.iPad_collectionView indexPathForItemAtPoint: currentTouchPosition];
        if (indexPath != nil) {
            [self handleAddToFavBtnForCellAtIndexPath:indexPath];
        }
    }*/

    }
}

- (void) handleAddToFavBtnForCellAtIndexPath:(NSIndexPath *) indexPath {
    
    Ad * carAdObject = (Ad *)[adsArray objectAtIndex:indexPath.row];
    
    if (!carAdObject.isFavorite)
    {
        [(Ad *)[adsArray objectAtIndex:indexPath.row] setIsFavorite:YES];
            if (carAdObject.thumbnailURL)
            {
                //store ad - with image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured){
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"apartments_viewed_bluelike_icon"] forState:UIControlStateNormal];
                    }
                    
                    else{
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    
                }
                //individual ad - with image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (carAdObject.isFeatured){
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                        
                    }
                    else
                    {
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
            }
            //ad with no image
            else
            {
                //store ad - no image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreNoImageCell * cell = (AdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured){
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
                //individual - no image
                else
                {
                    PlainAdCell * cell = (PlainAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured){
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else{
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
            }
        
        //add from fav
        [[ProfileManager sharedInstance] addCarAd:carAdObject.adID toFavoritesWithDelegate:self];
    }
    else
    {
        [(Ad *)[adsArray objectAtIndex:indexPath.row] setIsFavorite:NO];
            if (carAdObject.thumbnailURL)
            {
                //store ad - with image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreWithImageCell * cell = (AdWithStoreWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    
                    if (carAdObject.isFeatured)
                    {
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
                //individual ad - with image
                else
                {
                    AdWithImageCell * cell = (AdWithImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured){
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else{
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
            }
            //ad with no image
            else
            {
                //store ad - no image
                if (carAdObject.storeID > 0)
                {
                    AdWithStoreNoImageCell * cell = (AdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    if (carAdObject.isFeatured){
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else{
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
                //individual - no image
                else
                {
                    PlainAdCell * cell = (PlainAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (carAdObject.isFeatured){
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                    else{
                        [cell.favoriteBtn setImage:[UIImage imageNamed:@"FavoriteIcons.png"] forState:UIControlStateNormal];
                        
                    }
                }
            }
        //remove to fav
        [[ProfileManager sharedInstance] removeCarAd:carAdObject.adID fromFavoritesWithDelegate:self];
    }
}
@end
