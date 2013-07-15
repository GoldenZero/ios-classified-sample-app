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

@interface CarsInGalleryViewController (){
    NSArray *adsArray;
    MBProgressHUD2 *loadingHUD;
    gallariesManager *manager;
    float xForShiftingTinyImg;
}

@end

@implementation CarsInGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        adsArray=[NSArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"carInGalleryCell" bundle:nil]
         forCellReuseIdentifier:@"CustomCell"];
    
    manager = [gallariesManager sharedInstance];
    [manager setCurrentPageNum:0];
    [manager setPageSizeToDefault];
    
    //customize the gallery data
    [self.galleryNameLabel setText:self.gallery.StoreName];
    [self.galleryPhoneLabel setText:[NSString stringWithFormat:@"%@",self.gallery.StoreContactNo]];
    
    
    [self.galleryImage setImageWithURL:self.gallery.StoreImageURL placeholderImage:[UIImage imageNamed:@"default-car.jpg"]];
    
    //NSData *data = [NSData dataWithContentsOfURL:[self.gallery StoreImageURL]];
    //self.galleryImage.image=[UIImage imageWithData:data];
    
    
    //load ads in the gallery
    [self loadPageOfData];
    
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.gallery StoreContactNo]]]];
}


#pragma mark - tableView delegate handler

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    xForShiftingTinyImg = 0;
    static NSString *CellIdentifier = @"CustomCell";
    
    carInGalleryCell *cell =(carInGalleryCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[carInGalleryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    GalleryAd * adObject = [adsArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:event:) forControlEvents:UIControlEventTouchUpInside];

    
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
        [cell.cellBackgoundImage setImage:[UIImage imageNamed:@"Listing2_nonphoto_bg_Sp.png"]];
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
                [cell.favoriteButton setImage:[UIImage imageNamed:@"orange_heart.png"] forState:UIControlStateNormal];
            }
            else{
                [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_orang_heart.png"] forState:UIControlStateNormal];
            }
            
        }
        else
        {
            if (adObject.isFeatured){
                [cell.favoriteButton setImage:[UIImage imageNamed:@"blank_heart.png"] forState:UIControlStateNormal];
                
                
            }
            else{
                [cell.favoriteButton setImage:[UIImage imageNamed:@"Listing_icon_heart"] forState:UIControlStateNormal];
                
            }
        }
    }
    
    
    /*
    [cell.favoriteButton addTarget:self action:@selector(favoriteButton:event:) forControlEvents:UIControlEventTouchUpInside];
    CarDetails *temp =(CarDetails*)[adsArray objectAtIndex:indexPath.row] ;
    
    cell.watchingCountsLabel.text= [NSString stringWithFormat:@"%d", [temp viewCount]];
    cell.yearLabel.text= [NSString stringWithFormat:@"%d", [temp modelYear]];
    cell.carMileageLabel.text=[NSString stringWithFormat:@"%d", [temp distanceRangeInKm]];
    if (temp.isFeatured) {
        cell.distingushingImage.hidden=NO;
        cell.cellBackgoundImage.image=[UIImage imageNamed:@"Listing2_nonphoto_bg_Sp.png"];
    }
    
    NSData *data = [NSData dataWithContentsOfURL:[temp thumbnailURL]];
    cell.imageView.image=[UIImage imageWithData:data];
    
    cell.detailsLabel.text=[temp description];
    cell.carPriceLabel.text=[NSString stringWithFormat:@"%f %@", [temp price],[temp currencyString]];
     */
    
    return cell;
    
    
}

/*
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarDetails * adObject = (CarDetails *)[adsArray objectAtIndex:indexPath.row];
    CarAdDetailsViewController * vc;
 
    if (adObject.thumbnailURL)   //ad with image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    
    else                            //ad with no image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
    
    vc.currentAdID =  adObject.adID;
    // vc.parentVC = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (adsArray && adsArray.count)
        return [adsArray count];
    else
        return 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom <= height)
    {
        [self loadPageOfData];
    }
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

- (void) addToFavoritePressed:(id)sender event:(id)event {
    //get the tapping position on table to determine the tapped cell
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    //get the cell index path
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil) {
        //  [self handleAddToFavBtnForCellAtIndexPath:indexPath];
    }
}

#pragma mark - laoding indicator handling
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

#pragma mark - CarsInGallery Delegate methods
- (void) carsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
}


- (void) carsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    if (resultArray && resultArray.count) {
        
        adsArray = resultArray;
        
        [self.tableView reloadData];
    }
    else {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    }
}

@end
