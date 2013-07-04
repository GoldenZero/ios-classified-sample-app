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
@interface CarsInGalleryViewController (){
    NSArray *adsArray;
    MBProgressHUD2 *loadingHUD;
    gallariesManager *manager;
}

@end

@implementation CarsInGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        adsArray=[[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"exhibitCell" bundle:nil]
         forCellReuseIdentifier:@"CustomCell"];
        manager=[gallariesManager sharedInstance];
    [self showLoadingIndicator];
    [self.galleryNameLabel setText:self.gallery.StoreName];
    [self.galleryPhoneLabel setText:[NSString stringWithFormat:@"%@",self.gallery.StoreContactNo]];
    
    NSData *data = [NSData dataWithContentsOfURL:[self.gallery StoreImageURL]];
    
    self.galleryImage.image=[UIImage imageWithData:data];
    

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

- (IBAction)phoneBtnPrss:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.gallery StoreContactNo]]]];
}


#pragma mark - tableView delegate handler
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarAdDetailsViewController *vc=[[CarAdDetailsViewController alloc] initWithNibName:@"" bundle:nil];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [adsArray count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

#pragma mark - loading data handler
- (void) loadData{
    if (![GenericMethods connectedToInternet])
    {
        [manager getGallariesWithDelegate:self];
        return;
    }
    
}

- (void)didFinishLoadingWithData:(NSArray *)resultArray{
    adsArray=resultArray;
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
