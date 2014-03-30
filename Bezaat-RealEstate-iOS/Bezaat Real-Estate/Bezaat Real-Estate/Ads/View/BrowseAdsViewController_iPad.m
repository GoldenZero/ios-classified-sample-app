//
//  BrowseAdsViewController_iPad.m
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrowseAdsViewController_iPad.h"
#import "CarAdDetailsViewController.h"
#import "CarAdDetailsViewController_iPad.h"
#import "ChooseCategoryViewController.h"
#import "HomePageViewController.h"
#import "labelAdViewController.h"
#import "AppDelegate.h"
#import "ODRefreshControl.h"
#import "DropDownView.h"
#import "whyLabelAdViewController.h"
#import "AddNewCarAdViewController_iPad.h"
#import "AddNewStoreAdViewController_iPad.h"
#import "ExhibitViewController.h"
#import "AddNewStoreViewController.h"

@interface BrowseAdsViewController_iPad ()
{
    
    bool searchBtnFlag;
    float lastContentOffset;
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tapCloseSearch;
    
    MBProgressHUD2 * loadingHUD;
    NSMutableArray * carAdsArray;
    NSMutableArray * rowHeightsArray;
    //HJObjManager* asynchImgManager;   //asynchronous image loading manager
    BOOL dataLoadedFromCache;
    ODRefreshControl *refreshControl;
    BOOL isRefreshing;
    
    DropDownView *dropDownRoom;
    bool dropDownRoomFlag;
    DropDownView *dropDownfromYear;
    bool dropDownfromYearFlag;
    DropDownView *dropDowntoYear;
    bool dropDowntoYearFlag;
    
    DropDownView *dropDownCurrency;
    bool dropDoownCurrencyFlag;

    
    SingleValue* roomObject;
    SingleValue* currencyObject;
    
    Category1* searchedCategory;
    //DFPInterstitial *interstitial_;
    DFPBannerView* bannerView;
    
    NSMutableArray *distanseArray;
    NSArray *fromYearArray;
    NSArray *toYearArray;
    
    // Search panels attributes
    bool searchWithImage;
    bool searchWithPrice;
    NSMutableArray *roomsArray;
    NSMutableArray* currunciesArray;
    NSString *fromYearString;
    NSString *toYearString;
    NSString* currentCurrenciesCountString;
    NSString *currentMinPriceString;
    NSString *currentMaxPriceString;
    NSInteger currentDistanceRangeID;
    
    CGSize tableDataSize;
    
    BOOL isSearching;
    BOOL userDidScroll;
    
    float xForShiftingTinyImg;
    
    UITapGestureRecognizer * iPad_tapFordismissingKeyBoard;
    BOOL iPad_buyCarSegmentBtnChosen;
    BOOL iPad_addCarSegmentBtnChosen;
    BOOL iPad_browseGalleriesSegmentBtnChosen;
    BOOL iPad_addStoreSegmentBtnChosen;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    UISwipeGestureRecognizer * iPad_leftSwipe;
    UISwipeGestureRecognizer * iPad_rightSwipe;
}

@end

@implementation BrowseAdsViewController_iPad

@synthesize tableView;
@synthesize lastScrollPosition, tableContainer;
//@synthesize tableScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        searchWithImage=false;
        searchWithPrice = false;
        lastContentOffset=0;
        
        // Init search panels attributes
        searchBtnFlag=false;
        searchWithImage=false;
        searchWithPrice = false;
        fromYearString=@"";
        toYearString=@"";
        
        // Set the flags of the dropdown
        dropDownRoomFlag=false;
        dropDoownCurrencyFlag = false;
        dropDownfromYearFlag=false;
        dropDowntoYearFlag=false;
        self.searchPanelView.frame = CGRectMake(0,-self.searchPanelView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
    }
    return self;
}

