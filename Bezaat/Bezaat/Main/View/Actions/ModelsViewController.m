//
//  ModelsViewController.m
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ModelsViewController.h"

#import "BrandCell.h"
#import "ModelCell.h"

#import "Brand.h"
#import "Model.h"

#import "BrowseCarAdsViewController.h"
@interface ModelsViewController ()

@end

@implementation ModelsViewController

#pragma mark -
#pragma mark UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tblBrands) {
        return currentBrands.count;
    }
    else {
        return currentModels.count;        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Choose the cell nib file to load
    NSString* cellNameToLoad = (tableView == _tblBrands) ? @"BrandCell" : @"ModelCell";
    
    // Build a new cell
    UITableViewCell* cell = [[NSBundle mainBundle] loadNibNamed:cellNameToLoad owner:self options:nil][0];

    if (tableView == _tblBrands) {
        // Get the current brand item
        Brand* currentItem = currentBrands[indexPath.row];
        
        // Update the cell information
        BrandCell* brandCell = (BrandCell*)cell;
        [brandCell reloadInformation:currentItem];
    }
    else {
        // Get the current model item
        Model* currentItem = currentModels[indexPath.row];
        
        // Update the cell information
        ModelCell* modelCell = (ModelCell*)cell;
        [modelCell reloadInformation:currentItem];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblBrands) {
        return 130;
    }
    else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblBrands) {
        // Mark this brand as selected and all the others as not selected
        for (int counter=0; counter<[tableView numberOfRowsInSection:0]; counter++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:counter inSection:0] ;
            [(BrandCell*)[tableView cellForRowAtIndexPath:index] unselectCell];
        }
        
        BrandCell* cell = (BrandCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell selectCell];
        
        // Reload the models table
        Brand* selectedBrand = (Brand*)currentBrands[indexPath.row];
        currentModels = selectedBrand.models;
        [_tblModels reloadData];
    }
    else {
        // Get the model
        Model* selectedModel = (Model*)currentModels[indexPath.row];
       
        // TODO pass this information to the next view
        BrowseCarAdsViewController *carAdsMenu=[[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController" bundle:nil];
        carAdsMenu.currentModel=selectedModel;
        [self presentViewController:carAdsMenu animated:YES completion:nil];
        
    }
}

- (IBAction)btnCloseTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark Brands Manager Delegate
#pragma mark -

- (void) didFinishLoadingWithData:(NSArray*) resultArray {
    // Update the information
    currentBrands = resultArray;
    currentModels = ((Brand*)resultArray[0]).models;
    
    // Reload the tables
    [_tblBrands reloadData];
    [_tblModels reloadData];
    
    [MBProgressHUD2 hideHUDForView:self.view animated:YES];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Show the loading indicator
    [MBProgressHUD2 showHUDAddedTo:self.view
                              text:@"جاري تحميل الموديلات"
                      detailedText:@"الرجاء الانتظار"
                          animated:YES];
    
    // Get the brands and models
    [[BrandsManager sharedInstance] loadBrandsAndModelsWithDelegate:self];
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
