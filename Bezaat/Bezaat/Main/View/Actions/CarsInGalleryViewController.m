//
//  CarsInGalleryViewController.m
//  Bezaat
//
//  Created by Syrisoft on 7/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarsInGalleryViewController.h"
#import "MBProgressHUD2.h"
#import "CarAdDetailsViewController.h"
#import "CarAd.h"
#import "CarDetails.h"
#import "carInGalleryCell.h"
#import "AddNewCarAdViewController_iPad.h"

@interface CarsInGalleryViewController (){
    NSMutableArray *adsArray;
    MBProgressHUD2 *loadingHUD;
    gallariesManager *manager;
    float xForShiftingTinyImg;
    bool userDidScroll;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    BOOL iPad_buyCarSegmentBtnChosen;
    BOOL iPad_addCarSegmentBtnChosen;
    BOOL iPad_browseGalleriesSegmentBtnChosen;
    BOOL iPad_addStoreSegmentBtnChosen;
}

@end

@implementation CarsInGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        adsArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDidScroll = NO;
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        //customize the noAdsLabel
        [self.noAdsLabel setBackgroundColor:[UIColor clearColor]];
        [self.noAdsLabel setTextAlignment:SSTextAlignmentCenter];
        [self.noAdsLabel setTextColor:[UIColor grayColor]];
        [self.noAdsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:20.0] ];
        [self.noAdsLabel setText:@"لا يوجد إعلانات في هذا المتجر"];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"carInGalleryCell" bundle:nil]
         forCellReuseIdentifier:@"CustomCell"];
    }
    else
        [self.tableView registerNib:[UINib nibWithNibName:@"carInGalleryCell_iPad" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    manager = [gallariesManager sharedInstance];
    [manager setCurrentPageNum:0];
    [manager setPageSizeToDefault];
    
    //customize the gallery data
    [self.galleryNameLabel setText:self.gallery.StoreName];
    [self.galleryPhoneLabel setText:[NSString stringWithFormat:@"%@",self.gallery.StoreContactNo]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //self.iPad_countOfAdsLabel.text = @"";
        self.iPad_galleryDescriptionLabel.text = self.gallery.Description;
        
        iPad_buyCarSegmentBtnChosen = YES;
        iPad_addCarSegmentBtnChosen = NO;
        iPad_browseGalleriesSegmentBtnChosen = NO;
        iPad_addStoreSegmentBtnChosen = NO;
    }
        
    
    [self.galleryImage setImageWithURL:self.gallery.StoreImageURL placeholderImage:[UIImage imageNamed:@"default-car.jpg"]];
    
    //load ads in the gallery
    [self loadPageOfData];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    userDidScroll = NO;
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)homeBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)phoneBtnPrss:(id)sender {
    /*
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%d",[self.gallery StoreContactNo]]]];
     */
    
    if ((self.gallery) && !([self.gallery.StoreContactNo isEqualToString:@""])) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"هل تريد الاتصال بهذا الرقم؟\n%@",self.gallery.StoreContactNo] delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"إلغاء", nil];
        alert.tag = 101;
        [alert show];
        return;
    }
    
}

- (IBAction)iPad_smsBtnPrss:(id)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"Hello";
		controller.recipients = [NSArray arrayWithObjects:self.gallery.StoreContactNo, nil];
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
}

#pragma mark - SMS delegate handler
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"بيزات" message:@"Unknown Error"
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			break;
        }
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView Delegate methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            // call
            NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",self.gallery.StoreContactNo];
            NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
            [[UIApplication sharedApplication] openURL:phoneURL];
            
        }
        else if (buttonIndex == 1) {
            // ignore
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
        }
    }
}