- (void)viewDidLoad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView.adUnitID = BANNER_IPHONE_LISTING;
        bannerView.rootViewController = self;
        bannerView.delegate = self;
        
        [bannerView loadRequest:[GenericMethods createRequestWithCountry:@"" andSection:@"Browse Ads"]];
        
        [self.adBannerView addSubview:bannerView];
    }
    else
    {
        
       /* bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
        bannerView.adUnitID = BANNER_MPU;
        bannerView.rootViewController = self;
        bannerView.delegate = self;
        bannerView.frame = CGRectMake(bannerView.frame.origin.x + 20, bannerView.frame.origin.y, bannerView.frame.size.width, bannerView.frame.size.height);
        
        [bannerView loadRequest:[GADRequest request]];*/
        
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.adWithImageButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg4.png"] forState:UIControlStateNormal];
        [self.adWithPriceButton setBackgroundImage:[UIImage imageNamed:@"WithOutBut.png"] forState:UIControlStateNormal];
        [self.tableView setSeparatorColor:[UIColor clearColor]];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        
        
        tap = [[UITapGestureRecognizer alloc]
               initWithTarget:self
               action:@selector(dismissKeyboard)];
        [self.searchPanelView addGestureRecognizer:tap];
        
        
        tapCloseSearch= [[UITapGestureRecognizer alloc]
                         initWithTarget:self
                         action:@selector(dismissSearch)];
        [self.forTapping addGestureRecognizer:tapCloseSearch];
        
        
        [super viewDidLoad];
        
        [self setButtonsToToolbar];
        
        //init the array if it is still nullable
        if (!carAdsArray)
            carAdsArray = [NSMutableArray new];
        
        /*
         //init the image load manager
         asynchImgManager = [[HJObjManager alloc] init];
         NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
         HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
         asynchImgManager.fileCache = fileCache;
         */
        
        //init search panel attributes
        searchWithImage=false;
        searchWithPrice = false;
        fromYearString=@"";
        toYearString=@"";
        
        //hide the scrolling indicator
        [self.tableView setShowsVerticalScrollIndicator:NO];
        //[self.tableView setScrollEnabled:NO];
        tableDataSize = CGSizeZero;
        self.lastScrollPosition = CGPointZero;
        
        dataLoadedFromCache = NO;
        isRefreshing = NO;
        isSearching = NO;
        userDidScroll = NO;
        
        //set up the refresher
        refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
        [refreshControl addTarget:self action:@selector(refreshAds:) forControlEvents:UIControlEventValueChanged];
        
        //distanceRangeArray =  [[BrandsManager sharedInstance] getDistanceRangesArray];
        [self prepareDropDownLists];
        
        
        //register reuse identifiers for reusing cells
        [self.tableView registerNib:[UINib nibWithNibName:@"CarAdCell" bundle:nil] forCellReuseIdentifier:@"CarAdCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"CarAdNoImageCell" bundle:nil] forCellReuseIdentifier:@"CarAdNoImageCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"CarAdWithStoreCell" bundle:nil] forCellReuseIdentifier:@"CarAdWithStoreCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"CarAdWithStoreNoImageCell" bundle:nil] forCellReuseIdentifier:@"CarAdWithStoreNoImageCell"];
        
        //GA
        [[GAI sharedInstance].defaultTracker sendView:@"Browse Ads screen"];
        //[TestFlight passCheckpoint:@"Browse Ads screen"];
        //end GA
    }
    else { //iPad
        [super viewDidLoad];
        
        [self.adWithPriceButton setBackgroundImage:[UIImage imageNamed:@"WithOutBut.png"] forState:UIControlStateNormal];

        
        self.iPad_searchSideMenuBtn.layer.zPosition = 1; //bring to front
        
        //customize SSLabels
        [self.iPad_startSearchTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.iPad_startSearchTitleLabel setTextAlignment:SSTextAlignmentCenter];
        [self.iPad_startSearchTitleLabel setTextColor:[UIColor whiteColor]];
        [self.iPad_startSearchTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:30.0] ];
        [self.iPad_startSearchTitleLabel setText:@"البدء بالبحث"];
        
        [self.iPad_modelYearTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.iPad_modelYearTitleLabel setTextAlignment:SSTextAlignmentCenter];
        [self.iPad_modelYearTitleLabel setTextColor:[UIColor darkGrayColor]];
        [self.iPad_modelYearTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:15.0] ];
        [self.iPad_modelYearTitleLabel setText:@"سنة الصنع"];
        
        [self.iPad_priceTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.iPad_priceTitleLabel setTextAlignment:SSTextAlignmentCenter];
        [self.iPad_priceTitleLabel setTextColor:[UIColor darkGrayColor]];
        [self.iPad_priceTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:15.0] ];
        [self.iPad_priceTitleLabel setText:@"السعر بالريال"];
        
        self.brandsPopOver = nil;
        self.distanceRangePopOver = nil;
        self.currencyRangePopOver = nil;
        self.yearFromRangePopOver = nil;
        self.yearToRangePopOver = nil;
        
        tap = [[UITapGestureRecognizer alloc]
               initWithTarget:self
               action:@selector(dismissKeyboard)];
        [self.iPad_searchSideMenuView addGestureRecognizer:tap];
        
        iPad_leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(iPad_handleSwipeLeft:)];
        [iPad_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.iPad_searchPanelBtn addGestureRecognizer:iPad_leftSwipe];
        
        iPad_rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(iPad_handleSwipeRight:)];
        [iPad_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.iPad_searchPanelBtn addGestureRecognizer:iPad_rightSwipe];
        
        //init search panel attributes
        searchWithImage=false;
        searchWithPrice = false;
        roomObject=nil;
        currencyObject = nil;
        fromYearString=@"";
        toYearString=@"";
        
        [self iPad_initSlider];
        
        
        //init the array if it is still nullable
        if (!carAdsArray)
            carAdsArray = [NSMutableArray new];
        dataLoadedFromCache = NO;
        isRefreshing = NO;
        isSearching = NO;
        userDidScroll = NO;
        
        iPad_buyCarSegmentBtnChosen = YES;
        iPad_addCarSegmentBtnChosen = NO;
        iPad_browseGalleriesSegmentBtnChosen = NO;
        iPad_addStoreSegmentBtnChosen = NO;
        
        //distanceRangeArray =  [[BrandsManager sharedInstance] getDistanceRangesArray];
        
        [self.iPad_collectionView registerNib:[UINib nibWithNibName:@"CarAdCell_iPad" bundle:nil] forCellWithReuseIdentifier:@"CarAdCell_iPad"];
        [self.iPad_collectionView registerNib:[UINib nibWithNibName:@"CarAdWithStoreCell_iPad" bundle:nil] forCellWithReuseIdentifier:@"CarAdWithStoreCell_iPad"];
        
        [self.iPad_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Banner_Cell"];
        
        //GA
        [[GAI sharedInstance].defaultTracker sendView:@"Browse Ads screen"];
        //[TestFlight passCheckpoint:@"Browse Ads screen"];
        
        //end GA
    }
    
    
        //load the first page of data
        [self loadFirstData];
  
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  set the model label name
   /* if (currentModel){
        if (currentModel.modelID!=-1) {
            [self.modelNameLabel setText:currentModel.modelName];
        }
        else{
            [self.modelNameLabel setText:_currentBrand.brandNameAr];
        }
    
    }
    else*/
        [self.modelNameLabel setText:@"جميع السيارات"];
    
    //[self.tableView setScrollEnabled:NO];
    
    if (!CGSizeEqualToSize(tableDataSize, CGSizeZero))
    {
        /*
         NSLog(@"size: h= %f, w =%f", self.tableView.frame.size.height, self.tableView.frame.size.width);
         self.tableView.contentSize = tableDataSize;
         NSLog(@"content size: h= %f, w =%f", self.tableView.contentSize.height, self.tableView.contentSize.width);
         */
        self.tableView.contentSize = tableDataSize;
        self.tableView.contentOffset = self.lastScrollPosition;
    }
    
    
    userDidScroll = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.tableView reloadData];
        [self.tableView setNeedsDisplay];
    }
    else {
        [self.iPad_collectionView reloadData];
        [self.iPad_collectionView setNeedsDisplay];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self iPad_buyCarSegmentBtnPressed:nil];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    self.lastScrollPosition = self.tableView.contentOffset;
    tableDataSize = self.tableView.contentSize;
    
    //cache the data
    if (carAdsArray && carAdsArray.count)
    {
        if (!isSearching)
        {
            if (!dataLoadedFromCache) {
               /* if (currentModel)
                    [[AdsManager sharedInstance] cacheDataFromArray:carAdsArray
                                                              forBrand:currentModel.brandID
                                                                 Model:currentModel.modelID
                                                                InCity:[[SharedUser sharedInstance] getUserCityID]
                                                           tillPageNum:[[AdsManager sharedInstance] getCurrentPageNum]
                                                           forPageSize: [[AdsManager sharedInstance] getCurrentPageSize]];
                else
                    [[AdsManager sharedInstance] cacheDataFromArray:carAdsArray
                                                              forBrand:-1
                                                                 Model:-1
                                                                InCity:[[SharedUser sharedInstance] getUserCityID]
                                                           tillPageNum:[[AdsManager sharedInstance] getCurrentPageNum]
                                                           forPageSize: [[AdsManager sharedInstance] getCurrentPageSize]];*/
            }
        }
    }
    [self.searchImageButton setHidden:YES];
    searchBtnFlag=false;
    //[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Banner Ad handlig

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"recieved AD");
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"error Ad : %@",error);
}



#pragma mark - tableView handlig



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
     //ad with image
     int separatorHeight = 5;//extra value for separating
     if (carAdObject.thumbnailURL)
     {
     //store ad - with image
     if (carAdObject.storeID > 0)
     return 270 + separatorHeight;
     
     //individual ad - with image
     else
     return 270 + separatorHeight;
     
     }
     //ad with no image
     else
     {
     //store ad - no image
     if (carAdObject.storeID > 0)
     return 150 + separatorHeight;
     //individual - no image
     else
     return 110 + separatorHeight;
     }
     */
    
    if (rowHeightsArray && rowHeightsArray.count)
        return [(NSNumber *)[rowHeightsArray objectAtIndex:indexPath.row] integerValue];
    else
        return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (carAdsArray)
    {
        return carAdsArray.count;
    }
    return 0;
}

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState {
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        [(Ad *)[carAdsArray objectAtIndex:index] setIsFavorite:favState];
    }
}

- (void) removeAdWithAdID:(NSUInteger) adID {
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    [carAdsArray removeObjectAtIndex:index];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.tableView reloadData];
    else
        [self.iPad_collectionView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (aScrollView == self.tableView)
            userDidScroll = YES;
    }
    else {
        if (aScrollView == self.iPad_collectionView)
            userDidScroll = YES;
    }
}

