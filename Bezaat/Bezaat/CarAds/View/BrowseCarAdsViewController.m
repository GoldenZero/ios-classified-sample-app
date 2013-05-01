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
#import "AppDelegate.h"
#import "ODRefreshControl.h"
#import "DropDownView.h"
#import "DistanceRange.h"
#import "whyLabelAdViewController.h"

@interface BrowseCarAdsViewController (){
    
    bool searchBtnFlag;
    float lastContentOffset;
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tapCloseSearch;
    
    MBProgressHUD2 * loadingHUD;
    NSMutableArray * carAdsArray;
    //HJObjManager* asynchImgManager;   //asynchronous image loading manager
    BOOL dataLoadedFromCache;
    ODRefreshControl *refreshControl;
    BOOL isRefreshing;
    
    DropDownView *dropDownDistance;
    bool dropDownDistanceFlag;
    DropDownView *dropDownfromYear;
    bool dropDownfromYearFlag;
    DropDownView *dropDowntoYear;
    bool dropDowntoYearFlag;
    
    NSMutableArray *distanseArray;
    NSArray *fromYearArray;
    NSArray *toYearArray;
    
    // Search panels attributes
    bool searchWithImage;
    NSArray *distanceRangeArray;
    DistanceRange *distanceObj;
    NSString *fromYearString;
    NSString *toYearString;
    NSString *currentMinPriceString;
    NSString *currentMaxPriceString;
    NSInteger currentDistanceRangeID;
    
    CGSize tableDataSize;
    
    BOOL isSearching;
}

@end

@implementation BrowseCarAdsViewController
@synthesize tableView,currentModel;
@synthesize lastScrollPosition, tableContainer;
//@synthesize tableScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        searchWithImage=false;
        lastContentOffset=0;
        
        // Init search panels attributes
        searchBtnFlag=false;
        distanceObj=nil;
        fromYearString=@"";
        toYearString=@"";
        
        // Set the flags of the dropdown
        dropDownDistanceFlag=false;
        dropDownfromYearFlag=false;
        dropDowntoYearFlag=false;
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self.searchPanelView setHidden:YES];
    
    [self.adWithImageButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg4.png"] forState:UIControlStateNormal];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.searchPanelView addGestureRecognizer:tap];
    
    /*
    tapCloseSearch= [[UITapGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(dismissSearch)];
    [self.forTapping addGestureRecognizer:tapCloseSearch];
    */
    
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
    
    //hide the scrolling indicator
    [self.tableView setShowsVerticalScrollIndicator:NO];
    //[self.tableView setScrollEnabled:NO];
    tableDataSize = CGSizeZero;
    self.lastScrollPosition = CGPointZero;
    
    dataLoadedFromCache = NO;
    isRefreshing = NO;
    isSearching = NO;
    
    //set up the refresher
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(refreshAds:) forControlEvents:UIControlEventValueChanged];
    
    //load the first page of data
    [self loadFirstData];
    distanceRangeArray =  [[BrandsManager sharedInstance] getDistanceRangesArray];
    [self prepareDropDownLists];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //[self.tableView setScrollEnabled:NO];
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
    
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
    

}

