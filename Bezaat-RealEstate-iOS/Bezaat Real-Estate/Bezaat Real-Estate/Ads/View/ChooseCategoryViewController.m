//
//  ChooseCategoryViewController.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/13/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseCategoryViewController.h"
#import "CategoryCell.h"
#import "BrowseAdsViewController.h"
#import "BrowseAdsViewController_iPad.h"

@interface ChooseCategoryViewController ()
{
    NSMutableArray * categoriesArray;
    NSMutableArray * NewCategoriesArray;

    BOOL offeredSegmentBtnChosen;
}
@end

@implementation ChooseCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void) loadView {
    [super loadView];

    //init & load categories array
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GAI sharedInstance].defaultTracker sendView:@"Choose Category screen"];
    categoriesArray = [NSMutableArray arrayWithArray:
                       [[AdsManager sharedInstance] getCategoriesForstatus:self.browsingForSale]];
    [self.loaderActivity startAnimating];
    NewCategoriesArray = [NSMutableArray new];
    if (self.tagOfCallXib == 2) {
        [self.browseAllBtn setHidden:YES];
        
        self.categoriesTableView.frame = CGRectMake(self.categoriesTableView.frame.origin.x, self.categoriesTableView.frame.origin.y - 50, self.categoriesTableView.frame.size.width, self.categoriesTableView.frame.size.height + 50);
        //self.requireView.frame = CGRectMake(self.requireView.frame.origin.x, self.requireView.frame.origin.y + 50, self.requireView.frame.size.width, self.requireView.frame.size.height);
        
        //self.categoriesTableView.frame = CGRectMake(self.categoriesTableView.frame.origin.x, self.categoriesTableView.frame.origin.y + 50, self.categoriesTableView.frame.size.width, self.categoriesTableView.frame.size.height - 50);
    }
    if (self.browsingForSale)
        [[AdsManager sharedInstance] GetSubCategoriesCountForCategory:@"properties-for-sale" andCity:[[SharedUser sharedInstance] getUserCityID] andServiceType:@"معروض" WithDelegate:self];
    else
        [[AdsManager sharedInstance] GetSubCategoriesCountForCategory:@"properties-for-rent" andCity:[[SharedUser sharedInstance] getUserCityID] andServiceType:@"معروض" WithDelegate:self];
    
    //customize category label:
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:SSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:20.0] ];
    self.titleLabel.text = @"اختر نوع العقار";
    
    //initialy, the offered button is pressed and wanted button is not
    offeredSegmentBtnChosen = YES;
    [self updateSegmentButtonStyles];
    
    //customize the browse all button with custom Label
    [self customizeBrowseAllBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableView Delegate methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (NewCategoriesArray && NewCategoriesArray.count)
        return NewCategoriesArray.count;
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (NewCategoriesArray && NewCategoriesArray.count) {
        
        Category1 * cat = [NewCategoriesArray objectAtIndex:indexPath.row];
        
        CategoryCell * cell = [self.categoriesTableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
        if (!cell)
            cell = (CategoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil] objectAtIndex:0];
        [cell.catImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"small_default-Cat-%lu",(unsigned long)cat.categoryID]]];
        
        NSString* temp;
        if (self.browsingForSale)
            temp = [cat.categoryName stringByReplacingOccurrencesOfString:@"للبيع" withString:@""];
        else
            temp = [cat.categoryName stringByReplacingOccurrencesOfString:@"للإيجار" withString:@""];
        cell.catNameLabel.text = temp;
        cell.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)cat.ActiveAdsCount];
        return cell;
    }
    return [UITableViewCell new];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserProfile* myStore = [[SharedUser sharedInstance] getUserProfileData];
    if (self.tagOfCallXib==2) {
        if (myStore.hasStores) {
            Category1 * cat = [NewCategoriesArray objectAtIndex:indexPath.row];

            AddNewStoreAdViewController *adNewCar=[[AddNewStoreAdViewController alloc] initWithNibName:@"AddNewStoreAdViewController" bundle:nil];
            
            adNewCar.currentSubCategoryID=cat.categoryID;
            //adNewCar.currentModel=selectedModel;
            //adNewCar.currentStore = self.sentStore;
            adNewCar.browsingForSale = self.browsingForSale;
            [self presentViewController:adNewCar animated:YES completion:nil];
            
        }else {
        Category1 * cat = [NewCategoriesArray objectAtIndex:indexPath.row];
            AddNewCarAdViewController *adNewCar=[[AddNewCarAdViewController alloc] initWithNibName:@"AddNewCarAdViewController" bundle:nil];
            adNewCar.currentSubCategoryID=cat.categoryID;
            adNewCar.browsingForSale = self.browsingForSale;
            adNewCar.isOffered = offeredSegmentBtnChosen;
            [self presentViewController:adNewCar animated:YES completion:nil];
            
        }
    }
    else{
        Category1 * cat = [NewCategoriesArray objectAtIndex:indexPath.row];
        BrowseAdsViewController * browseAdsVC;
        BrowseAdsViewController_iPad* browseAdsVC_iPad;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            browseAdsVC_iPad = [[BrowseAdsViewController_iPad alloc] initWithNibName:@"BrowseAdsViewController_iPad" bundle:nil];
            browseAdsVC_iPad.currentSubCategoryID = cat.categoryID;
            browseAdsVC_iPad.browsingForSale = self.browsingForSale;
            browseAdsVC_iPad.offeredSegmentBtnChosen=offeredSegmentBtnChosen;
            browseAdsVC_iPad.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:browseAdsVC_iPad animated:YES completion:nil];
        }else
        {
        browseAdsVC = [[BrowseAdsViewController alloc] initWithNibName:@"BrowseAdsViewController" bundle:nil];
        browseAdsVC.currentSubCategoryID = cat.categoryID;
        browseAdsVC.browsingForSale = self.browsingForSale;
        browseAdsVC.offeredSegmentBtnChosen=offeredSegmentBtnChosen;
            browseAdsVC.categoryHasRoom = cat.hasRooms;
            if (offeredSegmentBtnChosen)
                browseAdsVC.currentTitle = [NSString stringWithFormat:@"معروض/%@",cat.categoryName];
            else
                browseAdsVC.currentTitle = [NSString stringWithFormat:@"مطلوب/%@",cat.categoryName];
        browseAdsVC.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:browseAdsVC animated:YES completion:nil];
        }
    }

    if (NewCategoriesArray && NewCategoriesArray.count) {
        
        
    }
}

