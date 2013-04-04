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

@interface BrowseCarAdsViewController ()

@end

@implementation BrowseCarAdsViewController
@synthesize tableView,currentModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setButtonsToToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView handlig
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CarAdCell * cell = (CarAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarAdCell" owner:self options:nil] objectAtIndex:0];
    [cell.favoriteButton addTarget:self action:@selector(addToFavoritePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.specailButton addTarget:self action:@selector(distinguishButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarAdDetailsViewController *vc=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    //vc.carPhotos;
    //vc.carDetails;
    [self presentViewController:vc animated:YES completion:nil];

    
}

# pragma mark - hide bars while scrolling

- (void) scrollViewDidScroll:(UITableView *)sender {
    if (sender.contentOffset.y == 0){
        [UIView animateWithDuration:.25
                         animations:^{
                             self.topBarView.frame = CGRectMake(0,0,self.topBarView.frame.size.width,self.topBarView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        CGSize screenBounds = [[UIScreen mainScreen] bounds].size;
        [UIView animateWithDuration:.25
                         animations:^{
                             self.contentView.frame = CGRectMake(0,self.topBarView.frame.size.height,screenBounds.width,screenBounds.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        

    }

    else {
    [UIView animateWithDuration:.25
                     animations:^{
                         self.topBarView.frame = CGRectMake(0,-self.topBarView.frame.size.height,self.topBarView.frame.size.width,self.topBarView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
        CGSize screenBounds = [[UIScreen mainScreen] bounds].size;
        [UIView animateWithDuration:.25
                         animations:^{
                             self.contentView.frame = CGRectMake(0,0,screenBounds.width,screenBounds.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];

        
    }
}
# pragma mark - custom methods

- (void) addToFavoritePressed{
    // Code of add car ad to user favorite
}

- (void) distinguishButtonPressed{
    // Code of distiguish car ad 
}

- (void) setButtonsToToolbar{
    
    //  set the model label name
    [self.modelNameLabel setText:currentModel.modelName];

    //  add background to the toolbar
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Listing_navigation_bg.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
}

#pragma mark - actions
- (IBAction)homeBtnPress:(id)sender {
    ChooseActionViewController *homeVC=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:homeVC animated:YES completion:nil];
}

- (IBAction)searchBtnPress:(id)sender {
}

- (IBAction)modelBtnPress:(id)sender {
    
    ModelsViewController *popover=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    [self presentViewController:popover animated:YES completion:nil];

}
@end
