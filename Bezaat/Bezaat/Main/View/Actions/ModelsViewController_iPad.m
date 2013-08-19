//
//  ModelsViewController_iPad.m
//  Bezaat
//
//  Created by Roula Misrabi on 8/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ModelsViewController_iPad.h"
#import "BrandCell.h"
#import "ModelCell.h"
#import "ChooseModelView_iPad.h"
#import "Brand.h"
#import "Model.h"
#import "AddNewCarAdViewController.h"
#import "AddNewStoreAdViewController.h"
#import "BrowseCarAdsViewController.h"

#define ALL_MODELS_TEXT     @"جميع الموديلات"

@interface ModelsViewController_iPad ()
{
    BOOL oneSelectionMade;
    Brand * choosenBrand;
    NSMutableArray * brandCellsArray;
    //NSMutableArray * brandsTapGesturesArray;
    //NSMutableArray * modelsTapGesturesArray;
    ChooseModelView_iPad * dropDownView;
}
@end

@implementation ModelsViewController_iPad

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
	
    self.trackedViewName = @"Choose Model";
    brandCellsArray = [NSMutableArray new];
    //brandsTapGesturesArray = [NSMutableArray new];
    //modelsTapGesturesArray = [NSMutableArray new];
    oneSelectionMade = NO;
    dropDownView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    /*
     if ((currentBrands && currentBrands.count) && (currentModels && currentModels.count))
     {
     if (lastBrandSelectedRow > -1)
     {
     oneSelectionMade = YES;
     selectedBrandIndexPath = [NSIndexPath indexPathForRow:lastBrandSelectedRow inSection:0];
     [_tblBrands selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastBrandSelectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
     [_tblBrands scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastBrandSelectedRow inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
     BrandCell * brandCell = (BrandCell *)[_tblBrands cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastBrandSelectedRow inSection:0]];
     choosenBrand=(Brand*)currentBrands[lastBrandSelectedRow];
     [brandCell selectCell];
     }
     }
     */
}

#pragma mark - Brands Manager Delegate

- (void) didFinishLoadingWithData:(NSArray*) resultArray {
    
    // Add new car ad call this xib
    if (self.tagOfCallXib==2) {
        currentBrands=resultArray;
        currentModels=((Brand*)resultArray[0]).models;
        //if (lastBrandSelectedRow > -1)
        //currentModels=((Brand*)resultArray[lastBrandSelectedRow]).models;
        //else
        //currentModels=((Brand*)resultArray[0]).models;
    }
    
    // Browse car ads call this xib
    else {
        currentBrands = resultArray;
        
        // create an extra item for 'all models'
        Model * allModelsItem = [[Model alloc] init];
        allModelsItem.modelID = -1;
        allModelsItem.brandID = ((Brand*)resultArray[0]).brandID;
        /*
         if (lastBrandSelectedRow > -1)
         allModelsItem.brandID = ((Brand*)resultArray[lastBrandSelectedRow]).brandID;
         else
         allModelsItem.brandID = ((Brand*)resultArray[0]).brandID;
         */
        allModelsItem.modelName = ALL_MODELS_TEXT;
        
        //create an array that has the 'all models' item first
        NSMutableArray * tempArray = [NSMutableArray arrayWithObject:allModelsItem];
        [tempArray addObjectsFromArray:((Brand*)resultArray[0]).models];
        /*
         //add the rest of models for this brand
         if (lastBrandSelectedRow > -1)
         [tempArray addObjectsFromArray:((Brand*)resultArray[lastBrandSelectedRow]).models];
         else
         [tempArray addObjectsFromArray:((Brand*)resultArray[0]).models];
         */
        
        currentModels = tempArray;
        
        
    }
    
    //currentModels = ((Brand*)resultArray[0]).models;
    choosenBrand=(Brand*)[currentBrands objectAtIndex:0];
    
    [MBProgressHUD2 hideHUDForView:self.view animated:YES];
    
    [self DrawBrands];
}

#pragma mark - helper methods

- (void) DrawBrands {
    float currentX = 0;
    float currentY = 0;
    float totalHeight = 0;
    
    int rowCounter = 0;
    int colCounter = 0;
    
    CGRect brandFrame = CGRectMake(-1, -1, 114, 114);//these are the dimensions of the brand cell
    
    for (int i = 0; i < currentBrands.count; i++) {
        Brand * currentItem = currentBrands[i];
        
        // Update the cell information
        BrandCell* brandCell = (BrandCell*)[[NSBundle mainBundle] loadNibNamed:@"BrandCell_iPad" owner:self options:nil][0];;
        [brandCell reloadInformation:currentItem];
        
        if ((choosenBrand) && (choosenBrand.brandID == currentItem.brandID))
            [brandCell selectCell];
        
        if ((!oneSelectionMade) && (i == 0))
            [brandCell selectCell];
        
        
        if (i != 0) {
            if (i % 5 == 0) {
                rowCounter ++;
                colCounter = 0;
            }
            else
                colCounter ++;
        }
        
        
        currentX = (colCounter * brandFrame.size.width) + ((colCounter + 1) * 5);
        //currentY = (rowCounter * brandFrame.size.height) + ((rowCounter + 1) * 5);
        currentY = (rowCounter * brandFrame.size.height);
        
        
        brandFrame.origin.x = currentX;
        brandFrame.origin.y = currentY;
        
        brandCell.frame = brandFrame;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectBrandCell:)];
        tap.numberOfTapsRequired = 1;
        [brandCell addGestureRecognizer:tap];
        
        
        
        [self.scrollView addSubview:brandCell];
        [brandCellsArray addObject:brandCell];
        //[brandsTapGesturesArray addObject:tap];
        
    }
    totalHeight = 5 + brandFrame.size.height + currentY + 15;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, totalHeight)];
}