#pragma mark - helper methods

- (void) updateSegmentButtonStyles {
    UIImage * offeredImg;
    UIImage * wantedImg;
    
    if (self.browsingForSale) {
        
         if (offeredSegmentBtnChosen) {
            [[AdsManager sharedInstance] GetSubCategoriesCountForCategory:@"properties-for-sale" andCity:[[SharedUser sharedInstance] getUserCityID] andServiceType:@"معروض" WithDelegate:self];
         }else{
             [[AdsManager sharedInstance] GetSubCategoriesCountForCategory:@"properties-for-sale" andCity:[[SharedUser sharedInstance] getUserCityID] andServiceType:@"مطلوب" WithDelegate:self];
         }
        
        offeredImg = [UIImage imageNamed:
                      [NSString stringWithFormat:@"%@",
                       (offeredSegmentBtnChosen ? @"select_rea_estate_offered_sell_btn1.png" :
                        @"select_rea_estate_offered_sell_btn2.png")
                       ]];
        
        wantedImg = [UIImage imageNamed:
                     [NSString stringWithFormat:@"%@",
                      (offeredSegmentBtnChosen ? @"select_rea_estate_wanted_sell_btn2.png" :
                       @"select_rea_estate_wanted_sell_btn1.png")
                      ]];
    }
    else { //browsing for rent
        if (offeredSegmentBtnChosen) {
             [[AdsManager sharedInstance] GetSubCategoriesCountForCategory:@"properties-for-rent" andCity:[[SharedUser sharedInstance] getUserCityID] andServiceType:@"معروض" WithDelegate:self];
        }else{
        [[AdsManager sharedInstance] GetSubCategoriesCountForCategory:@"properties-for-rent" andCity:[[SharedUser sharedInstance] getUserCityID] andServiceType:@"مطلوب" WithDelegate:self];
        }
        offeredImg = [UIImage imageNamed:
                      [NSString stringWithFormat:@"%@",
                       (offeredSegmentBtnChosen ? @"select_rea_estate_offered_rent_btn1.png" :
                        @"select_rea_estate_offered_rent_btn2.png")
                       ]];
        
        wantedImg = [UIImage imageNamed:
                     [NSString stringWithFormat:@"%@",
                      (offeredSegmentBtnChosen ? @"select_rea_estate_wanted_rent_btn2.png" :
                       @"select_rea_estate_wanted_rent_btn1.png")
                      ]];
    }
    
    
    [self.offeredSegmentBtn setBackgroundImage:offeredImg forState:UIControlStateNormal];
    [self.wantedSegmentBtn setBackgroundImage:wantedImg forState:UIControlStateNormal];
    
}