#pragma mark - tableView delegate handler

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (adsArray && adsArray.count) {
        
        xForShiftingTinyImg = 0;
        static NSString *CellIdentifier = @"CustomCell";
        carInGalleryCell *cell;
        
        cell=(carInGalleryCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell=[[carInGalleryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        GalleryAd * adObject = [adsArray objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [cell.iPad_phoneBtn addTarget:self action:@selector(phoneBtnPrss:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.iPad_smsBtn addTarget:self action:@selector(iPad_smsBtnPrss:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.detailsLabel.text = adObject.title;
        
        NSString * priceStr = [GenericMethods formatPrice:adObject.price];
        if ([priceStr isEqualToString:@""])
            cell.carPriceLabel.text = priceStr;
        else
            cell.carPriceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, adObject.currencyString];
        cell.addTimeLabel.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:adObject.postedOnDate];
        
        //hiding & shifting
        if (adObject.modelYear > 0)
            cell.yearLabel.text = [NSString stringWithFormat:@"%i", adObject.modelYear];
        else {
            xForShiftingTinyImg = cell.yearTinyImg.frame.origin.x;
            
            cell.yearLabel.hidden = YES;
            cell.yearTinyImg.hidden = YES;
        }
        
        if (xForShiftingTinyImg > 0) {
            CGRect tempLabelFrame = cell.carMileageLabel.frame;
            CGRect tempImgFrame = cell.carMileageTinyImg.frame;
            
            
            tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
            tempImgFrame.origin.x = xForShiftingTinyImg;
            
            
            [UIView animateWithDuration:0.3f animations:^{
                
                [cell.carMileageTinyImg setFrame:tempImgFrame];
                [cell.carMileageLabel setFrame:tempLabelFrame];
            }];
            
            xForShiftingTinyImg = tempLabelFrame.origin.x - 5 - cell.countOfViewsTinyImg.frame.size.width;
        }
        
        if (adObject.distanceRangeInKm != -1)
            //if (adObject.distanceRangeInKm != 0)
            cell.carMileageLabel.text = [NSString stringWithFormat:@"%i KM", adObject.distanceRangeInKm];
        else {
            xForShiftingTinyImg = cell.carMileageTinyImg.frame.origin.x;
            
            cell.carMileageLabel.hidden = YES;
            cell.carMileageTinyImg.hidden = YES;
        }
        
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
        
        if (adObject.viewCount > 0)
            cell.watchingCountsLabel.text = [NSString stringWithFormat:@"%i", adObject.viewCount];
        else
        {
            cell.watchingCountsLabel.text = @"";
            [cell.countOfViewsTinyImg setHidden:YES];
        }
        
        
        NSString* temp = [adObject.thumbnailURL absoluteString];
        
        if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
            cell.carImage.image = [UIImage imageNamed:@"waitForApprove.png"];
        }else{
            [cell.carImage setImageWithURL:adObject.thumbnailURL
                          placeholderImage:[UIImage imageNamed:@"default-car.jpg"]];
        }
        [cell.carImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.carImage setClipsToBounds:YES];
        
        
        //check featured
        if (adObject.isFeatured)
        {
            //[cell.cellBackgoundImage setImage:[UIImage imageNamed:@"Listing2_nonphoto_bg_Sp.png"]];
            
            [cell.cellBackgoundImage setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing2_nonphoto_bg_Sp.png" : @"tb_ads_view_orange_box.png")]];
            cell.cellBackgoundImage.frame = CGRectMake(cell.cellBackgoundImage.frame.origin.x, cell.cellBackgoundImage.frame.origin.y, cell.cellBackgoundImage.frame.size.width, cell.cellBackgoundImage.frame.size.height);
            
            [cell.distingushingImage setHidden:NO];
            [cell.carPriceLabel setTextColor:[UIColor orangeColor]];
            [cell.favoriteButton setHidden:NO];
            
        }
        
        //check owner
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        // Not logged in
        if(!savedProfile){
            [cell.favoriteButton setHidden:YES];
            
        }
        
        if (savedProfile)   //logged in
        {
            if (savedProfile.userID == adObject.ownerID) //is owner
                [cell.favoriteButton setHidden:YES];
            
            //check favorite
            if (adObject.isFavorite)
            {
                if (adObject.isFeatured) {
                    [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"orange_heart.png" : @"tb_car_brand_orange_like.png")] forState:UIControlStateNormal];
                }
                else{
                    [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_orang_heart.png" : @"tb_car_brand_blue_like.png")] forState:UIControlStateNormal];
                }
                
            }
            else
            {
                if (adObject.isFeatured){
                    [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"blank_heart.png" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
                }
                else {
                    [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_icon_heart" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
                }
            }
        }
        return cell;
    }
    return [UITableViewCell new];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GalleryAd * adObject = (GalleryAd *)[adsArray objectAtIndex:indexPath.row];
    CarAdDetailsViewController * vc;
    
    if (adObject.thumbnailURL) {   //ad with image
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
    
    vc.currentAdID =  adObject.adID;
    vc.secondParentVC = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (adsArray && adsArray.count)
        return [adsArray count];
    else
        return 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == ([self.tableView numberOfRowsInSection:0] - 1)) && (userDidScroll))
    {
        if (adsArray && adsArray.count)
        {
            CGFloat heightDiff = self.tableView.contentSize.height - self.tableView.frame.size.height;
            
            int separatorHeight = 5;//extra value for separating
            CGFloat minDiff = 110 + separatorHeight;
            
            
            if (heightDiff > minDiff)//to prevent continue loading if the page has returned less than 10 objects
            {
                [self loadPageOfData];
            }
        }
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /*
     CGFloat height = scrollView.frame.size.height;
     
     CGFloat contentYoffset = scrollView.contentOffset.y;
     
     CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
     
     if(distanceFromBottom <= height)
     {
     [self loadPageOfData];
     }
     */
    
    if (scrollView == self.tableView)
        userDidScroll = YES;
}




#pragma mark - loading data handler
- (void) loadPageOfData {
    
    [self showLoadingIndicator];
    
    NSInteger page = [manager nextPage];
    
    [manager getCarAdsOfPage:page forStore:self.gallery.StoreID InCountry:self.gallery.CountryID WithDelegate:self];
    
    
    /*
     if (![GenericMethods connectedToInternet])
     {
     
     [manager getCarsInGalleryWithDelegateOfPage:pageNumber forStore:(int)[self.gallery StoreID] Country:*[self.gallery CountryID] pageSize:10 WithDelegate:self];
     return;
     
     }
     */
    
}

#pragma mark - laoding indicator handling

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

#pragma mark - CarsInGallery Delegate methods

- (void) carsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
}


- (void) carsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    userDidScroll = NO;
    
    if (resultArray && resultArray.count) {
        
        //adsArray = resultArray;
        [adsArray addObjectsFromArray:resultArray];
        
        [self.tableView reloadData];
        
        NSMutableArray * URLsToPrefetch = [NSMutableArray new];
        for (GalleryAd * newAd in resultArray)
        {
            if (newAd.thumbnailURL)
                [URLsToPrefetch addObject:[NSURL URLWithString:newAd.thumbnailURL.absoluteString]];
        }
        
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:URLsToPrefetch];
        
    }

    if ((!adsArray) || (!adsArray.count)) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.backgroundImageView setHidden:YES];
            [self.noAdsLabel setHidden:NO];
            [self.noAdsImageView setHidden:NO];
        }
    }
}

