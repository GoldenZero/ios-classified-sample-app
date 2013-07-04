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
    manager=[gallariesManager sharedInstance];
    manager.countryID=self.countryID;
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
   
    static NSString *CellIdentifier = @"CustomCell";

    exhibitCell *cell =(exhibitCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[exhibitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.numberButton addTarget:self action:@selector(callNumber:event:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger *temp =[(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row] StoreContactNo] ;
    [cell.numberLabel setText:[NSString stringWithFormat:@"%d",temp]];
    cell.exhibNameLabel.text=[(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row] StoreName] ;
    cell.exhibDetailLabel.text=[(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row] StoreOwnerEmail] ;
    
    NSData *data = [NSData dataWithContentsOfURL:[(CarsGallery*)[galleriesArray objectAtIndex:indexPath.row] StoreImageURL]];

    cell.imageView.image=[UIImage imageWithData:data];
    
    return cell;
    
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
}

#pragma mark - gallaries manager delegate 
- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    
    galleriesArray=resultArray;
    [self.tableView reloadData];
    [self hideLoadingIndicator];
}

- (void) loadData{
    if (![GenericMethods connectedToInternet])
    {
        [manager getGallariesWithDelegate:self];
        return;
    }

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
@end
