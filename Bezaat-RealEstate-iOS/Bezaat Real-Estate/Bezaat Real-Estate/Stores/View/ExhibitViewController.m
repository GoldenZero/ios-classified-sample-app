//
//  ExhibitViewController.m
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ExhibitViewController.h"
#import "exhibitCell.h"
#import "exhibitCell_iPad.h"
#import "MBProgressHUD2.h"
#import "CarsGallery.h"
#import "gallariesManager.h"
#import "CarsInGalleryViewController.h"

@interface ExhibitViewController (){
    NSArray *galleriesArray;
    MBProgressHUD2 * loadingHUD;
    gallariesManager *manager;
    NSString * currentPhone2Call;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}

@end

@implementation ExhibitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        galleriesArray=[[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.tableView registerNib:[UINib nibWithNibName:@"exhibitCell" bundle:nil]
         forCellReuseIdentifier:@"CustomCell"];
    else {
        if (self.iPad_titleLabel) {
            [self.iPad_titleLabel setBackgroundColor:[UIColor clearColor]];
            [self.iPad_titleLabel setTextAlignment:SSTextAlignmentCenter];
            [self.iPad_titleLabel setTextColor:[UIColor whiteColor]];
            [self.iPad_titleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:30.0] ];
            [self.iPad_titleLabel setText:@"معارض السيارات"];
        }
        
        [self.iPad_collectionView registerNib:[UINib nibWithNibName:@"exhibitCell_iPad" bundle:nil] forCellWithReuseIdentifier:@"CustomCell_iPad"];
    }
    manager = [gallariesManager sharedInstance];
    currentPhone2Call = @"";
    //manager.countryID=self.countryID;
    [self showLoadingIndicator];
    [self loadData];
    
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

- (void) callNumber:(id)sender event:(id)event {
    //get the tapping position on table to determine the tapped cell
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition;
    NSIndexPath *indexPath;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        currentTouchPosition = [touch locationInView:self.tableView];
        indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    }
    else {
        //currentTouchPosition = [touch locationInView:self.iPad_collectionView];
        indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    }
    
    if (indexPath != nil) {
        /*
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row] StoreContactNo]]]];
        */
        CarsGallery * gallery;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            gallery = (CarsGallery*)[galleriesArray objectAtIndex:indexPath.row];
        else
            gallery = (CarsGallery*)[galleriesArray objectAtIndex:indexPath.item];
        
        if ((gallery) && !([gallery.StoreContactNo isEqualToString:@""])) {
            currentPhone2Call = gallery.StoreContactNo;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"هل تريد الاتصال بهذا الرقم؟\n%@",gallery.StoreContactNo] delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 101;
            [alert show];
            return;
        }
    }
    
}

#pragma mark - UIAlertView Delegate methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            // call
            NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",currentPhone2Call];
            NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
            [[UIApplication sharedApplication] openURL:phoneURL];
            
        }
        else if (buttonIndex == 1) {
            // ignore
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
        }
        currentPhone2Call = @"";
    }else  if (alertView.tag == 4) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TableView delegates handler

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (galleriesArray && galleriesArray.count)
        return 110;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (galleriesArray && galleriesArray.count) {
        
        static NSString *CellIdentifier = @"CustomCell";
        
        CarsGallery * gallery = (CarsGallery*)[galleriesArray objectAtIndex:indexPath.row];
        
        exhibitCell *cell =(exhibitCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell=[[exhibitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numberButton addTarget:self action:@selector(callNumber:event:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.numberLabel setText:gallery.StoreContactNo];
        
        cell.exhibNameLabel.text = gallery.StoreName ;
        cell.exhibDetailLabel.text = gallery.Description ;
        
        if (gallery.StoreImageURL) {
            [cell.exhibImage setImageWithURL:gallery.StoreImageURL];
            [cell.exhibImage setContentMode:UIViewContentModeScaleAspectFill];
            [cell.exhibImage setClipsToBounds:YES];
        }
        
        
        return cell;
    }
    
    return [UITableViewCell new];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [galleriesArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarsInGalleryViewController *vc;
    vc=[[CarsInGalleryViewController alloc] initWithNibName:@"CarsInGalleryViewController" bundle:nil];
    vc.gallery=(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
    
    //NSLog(@"storeID = %i, countryID = %i", vc.gallery.StoreID, vc.gallery.CountryID);
}

#pragma mark - collection view delegate methods

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (galleriesArray && galleriesArray.count)
        return galleriesArray.count;
    
    return 0;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0f;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(468.0, 230.0);
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (galleriesArray && galleriesArray.count) {
        
        static NSString *CellIdentifier = @"CustomCell_iPad";
        
        CarsGallery * gallery = (CarsGallery*)[galleriesArray objectAtIndex:indexPath.item];
        
        exhibitCell_iPad *cell =(exhibitCell_iPad*) [self.iPad_collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell=[[exhibitCell_iPad alloc] init];
        }
        
        [cell.numberButton addTarget:self action:@selector(callNumber:event:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.numberLabel setText:gallery.StoreContactNo];
        
        cell.exhibNameLabel.text = gallery.StoreName ;
        cell.exhibDetailLabel.text = gallery.Description ;
        
        if (gallery.StoreImageURL) {
            [cell.exhibImage setImageWithURL:gallery.StoreImageURL placeholderImage:[UIImage imageNamed:@"iPad_exhibit_default.png"]];
            //[cell.exhibImage setContentMode:UIViewContentModeScaleAspectFill];
            //[cell.exhibImage setClipsToBounds:YES];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    return [UICollectionViewCell new];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CarsInGalleryViewController *vc;
    vc=[[CarsInGalleryViewController alloc] initWithNibName:@"CarsInGalleryViewController_iPad" bundle:nil];
    vc.gallery=(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void) loadData{
    /*
     if (![GenericMethods connectedToInternet])
     {
     [manager getGallariesInCountry:self.countryID WithDelegate:self];
     return;
     }
     */
    [manager getGallariesInCountry:[[SharedUser sharedInstance] getUserCountryID] WithDelegate:self];
    
}

#pragma mark - Loading indicator
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

#pragma mark - Galleries Delegate methods
- (void) galleriesDidFailLoadingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    [self hideLoadingIndicator];
    currentPhone2Call = @"";
}

- (void) galleriesDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    currentPhone2Call = @"";
    
    if (resultArray && resultArray.count) {
        
        galleriesArray = resultArray;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [self.tableView reloadData];
        else
            [self.iPad_collectionView reloadData];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لا يوجد وسطاء في هذا البلد"
                                                        delegate:self
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil];
        alert.tag = 4;
        [alert show];
    }
    
}

@end