- (void) didSelectBrandCell:(id) sender {
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *) sender;
    BrandCell * senderCell = (BrandCell *) tap.view;
    
    if (dropDownView) {
        
        if (dropDownView.owner == senderCell)//selecting the same cell
            return;
        
        for (int i = 0; i < brandCellsArray.count; i++) {
            BrandCell * cell = (BrandCell *) brandCellsArray[i];
            
            if (cell.imgBrand.image != senderCell.imgBrand.image)
                [cell unselectCell];
        }
        
        if (dropDownView.frame.origin.y != ((senderCell.frame.origin.y + senderCell.frame.size.height))) {
            
            //1- remove the view
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
                //move up
                for (BrandCell * cell in brandCellsArray) {
                    if (cell.frame.origin.y > dropDownView.owner.frame.origin.y) {
                        CGRect tempFrame = cell.frame;
                        tempFrame.origin.y = tempFrame.origin.y - dropDownView.frame.size.height - 12;
                        cell.frame = tempFrame;
                    }
                }
                
                [dropDownView removeFromSuperview];
                dropDownView = nil;
                
            } completion:^(BOOL completed) {
                
                [senderCell selectCell];
                
                CGRect newDropDownFrame = CGRectMake(5, (senderCell.frame.origin.y + senderCell.frame.size.height), 590.0f, 200.0f);
                
                dropDownView = (ChooseModelView_iPad *)[[NSBundle mainBundle] loadNibNamed:@"ChooseModelView_iPad" owner:self options:nil][0];
                
                dropDownView.owner = senderCell;
                dropDownView.frame = newDropDownFrame;
                
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    //[UIView animateWithDuration:1.0f animations:^{
                    
                    [self.scrollView addSubview:dropDownView];
                    //move down
                    for (BrandCell * cell in brandCellsArray) {
                        if (cell.frame.origin.y > senderCell.frame.origin.y) {
                            
                            CGRect tempFrame = cell.frame;
                            tempFrame.origin.y = tempFrame.origin.y + newDropDownFrame.size.height + 12;
                            cell.frame = tempFrame;
                        }
                    }
                    
                } completion:nil];
                int i = [self locateBrandCell:senderCell];
                if (i == -1)
                    return ;
                
                [dropDownView DrawModels:[(Brand *)currentBrands[i] models]];
            }];
        }
        else { // a drop down on the same row --> just change the frame
            [senderCell selectCell];
            for (int i = 0; i < brandCellsArray.count; i++) {
                BrandCell * cell = (BrandCell *) brandCellsArray[i];
                
                if (cell.imgBrand.image != senderCell.imgBrand.image)
                    [cell unselectCell];
            }
            
            CGRect newDropDownFrame = CGRectMake(5, (senderCell.frame.origin.y + senderCell.frame.size.height), 590.0f, 200.0f);
            
            dropDownView.owner = senderCell;
            dropDownView.frame = newDropDownFrame;
            
            int i = [self locateBrandCell:senderCell];
            if (i == -1)
                return ;
            
            [dropDownView DrawModels:[(Brand *)currentBrands[i] models]];
            
        }
    }
    else {
        [senderCell selectCell];
        
        for (int i = 0; i < brandCellsArray.count; i++) {
            BrandCell * cell = (BrandCell *) brandCellsArray[i];
            
            if (cell.imgBrand.image != senderCell.imgBrand.image)
                [cell unselectCell];
        }
        
        CGRect newDropDownFrame = CGRectMake(5, (senderCell.frame.origin.y + senderCell.frame.size.height), 590.0f, 200.0f);
        
        dropDownView = (ChooseModelView_iPad *)[[NSBundle mainBundle] loadNibNamed:@"ChooseModelView_iPad" owner:self options:nil][0];
        
        dropDownView.owner = senderCell;
        
        dropDownView.frame = newDropDownFrame;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [self.scrollView addSubview:dropDownView];
            
            //move down
            for (BrandCell * cell in brandCellsArray) {
                if (cell.frame.origin.y > senderCell.frame.origin.y) {
                    
                    CGRect tempFrame = cell.frame;
                    tempFrame.origin.y = tempFrame.origin.y + newDropDownFrame.size.height + 12 ;
                    cell.frame = tempFrame;
                }
            }
            CGSize scrollContentSize = self.scrollView.contentSize;
            scrollContentSize.height = scrollContentSize.height + newDropDownFrame.size.height + 12 + 15;
            [self.scrollView setContentSize:scrollContentSize];
            
        } completion:nil];
        
        int i = [self locateBrandCell:senderCell];
        if (i == -1)
            return ;
        
        [dropDownView DrawModels:[(Brand *)currentBrands[i] models]];
    }
    
    
}

- (void) didSelectModelCell:(id) sender {
    
}

- (int) locateBrandCell:(BrandCell *) cell {
    if (brandCellsArray && brandCellsArray.count) {
        for (int i = 0; i < brandCellsArray.count; i++) {
            if (brandCellsArray[i] == cell)
                return i;
        }
        return -1;
    }
    else
        return -1;
}


/*
 - (int) locateTapGesture:(UITapGestureRecognizer *) tap {
 if (brandsTapGesturesArray && brandsTapGesturesArray.count) {
 for (int i = 0; i < brandsTapGesturesArray.count; i++) {
 if (brandsTapGesturesArray[i] == tap)
 return i;
 }
 return -1;
 }
 else
 return -1;
 }
 */

@end
