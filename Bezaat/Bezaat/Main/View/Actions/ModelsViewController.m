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
#import "AddNewCarAdViewController.h"

#import "BrowseCarAdsViewController.h"

#define ALL_MODELS_TEXT     @"جميع الموديلات"

@interface ModelsViewController ()
{
    BOOL oneSelectionMade;
}
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
        if (self.tagOfCallXib!=2) {
            /*if (indexPath.row == 0)
            {
                [brandCell.imgSelected  setImage:[UIImage imageNamed:@"Brands2_allcars_button.png"]];
                [brandCell.imgUnselected  setImage:[UIImage imageNamed:@"Brands2_allcars_button.png"]];
            }*/
            if ((!oneSelectionMade) && (indexPath.row == 1))
                [brandCell selectCell];
        }
        else{
            if ((!oneSelectionMade) && (indexPath.row == 0))
                [brandCell selectCell];
        }
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
        return 58;
    }
    else {
        return 41;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblBrands) {
        
        oneSelectionMade = YES;
        
        // Mark this brand as selected and all the others as not selected
        for (int counter=0; counter<[tableView numberOfRowsInSection:0]; counter++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:counter inSection:0] ;
            [(BrandCell*)[tableView cellForRowAtIndexPath:index] unselectCell];
        }
        
        BrandCell* cell = (BrandCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell selectCell];
        
        // Reload the models table
        Brand* selectedBrand = (Brand*)currentBrands[indexPath.row];
        if (self.tagOfCallXib!=2) {
            // create an extra item for 'all models'
            Model * allModelsItem = [[Model alloc] init];
            allModelsItem.modelID = -1;
            allModelsItem.brandID = selectedBrand.brandID;
            allModelsItem.modelName = ALL_MODELS_TEXT;
            
            //create an array that has the 'all models' item first
            NSMutableArray * tempArray = [NSMutableArray arrayWithObject:allModelsItem];
            
            //add the rest of models for this brand
            [tempArray addObjectsFromArray:selectedBrand.models];
            currentModels = tempArray;

        }
        
        //currentModels = selectedBrand.models;
        if (selectedBrand.models!=nil) {
            [_tblModels reloadData];
        }
        else{
            /*
                BrowseCarAdsViewController *carAdsMenu=[[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController" bundle:nil];
                carAdsMenu.currentModel=nil;
                [self presentViewController:carAdsMenu animated:YES completion:nil];
*/
        }
    
    }
    else {
        // Get the model
        Model* selectedModel = (Model*)currentModels[indexPath.row];
       
        // TODO pass this information to the next view
        if (self.tagOfCallXib==2) {
            AddNewCarAdViewController *adNewCar=[[AddNewCarAdViewController alloc] initWithNibName:@"AddNewCarAdViewController" bundle:nil];
            adNewCar.currentModel=selectedModel;
            [self presentViewController:adNewCar animated:YES completion:nil];
        }
        else{
            BrowseCarAdsViewController *carAdsMenu=[[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController" bundle:nil];
            carAdsMenu.currentModel=selectedModel;
            [self presentViewController:carAdsMenu animated:YES completion:nil];
        }
       
        
    }
}

- (IBAction)btnCloseTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Brands Manager Delegate

- (void) didFinishLoadingWithData:(NSArray*) resultArray {
    
    // Add new car ad call this xib
    if (self.tagOfCallXib==2) {
        currentBrands=resultArray;
        currentModels=((Brand*)resultArray[0]).models;
    }
    
    // Browse car ads call this xib
    else{
        // create an extra item for 'all barnds'
        Brand * allBrandsItem = [[Brand alloc] init];
        allBrandsItem.brandID = -1;
        allBrandsItem.models=nil;
        
        //create an array that has the 'all brands' item first
        NSMutableArray * tempBrandsArray = [NSMutableArray arrayWithObject:allBrandsItem];
        
        //add the rest of models for this brand
        [tempBrandsArray addObjectsFromArray:resultArray];
        currentBrands = tempBrandsArray;
        
        // create an extra item for 'all models'
        Model * allModelsItem = [[Model alloc] init];
        allModelsItem.modelID = -1;
        allModelsItem.brandID = ((Brand*)resultArray[0]).brandID;
        allModelsItem.modelName = ALL_MODELS_TEXT;
        
        //create an array that has the 'all models' item first
        NSMutableArray * tempArray = [NSMutableArray arrayWithObject:allModelsItem];
        
        //add the rest of models for this brand
        [tempArray addObjectsFromArray:((Brand*)resultArray[0]).models];
        currentModels = tempArray;

        
    }
        
    //currentModels = ((Brand*)resultArray[0]).models;
    
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
    
    if (self.tagOfCallXib == 2) {
        [self.allBrandsBtn setHidden:NO];
        [self.allCarsBtn setHidden:YES];
    }
    // Get the brands and models
    if ((!currentBrands) || (!currentModels))
    {
        // Show the loading indicator
        [MBProgressHUD2 showHUDAddedTo:self.view
                                  text:@"جاري تحميل الموديلات"
                          detailedText:@"الرجاء الانتظار"
                              animated:YES];
        if (self.tagOfCallXib==2) {
            [[BrandsManager sharedInstance] getBrandsAndModelsForPostAdWithDelegate:self];
        }
        else{
            [[BrandsManager sharedInstance] getBrandsAndModelsWithDelegate:self];
        }
        
    }
    
    else if ((currentBrands) && (!currentBrands.count))
    {
        // Show the loading indicator
        [MBProgressHUD2 showHUDAddedTo:self.view
                                  text:@"جاري تحميل الموديلات"
                          detailedText:@"الرجاء الانتظار"
                              animated:YES];
        if (self.tagOfCallXib==2) {
            [[BrandsManager sharedInstance] getBrandsAndModelsForPostAdWithDelegate:self];
        }
        else{
            [[BrandsManager sharedInstance] getBrandsAndModelsWithDelegate:self];
        }

    }
    
    else if ((currentModels) && (!currentModels.count))
    {
        // Show the loading indicator
        [MBProgressHUD2 showHUDAddedTo:self.view
                                  text:@"جاري تحميل الموديلات"
                          detailedText:@"الرجاء الانتظار"
                              animated:YES];
        if (self.tagOfCallXib==2) {
            [[BrandsManager sharedInstance] getBrandsAndModelsForPostAdWithDelegate:self];
        }
        else{
            [[BrandsManager sharedInstance] getBrandsAndModelsWithDelegate:self];
        }

    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"Choose Model";
    self.tblModels.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
            
        {
            self.tblModels.frame=CGRectMake(self.tblModels.frame.origin.x, self.tblModels.frame.origin.y, self.tblModels.frame.size.width ,self.tblModels.frame.size.height);
            self.blackBgImgV.frame=CGRectMake(self.blackBgImgV.frame.origin.x, self.blackBgImgV.frame.origin.y, self.blackBgImgV.frame.size.width ,self.blackBgImgV.frame.size.height);
            self.blueBgImgV.frame=CGRectMake(self.blueBgImgV.frame.origin.x, self.blueBgImgV.frame.origin.y, self.blueBgImgV.frame.size.width ,self.blueBgImgV.frame.size.height);
        }
        
        else
            
        {
             self.tblModels.frame=CGRectMake(self.tblModels.frame.origin.x, self.tblModels.frame.origin.y, self.tblModels.frame.size.width ,self.tblModels.frame.size.height+90);
            self.blackBgImgV.frame=CGRectMake(self.blackBgImgV.frame.origin.x, self.blackBgImgV.frame.origin.y, self.blackBgImgV.frame.size.width ,self.blackBgImgV.frame.size.height+90);
            self.blueBgImgV.frame=CGRectMake(self.blueBgImgV.frame.origin.x, self.blueBgImgV.frame.origin.y, self.blueBgImgV.frame.size.width ,self.blueBgImgV.frame.size.height+90);
        }
    }

    [self.tblBrands setBackgroundColor:[UIColor clearColor]];
    //[self.tblModels setBackgroundColor:[UIColor clearColor]];
    oneSelectionMade = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)allCarsInvoked:(id)sender {
    
    BrowseCarAdsViewController *carAdsMenu=[[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController" bundle:nil];
    carAdsMenu.currentModel=nil;
    [self presentViewController:carAdsMenu animated:YES completion:nil];
}
@end
