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
    NSMutableArray *adsArray;
    MBProgressHUD2 *loadingHUD;
    gallariesManager *manager;
    int pageNum;
}

@end

@implementation CarsInGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        adsArray=[[NSMutableArray alloc] init];
        pageNum=1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"carInGalleryCell" bundle:nil]
         forCellReuseIdentifier:@"CustomCell"];
        manager=[gallariesManager sharedInstance];
    [self showLoadingIndicator];
    [self.galleryNameLabel setText:self.gallery.StoreName];
    [self.galleryPhoneLabel setText:[NSString stringWithFormat:@"%@",self.gallery.StoreContactNo]];
    
    NSData *data = [NSData dataWithContentsOfURL:[self.gallery StoreImageURL]];
    
    self.galleryImage.image=[UIImage imageWithData:data];
    

    [self loadData:pageNum];

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
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%d",[self.gallery StoreContactNo]]]];
}


#pragma mark - tableView delegate handler
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CustomCell";
    
    carInGalleryCell *cell =(carInGalleryCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[carInGalleryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
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
    return cell;

    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarDetails * carAdObject = (CarDetails *)[adsArray objectAtIndex:indexPath.row];
    CarAdDetailsViewController * vc;
    
    if (carAdObject.thumbnailURL)   //ad with image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    
    else                            //ad with no image
        vc = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
    
    vc.currentAdID =  carAdObject.adID;
   // vc.parentVC = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [adsArray count];
    
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
        pageNum++;
        [self loadData:pageNum];
    }
}

#pragma mark - loading data handler
- (void) loadData:(int) pageNumber{
    if (![GenericMethods connectedToInternet])
    {
        /*
        [manager getCarsInGalleryWithDelegateOfPage:pageNumber forStore:(int)[self.gallery StoreID] Country:*[self.gallery CountryID] pageSize:10 WithDelegate:self];
        return;
         */
    }
    
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

- (void)didFinishLoadingWithData:(NSArray *)resultArray{
    [adsArray addObjectsFromArray:resultArray];
    [self.tableView reloadData];
    [self hideLoadingIndicator];

    
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

@end
