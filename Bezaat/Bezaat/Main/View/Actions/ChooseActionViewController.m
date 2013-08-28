//
//  ChooseActionViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "ModelsViewController_iPad.h"
#import "sideMenuCell.h"
#import "AppDelegate.h"
#import "AddNewCarAdViewController.h"
#import "labelAdViewController.h"
#import "ProfileDetailsViewController.h"
#import "UserDetailsViewController.h"
#import "GuestProfileViewController.h"
#import "SignInViewController.h"
#import "AddNewStoreViewController.h"
#import "BrowseStoresViewController.h"
#import "AboutAppViewController.h"
#import "ExhibitViewController.h"
#import "StoreOrdersViewController.h"
#import "ChooseLocationVC.h"
#import "BrowseCarAdsViewController.h"

@interface ChooseActionViewController (){
    NSArray *menuArray;
    NSArray *iconMenuArray;
    NSMutableArray *custoMenuArray;
    NSMutableArray *custoIconMenuArray;
    MBProgressHUD2 * loadingHUD;
    
    Country * chosenCountry;
    Country * myCountry;
    NSUInteger defaultIndex;
    NSInteger defaultCountryID;
    LocationManager * locationMngr;
    NSArray * countriesArray;
    
    // Gestures
    UISwipeGestureRecognizer *rightRecognizer;
    UISwipeGestureRecognizer *leftRecognizer;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}

@end

