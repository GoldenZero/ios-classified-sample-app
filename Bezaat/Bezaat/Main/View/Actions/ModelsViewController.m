//
//  ModelsViewController.m
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ModelsViewController.h"

@interface ModelsViewController ()

@end

@implementation ModelsViewController

#pragma mark UITableView Methods
#pragma mark -

#pragma mark -
#pragma mark UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // The 0 section is for sub categories and the 1 is for the ads
    if (section == 0) {
        return [categories count];
    }
    else {
        return [ads count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Two sections (0 for sub categories and 1 for ads)
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Choose the cell identifier according to the section
    NSString* cellID = (indexPath.section == 0) ? @"CategoryCell" : @"AdCell";
    NSString* cellNameToLoad = (indexPath.section == 0) ? @"CategoryCellView" : @"AdCellView";
    // Get a used cell or build a new one
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellNameToLoad owner:self options:nil][0];
    }
    
    if (indexPath.section == 0) {
        // Get the current category item
        Category* currentItem = categories[indexPath.row];
        
        // Force the cell to be a Category cell
        CategoryCell* categoryCell = (CategoryCell*)cell;
        
        // Set the values of the UI controls
        categoryCell.lblTitle.text = currentItem.name;
        categoryCell.lblAdsCount.text = [NSString stringWithFormat:@"%d", currentItem.adsCount];
    }
    else {
        // Get the current ad item
        Ad* currentItem = ads[indexPath.row];
        
        // Force the cell to be an Ad cell
        AdCell* adCell = (AdCell*)cell;
        [adCell reloadViewWithData:currentItem];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.0f;
    }
    else {
        return 100.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Get the clicked item
        Category* clickedCategory = categories[indexPath.row];
        
        // Build the ads controller and pass the clicked category to it
        CategoriesViewController* childsController = [[CategoriesViewController alloc] init];
        childsController.parentCategory = clickedCategory;
        
        // Show the new controller
        [self.navigationController pushViewController:childsController animated:YES];
    }
    else {
        // Get the clicked item
        Ad* ad = ads[indexPath.row];
        
        // Build the ad details controller and pass the clicked ad to it
        AdDetailsViewController* adDetails = [[AdDetailsViewController alloc] init];
        adDetails.ad = ad;
        
        // Show the new controller
        [self.navigationController pushViewController:adDetails animated:YES];
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.parentType == nil) {
        // Build a label for the section header
        UILabel* lblTitle = [[UILabel alloc] init];
        
        // Set the background color to transparent
        lblTitle.backgroundColor = [UIColor clearColor];
        
        // Set the label's size to fill the header
        CGRect frame = lblTitle.frame;
        frame.size.width = tableView.frame.size.width;
        lblTitle.frame = frame;
        
        // Set the text alignment to center
        lblTitle.textAlignment = UITextAlignmentCenter;
        
        // Set the text of the label
        if (section == 0) {
            lblTitle.text = @"Sub Categories";
        }
        else {
            lblTitle.text = @"Ads";
        }
        
        return lblTitle;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.parentType == nil) {
        return 50.0f;
    }
    
    return 10.0f;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_background"]];
}

#pragma mark UIViewController Methods
#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