- (void) customizeBrowseAllBtn {
    
    SSLabel * titleLabel = [[SSLabel alloc] initWithFrame:CGRectMake(7, 5, 300, 33)];
    //customize browse all estates label
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:SSTextAlignmentRight];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:18.0] ];
    titleLabel.text = [NSString stringWithFormat:@"تصفح جميع العقارات %@",
                                (self.browsingForSale ? @"للبيع" : @"للإيجار")];

    //This gesture recognizer is to provide the title of the butto from hiding the button tapping action
    UITapGestureRecognizer * tapOnTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browseAllBtnPressed:)];
    [titleLabel addGestureRecognizer:tapOnTitle];
    
    [self.browseAllBtn addSubview:titleLabel];
}

#pragma mark - actions

- (IBAction)backBtnPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)browseAllBtnPressed:(id)sender {
    
    BrowseAdsViewController * browseAdsVC;
    BrowseAdsViewController_iPad* browseAdsVC_iPad;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        browseAdsVC_iPad = [[BrowseAdsViewController_iPad alloc] initWithNibName:@"BrowseAdsViewController_iPad" bundle:nil];
        browseAdsVC_iPad.currentSubCategoryID = -1;
        browseAdsVC_iPad.browsingForSale = self.browsingForSale;
        browseAdsVC_iPad.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:browseAdsVC_iPad animated:YES completion:nil];
    }else
    {
        browseAdsVC = [[BrowseAdsViewController alloc] initWithNibName:@"BrowseAdsViewController" bundle:nil];
        browseAdsVC.currentSubCategoryID = -1;
        browseAdsVC.browsingForSale = self.browsingForSale;
        browseAdsVC.currentTitle = @"جميع العقارات";
        browseAdsVC.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:browseAdsVC animated:YES completion:nil];
    }

    
}

- (IBAction)offeredSegmentBtnPressed:(id)sender {
    offeredSegmentBtnChosen = !offeredSegmentBtnChosen;
    [self updateSegmentButtonStyles];
}

- (IBAction)wantedSegmentBtnPressed:(id)sender {
    offeredSegmentBtnChosen = !offeredSegmentBtnChosen;
    
    [self updateSegmentButtonStyles];
}


-(void)subCategoriesDidFailLoadingWithError:(NSError *)error
{
   // NSLog(@"failed");
    NewCategoriesArray = categoriesArray;
    [self.categoriesTableView reloadData];
    [self.loaderActivity stopAnimating];
}

-(void)subCategoriesDidFinishLoadingWithStatus:(NSArray *)resultArray
{
    NewCategoriesArray = [NSMutableArray new];
    
    for (int i = 0; i < [categoriesArray count]; i++) {
        Category1* currCat = [categoriesArray objectAtIndex:i];
        for (Category1* cat in resultArray) {
            if (cat.categoryID == currCat.categoryID) {
                currCat.ActiveAdsCount = cat.ActiveAdsCount;
                [NewCategoriesArray addObject:currCat];
                break;
            }
        }
    }
    if ([resultArray count] == 0) {
       NewCategoriesArray = categoriesArray;
    }
    if ([NewCategoriesArray count] == 0) {
        NewCategoriesArray = categoriesArray;
    }
    [self sortArrayAscending:NewCategoriesArray];
    [self.categoriesTableView reloadData];
    [self.loaderActivity stopAnimating];
    
}

-(NSArray*)sortArrayAscending:(NSArray*)myArray
{
    NSSortDescriptor* sorter = [[NSSortDescriptor alloc] initWithKey:@"ActiveAdsCount" ascending:NO selector:@selector(compare:)];
    NSArray* sortDescriptor = [NSArray arrayWithObject:sorter];
    NSArray* sortedItems = [myArray sortedArrayUsingDescriptors:sortDescriptor];
    [NewCategoriesArray removeAllObjects];
    [NewCategoriesArray addObjectsFromArray:sortedItems];
    return NewCategoriesArray;

}

@end