@implementation ChooseActionViewController
@synthesize AddCarButton,AddStoreButton,BuyCarButton,toolBar,exihibiButton;
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
    
    custoMenuArray=[[NSMutableArray alloc]init];
    custoIconMenuArray=[[NSMutableArray alloc]init];
    
    [super viewDidLoad];
    //[self customizeMenu];
    self.menuTableView.separatorColor = [UIColor colorWithRed:42.0/255 green:93.0/255 blue:109.0/255 alpha:1.0f];
    self.trackedViewName = @"Home Screen";
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self prepareImages];
        [self customGestures];
        [self prepareGestures];
    }
    else {
        if (savedProfile)
            self.iPad_signInBtn.enabled = NO;
        else
            self.iPad_signInBtn.enabled = YES;
    }
    
    if (savedProfile.hasStores) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if ([[UIScreen mainScreen] bounds].size.height == 568){
                AddStoreButton.frame = CGRectMake(AddStoreButton.frame.origin.x, AddStoreButton.frame.origin.y + 30, AddStoreButton.frame.size.width, AddStoreButton.frame.size.height + 30);
                [AddStoreButton setImage:[UIImage imageNamed:@"iPhone5_manager.png"] forState:UIControlStateNormal];
                
                exihibiButton.frame = CGRectMake(exihibiButton.frame.origin.x, exihibiButton.frame.origin.y + 30, exihibiButton.frame.size.width, exihibiButton.frame.size.height + 30);
                [exihibiButton setImage:[UIImage imageNamed:@"iPhone5_Exhimenu.png"] forState:UIControlStateNormal];
                
                BuyCarButton.frame = CGRectMake(BuyCarButton.frame.origin.x, BuyCarButton.frame.origin.y, BuyCarButton.frame.size.width, BuyCarButton.frame.size.height + 30);
                [BuyCarButton setImage:[UIImage imageNamed:@"iphone5_addcar.png"] forState:UIControlStateNormal];
                
                AddCarButton.frame = CGRectMake(AddCarButton.frame.origin.x, AddCarButton.frame.origin.y, AddCarButton.frame.size.width, AddCarButton.frame.size.height + 30);
                [AddCarButton setImage:[UIImage imageNamed:@"iphone5_buycar.png"] forState:UIControlStateNormal];
                
            }else
            {
                AddStoreButton.frame = CGRectMake(AddStoreButton.frame.origin.x+2, AddStoreButton.frame.origin.y +7, AddStoreButton.frame.size.width, AddStoreButton.frame.size.height);
                [AddStoreButton setImage:[UIImage imageNamed:@"manage_store.png"] forState:UIControlStateNormal];
                
                exihibiButton.frame = CGRectMake(exihibiButton.frame.origin.x +2, exihibiButton.frame.origin.y +7, exihibiButton.frame.size.width, exihibiButton.frame.size.height);
                BuyCarButton.frame = CGRectMake(BuyCarButton.frame.origin.x + 2, BuyCarButton.frame.origin.y + 7, BuyCarButton.frame.size.width, BuyCarButton.frame.size.height);
                
                AddCarButton.frame = CGRectMake(AddCarButton.frame.origin.x - 1, AddCarButton.frame.origin.y + 7, AddCarButton.frame.size.width, AddCarButton.frame.size.height);
                
            }
        }
        [[GAI sharedInstance].defaultTracker sendView:@"Home Screen (Store)"];
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if ([[UIScreen mainScreen] bounds].size.height == 568){
                AddStoreButton.frame = CGRectMake(AddStoreButton.frame.origin.x, AddStoreButton.frame.origin.y + 30, AddStoreButton.frame.size.width, AddStoreButton.frame.size.height + 30);
                [AddStoreButton setImage:[UIImage imageNamed:@"iPhone5_openStrore.png"] forState:UIControlStateNormal];
                
                exihibiButton.frame = CGRectMake(exihibiButton.frame.origin.x, exihibiButton.frame.origin.y + 30, exihibiButton.frame.size.width, exihibiButton.frame.size.height + 30);
                [exihibiButton setImage:[UIImage imageNamed:@"iPhone5_Exhimenu.png"] forState:UIControlStateNormal];
                
                
                BuyCarButton.frame = CGRectMake(BuyCarButton.frame.origin.x, BuyCarButton.frame.origin.y, BuyCarButton.frame.size.width, BuyCarButton.frame.size.height + 30);
                [BuyCarButton setImage:[UIImage imageNamed:@"iphone5_addcar.png"] forState:UIControlStateNormal];
                
                AddCarButton.frame = CGRectMake(AddCarButton.frame.origin.x, AddCarButton.frame.origin.y, AddCarButton.frame.size.width, AddCarButton.frame.size.height + 30);
                [AddCarButton setImage:[UIImage imageNamed:@"iphone5_buycar.png"] forState:UIControlStateNormal];
            }else
            {
                AddStoreButton.frame = CGRectMake(AddStoreButton.frame.origin.x, AddStoreButton.frame.origin.y + 7, AddStoreButton.frame.size.width, AddStoreButton.frame.size.height);
                
                exihibiButton.frame = CGRectMake(exihibiButton.frame.origin.x, exihibiButton.frame.origin.y + 7, exihibiButton.frame.size.width, exihibiButton.frame.size.height);
                
                BuyCarButton.frame = CGRectMake(BuyCarButton.frame.origin.x , BuyCarButton.frame.origin.y + 7, BuyCarButton.frame.size.width, BuyCarButton.frame.size.height);
                
                AddCarButton.frame = CGRectMake(AddCarButton.frame.origin.x, AddCarButton.frame.origin.y + 7, AddCarButton.frame.size.width, AddCarButton.frame.size.height);
                
            }
        }
        [[GAI sharedInstance].defaultTracker sendView:@"Home Screen (User)"];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    if  (defaultIndex!= -1){
        chosenCountry =[countriesArray objectAtIndex:defaultIndex];
    }
    locationMngr = [LocationManager sharedInstance];
    defaultCountryID =  [[LocationManager sharedInstance] getSavedUserCountryID];
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self customizeMenu];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countriesArray=resultArray;
    for (int i =0; i <= [countriesArray count] - 1; i++) {
        chosenCountry=[countriesArray objectAtIndex:i];
        if (chosenCountry.countryID == defaultCountryID)
        {
            myCountry = [countriesArray objectAtIndex:i];
            [self.countryBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",myCountry.countryNameEn]] forState:UIControlStateNormal];
            break;
            //return;
        }
        
    }
}

#pragma mark - Gesture handling
- (void) prepareGestures{
    rightRecognizer = [[UISwipeGestureRecognizer alloc]
                       
                       initWithTarget:self action:@selector(rightSwipeHandle:)];
    
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:rightRecognizer];
    
    leftRecognizer = [[UISwipeGestureRecognizer alloc]
                      
                      initWithTarget:self action:@selector(leftSwipeHandle:)];
    
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [leftRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:leftRecognizer];
    
}


- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self hideMenu];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self showMenu];
}
#pragma mark - actions
- (IBAction)AddNewCarAdBtnPressed:(id)sender {
    [self hideMenu];
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=1;
    [self presentViewController:vc animated:YES completion:nil];
    
    //GA
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"uiAction"
                                                    withAction:@"buttonPress"
                                                     withLabel:@"sell car"
                                                     withValue:[NSNumber numberWithInt:100]];
    
}

