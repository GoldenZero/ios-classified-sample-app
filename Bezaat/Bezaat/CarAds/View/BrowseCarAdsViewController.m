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
    return 190;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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

# pragma mark - custom methods

- (void) addToFavoritePressed{
    // Code of add car ad to user favorite
}

- (void) distinguishButtonPressed{
    // Code of distiguish car ad 
}

- (void) searchBtnPressed{
    
}

- (void) homeBtnPressed{
    ChooseActionViewController *homeVC=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:homeVC animated:YES completion:nil];
    
}

- (void) modelBtnPressed{
    ModelsViewController *popover=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    [self presentViewController:popover animated:YES completion:nil];
}

- (void) setButtonsToToolbar{
    
    // 1- set search button
    UIImage * searchBtnImg = [UIImage imageNamed:@""];
    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [searchBtn setImage:searchBtnImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    // 2- set home button
    UIImage * homeBtnImg = [UIImage imageNamed:@""];
    UIButton * homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [homeBtn setImage:homeBtnImg forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * homeButton = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];

    // 3- set model button
    UIImage * modelBtnImg = [UIImage imageNamed:@""];
    UIButton * modelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [modelBtn setImage:modelBtnImg forState:UIControlStateNormal];
    [modelBtn addTarget:self action:@selector(modelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * modelButton = [[UIBarButtonItem alloc] initWithCustomView:modelBtn];
    
    // 4- set the model label name
    [self.modelNameLabel setText:currentModel.modelName];
    
    // 5- adding buttons too the toolbar
    NSArray * items = [NSArray arrayWithObjects:searchButton,homeButton,modelButton, nil];
    [self.toolBar setItems:items];
    
    // 6- add background to the toolbar
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@""] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
}
@end