- (void) viewWillDisappear:(BOOL)animated {
    
    self.lastScrollPosition = self.tableView.contentOffset;
    tableDataSize = self.tableView.contentSize;
    
    //cache the data
    if (carAdsArray && carAdsArray.count)
    {
        if (!isSearching)
        {
            if (currentModel)
                [[CarAdsManager sharedInstance] cacheDataFromArray:carAdsArray
                                                          forBrand:currentModel.brandID
                                                             Model:currentModel.modelID
                                                            InCity:[[SharedUser sharedInstance] getUserCityID]
                                                       tillPageNum:[[CarAdsManager sharedInstance] getCurrentPageNum]
                                                       forPageSize: [[CarAdsManager sharedInstance] getCurrentPageSize]];
            else
                [[CarAdsManager sharedInstance] cacheDataFromArray:carAdsArray
                                                          forBrand:-1
                                                             Model:-1
                                                            InCity:[[SharedUser sharedInstance] getUserCityID]
                                                       tillPageNum:[[CarAdsManager sharedInstance] getCurrentPageNum]
                                                       forPageSize: [[CarAdsManager sharedInstance] getCurrentPageSize]];
        }
    }
    
    [self.searchPanelView setHidden:YES];
    [self.searchImageButton setHidden:YES];
    searchBtnFlag=false;
    //[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (void) presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {

    NSLog(@"w = %f, h = %f", self.tableView.frame.size.width, self.tableView.frame.size.height);
    NSLog(@"content: w = %f, h = %f", self.tableView.contentSize.width, self.tableView.contentSize.height);
    NSLog(@"(%f, %f)", self.tableView.contentOffset.x, self.tableView.contentOffset.y);
    
    self.lastScrollPosition = self.tableView.contentOffset;
    tableDataSize = self.tableView.contentSize;
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
 */

/*
- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {

    NSLog(@"w = %f, h = %f", self.tableView.frame.size.width, self.tableView.frame.size.height);
    NSLog(@"w = %f, h = %f", self.tableView.frame.size.width, self.tableView.frame.size.height);
    NSLog(@"content: w = %f, h = %f", self.tableView.contentSize.width, self.tableView.contentSize.height);
    NSLog(@"(%f, %f)", self.tableView.contentOffset.x, self.tableView.contentOffset.y);
    
    self.lastScrollPosition = self.tableView.contentOffset;
    tableDataSize = self.tableView.contentSize;

    
    [super dismissViewControllerAnimated:flag completion:completion];
}
*/
#pragma mark - tableView handlig



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (carAdsArray)
    {
        return carAdsArray.count;
    }
    return 0;
}

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState {
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:favState];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CarAd * carAdObject;
    if ((carAdsArray) && (carAdsArray.count))
        carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    else{
        
        return [UITableViewCell new];
    }

    //ad with image
    if (carAdObject.thumbnailURL)
    {
        //store ad - with image
        if (carAdObject.storeID > 0)
        {
            
            CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdWithStoreCell" owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.helpButton addTarget:self action:@selector(featureAdSteps) forControlEvents:UIControlEventTouchUpInside];
            
            //customize the carAdCell with actual data
            [cell.detailsLabel setBackgroundColor:[UIColor clearColor]];
            [cell.detailsLabel setTextAlignment:SSTextAlignmentRight];
            [cell.detailsLabel setTextColor:[UIColor blackColor]];
            [cell.detailsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];

            cell.detailsLabel.text = carAdObject.title;
            
            [cell.carPriceLabel setBackgroundColor:[UIColor clearColor]];
            [cell.carPriceLabel setTextAlignment:SSTextAlignmentRight];
            [cell.carPriceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
            [cell.carPriceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:11.0] ];

            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPriceLabel.text = priceStr;
            else
                cell.carPriceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            cell.addTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            cell.yearLabel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            
            if (carAdObject.viewCount > 0)
                cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.watchingCountsLabel.text = @"";
                [cell.countOfViewsTinyImg setHidden:YES];
            }
            
            cell.carMileageLabel.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            
            
            
            //load image as URL
            /*
            [cell.carImage clear];
            cell.carImage.url = carAdObject.thumbnailURL;
            
            [cell.carImage showLoadingWheel];
            [asynchImgManager manage:cell.carImage];
             */
            
            [cell.carImage setImageWithURL:carAdObject.thumbnailURL
                           placeholderImage:[UIImage imageNamed:@"default-car.jpg"]];
            
            [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage setClipsToBounds:YES];
            
            //customize storeName
            [cell.showInStoreLabel setBackgroundColor:[UIColor clearColor]];
            [cell.showInStoreLabel setTextAlignment:SSTextAlignmentRight];
            [cell.showInStoreLabel setTextColor:[UIColor grayColor]];
            [cell.showInStoreLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
            cell.showInStoreLabel.text = @"معروض في متجر";

            [cell.storeNameLabel setBackgroundColor:[UIColor clearColor]];
            [cell.storeNameLabel setTextAlignment:SSTextAlignmentRight];
            [cell.storeNameLabel setTextColor:[UIColor grayColor]];
            [cell.storeNameLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:13.0] ];
            cell.storeNameLabel.text = carAdObject.storeName;
            
            //customize storeLogo
            if (carAdObject.storeLogoURL)
            {
                [cell.storeImage setHidden:NO];
                /*
                [cell.storeImage clear];
                cell.storeImage.url = carAdObject.storeLogoURL;
                [asynchImgManager manage:cell.storeImage];
                 */
                
                [cell.storeImage setImageWithURL:carAdObject.storeLogoURL];
                [cell.storeImage setContentMode:UIViewContentModeScaleToFill];
                [cell.storeImage setClipsToBounds:YES];
            }
            else
                [cell.storeImage setHidden:YES];
            
            //
            
            
            //check featured
            if (!carAdObject.isFeatured)
            {
                [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"Listing_special_bg.png"]];
                [cell.helpButton setHidden:NO];
                [cell.distingushingImage setHidden:NO];
                [cell.carPriceLabel setTextColor:[UIColor orangeColor]];
                [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
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
                    [cell.helpButton setHidden:YES];
                    [cell.specailButton setHidden:NO];
                    [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
                }
                
                //check favorite
                if (carAdObject.isFavorite)
                {
                    if (carAdObject.isFeatured) {
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    }
                    
                }
                else
                {
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                }
                
            }
            
            return cell;
        }
        
        //individual ad - with image
        else
        {
            CarAdCell * cell = (CarAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdCell" owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.helpButton addTarget:self action:@selector(featureAdSteps) forControlEvents:UIControlEventTouchUpInside];
            
            //customize the carAdCell with actual data
            //customize the carAdCell with actual data
            [cell.detailsLabel setBackgroundColor:[UIColor clearColor]];
            [cell.detailsLabel setTextAlignment:SSTextAlignmentRight];
            [cell.detailsLabel setTextColor:[UIColor blackColor]];
            [cell.detailsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
            
            cell.detailsLabel.text = carAdObject.title;
            
            [cell.carPriceLabel setBackgroundColor:[UIColor clearColor]];
            [cell.carPriceLabel setTextAlignment:SSTextAlignmentRight];
            [cell.carPriceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
            [cell.carPriceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:11.0] ];
            
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPriceLabel.text = priceStr;
            else
                cell.carPriceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            cell.addTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            cell.yearLabel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            
            if (carAdObject.viewCount > 0)
                cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.watchingCountsLabel.text = @"";
                [cell.countOfViewsTinyImg setHidden:YES];
            }
            cell.carMileageLabel.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            
            
            //load image as URL
            /*
            [cell.carImage clear];
            cell.carImage.url = carAdObject.thumbnailURL;
            
            [cell.carImage showLoadingWheel];
            
            [asynchImgManager manage:cell.carImage];
             */
            NSString* temp = [carAdObject.thumbnailURL absoluteString];
            
            if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                cell.carImage.image = [UIImage imageNamed:@"waitForApprove.png"];
            }else{
            [cell.carImage setImageWithURL:carAdObject.thumbnailURL
                          placeholderImage:[UIImage imageNamed:@"default-car.jpg"]];
            }
            [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
            [cell.carImage setClipsToBounds:YES];
            
            //
            
            //check featured
            if (carAdObject.isFeatured)
            {
                [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"Listing_special_bg.png"]];
                [cell.helpButton setHidden:NO];
                [cell.distingushingImage setHidden:NO];
                [cell.carPriceLabel setTextColor:[UIColor orangeColor]];
                [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
                
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
                    [cell.helpButton setHidden:YES];
                    [cell.specailButton setHidden:NO];
                    [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
                }
                //check favorite
                if (carAdObject.isFavorite)
                {
                    if (carAdObject.isFeatured) {
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    }
                    
                }
                else
                {
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                }
                
                
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
            CarAdWithStoreNoImageCell * cell = (CarAdWithStoreNoImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdWithStoreNoImageCell" owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.helpButton addTarget:self action:@selector(featureAdSteps) forControlEvents:UIControlEventTouchUpInside];
            
            //customize the carAdCell with actual data
            //customize the carAdCell with actual data
            [cell.detailsLabel setBackgroundColor:[UIColor clearColor]];
            [cell.detailsLabel setTextAlignment:SSTextAlignmentRight];
            [cell.detailsLabel setTextColor:[UIColor blackColor]];
            [cell.detailsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
            
            cell.detailsLabel.text = carAdObject.title;
            
            [cell.carPriceLabel setBackgroundColor:[UIColor clearColor]];
            [cell.carPriceLabel setTextAlignment:SSTextAlignmentRight];
            [cell.carPriceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
            [cell.carPriceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:11.0] ];
            

            
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPriceLabel.text = priceStr;
            else
                cell.carPriceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            
            cell.addTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            cell.yearLabel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            
            if (carAdObject.viewCount > 0)
                cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.watchingCountsLabel.text = @"";
                [cell.countOfViewsTinyImg setHidden:YES];
            }
            
            cell.carMileageLabel.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            
            //customize carAdObject.storeName
            [cell.showInStoreLabel setBackgroundColor:[UIColor clearColor]];
            [cell.showInStoreLabel setTextAlignment:SSTextAlignmentRight];
            [cell.showInStoreLabel setTextColor:[UIColor grayColor]];
            [cell.showInStoreLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
            cell.showInStoreLabel.text = @"معروض في متجر";
            
            [cell.storeNameLabel setBackgroundColor:[UIColor clearColor]];
            [cell.storeNameLabel setTextAlignment:SSTextAlignmentRight];
            [cell.storeNameLabel setTextColor:[UIColor grayColor]];
            [cell.storeNameLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:13.0] ];
            cell.storeNameLabel.text = carAdObject.storeName;

            
            //customize storeLogo
            if (carAdObject.storeLogoURL)
            {
                [cell.storeImage setHidden:NO];
                /*
                [cell.storeImage clear];
                cell.storeImage.url = carAdObject.storeLogoURL;
                [asynchImgManager manage:cell.storeImage];
                 */
                [cell.storeImage setImageWithURL:carAdObject.storeLogoURL];
                [cell.storeImage setContentMode:UIViewContentModeScaleToFill];
                [cell.storeImage setClipsToBounds:YES];
            }
            else
                [cell.storeImage setHidden:YES];
            
            //
            
            
            //check featured
            if (carAdObject.isFeatured)
            {
                [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"Listing2_nonphoto_bg_Sp.png"]];
                [cell.helpButton setHidden:NO];
                [cell.distingushingImage setHidden:NO];
                [cell.carPriceLabel setTextColor:[UIColor orangeColor]];
                [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
            }
            
            //check owner
            UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
            // Not logged in
            if(!savedProfile){
                [cell.favoriteButton setHidden:YES];
            }
            
            if (savedProfile)  //logged in
            {
                if (savedProfile.userID == carAdObject.ownerID) //is owner
                {
                    [cell.helpButton setHidden:YES];
                    [cell.specailButton setHidden:NO];
                    [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
                }
                
                //check favorite
                if (carAdObject.isFavorite)
                {
                    if (carAdObject.isFeatured) {
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    }
                    
                }
                else
                {
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                }
            }
            
            return cell;
        }
        
        //individual - no image
        else
        {
            CarAdNoImageCell * cell = (CarAdNoImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdNoImageCell" owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.helpButton addTarget:self action:@selector(featureAdSteps) forControlEvents:UIControlEventTouchUpInside];
            
            //customize the carAdCell with actual data
            //customize the carAdCell with actual data
            [cell.detailsLabel setBackgroundColor:[UIColor clearColor]];
            [cell.detailsLabel setTextAlignment:SSTextAlignmentRight];
            [cell.detailsLabel setTextColor:[UIColor blackColor]];
            [cell.detailsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
            
            cell.detailsLabel.text = carAdObject.title;
            
            [cell.carPriceLabel setBackgroundColor:[UIColor clearColor]];
            [cell.carPriceLabel setTextAlignment:SSTextAlignmentRight];
            [cell.carPriceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
            [cell.carPriceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:11.0] ];
            
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPriceLabel.text = priceStr;
            else
                cell.carPriceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            cell.addTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];
            cell.yearLabel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
            if (carAdObject.viewCount > 0)
                cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
            else
            {
                cell.watchingCountsLabel.text = @"";
                [cell.countOfViewsTinyImg setHidden:YES];
            }
            cell.carMileageLabel.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
            
            //
            
            //check featured
            if (carAdObject.isFeatured)
            {
                
                [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"Listing2_nonphoto_bg_Sp.png"]];
                [cell.helpButton setHidden:NO];
                [cell.distingushingImage setHidden:NO];
                [cell.carPriceLabel setTextColor:[UIColor orangeColor]];
                [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
                
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
                    [cell.helpButton setHidden:YES];
                    [cell.specailButton setHidden:NO];
                    [cell.favoriteButton setFrame:CGRectMake(cell.favoriteButton.frame.origin.x+36, cell.favoriteButton.frame.origin.y, cell.favoriteButton.frame.size.width, cell.favoriteButton.frame.size.height)];
                }
                //check favorite
                if (carAdObject.isFavorite)
                {
                    if (carAdObject.isFeatured) {
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    }
                    
                }
                else
                {
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                }
            }
            
            return cell;
        }
        
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    CarAdDetailsViewController * vc;
    
    if (carAdObject.thumbnailURL)   //ad with image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    
    else                            //ad with no image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
    
    vc.currentAdID =  carAdObject.adID;
    vc.parentVC = self;
    
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == ([self.tableView numberOfRowsInSection:0] - 1))
    {
        if (self.tableView.contentSize.height > self.tableView.frame.size.height)//to prevent continue loading if the page has returned less than 10 objects
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



# pragma mark - hide bars while scrolling
# pragma mark - custom methods

- (void) addToFavoritePressed:(id)sender event:(id)event {
    //get the tapping position on table to determine the tapped cell
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    //get the cell index path
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil) {
        [self handleAddToFavBtnForCellAtIndexPath:indexPath];
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
    if (currentModel)
        [self.modelNameLabel setText:currentModel.modelName];
    else
        [self.modelNameLabel setText:@"جميع السيارات"];
    
    //  add background to the toolbar
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Listing_bg.png"]]];
}

- (void) handleAddToFavBtnForCellAtIndexPath:(NSIndexPath *) indexPath {
    
    CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    
    if (!carAdObject.isFavorite)
    {
        if (carAdObject.thumbnailURL)
        {
            //store ad - with image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
            //individual ad - with image
            else
            {
                CarAdCell * cell = (CarAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
        }
        //ad with no image
        else
        {
            //store ad - no image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreNoImageCell * cell = (CarAdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
            //individual - no image
            else
            {
                CarAdNoImageCell * cell = (CarAdNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
        }
        //add from fav
        [[ProfileManager sharedInstance] addCarAd:carAdObject.adID toFavoritesWithDelegate:self];
    }
    else
    {
        if (carAdObject.thumbnailURL)
        {
            //store ad - with image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
            //individual ad - with image
            else
            {
                CarAdCell * cell = (CarAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
        }
        //ad with no image
        else
        {
            //store ad - no image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreNoImageCell * cell = (CarAdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
            //individual - no image
            else
            {
                CarAdNoImageCell * cell = (CarAdNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
        }
        //remove to fav
        [[ProfileManager sharedInstance] removeCarAd:carAdObject.adID fromFavoritesWithDelegate:self];
    }
}

- (void) handleFeaturingBtnForCellAtIndexPath:(NSIndexPath *) indexPath {
    
    //CarAd * carAdObject = (CarAd *)[carAdsArray objectAtIndex:indexPath.row];
    
    labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
    
    //COME BACK HERE
    
    //set the ad ID according to indexPath
    
    [self presentViewController:vc animated:YES completion:nil];
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

- (void) searchPageOfAds {
    dataLoadedFromCache = NO;
    isSearching = YES;
    
    //show loading indicator
    [self showLoadingIndicator];
    
    //load a page of data
    NSInteger page = [[CarAdsManager sharedInstance] nextPage];
    
    if (currentModel)
    {
        [self searchOfPage:page
                  forBrand:currentModel.brandID
                     Model:currentModel.modelID
                    InCity:[[SharedUser sharedInstance] getUserCityID]
                  textTerm:self.carNameText.text
                  minPrice:currentMinPriceString
                  maxPrice:currentMaxPriceString
           distanceRangeID:currentDistanceRangeID
                  fromYear:fromYearString
                    toYear:toYearString
                      area:@""
                   orderby:@""
             lastRefreshed:@""];
    }
    else
    {
        
        [self searchOfPage:page
                  forBrand:-1
                     Model:-1
                    InCity:[[SharedUser sharedInstance] getUserCityID]
                  textTerm:self.carNameText.text
                  minPrice:currentMinPriceString
                  maxPrice:currentMaxPriceString
           distanceRangeID:currentDistanceRangeID
                  fromYear:fromYearString
                    toYear:toYearString
                      area:@""
                   orderby:@""
             lastRefreshed:@""];
    }
    
    
}
- (void) loadPageOfAds {
    dataLoadedFromCache = NO;
    
    //show loading indicator
    [self showLoadingIndicator];
    
    //load a page of data
    NSInteger page = [[CarAdsManager sharedInstance] nextPage];
    //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
    
    if (currentModel)
        [[CarAdsManager sharedInstance] loadCarAdsOfPage:page forBrand:currentModel.brandID Model:currentModel.modelID InCity:[[SharedUser sharedInstance] getUserCityID] WithDelegate:self];
    else
        [[CarAdsManager sharedInstance] loadCarAdsOfPage:page forBrand:-1 Model:-1 InCity:[[SharedUser sharedInstance] getUserCityID] WithDelegate:self];
}

- (void) loadFirstData {
    NSArray * cachedArray;
    isSearching = NO;
    
    if (currentModel)
        cachedArray = [[CarAdsManager sharedInstance] getCahedDataForBrand:currentModel.brandID Model:currentModel.modelID InCity:[[SharedUser sharedInstance] getUserCityID]];
    else
        cachedArray = [[CarAdsManager sharedInstance] getCahedDataForBrand:-1 Model:-1 InCity:[[SharedUser sharedInstance] getUserCityID]];
    
    if (cachedArray && cachedArray.count)
    {
        
        NSInteger cachedPageNum;
        if (currentModel)
            cachedPageNum = [[CarAdsManager sharedInstance] getCahedPageNumForBrand:currentModel.brandID Model:currentModel.modelID InCity:[[SharedUser sharedInstance] getUserCityID]];
        else
            cachedPageNum = [[CarAdsManager sharedInstance] getCahedPageNumForBrand:-1 Model:-1 InCity:[[SharedUser sharedInstance] getUserCityID]];
        
        NSInteger cachedPageSize;
        if (currentModel)
            cachedPageSize = [[CarAdsManager sharedInstance] getCahedPageSizeForBrand:currentModel.brandID Model:currentModel.modelID InCity:[[SharedUser sharedInstance] getUserCityID]];
        else
            cachedPageSize = [[CarAdsManager sharedInstance] getCahedPageSizeForBrand:-1 Model:-1 InCity:[[SharedUser sharedInstance] getUserCityID]];
        
        [[CarAdsManager sharedInstance] setCurrentPageNum:cachedPageNum];
        [[CarAdsManager sharedInstance] setCurrentPageSize:cachedPageSize];
        [carAdsArray addObjectsFromArray:cachedArray];
        
        //refresh table data
        [self.tableView reloadData];
        //self.tableView.contentSize=CGSizeMake(320, self.tableView.contentSize.height);
        [self.tableView setContentOffset:CGPointZero animated:YES];
        
        dataLoadedFromCache = YES;
        
    }
    else
    {
        dataLoadedFromCache = NO;
        
        [[CarAdsManager sharedInstance] setCurrentPageNum:0];
        [[CarAdsManager sharedInstance] setPageSizeToDefault];
        [self loadPageOfAds];
    }
}

- (void) refreshAds:(ODRefreshControl *)refreshControl {

    
    //NSLog(@"refresher released!");
    //1- clear cache
    if (currentModel)
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
                                                    forPageSize: [[CarAdsManager sharedInstance] getCurrentPageSize]];
    
    //2- reset page identifiers
    [[CarAdsManager sharedInstance] setCurrentPageNum:0];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    
    
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

#pragma mark - keyboard handler
-(void)dismissKeyboard {
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];
    [dropDownDistance closeAnimation];
    [dropDownfromYear closeAnimation];
    [dropDowntoYear closeAnimation];
    dropDownDistanceFlag=false;
    dropDownfromYearFlag=false;
    dropDowntoYearFlag=false;
    
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
    // Init search panels attributes before next search
    searchWithImage=false;
    distanceObj=nil;
    fromYearString=@"";
    toYearString=@"";
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.searchPanelView.frame = CGRectMake(0,self.topBarView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) hideSearchPanel{
    [dropDownDistance closeAnimation];
    [dropDownfromYear closeAnimation];
    [dropDowntoYear closeAnimation];
    dropDownDistanceFlag=false;
    dropDownfromYearFlag=false;
    dropDowntoYearFlag=false;
    [UIView animateWithDuration:.5
                     animations:^{
                         self.searchPanelView.frame = CGRectMake(0,-self.searchPanelView.frame.size.height,self.searchPanelView.frame.size.width,self.searchPanelView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

- (void) hideSearchPanelAndShowLoading{
    [dropDownDistance closeAnimation];
    [dropDownfromYear closeAnimation];
    [dropDowntoYear closeAnimation];
    dropDownDistanceFlag=false;
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
                             [self showLoadingIndicator];
                         }
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
        [self showSearchPanel];
        [self.searchPanelView setHidden:NO];
        [self.searchImageButton setHidden:NO];
        
    }
    
    else {
        [self hideSearchPanel];
        [self.searchPanelView setHidden:YES];
        [self.searchImageButton setHidden:YES];
        
        
    }
    
    

}

- (IBAction)modelBtnPress:(id)sender {
    
    ModelsViewController *popover=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    popover.tagOfCallXib=1;

    
    [self presentViewController:popover animated:YES completion:nil];
    
}

- (IBAction)searchInPanelBtnPrss:(id)sender {
    
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];

    BOOL validYears ;
    //1- validate year values
    if (( ([fromYearString isEqualToString:@""])
         && (![toYearString isEqualToString:@""]))
        ||
        ( (![fromYearString isEqualToString:@""])
         && ([toYearString isEqualToString:@""])) )
        validYears = NO;
    else
    {
        validYears = [self validateStringYearsFrom:fromYearString To:toYearString];
    }
    
    if (!validYears)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال قيم سنوات صحيحة" delegateVC:self];
    }
    
    NSInteger from = self.lowerPriceText.text.integerValue;
    NSInteger to = self.higherPriceText.text.integerValue;
    
    BOOL validPrice = YES;
    //2- validate price values
    if (( ([self.lowerPriceText.text isEqualToString:@""])
         && (![self.higherPriceText.text isEqualToString:@""]))
        ||
        ( (![self.lowerPriceText.text isEqualToString:@""])
         && ([self.higherPriceText.text isEqualToString:@""])) )
        validPrice = NO;
    
    else if ((![self.lowerPriceText.text isEqualToString:@""])
             && (![self.higherPriceText.text isEqualToString:@""]))
    {
        
        validPrice = [self validatePriceFrom:from to:to];
    }
    
    if (!validPrice)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال قيم سعر صحيحة" delegateVC:self];
        return;
    }
    
    if ([self.lowerPriceText.text isEqualToString:@""])
        currentMinPriceString = self.lowerPriceText.text;
    else
        currentMinPriceString = [NSString stringWithFormat:@"%i", self.lowerPriceText.text.integerValue];
    
    if ([self.higherPriceText.text isEqualToString:@""])
        currentMaxPriceString = self.higherPriceText.text;
    else
        currentMaxPriceString = [NSString stringWithFormat:@"%i", self.higherPriceText.text.integerValue];
    
    //1- reset the pageNumber to 0 to start a new search
    [[CarAdsManager sharedInstance] setCurrentPageNum:0];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    
    NSInteger page = [[CarAdsManager sharedInstance] nextPage];
    
    currentDistanceRangeID = -1;
    if (distanceObj)
        currentDistanceRangeID = distanceObj.rangeID;
    
    
    //2- load search data
    if (currentModel)
    {
        isSearching = YES;
        [carAdsArray removeAllObjects];
        [self dismissSearchAndShowLoading];
        
        [self searchOfPage:page
                  forBrand:currentModel.brandID
                     Model:currentModel.modelID
                    InCity:[[SharedUser sharedInstance] getUserCityID]
                  textTerm:self.carNameText.text
                  minPrice:currentMinPriceString
                  maxPrice:currentMaxPriceString
           distanceRangeID:currentDistanceRangeID
                  fromYear:fromYearString
                    toYear:toYearString
                      area:@""
                   orderby:@""
             lastRefreshed:@""];
    }
    else
    {
        isSearching = YES;
        [carAdsArray removeAllObjects];
        [self dismissSearchAndShowLoading];

        [self searchOfPage:page
                  forBrand:-1
                     Model:-1
                    InCity:[[SharedUser sharedInstance] getUserCityID]
                  textTerm:self.carNameText.text
                  minPrice:currentMinPriceString
                  maxPrice:currentMaxPriceString
           distanceRangeID:currentDistanceRangeID
                  fromYear:fromYearString
                    toYear:toYearString
                      area:@""
                   orderby:@""
             lastRefreshed:@""];
    }
    
    
}

- (void) searchOfPage:(NSInteger) page
             forBrand:(NSInteger) brandID
                  Model:(NSInteger) modelID
                 InCity:(NSInteger) cityID
               textTerm:(NSString *) aTextTerm
               minPrice:(NSString *) aMinPriceString
               maxPrice:(NSString *) aMaxPriceString
        distanceRangeID:(NSInteger) aDistanceRangeID
               fromYear:(NSString *) aFromYearString
                 toYear:(NSString *) aToYearString
                   area:(NSString *) aArea
                orderby:(NSString *) orderByString
          lastRefreshed:(NSString *) lasRefreshedString {
    
    
    [[CarAdsManager sharedInstance] searchCarAdsOfPage:page
                                              forBrand:brandID
                                                 Model:modelID
                                                InCity:cityID
                                              textTerm:aTextTerm
                                              minPrice:aMinPriceString
                                              maxPrice:aMaxPriceString
                                       distanceRangeID:aDistanceRangeID
                                              fromYear:aFromYearString
                                                toYear:aToYearString
                                         adsWithImages:searchWithImage
                                          adsWithPrice:YES
                                                  area:aArea
                                               orderby:orderByString
                                         lastRefreshed:lasRefreshedString
                                          WithDelegate:self];
    
}

- (IBAction)clearInPanelBtnPrss:(id)sender {
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];

    [self.carNameText setText:@""];
    [self.lowerPriceText setText:@""];
    [self.higherPriceText setText:@""];
    [self.distanceRangeLabel setText:@"المسافة المقطوعة"];
    [self.fromYearLabel setText:@"من سنة "];
    [self.toYearLabel setText:@"إلى سنة"];
    [self.adWithImageButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg4.png"] forState:UIControlStateNormal];
    
    // Init search panels attributes
    searchWithImage=false;
    distanceObj=nil;
    fromYearString=@"";
    toYearString=@"";
    
}

- (IBAction)adWithImageBtnPrss:(id)sender {
    if(searchWithImage==false){
        [self.adWithImageButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg3.png"] forState:UIControlStateNormal];
        searchWithImage=true;
        
    }
    else{
        [self.adWithImageButton setBackgroundImage:[UIImage imageNamed:@"searchView_text_bg4.png"] forState:UIControlStateNormal];
        searchWithImage=false;
        
    }
}

- (IBAction)distanceBtnPrss:(id)sender {
    [self.carNameText resignFirstResponder];
    [self.lowerPriceText resignFirstResponder];
    [self.higherPriceText resignFirstResponder];
    if (dropDownDistanceFlag==false) {
        dropDownDistanceFlag=true;
        [dropDownDistance openAnimation];
    }
    else{
        dropDownDistanceFlag=false;
        [dropDownDistance closeAnimation];
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

#pragma mark - CarAdsManager Delegate methods

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
}

- (void) adsDidFinishLoadingWithData:(NSArray *)resultArray {
    //1- hide the loading indicator
    
    if (isRefreshing)
    {
        isRefreshing = NO;
        [refreshControl endRefreshing];
    }
    
    //2- append the newly loaded ads
    if (resultArray && resultArray.count)
    {
        [self.nocarImg setHidden:YES];
        [self.tableContainer setHidden:NO];
        for (CarAd * newAd in resultArray)
        {
            NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:newAd.adID inArray:carAdsArray];
            if (index == -1)
                [carAdsArray addObject:newAd];
        }
    }
    else
    {
        if ((!carAdsArray) || (carAdsArray.count == 0))
        {
            [self.nocarImg setHidden:NO];
            [self.tableContainer setHidden:YES];
        }
    }
    
    //3- refresh table data
    [self.tableView reloadData];
    //self.tableView.contentSize=CGSizeMake(320, self.tableView.contentSize.height);
    if ([carAdsArray count] <= 10 && [carAdsArray count] != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
    
    [self hideLoadingIndicator];
    
}

#pragma mark - favorites Delegate methods
- (void) FavoriteFailAddingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        CarAd * carAdObject = [carAdsArray objectAtIndex:index];
        if (carAdObject.thumbnailURL)
        {
            //store ad - with image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
            //individual ad - with image
            else
            {
                CarAdCell * cell = (CarAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
        }
        //ad with no image
        else
        {
            //store ad - no image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreNoImageCell * cell = (CarAdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
            //individual - no image
            else
            {
                CarAdNoImageCell * cell = (CarAdNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
                
            }
        }
    }
}

- (void) FavoriteDidAddWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        CarAd * carAdObject = [carAdsArray objectAtIndex:index];
        if (carAdObject.thumbnailURL)
        {
            //store ad - with image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//added successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
            }
            //individual ad - with image
            else
            {
                CarAdCell * cell = (CarAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//added successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
            }
        }
        //ad with no image
        else
        {
            //store ad - no image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreNoImageCell * cell = (CarAdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//added successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
            }
            //individual - no image
            else
            {
                CarAdNoImageCell * cell = (CarAdNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//added successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
            }
        }
    }
}

- (void) FavoriteFailRemovingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        CarAd * carAdObject = [carAdsArray objectAtIndex:index];
        if (carAdObject.thumbnailURL)
        {
            //store ad - with image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
            //individual ad - with image
            else
            {
                CarAdCell * cell = (CarAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
        }
        //ad with no image
        else
        {
            //store ad - no image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreNoImageCell * cell = (CarAdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
            //individual - no image
            else
            {
                CarAdNoImageCell * cell = (CarAdNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                if (carAdObject.isFeatured)
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                else
                    [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                
                
            }
        }
    }
    
}

- (void) FavoriteDidRemoveWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:carAdsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        CarAd * carAdObject = [carAdsArray objectAtIndex:index];
        if (carAdObject.thumbnailURL)
        {
            //store ad - with image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreCell * cell = (CarAdWithStoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//removed successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
            }
            //individual ad - with image
            else
            {
                CarAdCell * cell = (CarAdCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//removed successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
            }
        }
        //ad with no image
        else
        {
            //store ad - no image
            if (carAdObject.storeID > 0)
            {
                CarAdWithStoreNoImageCell * cell = (CarAdWithStoreNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//removed successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
            }
            //individual - no image
            else
            {
                CarAdNoImageCell * cell = (CarAdNoImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (resultStatus)//removed successfully
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:NO];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_special_heart"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [(CarAd *)[carAdsArray objectAtIndex:index] setIsFavorite:YES];
                    if (carAdObject.isFeatured)
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_special_heart.png"] forState:UIControlStateNormal];
                    else
                        [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
                    
                }
            }
        }
    }
    
}

#pragma - mark drop down handler

- (void) prepareDropDownLists{
    distanseArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<distanceRangeArray.count; i++) {
        [distanseArray addObject:[[distanceRangeArray objectAtIndex:i] rangeName]];
        
    }
    fromYearArray = [[BrandsManager sharedInstance] getYearsArray];
    toYearArray = [[BrandsManager sharedInstance] getYearsArray];
    
    dropDownDistance=[[DropDownView alloc] initWithArrayData:distanseArray imageData:nil checkMarkData:-1 cellHeight:30 heightTableView:100 paddingTop:43 paddingLeft:0 paddingRight:0 refView:self.distanceButton animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2 _tag:1];
	dropDownDistance.delegate = self;
	[self.view addSubview:dropDownDistance.view];
	//[self.distanceButton setTitle:[dataArray objectAtIndex:0] forState:UIControlStateNormal];
    
    
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
            [self.distanceRangeLabel setText:[distanseArray objectAtIndex:returnIndex ]];
            distanceObj=(DistanceRange*)[distanceRangeArray objectAtIndex:returnIndex];
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
        default:
            break;
    }
    
}

@end
