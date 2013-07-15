//
//  ExhibitViewController.m
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ExhibitViewController.h"
#import "exhibitCell.h"
#import "MBProgressHUD2.h"
#import "CarsGallery.h"
#import "gallariesManager.h"
#import "CarsInGalleryViewController.h"

@interface ExhibitViewController (){
    NSArray *galleriesArray;
    MBProgressHUD2 * loadingHUD;
    gallariesManager *manager;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"exhibitCell" bundle:nil]
         forCellReuseIdentifier:@"CustomCell"];
    manager = [gallariesManager sharedInstance];
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
    
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    
    
    //get the cell index path
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row] StoreContactNo]]]];
        
    }
    
}

#pragma mark - TableView delegates handler

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
        cell.exhibDetailLabel.text = gallery.StoreOwnerEmail ;
        
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
    CarsInGalleryViewController *vc=[[CarsInGalleryViewController alloc] initWithNibName:@"CarsInGalleryViewController" bundle:nil];
    vc.gallery=(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
    
    //NSLog(@"storeID = %i, countryID = %i", vc.gallery.StoreID, vc.gallery.CountryID);
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

#pragma mark - Galleries Delegate methods
- (void) galleriesDidFailLoadingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    [self hideLoadingIndicator];
}

- (void) galleriesDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    
    if (resultArray && resultArray.count) {
        
        galleriesArray = resultArray;
        
        [self.tableView reloadData];
    }
    else {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    }
    
}
@end
