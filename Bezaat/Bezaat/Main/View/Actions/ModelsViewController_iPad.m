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
    NSMutableArray * brandCellsArray;
    //NSMutableArray * brandsTapGesturesArray;
    //NSMutableArray * modelsTapGesturesArray;
    ChooseModelView_iPad * dropDownView;
    BOOL isFirstAppearance;
}
@end

@implementation ModelsViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.displayedAsPopOver = NO;//by default, it is a separate UI
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.trackedViewName = @"Choose Model";
    brandCellsArray = [NSMutableArray new];
    
    self.chosenBrand = nil;
    self.chosenModel = nil;
    
    oneSelectionMade = NO;
    dropDownView = nil;
    
    isFirstAppearance = YES;
    
    if (self.titleLabel) {
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextAlignment:SSTextAlignmentCenter];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:30.0] ];
        [self.titleLabel setText:@"سيارات بيزات"];
    }
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

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ((self.displayedAsPopOver) && (isFirstAppearance))
        [self selectFirstBrandCell];
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
    self.chosenBrand =(Brand*)[currentBrands objectAtIndex:0];
    
    [MBProgressHUD2 hideHUDForView:self.view animated:YES];
    
    [self DrawBrands];
}

#pragma mark - methods

- (void) setFirstAppearance:(BOOL) status {
    isFirstAppearance = status;
}

#pragma mark - helper methods

//This method is called for the first time the popover is created
- (void) selectFirstBrandCell {
    if (brandCellsArray && brandCellsArray.count) {
        UITapGestureRecognizer * tapOfFirstCell = [(BrandCell *) brandCellsArray[0] gestureRecognizers][0];
        [self didSelectBrandCell:tapOfFirstCell];
    }
    
}

- (void) DrawBrands {
    float currentX = 0;
    float currentY = 0;
    float totalHeight = 0;
    
    int rowCounter = 0;
    int colCounter = 0;
    
    CGRect brandFrame;
    
    for (int i = 0; i < currentBrands.count; i++) {
        Brand * currentItem = currentBrands[i];
        
        // Update the cell information
        BrandCell* brandCell;
        if (self.displayedAsPopOver) {
            brandFrame = CGRectMake(-1, -1, 114, 114);//these are the dimensions of the brand cell
            brandCell = (BrandCell*)[[NSBundle mainBundle] loadNibNamed:@"BrandCell_popOver_iPad" owner:self options:nil][0];
        }
        else {
            brandFrame = CGRectMake(-1, -1, 166, 166);//these are the dimensions of the brand cell
            brandCell = (BrandCell*)[[NSBundle mainBundle] loadNibNamed:@"BrandCell_iPad" owner:self options:nil][0];
        }
        
        [brandCell reloadInformation:currentItem];
        
        if ((self.chosenBrand) && (self.chosenBrand.brandID == currentItem.brandID))
            [brandCell selectCell];
        
        if ((!oneSelectionMade) && (i == 0) )
            [brandCell selectCell];
        
        
        if (i != 0) {
            if (i % 6 == 0) {
                rowCounter ++;
                colCounter = 0;
            }
            else
                colCounter ++;
        }
        
        
        currentX = (colCounter * brandFrame.size.width) + ((colCounter + 1) * 5);
        if (self.displayedAsPopOver)    //This is related to an appearance issue
            currentY = (rowCounter * brandFrame.size.height);
        else
            currentY = (rowCounter * brandFrame.size.height) + ((rowCounter + 1) * 5);
        
        
        
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
    int indexOfSenderCell = [self locateBrandCell:senderCell];
    self.chosenBrand = currentBrands[indexOfSenderCell];
    currentModels = self.chosenBrand.models;
    
    if (self.displayedAsPopOver) {
        
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
                [UIView animateWithDuration:0.45f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    
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
                    dropDownView.containerViewController = nil;
                    
                    dropDownView.owner = senderCell;
                    dropDownView.frame = newDropDownFrame;
                    
                    [UIView animateWithDuration:0.45f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
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
                    
                    if (indexOfSenderCell == -1)
                        return ;
                    
                    [dropDownView drawModels:currentModels];
                    [self setModelsTapGestures];
                    self.chosenModel = currentModels[0]; //initially, the selected model is the first
                }];
            }
            else { // a drop down on the same row --> just change the frame
                [senderCell selectCell];
                
                [dropDownView removeFromSuperview];
                dropDownView = nil;
                
                for (int i = 0; i < brandCellsArray.count; i++) {
                    BrandCell * cell = (BrandCell *) brandCellsArray[i];
                    
                    if (cell.imgBrand.image != senderCell.imgBrand.image)
                        [cell unselectCell];
                }
                
                CGRect newDropDownFrame = CGRectMake(5, (senderCell.frame.origin.y + senderCell.frame.size.height), 590.0f, 200.0f);
                
                dropDownView = (ChooseModelView_iPad *)[[NSBundle mainBundle] loadNibNamed:@"ChooseModelView_iPad" owner:self options:nil][0];
                dropDownView.containerViewController = nil;
                
                dropDownView.owner = senderCell;
                dropDownView.frame = newDropDownFrame;
                
                [self.scrollView addSubview:dropDownView];
                
                if (indexOfSenderCell == -1)
                    return ;
                
                [dropDownView drawModels:currentModels];
                [self setModelsTapGestures];
                self.chosenModel = currentModels[0]; //initially, the selected model is the first
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
            dropDownView.containerViewController = nil;
            
            dropDownView.owner = senderCell;
            
            dropDownView.frame = newDropDownFrame;
            [UIView animateWithDuration:0.45f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
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
            
            if (indexOfSenderCell == -1)
                return ;
            
            [dropDownView drawModels:currentModels];
            [self setModelsTapGestures];
            self.chosenModel = currentModels[0]; //initially, the selected model is the first
        }
    }
    else {
        [senderCell selectCell];
        for (int i = 0; i < brandCellsArray.count; i++) {
            BrandCell * cell = (BrandCell *) brandCellsArray[i];
            
            if (cell.imgBrand.image != senderCell.imgBrand.image)
                [cell unselectCell];
        }
        
        CGRect newDropDownFrame = CGRectMake(25, 25, 590.0f, 200.0f);
        CGRect containerFrame = CGRectMake(0, 0, newDropDownFrame.size.width + 50, newDropDownFrame.size.height + 50);
        
        dropDownView = (ChooseModelView_iPad *)[[NSBundle mainBundle] loadNibNamed:@"ChooseModelView_iPad" owner:self options:nil][0];
        
        dropDownView.owner = senderCell;
        
        dropDownView.frame = newDropDownFrame;
        if (indexOfSenderCell == -1)
            return ;
        
        [dropDownView drawModels:currentModels];
        [self setModelsTapGestures];
        
        self.chosenModel = currentModels[0]; //initially, the selected model is the first
        [self setModelsTapGestures];
        
        UIViewController * container = [[UIViewController alloc] init];
        container.view = [[UIView alloc] initWithFrame:containerFrame];
        dropDownView.containerViewController = container;
        
        //background
        CGRect bgRect = CGRectMake(-1, -1, containerFrame.size.width + 2, containerFrame.size.height + 2);
        UIImageView * bg = [[UIImageView alloc] initWithFrame:bgRect];
        [bg setImage:[UIImage imageNamed:@"tb_choose_brand_box1.png"]];
        [container.view addSubview:bg];
        
        //close button
        UIButton * closeModelsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [closeModelsButton setTitle:@"" forState:UIControlStateNormal];
        [closeModelsButton setBackgroundImage:[UIImage imageNamed:@"tb_add_individual_ads_close_btn.png"] forState:UIControlStateNormal];
        [closeModelsButton addTarget:self action:@selector(closeModelsBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [container.view addSubview:closeModelsButton];
        
        //models
        [container.view addSubview:dropDownView];
        
        container.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:container animated:YES completion:nil];
        container.view.superview.frame = containerFrame;
        container.view.superview.bounds = containerFrame;
        container.view.superview.center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 2));
        

    }
    
}