#pragma mark - collection view handling
/*
 - (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 return 1;
 }
 */

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (carAdsArray && carAdsArray.count)
        return carAdsArray.count;
        //return carAdsArray.count + 1;
    return 0;
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0f;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(338.0f, 695); //the dimensions of all cell types
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifierAdBanner = @"Banner_Cell";
    /*if (indexPath.item == 2) {
        
        UICollectionViewCell *cell = [self.iPad_collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierAdBanner forIndexPath:indexPath];
        //UICollectionViewCell *cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0,315, 337)];
        
        if (!cell){
            cell = [[UICollectionViewCell alloc] init];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bannerView];
        return cell;
        
    }*/
    
    xForShiftingTinyImg = 0;
    Ad * carAdObject;
    
    if ((carAdsArray) && (carAdsArray.count))
        carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.row];
        /*if (indexPath.item > 2)
            carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.row - 1];
        else
            carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.row];*/
        
    else{
        
        return [UICollectionViewCell new];
    }
    
    
    
    //store ad - with image
    if (carAdObject.storeID > 0)
    {
        
        //CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdWithStoreCell" owner:self options:nil] objectAtIndex:0];
        
        CarAdWithStoreCell_iPad * cell = (CarAdWithStoreCell_iPad *)[self.iPad_collectionView dequeueReusableCellWithReuseIdentifier:@"CarAdWithStoreCell_iPad" forIndexPath:indexPath];
        
        if (!cell)
            cell = (CarAdWithStoreCell_iPad *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdWithStoreCell_iPad" owner:self options:nil] objectAtIndex:0];
        
        [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.specailButton addTarget:self action:@selector(distinguishButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.helpButton addTarget:self action:@selector(featureAdSteps) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.adTitleLabel.text = carAdObject.title;
        cell.detailsLabel.text = carAdObject.adDetails;

        NSArray* arraysofCountry  = [[LocationManager sharedInstance] getTotalCountries];
        int indexCountry = [[LocationManager sharedInstance] getIndexOfCountry:carAdObject.countryID];
        Country* areaCountry = [arraysofCountry objectAtIndex:indexCountry];
        
        cell.locationLabel.text = [NSString stringWithFormat:@"%@,%@",areaCountry.countryName,carAdObject.area];

        
        NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
        if ([priceStr isEqualToString:@""])
            cell.carPriceLabel.text = priceStr;
        else
            cell.carPriceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
        cell.addTimeLabel.text = [[AdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
        
        
        //hiding & shifting
        if ([carAdObject.rooms length] > 0){
            cell.roomsLabel.text = [NSString stringWithFormat:@"(%@) غرف", carAdObject.rooms];
            cell.roomsLabel.hidden = NO;
            cell.roomsTinyImg.hidden = NO;
        }
        else {
            xForShiftingTinyImg = cell.roomsTinyImg.frame.origin.x;
            
            cell.roomsLabel.hidden = YES;
            cell.roomsTinyImg.hidden = YES;
        }
     
      /*  if (xForShiftingTinyImg > 0) {
            CGRect tempLabelFrame = cell.watchingCountsLabel.frame;
            CGRect tempImgFrame = cell.countOfViewsTinyImg.frame;
            
            
            tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
            tempImgFrame.origin.x = xForShiftingTinyImg;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                [cell.countOfViewsTinyImg setFrame:tempImgFrame];
                [cell.watchingCountsLabel setFrame:tempLabelFrame];
            }];
        }
        */
        if (carAdObject.viewCount > 0) {
            cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            [cell.countOfViewsTinyImg setHidden:NO];
        }
        else
        {
            cell.watchingCountsLabel.text = @"";
            [cell.countOfViewsTinyImg setHidden:YES];
        }
        
        
        //load image as URL
        if (carAdObject.thumbnailURL) {
            NSString* temp = [carAdObject.thumbnailURL absoluteString];
            
            if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                cell.carImage.image = [UIImage imageNamed:@"waitForApprove.png"];
            }else{
                [cell.carImage setImageWithURL:carAdObject.thumbnailURL
                              placeholderImage:[UIImage imageNamed:@"default-Cat-636.png"]];
            }
            
            
            [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage setClipsToBounds:YES];
        }
        
        else {
            [cell.carImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"default-Cat-%i.png", carAdObject.categoryID]]];
            [cell.carImage setBackgroundColor:[UIColor clearColor]];
            [cell.carImage setContentMode:UIViewContentModeScaleAspectFit];
            [cell.carImage setClipsToBounds:YES];
        }
        if (!cell.carImage.image) {
            [cell.carImage setImage:[UIImage imageNamed:@"default-Cat-636.png"]];
        }
        
        [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.carImage setClipsToBounds:YES];
        
        /*
         else if (self.currentBrand) {
         [cell.carImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tb_default_%i.png", self.currentBrand.brandID]]];
         [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
         [cell.carImage setClipsToBounds:YES];
         }
         else { //for "all cars"
         [cell.carImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", carAdObject.categoryID]]];
         [cell.carImage setContentMode:UIViewContentModeScaleAspectFit];
         [cell.carImage setClipsToBounds:YES];
         }
         */
        
        //customize storeName
        cell.storeNameLabel.text = carAdObject.storeName;
        
        //customize storeLogo
        if (carAdObject.storeLogoURL)
        {
            [cell.storeImage setHidden:NO];
            
            //UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            //activityIndicator.hidesWhenStopped = YES;
            //activityIndicator.hidden = NO;
            //activityIndicator.center = CGPointMake(cell.storeImage.frame.size.width /2, cell.storeImage.frame.size.height/2);
            
            //[cell.storeImage addSubview:activityIndicator];
            //[activityIndicator startAnimating];
            [cell.storeImage setImageWithURL:carAdObject.storeLogoURL];
            
            [cell.storeImage setContentMode:UIViewContentModeScaleToFill];
            [cell.storeImage setClipsToBounds:YES];
        }
        //else
        //[cell.storeImage setHidden:YES];
        
        
        
        //check featured
        if (carAdObject.isFeatured)
        {
            [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"iPad_listing_orange_bkg.png"]];
            [cell.distingushingImage setHidden:NO];
            [cell.carPriceLabel setTextColor:[UIColor orangeColor]];
        }
        else{
            [cell.distingushingImage setHidden:YES];
            [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"iPad_listing_blue_bkg"]];
        }
        
        //check owner
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        // Not logged in
        if(!savedProfile){
            [cell.favoriteButton setHidden:YES];
            
        }
        if (savedProfile)   //logged in
        {
            if (savedProfile.userID == carAdObject.ownerID) //is owner
            {
                //[cell.helpButton setHidden:YES];
                //[cell.specailButton setHidden:NO];
                [cell.favoriteButton setHidden:YES];
                
            }
            else {
                [cell.favoriteButton setHidden:NO];
            }
            //check favorite
            if (carAdObject.isFavorite)
            {
                if (carAdObject.isFeatured) {
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                
            }
            else
            {
                [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                /*
                 if (carAdObject.isFeatured){
                 [cell.favoriteButton setImage:[UIImage imageNamed:@"tb_search_result_like.png"] forState:UIControlStateNormal];
                 }
                 else{
                 [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                 }
                 */
            }
        }
        
        NSLog(@"url : %@",[carAdObject.adURL absoluteString]);
        cell.twitterBtn.tag = indexPath.item;
        [cell.twitterBtn addTarget:self action:@selector(twitterAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.facebookBtn.tag = indexPath.item;
        [cell.facebookBtn addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    //individual ad
    else
    {
        CarAdCell_iPad * cell = (CarAdCell_iPad *)[self.iPad_collectionView dequeueReusableCellWithReuseIdentifier:@"CarAdCell_iPad" forIndexPath:indexPath];
        
        if (!cell)
            cell = (CarAdCell_iPad *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdCell_iPad" owner:self options:nil] objectAtIndex:0];
        
        
        [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.adTitleLabel.text = carAdObject.title;
        cell.detailsLabel.text = carAdObject.adDetails;
        NSArray* arraysofCountry  = [[LocationManager sharedInstance] getTotalCountries];
        int indexCountry = [[LocationManager sharedInstance] getIndexOfCountry:carAdObject.countryID];
        Country* areaCountry = [arraysofCountry objectAtIndex:indexCountry];
        
        cell.locationLabel.text = [NSString stringWithFormat:@"%@,%@",areaCountry.countryName,carAdObject.area];
        
        NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
        if ([priceStr isEqualToString:@""])
            cell.carPriceLabel.text = priceStr;
        else
            cell.carPriceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
        cell.addTimeLabel.text = [[AdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
        
        //hiding & shifting
        if ([carAdObject.rooms length] > 0){
            cell.roomsLabel.text = [NSString stringWithFormat:@"(%@) غرف", carAdObject.rooms];
            cell.roomsLabel.hidden = NO;
            cell.roomsTinyImg.hidden = NO;
        }else {
            xForShiftingTinyImg = cell.roomsTinyImg.frame.origin.x;
            
            cell.roomsLabel.hidden = YES;
            cell.roomsTinyImg.hidden = YES;
        }
        
        /*
        if (xForShiftingTinyImg > 0) {
            CGRect tempLabelFrame = cell.watchingCountsLabel.frame;
            CGRect tempImgFrame = cell.countOfViewsTinyImg.frame;
            
            
            tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
            tempImgFrame.origin.x = xForShiftingTinyImg;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                [cell.countOfViewsTinyImg setFrame:tempImgFrame];
                [cell.watchingCountsLabel setFrame:tempLabelFrame];
            }];
        }
        */
        if (carAdObject.viewCount > 0) {
            cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            [cell.countOfViewsTinyImg setHidden:NO];
        }
        else
        {
            cell.watchingCountsLabel.text = @"";
            [cell.countOfViewsTinyImg setHidden:YES];
        }
        
        //load image as URL
        if (carAdObject.thumbnailURL) {
            NSString* temp = [carAdObject.thumbnailURL absoluteString];
            
            if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                cell.carImage.image = [UIImage imageNamed:@"waitForApprove.png"];
            }else{
                [cell.carImage setImageWithURL:carAdObject.thumbnailURL
                              placeholderImage:[UIImage imageNamed:@"default-Cat-636.png"]];
                
            }
            [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage setClipsToBounds:YES];
        }
        else {
            [cell.carImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"default-Cat-%i.png", carAdObject.categoryID]]];
            [cell.carImage setBackgroundColor:[UIColor clearColor]];
            [cell.carImage setContentMode:UIViewContentModeScaleAspectFit];
            [cell.carImage setClipsToBounds:YES];
        }
        if (!cell.carImage.image) {
            [cell.carImage setImage:[UIImage imageNamed:@"default-Cat-636.png"]];
        }

        [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.carImage setClipsToBounds:YES];
        //check featured
        if (carAdObject.isFeatured)
        {
            [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"iPad_listing_orange_bkg.png"]];
            [cell.distingushingImage setHidden:NO];
            [cell.carPriceLabel setTextColor:[UIColor orangeColor]];
            [cell.favoriteButton setHidden:NO];
            
        }
        else{
            [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"iPad_listing_white_bkg.png"]];
            [cell.distingushingImage setHidden:YES];
        }
        
        
        //check owner
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        // Not logged in
        if(!savedProfile){
            [cell.favoriteButton setHidden:YES];
            
        }
        
        if (savedProfile)   //logged in
        {
            if (savedProfile.userID == carAdObject.ownerID) //is owner
            {
                [cell.favoriteButton setHidden:YES];
                
            }
            else {
                [cell.favoriteButton setHidden:NO];
            }
            //check favorite
            if (carAdObject.isFavorite)
            {
                if (carAdObject.isFeatured) {
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                
            }
            else
            {
                [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                /*
                 if (carAdObject.isFeatured){
                 [cell.favoriteButton setImage:[UIImage imageNamed:@"tb_search_result_like.png"] forState:UIControlStateNormal];
                 }
                 else{
                 [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                 }
                 */
            }
        }
        
        if ((indexPath.item == ([self.iPad_collectionView numberOfItemsInSection:0] - 1)) && (userDidScroll)) {
            [self iPad_loadMoreCellsToCollectionView];
        }
        
        cell.twitterBtn.tag = indexPath.item;
        [cell.twitterBtn addTarget:self action:@selector(twitterAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.facebookBtn.tag = indexPath.item;
        [cell.facebookBtn addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Ad * carAdObject;
    carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.item];
    /*if (indexPath.item > 2)
        carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.item - 1];
    else
        carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.item];*/

    CarAdDetailsViewController_iPad * vc;
    
    if (carAdObject.thumbnailURL) {   //ad with image
        vc = [[CarAdDetailsViewController_iPad alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
    }
    else {                            //ad with no image
        vc = [[CarAdDetailsViewController_iPad alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
    }
    
    vc.currentAdID =  carAdObject.adID;
    vc.parentVC_iPad = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) iPad_loadMoreCellsToCollectionView {
    
    if (carAdsArray && carAdsArray.count)
    {
        CGFloat widthDiff = self.iPad_collectionView.contentSize.width - self.iPad_collectionView.frame.size.width;
        //CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
        
        CGFloat minDiff = 338.0f;
        
        if (widthDiff > minDiff)//to prevent continue loading if the page has returned less than 10 objects
        {
            if (isSearching) {
                [self searchPageOfAds];
            }
            else {
                [self loadPageOfAds];
            }
        }
    }
    
}


- (IBAction)twitterAction:(id)sender {
    UIButton* btn = (UIButton*)sender;
    Ad* currentDetailsObject;
    if (btn.tag > 2)
       currentDetailsObject = [carAdsArray objectAtIndex:btn.tag - 1];
    else
        currentDetailsObject= [carAdsArray objectAtIndex:btn.tag];
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Twitter share"
                         withValue:[NSNumber numberWithInt:100]];
    
    //[shareButton fold];
    if (currentDetailsObject)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        else{
            // no twitter account set in device settings
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }
    
}

- (IBAction)facebookAction:(id)sender {
    UIButton* btn = (UIButton*)sender;
    Ad* currentDetailsObject;
    if (btn.tag > 2)
        currentDetailsObject = [carAdsArray objectAtIndex:btn.tag - 1];
    else
        currentDetailsObject= [carAdsArray objectAtIndex:btn.tag];
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Facebook Share"
                         withValue:[NSNumber numberWithInt:100]];
    
    //[shareButton fold];
    if (currentDetailsObject)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        else{
            // no facebook account set in device settings
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }
    
}


# pragma mark - hide bars while scrolling
# pragma mark - custom methods

- (void) hideCoachView {
    //[self.coach_view setHidden:YES];
    [UIView transitionWithView:self.coach_view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.coach_view.hidden = YES;
    [self loadFirstData];
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
        CGPoint currentTouchPosition = [touch locationInView:self.iPad_collectionView];
        NSIndexPath *indexPath = [self.iPad_collectionView indexPathForItemAtPoint: currentTouchPosition];
        if (indexPath != nil) {
            [self handleAddToFavBtnForCellAtIndexPath:indexPath];
        }
    }
}

- (void) distinguishButtonPressed:(id)sender event:(id)event{
    
    //get the tapping position on table to determine the tapped cell
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    //get the cell index path
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil) {
        [self handleFeaturingBtnForCellAtIndexPath:indexPath];
    }
}

- (void)featureAdSteps{
    whyLabelAdViewController *vc=[[whyLabelAdViewController alloc] initWithNibName:@"whyLabelAdViewController" bundle:nil];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void) setButtonsToToolbar{
    
    //  set the model label name
   /* if (currentModel){
        if (currentModel.modelID!=-1) {
            [self.modelNameLabel setText:currentModel.modelName];
        }
        else{
            [self.modelNameLabel setText:_currentBrand.brandNameAr];
        }
        
    }
    else*/
        [self.modelNameLabel setText:@"جميع السيارات"];
    
    //  add background to the toolbar
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grayBKG.png"]]];
}

- (void) handleAddToFavBtnForCellAtIndexPath:(NSIndexPath *) indexPath {
    
    Ad * carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.row];
    
    if (!carAdObject.isFavorite)
    {
        [(Ad *)[carAdsArray objectAtIndex:indexPath.row] setIsFavorite:YES];
            //store ad - with image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell_iPad * cell = (CarAdWithStoreCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
            }
            //individual ad
            else
            {
                CarAdCell_iPad * cell = (CarAdCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
            }
        
        
        //add from fav
        [[ProfileManager sharedInstance] addCarAd:carAdObject.adID toFavoritesWithDelegate:self];
    }
    else
    {
        [(Ad *)[carAdsArray objectAtIndex:indexPath.row] setIsFavorite:NO];
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell_iPad * cell = (CarAdWithStoreCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
            }
            //individual ad
            else
            {
                CarAdCell_iPad * cell = (CarAdCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
            }
        
        //remove to fav
        [[ProfileManager sharedInstance] removeCarAd:carAdObject.adID fromFavoritesWithDelegate:self];
    }
}

- (void) handleFeaturingBtnForCellAtIndexPath:(NSIndexPath *) indexPath {
    
    Ad * carAdObject = (Ad *)[carAdsArray objectAtIndex:indexPath.row];
    
    labelAdViewController *vc;
        vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
    
    //COME BACK HERE
    vc.currentAdID = carAdObject.adID;
    vc.countryAdID = [[SharedUser sharedInstance] getUserCountryID];
    vc.currentAdHasImages = NO;
    if (carAdObject.thumbnailURL)
        vc.currentAdHasImages = YES;
    // vc.parentNewCarVC = self;
    
    //set the ad ID according to indexPath
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (void) showLoadingIndicator {
    
   
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

- (void) hideLoadingIndicator {
    
   
        if ((iPad_activityIndicator) && (iPad_loadingView)) {
            [iPad_activityIndicator stopAnimating];
            [iPad_loadingView removeFromSuperview];
        }
        iPad_activityIndicator = nil;
        iPad_loadingView = nil;
        iPad_loadingLabel = nil;
    
    
}

- (void) searchPageOfAds {
    dataLoadedFromCache = NO;
    isSearching = YES;
    
    //show loading indicator
    //[self showLoadingIndicator];
    
    //1- reset the pageNumber to 0 to start a new search
    [[AdsManager sharedInstance] setCurrentPageNum:0];
    [[AdsManager sharedInstance] setPageSizeToDefault];
    
    NSInteger page = [[AdsManager sharedInstance] nextPage];
    //2- load search data
    if (self.currentSubCategoryID != -1)
    {
        isSearching = YES;
        [carAdsArray removeAllObjects];
        [self showLoadingIndicator];
        
        [self searchOfPage:page forSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:@"" minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:roomObject.valueString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@"" currency:currencyObject.valueString adsWithPrice:searchWithPrice];
    }
    else
    {
        isSearching = YES;
        [carAdsArray removeAllObjects];
        [self showLoadingIndicator];
        
        [self searchOfPage:page forSubCategory:-1 InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:@"" minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:roomObject.valueString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@"" currency:currencyObject.valueString adsWithPrice:searchWithPrice];
    }
    

    
  
    
    
}
- (void) loadPageOfAds {
    dataLoadedFromCache = NO;
    
    //show loading indicator
    [self showLoadingIndicator];
    
    //load a page of data
    NSInteger page = [[AdsManager sharedInstance] nextPage];
    //NSInteger size = [[AdsManager sharedInstance] pageSize];
    NSString* purpose;
    if (self.browsingForSale)
        purpose = @"sale";
    else
        purpose = @"rent";
    
    [[AdsManager sharedInstance] loadAdsOfPage:page forSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID] andPurpose:purpose WithDelegate:self];
    
    
}

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
        [carAdsArray addObjectsFromArray:cachedArray];
        
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

- (void) refreshAds:(ODRefreshControl *)refreshControl {
    
    
    //NSLog(@"refresher released!");
    //1- clear cache
        //[[AdsManager sharedInstance] loadAdsOfPage:1 forSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID] WithDelegate:self];

    
    //2- reset page identifiers
    [[AdsManager sharedInstance] setCurrentPageNum:0];
    [[AdsManager sharedInstance] setPageSizeToDefault];
    
    
    //3- reset the array
    [carAdsArray removeAllObjects];
    
    //4- reload
    isRefreshing = YES;
    if (isSearching)
        [self searchPageOfAds];
    else
        [self loadPageOfAds];
}

- (BOOL) validateStringYearsFrom:(NSString *) fromString To:(NSString *) toString {
    
    //if year is a string of (2003 لبق) then it returns a zero integer value
    NSInteger fromYear = [fromString integerValue];
    
    NSInteger toYear = [toString integerValue];
    
    if ((fromYear == 0) && (toYear == 0))
        return YES; //both strings are of type (2003 لبق) or both are empty
    
    else if ((fromYear != 0) && (toYear == 0))
        return NO;  //the toYear is (2003 لبق) and from year is a higher year
    
    else if ((fromYear != 0) && (toYear != 0))
    {
        if (fromYear > toYear)
            return NO;
    }
    return YES;
}

- (BOOL) validatePriceFrom:(float) Pmin to:(float) Pmax {
    
    if (Pmin > Pmax)
        return NO;
    return YES;
}

- (void) createRowHeightsArray {
    
    if (carAdsArray && carAdsArray.count) {
        if (!rowHeightsArray)
            rowHeightsArray = [NSMutableArray new];
        
        [rowHeightsArray removeAllObjects];
        
        int separatorHeight = 5;//extra value for separating
        
        for (Ad * carAdObject in carAdsArray) {
            //ad with image
            if (carAdObject.thumbnailURL)
            {
                //store ad - with image
                if (carAdObject.storeID > 0)
                    [rowHeightsArray addObject:[NSNumber numberWithInt:(275 + separatorHeight)]];
                
                //individual ad - with image
                else
                    [rowHeightsArray addObject:[NSNumber numberWithInt:(277 + separatorHeight)]];
                
            }
            //ad with no image
            else
            {
                //store ad - no image
                if (carAdObject.storeID > 0)
                    //[rowHeightsArray addObject:[NSNumber numberWithInt:(147 + separatorHeight)]];
                    [rowHeightsArray addObject:[NSNumber numberWithInt:(275 + separatorHeight)]];
                //individual - no image
                else
                    //[rowHeightsArray addObject:[NSNumber numberWithInt:(110 + separatorHeight)]];
                    [rowHeightsArray addObject:[NSNumber numberWithInt:(277 + separatorHeight)]];
            }
        }
        
    }
    
}

#pragma mark - keyboard handler
-(void)dismissKeyboard {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.carNameText resignFirstResponder];
        [self.lowerPriceText resignFirstResponder];
        [self.higherPriceText resignFirstResponder];
        [dropDownRoom closeAnimation];
        [dropDownCurrency closeAnimation];
        [dropDownfromYear closeAnimation];
        [dropDowntoYear closeAnimation];
        dropDownRoomFlag=false;
        dropDoownCurrencyFlag = false;
        dropDownfromYearFlag=false;
        dropDowntoYearFlag=false;
    }
    else {
        if (self.brandsPopOver)
            [self.brandsPopOver dismissPopoverAnimated:YES];
        
        if (self.distanceRangePopOver)
            [self.distanceRangePopOver dismissPopoverAnimated:YES];
        
        if (self.currencyRangePopOver)
            [self.currencyRangePopOver dismissPopoverAnimated:YES];
        
        if (self.yearFromRangePopOver)
            [self.yearFromRangePopOver dismissPopoverAnimated:YES];
        
        if (self.yearToRangePopOver)
            [self.yearToRangePopOver dismissPopoverAnimated:YES];
        
        [self.carNameText resignFirstResponder];
        [self.lowerPriceText resignFirstResponder];
        [self.higherPriceText resignFirstResponder];
    }
    
}

- (void) dismissSearch{
    [self hideSearchPanel];
    [self.searchImageButton setHidden:YES];
    searchBtnFlag=false;
}

- (void) dismissSearchAndShowLoading {
    
    [self.searchImageButton setHidden:YES];
    searchBtnFlag=false;
    [self hideSearchPanelAndShowLoading];
}
#pragma mark - animation

- (void) showSearchPanel{
    // Init search panel attributes before next search
    
    [self.searchPanelView setHidden:NO];
    self.searchPanelView.frame = CGRectMake(0,-self.searchPanelView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
    [UIView animateWithDuration:.5
                     animations:^{
                         self.searchPanelView.frame = CGRectMake(0,self.topBarView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) hideSearchPanel{
    [dropDownRoom closeAnimation];
    [dropDownCurrency closeAnimation];
    [dropDownfromYear closeAnimation];
    [dropDowntoYear closeAnimation];
    dropDownRoomFlag=false;
    dropDoownCurrencyFlag = false;
    dropDownfromYearFlag=false;
    dropDowntoYearFlag=false;
    [UIView animateWithDuration:.5
                     animations:^{
                         self.searchPanelView.frame = CGRectMake(0,-self.searchPanelView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                         {
                             [self.searchPanelView setHidden:YES];
                         }
                         
                     }];
    
}

- (void) hideSearchPanelAndShowLoading{
    [dropDownRoom closeAnimation];
    [dropDownCurrency closeAnimation];

    [dropDownfromYear closeAnimation];
    [dropDowntoYear closeAnimation];
    dropDownRoomFlag=false;
    dropDoownCurrencyFlag = false;
    dropDownfromYearFlag=false;
    dropDowntoYearFlag=false;
    [UIView animateWithDuration:.5
                     animations:^{
                         self.searchPanelView.frame = CGRectMake(0,-self.searchPanelView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                         {
                             [self.searchPanelView setHidden:YES];
                             //[self showLoadingIndicator];
                         }
                     }];
    
}

#pragma mark - actions
- (IBAction)homeBtnPress:(id)sender {
    
    HomePageViewController *homeVC;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        homeVC =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    else
        homeVC =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController_iPad" bundle:nil];
    
    
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
        [self showSearchPanel];
        [self.searchImageButton setHidden:NO];
        
    }
    
    else {
        [self hideSearchPanel];
        [self.searchImageButton setHidden:YES];
        
        
    }
    
    
    
}

- (IBAction)modelBtnPress:(id)sender {
    
    ChooseCategoryViewController *popover=[[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
    popover.tagOfCallXib=1;
    
    
    [self presentViewController:popover animated:YES completion:nil];
    
}

- (IBAction)searchInPanelBtnPrss:(id)sender {
    
    NSLog(@"performing search ...");
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Search filter"
                         withValue:[NSNumber numberWithInt:100]];
    
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];
    
    if ([self.lowerPriceText.text isEqualToString:@""])
        currentMinPriceString = self.lowerPriceText.text;
    else
        currentMinPriceString = [NSString stringWithFormat:@"%i", self.lowerPriceText.text.integerValue];
    
    if ([self.higherPriceText.text isEqualToString:@""])
        currentMaxPriceString = self.higherPriceText.text;
    else
        currentMaxPriceString = [NSString stringWithFormat:@"%i", self.higherPriceText.text.integerValue];
    
    currentDistanceRangeID = -1;
    
    
    //1- reset the pageNumber to 0 to start a new search
    [[AdsManager sharedInstance] setCurrentPageNum:0];
    [[AdsManager sharedInstance] setPageSizeToDefault];
    
    NSInteger page = [[AdsManager sharedInstance] nextPage];
    //2- load search data
    if (self.currentSubCategoryID != -1)
    {
        isSearching = YES;
        [carAdsArray removeAllObjects];
        [self showLoadingIndicator];
        
        //[self searchOfPage:page forSubCategory:self.currentSubCategoryID InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:(self.searchTextField.text.length > 0 ? self.searchTextField.text : @"")minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:currentroomsCountString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@""];
        [self searchOfPage:page forSubCategory:searchedCategory.categoryID InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:@"" minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:roomObject.valueString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@"" currency:currencyObject.valueString adsWithPrice:searchWithPrice];

    }
    else
    {
        isSearching = YES;
        [carAdsArray removeAllObjects];
        [self showLoadingIndicator];
        
        //[self searchOfPage:page forSubCategory:-1 InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:(self.searchTextField.text.length > 0 ? self.searchTextField.text : @"")minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:currentroomsCountString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@""];
        [self searchOfPage:page forSubCategory:-1 InCity:[[SharedUser sharedInstance] getUserCityID] textTerm:@"" minPrice:currentMinPriceString maxPrice:currentMaxPriceString roomCountID:roomObject.valueString area:(self.areaTextField.text.length > 0 ? self.areaTextField.text : @"") orderby:@"" lastRefreshed:@"" currency:currencyObject.valueString adsWithPrice:searchWithPrice];

    }

    
    
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
    
    [self iPad_hideSideMenu];
    
    [[AdsManager sharedInstance] searchCarAdsOfPage:page forSubCategory:subCategoryID InCity:cityID textTerm:aTextTerm serviceType:@"" minPrice:aMinPriceString maxPrice:aMaxPriceString adsWithImages:true adsWithPrice:searchWithPrice area:aArea orderby:orderByString lastRefreshed:lasRefreshedString numOfRoomsID:(aRoomCount) ? aRoomCount : @"" purpose:@"" withGeo:@"" longitute:@"" latitute:@"" radius:@"" currency:aCurrency WithDelegate:self];
    
    
}

- (IBAction)clearInPanelBtnPrss:(id)sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.carNameText resignFirstResponder];
        [self.lowerPriceText resignFirstResponder];
        [self.higherPriceText resignFirstResponder];
        
        [self.carNameText setText:@""];
        [self.lowerPriceText setText:@""];
        [self.higherPriceText setText:@""];
        [self.distanceRangeLabel setText:@"عدد الغرف"];
        [self.fromYearLabel setText:@"من سنة "];
        [self.toYearLabel setText:@"إلى سنة"];
        [self.adWithImageButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg4.png"] forState:UIControlStateNormal];
        [self.adWithPriceButton setBackgroundImage:[UIImage imageNamed:@"WithOutBut.png"] forState:UIControlStateNormal];
    }
    else {
        [self.lowerPriceText resignFirstResponder];
        [self.higherPriceText resignFirstResponder];
        
        //[self.carNameText setText:@""];
        [self.lowerPriceText setText:@""];
        [self.higherPriceText setText:@""];
        
        [self.adWithImageButton setBackgroundImage:[UIImage imageNamed:@"tb_car_brand_sidemenu_with_pic_btn_uncheck.png"] forState:UIControlStateNormal];
        [self.adWithPriceButton setBackgroundImage:[UIImage imageNamed:@"WithOutBut.png"] forState:UIControlStateNormal];
    }
    
    // Init search panels attributes
    searchWithImage=false;
    searchWithPrice = false;
    fromYearString=@"";
    toYearString=@"";
    
}

- (IBAction)adWithImageBtnPrss:(id)sender {
    
    UIImage * bgUncheckedImg;
    UIImage * bgCheckedImg;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        bgCheckedImg = [UIImage imageNamed:@"searchView_text_bg3.png"];
        bgUncheckedImg = [UIImage imageNamed:@"searchView_text_bg4.png"];
    }
    else {
        bgCheckedImg = [UIImage imageNamed:@"WithBut.png"];
        bgUncheckedImg = [UIImage imageNamed:@"WithOutBut.png"];
    }
    
    
    if(searchWithImage==false){
        [self.adWithImageButton setBackgroundImage:bgCheckedImg forState:UIControlStateNormal];
        searchWithImage=true;
        
    }
    else{
        [self.adWithImageButton setBackgroundImage:bgUncheckedImg forState:UIControlStateNormal];
        searchWithImage=false;
        
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

- (IBAction)distanceBtnPrss:(id)sender {
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];
    if (dropDownRoomFlag==false) {
        dropDownRoomFlag=true;
        [dropDownRoom openAnimation];
    }
    else{
        dropDownRoomFlag=false;
        [dropDownRoom closeAnimation];
    }
}

- (IBAction)fromYearBtnPrss:(id)sender {
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];
    if (dropDownfromYearFlag==false) {
        dropDownfromYearFlag=true;
        [dropDownfromYear openAnimation];
    }
    else{
        dropDownfromYearFlag=false;
        [dropDownfromYear closeAnimation];
    }
}

- (IBAction)toYearBtnPrss:(id)sender {
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];
    if (dropDowntoYearFlag==false) {
        dropDowntoYearFlag=true;
        [dropDowntoYear openAnimation];    }
    else{
        dropDowntoYearFlag=false;
        [dropDowntoYear closeAnimation];
    }
    
}

#pragma mark - AdsManager Delegate methods

- (void) adsDidFailLoadingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
    if (isRefreshing)
    {
        isRefreshing = NO;
        [refreshControl endRefreshing];
    }
    [self.nocarImg setHidden:NO];
    [self.tableContainer setHidden:YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.iPad_collectionView setHidden:YES];
        [self iPad_hideSideMenu];
    }
}

- (void) adsDidFinishLoadingWithData:(NSArray *)resultArray {
    //1- hide the loading indicator
    [self hideLoadingIndicator];
    
    
    //2- append the newly loaded ads
    if (resultArray && resultArray.count)
    {
        NSMutableArray * URLsToPrefetch = [NSMutableArray new];
        [self.nocarImg setHidden:YES];
        [self.tableContainer setHidden:NO];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self.iPad_collectionView setHidden:NO];
        for (Ad * newAd in resultArray)
        {
            NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:newAd.adID inArray:carAdsArray];
            if (index == -1)
                [carAdsArray addObject:newAd];
            
            if (newAd.thumbnailURL)
                [URLsToPrefetch addObject:[NSURL URLWithString:newAd.thumbnailURL.absoluteString]];
        }
        
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:URLsToPrefetch];
    }
    else
    {
        if ((!carAdsArray) || (carAdsArray.count == 0))
        {
            [self.nocarImg setHidden:NO];
            [self.tableContainer setHidden:YES];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self.iPad_collectionView setHidden:YES];
                [self iPad_hideSideMenu];
            }
            [self hideLoadingIndicator];
        }
    }
    
    [self createRowHeightsArray];
    
    //3- refresh table data
    
    userDidScroll = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.tableView reloadData];
    else {
        [self.iPad_collectionView reloadData];
        if (isRefreshing) {
            [self.iPad_collectionView setContentOffset:CGPointZero animated:YES];
        }
    }
    
    if (isRefreshing)
    {
        isRefreshing = NO;
        [refreshControl endRefreshing];
    }
    
    //self.tableView.contentSize=CGSizeMake(320, self.tableView.contentSize.height);
    /*
     if ([carAdsArray count] <= 10 && [carAdsArray count] != 0) {
     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
     [self.tableView setContentOffset:CGPointZero animated:YES];
     }
     */
    
    
}

#pragma mark - favorites Delegate methods
- (void) FavoriteFailAddingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [carAdsArray objectAtIndex:index];
        //store ad
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell_iPad * cell = (CarAdWithStoreCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                
                
            }
            //individual ad
            else
            {
                CarAdCell_iPad * cell = (CarAdCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                
            }
        
    }
}

- (void) FavoriteDidAddWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [carAdsArray objectAtIndex:index];
            //store ad
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell_iPad * cell = (CarAdWithStoreCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                if (resultStatus) {     //added successfulyy
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                
            }
            //individual ad
            else
            {
                CarAdCell_iPad * cell = (CarAdCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                if (resultStatus) {     //added successfulyy
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                
            }
        
    }
}

- (void) FavoriteFailRemovingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [carAdsArray objectAtIndex:index];
      
            //store ad
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell_iPad * cell = (CarAdWithStoreCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                
            }
            //individual ad
            else
            {
                CarAdCell_iPad * cell = (CarAdCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
            }
        
    }
    
}

- (void) FavoriteDidRemoveWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [[AdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        Ad * carAdObject = [carAdsArray objectAtIndex:index];
            //store ad
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell_iPad * cell = (CarAdWithStoreCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                if (resultStatus)      //removed successfuly
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                else {
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                
                
            }
            //individual ad
            else
            {
                CarAdCell_iPad * cell = (CarAdCell_iPad *)[self.iPad_collectionView cellForItemAtIndexPath:indexPath];
                
                if (resultStatus)      //removed successfuly
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_off.png"] forState:UIControlStateNormal];
                else {
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"iPad_listing_favourite_on.png"] forState:UIControlStateNormal];
                }
                
            }
        
        
    }
    
}