- (IBAction)BuyCarBtnPressed:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self hideMenu];
        //  UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        //if (savedProfile) {
        ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
        vc.tagOfCallXib=2;
        [self presentViewController:vc animated:YES completion:nil];
        // }
        // else{
        //   SignInViewController *vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        // [self presentViewController:vc animated:YES completion:nil];
        //}
    }
    else {
        /*
        BrowseCarAdsViewController * browseCarAdsVC = [[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController_iPad" bundle:nil];
        [self presentViewController:browseCarAdsVC animated:YES completion:nil];
         */
        
        ModelsViewController_iPad *vc=[[ModelsViewController_iPad alloc] initWithNibName:@"ModelsViewController_iPad" bundle:nil];
        vc.tagOfCallXib=2;
        vc.displayedAsPopOver = NO;
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    
    //GA
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"uiAction"
                                                    withAction:@"buttonPress"
                                                     withLabel:@"buy car"
                                                     withValue:[NSNumber numberWithInt:100]];
    
    
}

- (IBAction)AddNewStoreBtnPressed:(id)sender {
    [self hideMenu];
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if (savedProfile.hasStores) {
        BrowseStoresViewController *vc =[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        AddNewStoreViewController *vc=[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    //GA
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"uiAction"
                                                    withAction:@"buttonPress"
                                                     withLabel:@"Add new store"
                                                     withValue:[NSNumber numberWithInt:100]];
    
    
}

- (IBAction)sideMenuBtnPressed:(id)sender {
    
    if(self.content.frame.origin.x == 0) //only show the menu if it is not already shown
        [self showMenu];
    else
        [self hideMenu];
}

- (IBAction)countryBtnPrss:(id)sender {
    CountryListViewController* vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        vc = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController" bundle:nil];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        vc = [[CountryListViewController alloc]initWithNibName:@"CountriesPopOver_iPad" bundle:nil];
        self.countryPopOver = [[UIPopoverController alloc] initWithContentViewController:vc];
        [self.countryPopOver setPopoverContentSize:vc.view.frame.size];
        //[self.countryPopOver setPopoverContentSize:CGSizeMake(500, 800)];
        vc.iPad_parentViewOfPopOver = self;
        [self.countryPopOver presentPopoverFromRect:self.countryBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    

}

- (IBAction)exhibitBtnPrss:(id)sender {
    
    ExhibitViewController *exVC;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        exVC=[[ExhibitViewController alloc] initWithNibName:@"ExhibitViewController" bundle:nil];
    else
        exVC=[[ExhibitViewController alloc] initWithNibName:@"ExhibitViewController_iPad" bundle:nil];
    //exVC.countryID=chosenCountry.countryID;
    [self presentViewController:exVC animated:YES completion:nil];
    
}

- (IBAction)iPad_signInBtnPressed:(id)sender {
    SignInViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    else
        vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
    vc.returnPage = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) prepareImages {
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
}


#pragma mark - handle side menu
- (void) customGestures{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return custoMenuArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"sideMenuCell";
    sideMenuCell *cell = [self.menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"sideMenuCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (sideMenuCell *) currentObject;
                break;
            }
        }
    }
    cell.cellImage.image=[UIImage imageNamed:[custoIconMenuArray objectAtIndex:indexPath.row]];
    [cell.titleLable setText:[custoMenuArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) customizeMenu{
    NSString *menuPlistPath = [[NSBundle mainBundle] pathForResource:@"HomeScreenChoices" ofType:@"plist"];
    
    menuArray = [[NSArray alloc] initWithContentsOfFile:menuPlistPath];
    iconMenuArray=[[NSArray alloc]initWithObjects:@"Menu_icon_01.png",@"Menu_icon_02.png",@"Menu_icon_03.png",@"Menu_icon_04.png",@"Menu_icon_05.png",@"Menu_icon_06.png",@"Menu_icon_07.png",@"Menu_icon_08.png",@"Menu_icon_09.png",@"Menu_icon_10.png",@"Menu_icon_11.png",@"Menu_icon_12.png",@"Menu_icon_13.png", nil];
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    // gust
    if(!savedProfile){
        [self.userNameLabel setText:@"زائر"];
        
        [custoMenuArray addObject:[menuArray objectAtIndex:1]];
        [custoMenuArray addObject:[menuArray objectAtIndex:2]];
        [custoMenuArray addObject:[menuArray objectAtIndex:4]];
        [custoMenuArray addObject:[menuArray objectAtIndex:5]];
        //[custoMenuArray addObject:[menuArray objectAtIndex:12]];
        
        [custoMenuArray addObject:[menuArray objectAtIndex:8]];
        [custoMenuArray addObject:[menuArray objectAtIndex:9]];
        [custoMenuArray addObject:[menuArray objectAtIndex:11]];
        
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:11]];
        //[custoIconMenuArray addObject:[iconMenuArray objectAtIndex:12]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:7]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:10]];
    }
    // member
    else if (savedProfile){
        [self.userNameLabel setText:savedProfile.userName];
        if (savedProfile.hasStores) {
            [custoMenuArray addObject:[menuArray objectAtIndex:1]];
            [custoMenuArray addObject:[menuArray objectAtIndex:2]];
            [custoMenuArray addObject:[menuArray objectAtIndex:3]];
            [custoMenuArray addObject:[menuArray objectAtIndex:4]];
            [custoMenuArray addObject:[menuArray objectAtIndex:5]];
            [custoMenuArray addObject:[menuArray objectAtIndex:12]];
            
            [custoMenuArray addObject:[menuArray objectAtIndex:8]];
            [custoMenuArray addObject:[menuArray objectAtIndex:10]];
            [custoMenuArray addObject:[menuArray objectAtIndex:11]];
            
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:4]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:11]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:12]];
            
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:7]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:10]];
            
        }
        
        else{
            [custoMenuArray addObject:[menuArray objectAtIndex:0]];
            [custoMenuArray addObject:[menuArray objectAtIndex:1]];
            [custoMenuArray addObject:[menuArray objectAtIndex:2]];
            [custoMenuArray addObject:[menuArray objectAtIndex:4]];
            [custoMenuArray addObject:[menuArray objectAtIndex:5]];
            [custoMenuArray addObject:[menuArray objectAtIndex:12]];
            
            [custoMenuArray addObject:[menuArray objectAtIndex:8]];
            [custoMenuArray addObject:[menuArray objectAtIndex:10]];
            [custoMenuArray addObject:[menuArray objectAtIndex:11]];
            
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:0]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:4]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:11]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:12]];
            
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:7]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:10]];
        }
        
    }
}
#pragma mark - UITableView Delegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    [self hideMenu];
    if([menuArray containsObject:[custoMenuArray objectAtIndex:indexPath.row]]){
        NSInteger selectedIndex=[menuArray indexOfObject:[custoMenuArray objectAtIndex:indexPath.row]];
        switch (selectedIndex) {
            case 0:
            {
                [self hideMenu];
                UserDetailsViewController *vc=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                
            }
            case 1:
                
            {
                [self hideMenu];
                ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
                vc.tagOfCallXib=2;
                [self presentViewController:vc animated:YES completion:nil];
                
                break;
            }
            case 2:
                
            {
                [self hideMenu];
                ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
                vc.tagOfCallXib=1;
                [self presentViewController:vc animated:YES completion:nil];
                
                break;
            }
            case 3:
            {
                [self hideMenu];
                BrowseStoresViewController *vc=[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                
                break;
                /*
                 [self hideMenu];
                 UserDetailsViewController *vc=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
                 [self presentViewController:vc animated:YES completion:nil];*/
                
            }
            case 4:
            {
                [self hideMenu];
                AddNewStoreViewController *vc=[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                
                //GA
                [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"uiAction"
                                                                withAction:@"buttonPress"
                                                                 withLabel:@"Add new store (menu)"
                                                                 withValue:[NSNumber numberWithInt:100]];
                
                break;
            }
            case 5:
            {
                [self hideMenu];
                ExhibitViewController *exVC=[[ExhibitViewController alloc] initWithNibName:@"ExhibitViewController" bundle:nil];
                [self presentViewController:exVC animated:YES completion:nil];
                
                break;
            }
            case 6:
            {
                // TODO CODE
                //_____________________
                // Favorites view
                //_____________________
                break;
            }
            case 8:
            {
                if (!savedProfile) {
                    [self hideMenu];
                    GuestProfileViewController *vc=[[GuestProfileViewController alloc]initWithNibName:@"GuestProfileViewController" bundle:nil];
                    [self presentViewController:vc animated:YES completion:nil];
                    
                }else{
                    [self hideMenu];
                    ProfileDetailsViewController *vc=[[ProfileDetailsViewController alloc]initWithNibName:@"ProfileDetailsViewController" bundle:nil];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
                break;
            }
            case 9:
            {
                [self hideMenu];
                if ([[UIScreen mainScreen] bounds].size.height == 568){
                    //SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController5" bundle:nil];
                    SignInViewController *vc;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
                    else
                        vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
                    [self presentViewController:vc animated:YES completion:nil];
                }else {
                    //SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
                    SignInViewController *vc;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
                    else
                        vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
                break;
            }
            case 10:
            {
                [self logout];
                break;
            }
            case 11:
            {
                [self hideMenu];
                AboutAppViewController *vc;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    vc =[[AboutAppViewController alloc]initWithNibName:@"AboutAppViewController" bundle:nil];
                else
                    vc =[[AboutAppViewController alloc]initWithNibName:@"AboutAppViewController_iPad" bundle:nil];
                
                [self presentViewController:vc animated:YES completion:nil];
                
            }
            case 12:
            {
                StoreOrdersViewController *vc=[[StoreOrdersViewController alloc]initWithNibName:@"StoreOrdersViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
        
    }
    
}

-(void)logout
{
    [self hideMenu];
    [self showLoadingIndicator];
    //[[LocationManager locationKeyChainItemSharedInstance] resetKeychainItem];
    [FBSession.activeSession closeAndClearTokenInformation];
    [[ProfileManager loginKeyChainItemSharedInstance] resetKeychainItem];
    
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد تم تسجيل الخروج" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [self hideLoadingIndicator];
    [alert show];
    return;
    
}


- (void) showLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        loadingHUD.dimBackground = YES;
    }
    else {
        iPad_loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
        
        iPad_loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        iPad_loadingView.clipsToBounds = YES;
        iPad_loadingView.layer.cornerRadius = 10.0;
        iPad_loadingView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        
        iPad_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        iPad_activityIndicator.frame = CGRectMake(65, 40, iPad_activityIndicator.bounds.size.width, iPad_activityIndicator.bounds.size.height);
        [iPad_loadingView addSubview:iPad_activityIndicator];
        
        iPad_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        iPad_loadingLabel.backgroundColor = [UIColor clearColor];
        iPad_loadingLabel.textColor = [UIColor whiteColor];
        iPad_loadingLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        iPad_loadingLabel.adjustsFontSizeToFitWidth = YES;
        iPad_loadingLabel.textAlignment = NSTextAlignmentCenter;
        iPad_loadingLabel.text = @"جاري تحميل البيانات";
        [iPad_loadingView addSubview:iPad_loadingLabel];
        
        [self.view addSubview:iPad_loadingView];
        [iPad_activityIndicator startAnimating];
    }
    
}

- (void) hideLoadingIndicator {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (loadingHUD)
            [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
        loadingHUD = nil;
    }
    else {
        if ((iPad_activityIndicator) && (iPad_loadingView)) {
            [iPad_activityIndicator stopAnimating];
            [iPad_loadingView removeFromSuperview];
        }
        iPad_activityIndicator = nil;
        iPad_loadingView = nil;
        iPad_loadingLabel = nil;
    }
    
}



#pragma mark - animations -
-(void)showMenu{
    
    //slide the content view to the right to reveal the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         
                         [self.content setFrame:CGRectMake(-self.menuView.frame.size.width, self.content.frame.origin.y, self.content.frame.size.width, self.content.frame.size.height)];
                     }
     ];
    
}

-(void)hideMenu{
    
    //slide the content view to the left to hide the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         
                         [self.content setFrame:CGRectMake(0, self.content.frame.origin.y, self.content.frame.size.width, self.content.frame.size.height)];
                     }
     ];
}

#pragma mark - Gesture handlers -

-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    
    if(self.content.frame.origin.x != 0)
        [self hideMenu];
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(self.content.frame.origin.x == 0)
        [self showMenu];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        ChooseActionViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
        else
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (alertView.tag == 0)
    {
        
    }
}

- (void) iPad_userDidEndChoosingCountryFromPopOver {
    if (self.countryPopOver) {
        defaultCountryID =  [[LocationManager sharedInstance] getSavedUserCountryID];
        for (int i =0; i <= [countriesArray count] - 1; i++) {
            chosenCountry=[countriesArray objectAtIndex:i];
            if (chosenCountry.countryID == defaultCountryID)
            {
                myCountry = [countriesArray objectAtIndex:i];
                [self.countryBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",myCountry.countryNameEn]] forState:UIControlStateNormal];
                break;
                //return;
            }
            
        }
        [self.countryPopOver dismissPopoverAnimated:YES];
    }
    self.countryPopOver = nil;
}
@end