- (void) didSelectModelCell:(id) sender {
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *) sender;
    ModelCell * senderCell = (ModelCell *) tap.view;
    int indexOfSenderCell = [self locateModelCell:senderCell];
    if (indexOfSenderCell != -1)
        self.chosenModel = currentModels[indexOfSenderCell];
    
    [senderCell setSelected:YES];
    if (dropDownView) {
        for (id cell  in dropDownView.modelsScrollView.subviews) {
            if ( ([cell isKindOfClass:[ModelCell class]]) && (cell != senderCell))
                [cell setSelected:NO];
            
        }
    }
    [self.choosingDelegate didChooseModel:self.chosenModel];
    
    /*
     NSLog(@"chosen model is:%@, %i", self.chosenModel.modelName, self.chosenModel.modelID);
     NSLog(@"chosen brand is:%@, %i", self.chosenBrand.brandNameAr, self.chosenBrand.brandID);
     NSLog(@"-----------------");
     */
}

- (void) setModelsTapGestures {
    if (dropDownView) {
        for (id cell  in dropDownView.modelsScrollView.subviews) {
            if ([cell isKindOfClass:[ModelCell class]]) {
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectModelCell:)];
                tap.numberOfTapsRequired = 1;
                [cell addGestureRecognizer:tap];
            }
            
        }
    }
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

- (int) locateModelCell:(ModelCell *) cell {
    if (dropDownView && dropDownView.modelCellsArray && dropDownView.modelCellsArray.count) {
        for (int i = 0; i < dropDownView.modelCellsArray.count; i++) {
            if (dropDownView.modelCellsArray[i] == cell)
                return i;
        }
        return -1;
    }
    else
        return -1;
}

- (void) closeModelsBtnPressed {    //this method is called on ly in the separate brands UI
    if ((!self.displayedAsPopOver) && (dropDownView))
        [dropDownView.containerViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - actions of the separate UI

- (IBAction)closeBtnPressedInSeparateUI:(id)sender {
    if (!self.displayedAsPopOver)
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end