#pragma - mark drop down handler

- (void) prepareDropDownLists{
    roomsArray=[[NSMutableArray alloc]init];
    [roomsArray addObject:@"1"];
    [roomsArray addObject:@"2"];
    [roomsArray addObject:@"3"];
    [roomsArray addObject:@"4"];
    [roomsArray addObject:@"5"];
    [roomsArray addObject:@"6"];
    [roomsArray addObject:@"+6"];
    
    currunciesArray = [NSMutableArray new];
    /*for (int i=0; i<distanceRangeArray.count; i++) {
        [distanseArray addObject:[[distanceRangeArray objectAtIndex:i] rangeName]];
        
    }
    fromYearArray = [[BrandsManager sharedInstance] getYearsArray];
    toYearArray = [[BrandsManager sharedInstance] getYearsArray];*/
    
    
    currunciesArray= [[NSMutableArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    
    dropDownRoom=[[DropDownView alloc] initWithArrayData:roomsArray imageData:nil checkMarkData:-1 cellHeight:30 heightTableView:100 paddingTop:43 paddingLeft:0 paddingRight:0 refView:self.distanceButton animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2 _tag:1];
	dropDownRoom.delegate = self;
	[self.view addSubview:dropDownRoom.view];
	//[self.distanceButton setTitle:[dataArray objectAtIndex:0] forState:UIControlStateNormal];
    
    dropDownCurrency=[[DropDownView alloc] initWithArrayData:currunciesArray imageData:nil checkMarkData:-1 cellHeight:30 heightTableView:100 paddingTop:43 paddingLeft:0 paddingRight:0 refView:self.iPad_chooseCurrencyBtn animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2 _tag:4];
	dropDownCurrency.delegate = self;
	[self.view addSubview:dropDownCurrency.view];
    
    
    dropDownfromYear=[[DropDownView alloc] initWithArrayData:fromYearArray imageData:nil checkMarkData:-1 cellHeight:30 heightTableView:100 paddingTop:43 paddingLeft:0 paddingRight:0 refView:self.fromYearButton animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2 _tag:2];
    
	dropDownfromYear.delegate = self;
	[self.view addSubview:dropDownfromYear.view];
	//[self.distanceButton setTitle:[dataArray objectAtIndex:0] forState:UIControlStateNormal];
    
    
    dropDowntoYear=[[DropDownView alloc] initWithArrayData:toYearArray imageData:nil checkMarkData:-1 cellHeight:30 heightTableView:100 paddingTop:43 paddingLeft:0 paddingRight:0 refView:self.toYearButton animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2 _tag:3];
	dropDowntoYear.delegate = self;
	[self.view addSubview:dropDowntoYear.view];
	//[self.distanceButton setTitle:[dataArray objectAtIndex:0] forState:UIControlStateNormal];
    
}

-(void)dropDownCellSelected:(NSInteger)returnIndex :(NSInteger)_tag{
    switch (_tag) {
        case 1:
        {
            [self.distanceRangeLabel setText:[roomsArray objectAtIndex:returnIndex ]];
            //distanceObj=(DistanceRange*)[distanceRangeArray objectAtIndex:returnIndex];
            break;
        }
        case 2:{
            [self.fromYearLabel setText:[fromYearArray objectAtIndex:returnIndex ]];
            fromYearString= [NSString stringWithFormat:@"%@",
                             [fromYearArray objectAtIndex:returnIndex]];
            break;
        }
        case 3:{
            [self.toYearLabel setText:[toYearArray objectAtIndex:returnIndex ]];
            toYearString=[NSString stringWithFormat:@"%@",
                          [toYearArray objectAtIndex:returnIndex ]];
            break;
        }
        case 4:{
            currentCurrenciesCountString = [(SingleValue*)[currunciesArray objectAtIndex:returnIndex] valueString];
            [self.iPad_chooseCurrencyBtn setTitle:currentCurrenciesCountString forState:UIControlStateNormal];
            [dropDownCurrency closeAnimation];
            dropDoownCurrencyFlag = false;
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - iPad helper methods

- (void) iPad_initSlider {
    
   
}

- (void) iPad_showSideMenu {
    //slide the content view to the right to reveal the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         [self.iPad_contentView setFrame:CGRectMake(-self.iPad_searchSideMenuView.frame.size.width, self.iPad_contentView.frame.origin.y, self.iPad_contentView.frame.size.width, self.iPad_contentView.frame.size.height)];
                     }
     ];
}

- (void) iPad_hideSideMenu {
    [UIView animateWithDuration:.25
                     animations:^{
                         [self.iPad_contentView setFrame:CGRectMake(0, self.iPad_contentView.frame.origin.y, self.iPad_contentView.frame.size.width, self.iPad_contentView.frame.size.height)];
                     }
     ];

}

- (void) dismissBrandsPopOver:(id) sender {
    if (self.brandsPopOver)
        [self.brandsPopOver dismissPopoverAnimated:YES];
}

- (void) loadAllCarsBtnPressed:(id) sender {
    [self dismissBrandsPopOver:nil];
    
    [self refreshAds:nil];
}

- (void) dismissDistancePopOver {
    if (self.distanceRangePopOver)
        [self.distanceRangePopOver dismissPopoverAnimated:YES];
}

- (void) dismissYearFromPopOver {
    if (self.yearFromRangePopOver)
        [self.yearFromRangePopOver dismissPopoverAnimated:YES];
}

- (void) dismissYearToPopOver {
    if (self.yearToRangePopOver)
        [self.yearToRangePopOver dismissPopoverAnimated:YES];
}

-(void) dismissCurrencyPopOver
{
    if (self.currencyRangePopOver)
        [self.currencyRangePopOver dismissPopoverAnimated:YES];
}

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

-(void)iPad_handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    if(self.iPad_contentView.frame.origin.x == 0)
        [self iPad_showSideMenu];
    
}

-(void)iPad_handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(self.iPad_contentView.frame.origin.x != 0)
        [self iPad_hideSideMenu];
}

#pragma mark - iPad actions

- (IBAction) iPad_searchSideMenuBtn:(id)sender {
    
    if(self.iPad_contentView.frame.origin.x != 0)
        [self iPad_hideSideMenu];
    
    else if (self.iPad_contentView.frame.origin.x == 0)
        [self iPad_showSideMenu];
}

- (IBAction)iPad_chooseBrandBtnPressed:(id)sender {
    if (!self.brandsPopOver) {
         CategoriesPopOver_iPad* CategoryVC = [[CategoriesPopOver_iPad alloc] initWithNibName:@"CategoriesPopOver_iPad" bundle:nil];
        
        CategoryVC.choosingDelegate = self;
        CategoryVC.browsingForSale = self.browsingForSale;
        self.brandsPopOver = [[UIPopoverController alloc] initWithContentViewController:CategoryVC];
    }
   // else
       // [(ModelsViewController_iPad *) self.brandsPopOver.contentViewController setFirstAppearance:NO];
    
    CGRect popOverFrame = self.brandsPopOver.contentViewController.view.frame;
    
    [self.brandsPopOver setPopoverContentSize:popOverFrame.size];
    [self.brandsPopOver presentPopoverFromRect:self.iPad_chooseBrandBtn.frame inView:self.iPad_searchSideMenuView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}

-(void)didChooseCategory:(Category1 *)category
{
    searchedCategory = category;
    [self.brandsPopOver dismissPopoverAnimated:YES];
    self.iPad_CategoryLabel.text = category.categoryName;
}

- (IBAction)iPad_chooseDistanceRangeBtnPressed:(id)sender {
    roomsArray=[[NSMutableArray alloc]init];
    roomsArray = [[NSMutableArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadRoomsValues]];

    if (!self.distanceRangePopOver) {
        TableInPopUpTableViewController * roomsRangeVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        
        roomsRangeVC.choosingDelegate = self;
//        if (!distanceRangeArray)
  //          distanceRangeArray =  [[BrandsManager sharedInstance] getDistanceRangesArray];

        roomsRangeVC.arrayValues = [NSArray arrayWithArray:roomsArray];
        
        roomsRangeVC.showingFromYearObjects = NO;
        roomsRangeVC.showingToYearObjects = NO;
        roomsRangeVC.showingRoomsObjects = YES;
       // distanceRangeVC.showingDistanceRangeObjects = YES;
        roomsRangeVC.showingSingleValueObjects = NO;
        roomsRangeVC.showingCurrencyValueObjects = NO;
        roomsRangeVC.showingStores = NO;
        
        self.distanceRangePopOver = [[UIPopoverController alloc] initWithContentViewController:roomsRangeVC];
    }
    
    CGRect popOverFrame = self.distanceRangePopOver.contentViewController.view.frame;
    [self.distanceRangePopOver setPopoverContentSize:popOverFrame.size];
    [self.distanceRangePopOver presentPopoverFromRect:self.iPad_chooseDistanceRangeBtn.frame inView:self.iPad_searchSideMenuView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (IBAction)iPad_chooseCurrencyBtnPressed:(id)sender {
    currunciesArray=[[NSMutableArray alloc]init];
    currunciesArray= [[NSMutableArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    
    if (!self.currencyRangePopOver) {
        TableInPopUpTableViewController * currencyRangeVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        
        currencyRangeVC.choosingCurrencyDelegate = self;
        //        if (!distanceRangeArray)
        //          distanceRangeArray =  [[BrandsManager sharedInstance] getDistanceRangesArray];
        
        currencyRangeVC.arrayValues = [NSArray arrayWithArray:currunciesArray];
        
        currencyRangeVC.showingFromYearObjects = NO;
        currencyRangeVC.showingToYearObjects = NO;
        currencyRangeVC.showingRoomsObjects = NO;
        // distanceRangeVC.showingDistanceRangeObjects = YES;
        currencyRangeVC.showingSingleValueObjects = NO;
        currencyRangeVC.showingCurrencyValueObjects = YES;
        currencyRangeVC.showingStores = NO;
        
        self.currencyRangePopOver = [[UIPopoverController alloc] initWithContentViewController:currencyRangeVC];
    }
    
    CGRect popOverFrame = self.currencyRangePopOver.contentViewController.view.frame;
    [self.currencyRangePopOver setPopoverContentSize:popOverFrame.size];
    [self.currencyRangePopOver presentPopoverFromRect:self.iPad_chooseCurrencyBtn.frame inView:self.iPad_searchSideMenuView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (IBAction)iPad_chooseYearFromBtnPressed:(id)sender {
    
    if (!self.yearFromRangePopOver) {
        TableInPopUpTableViewController * yearFromRangeVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        
        yearFromRangeVC.choosingYearFromDelegate = self;
       // if (!fromYearArray)
        //    fromYearArray =  [[BrandsManager sharedInstance] getYearsArray];
        yearFromRangeVC.arrayValues = [NSArray arrayWithArray:fromYearArray];
        
        yearFromRangeVC.showingFromYearObjects = YES;
        yearFromRangeVC.showingToYearObjects = NO;
        yearFromRangeVC.showingRoomsObjects = NO;
        yearFromRangeVC.showingCurrencyValueObjects = NO;
        //yearFromRangeVC.showingDistanceRangeObjects = NO;
        yearFromRangeVC.showingSingleValueObjects = NO;
        yearFromRangeVC.showingStores = NO;
        
        self.yearFromRangePopOver = [[UIPopoverController alloc] initWithContentViewController:yearFromRangeVC];
    }
    
    CGRect popOverFrame = self.yearFromRangePopOver.contentViewController.view.frame;
    [self.yearFromRangePopOver setPopoverContentSize:popOverFrame.size];
    [self.yearFromRangePopOver presentPopoverFromRect:self.iPad_chooseYearFromBtn.frame inView:self.yearView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)iPad_chooseYearToBtnPressed:(id)sender {
    
    if (!self.yearToRangePopOver) {
        TableInPopUpTableViewController * yearToRangeVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        
        yearToRangeVC.choosingYearToDelegate = self;
        //if (!toYearArray)
        //    toYearArray =  [[BrandsManager sharedInstance] getYearsArray];
        yearToRangeVC.arrayValues = [NSArray arrayWithArray:toYearArray];
        
        yearToRangeVC.showingFromYearObjects = NO;
        yearToRangeVC.showingToYearObjects = YES;
        yearToRangeVC.showingRoomsObjects = NO;
        yearToRangeVC.showingSingleValueObjects = NO;
        yearToRangeVC.showingStores = NO;
        yearToRangeVC.showingCurrencyValueObjects = NO;
        self.yearToRangePopOver = [[UIPopoverController alloc] initWithContentViewController:yearToRangeVC];
    }
    
    CGRect popOverFrame = self.yearToRangePopOver.contentViewController.view.frame;
    [self.yearToRangePopOver setPopoverContentSize:popOverFrame.size];
    [self.yearToRangePopOver presentPopoverFromRect:self.iPad_chooseYearToBtn.frame inView:self.yearView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

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
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedProfile) {
        AddNewCarAdViewController_iPad * vc = [[AddNewCarAdViewController_iPad alloc] initWithNibName:@"AddNewCarAdViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (savedProfile.hasStores) {
        AddNewStoreAdViewController_iPad *adNewCar=[[AddNewStoreAdViewController_iPad alloc] initWithNibName:@"AddNewStoreAdViewController_iPad" bundle:nil];
        
        //adNewCar.currentStore = store;
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

- (IBAction)iPad_refreshBtnPressed:(id)sender {
    [self refreshAds:nil];
}


- (IBAction)iPad_checkPriceBtnPressed:(id)sender {
    
}

- (IBAction)iPad_checkImagesBtnPressed:(id)sender {
    
}

- (IBAction)iPad_performSearchBtnPressed:(id)sender {
    
}

- (IBAction)iPad_clearFieldsBtnPressed:(id)sender {
    
}

#pragma mark - brandChoosing Delegate method
/*
- (void) didChooseModel:(Model *)model {
    //dismissPopOver
    [self dismissBrandsPopOver:nil];
    
    //reload data
    currentModel = model;
    
    if(self.iPad_contentView.frame.origin.x != 0)
        [self iPad_hideSideMenu];
    
    [carAdsArray removeAllObjects];
    [self loadFirstData];
    //NSLog(@"reloading data ...");
}
*/
#pragma mark - TableInPopUpChoosingDelegate method
-(void)didChooseCurrencyItemWithObject:(id) obj{
    
    currencyObject = (SingleValue*)obj;
    [self.iPad_chooseCurrencyBtn setTitle:currencyObject.valueString forState:UIControlStateNormal];
    [self dismissCurrencyPopOver];
}

- (void) didChooseTableItemWithObject:(id) obj {
    
    roomObject= (SingleValue *)obj;
    self.iPad_distanceLabel.text = roomObject.valueString;
    [self dismissDistancePopOver];
}

-(void)didChooseYearFromTableItemWithObject:(NSString *)obj
{
    fromYearString = obj;
    self.iPad_minYearLabel.text = obj;
    [self dismissYearFromPopOver];
}

-(void)didChooseYearToTableItemWithObject:(NSString *)obj
{
    toYearString = obj;
    self.iPad_maxYearLabel.text = obj;
    [self dismissYearToPopOver];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
            (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
            [self dismissKeyboard];
    }
}
@end