#pragma mark - helper methods

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

- (void) handleAddToFavBtnForCellAtIndexPath:(NSIndexPath *) indexPath {
    
    
    GalleryAd * adObject = (GalleryAd *)[adsArray objectAtIndex:indexPath.row];
    
    if (!adObject.isFavorite)
    {
        carInGalleryCell * cell = (carInGalleryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (adObject.isFeatured) {
            [cell.favoriteButton setImage:[UIImage imageNamed:@"orange_heart.png"] forState:UIControlStateNormal];
        }
        else{
            [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
        }
        
        //add to fav
        [[ProfileManager sharedInstance] addCarAd:adObject.adID toFavoritesWithDelegate:self];
    }
    
    else
    {
        [(GalleryAd *)[adsArray objectAtIndex:indexPath.row] setIsFavorite:NO];
        
        carInGalleryCell * cell = (carInGalleryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (adObject.isFeatured){
            [cell.favoriteButton setImage:[UIImage imageNamed:@"blank_heart.png"] forState:UIControlStateNormal];
            
        }
        else {
            [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
        }
        
        //remove to fav
        [[ProfileManager sharedInstance] removeCarAd:adObject.adID fromFavoritesWithDelegate:self];
    }
}

- (NSInteger) getIndexOfGalleryAd:(NSInteger) adID  InArray:(NSArray *) galleryAdsArray {
    
    if (!galleryAdsArray)
        return -1;
    
    for (int index = 0; index < galleryAdsArray.count; index ++)
    {
        GalleryAd * obj = [galleryAdsArray objectAtIndex:index];
        if (obj.adID == adID)
            return index;
    }
    return -1;
}

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState {
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    if (index > -1)
    {
        [(GalleryAd *)[adsArray objectAtIndex:index] setIsFavorite:favState];
    }
}

- (void) removeAdWithAdID:(NSUInteger) adID {
    NSInteger index = [[CarAdsManager sharedInstance] getIndexOfAd:adID inArray:adsArray];
    [adsArray removeObjectAtIndex:index];
    [self.tableView reloadData];
}

#pragma mark - favorites Delegate methods

- (void) FavoriteFailAddingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [self getIndexOfGalleryAd:adID InArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        GalleryAd * adObject = [adsArray objectAtIndex:index];
        
        carInGalleryCell * cell = (carInGalleryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (adObject.isFeatured) {
            [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"blank_heart.png" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
        }
        else {
            [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_icon_heart" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
        }
        
    }
}

- (void) FavoriteDidAddWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [self getIndexOfGalleryAd:adID InArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        GalleryAd * adObject = [adsArray objectAtIndex:index];
        
        carInGalleryCell * cell = (carInGalleryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (resultStatus)//added successfully
        {
            [(GalleryAd *)[adsArray objectAtIndex:index] setIsFavorite:YES];
            if (adObject.isFeatured) {
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"orange_heart.png" : @"tb_car_brand_orange_like.png")] forState:UIControlStateNormal];
            }
            else{
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_orang_heart.png" : @"tb_car_brand_blue_like.png")] forState:UIControlStateNormal];
            }
            
        }
        else
        {
            [(GalleryAd *)[adsArray objectAtIndex:index] setIsFavorite:NO];
            if (adObject.isFeatured) {
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"blank_heart.png" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
            }
            else {
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_icon_heart" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
            }
            
        }
        
    }
}

- (void) FavoriteFailRemovingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    NSInteger index = [self getIndexOfGalleryAd:adID InArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        GalleryAd * adObject = [adsArray objectAtIndex:index];
        
        carInGalleryCell * cell = (carInGalleryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (adObject.isFeatured) {
            [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"orange_heart.png" : @"tb_car_brand_orange_like.png")] forState:UIControlStateNormal];
        }
        else {
            [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_orang_heart.png" : @"tb_car_brand_blue_like.png")] forState:UIControlStateNormal];
        }
    }
    
}

- (void) FavoriteDidRemoveWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    NSInteger index = [self getIndexOfGalleryAd:adID InArray:adsArray];
    if (index > -1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        GalleryAd * adObject = [adsArray objectAtIndex:index];
        
        carInGalleryCell * cell = (carInGalleryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (resultStatus)//removed successfully
        {
            [(GalleryAd *)[adsArray objectAtIndex:index] setIsFavorite:NO];
            if (adObject.isFeatured){
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"blank_heart.png" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
            }
            else {
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_icon_heart" : @"tb_search_result_like.png")] forState:UIControlStateNormal];
            }
            
        }
        else
        {
            [(GalleryAd *)[adsArray objectAtIndex:index] setIsFavorite:YES];
            if (adObject.isFeatured) {
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"orange_heart.png" : @"tb_car_brand_orange_like.png")] forState:UIControlStateNormal];
            }
            else {
                [cell.favoriteButton setImage:[UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Listing_orang_heart.png" : @"tb_car_brand_blue_like.png")] forState:UIControlStateNormal];
            }
            
        }
    }
    
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
