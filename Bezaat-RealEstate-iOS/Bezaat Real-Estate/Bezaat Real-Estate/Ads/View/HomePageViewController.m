//
//  HomePageViewController.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 7/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "HomePageViewController.h"
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "SideMenuCell.h"
#import "BrowseAdsViewController.h"
#import "ChooseCategoryViewController.h"
#import "BrowseAdsViewController_iPad.h"
#import "AddNewStoreAdViewController_iPad.h"

@interface HomePageViewController ()
{
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

@implementation HomePageViewController

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
    [self.headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [self.headerTitleLabel setTextAlignment:SSTextAlignmentCenter];
    [self.headerTitleLabel setTextColor:[UIColor blackColor]];
    [self.headerTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:20.0] ];
    self.headerTitleLabel.text = @"الصفحة الرئيسية";

    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        [self.browseEstateForRentBtn setBackgroundImage:[UIImage imageNamed:@"mainscreen_rentProp_iPh5"] forState:UIControlStateNormal];
        
        [self.browseEstateForSellBtn setBackgroundImage:[UIImage imageNamed:@"mainscreen_sellProp_iPh5"] forState:UIControlStateNormal];
        
        [self.browseEstateForRentBtn setFrame:CGRectMake(self.browseEstateForRentBtn.frame.origin.x, self.browseEstateForRentBtn.frame.origin.y, self.browseEstateForRentBtn.frame.size.width, self.browseEstateForRentBtn.frame.size.height + 30)];
        
        [self.browseEstateForSellBtn setFrame:CGRectMake(self.browseEstateForSellBtn.frame.origin.x, self.browseEstateForSellBtn.frame.origin.y, self.browseEstateForSellBtn.frame.size.width, self.browseEstateForSellBtn.frame.size.height + 30)];
        
        
        [self.rentYourEstateBtn setFrame:CGRectMake(self.rentYourEstateBtn.frame.origin.x, self.rentYourEstateBtn.frame.origin.y + 30, self.rentYourEstateBtn.frame.size.width, self.rentYourEstateBtn.frame.size.height + 30)];
        
        [self.sellYourEstateBtn setFrame:CGRectMake(self.sellYourEstateBtn.frame.origin.x, self.sellYourEstateBtn.frame.origin.y + 30, self.sellYourEstateBtn.frame.size.width, self.sellYourEstateBtn.frame.size.height + 30)];
        
        [self.rentYourEstateBtn setBackgroundImage:[UIImage imageNamed:@"mainscreen_doRent_iPh5"] forState:UIControlStateNormal];
         [self.sellYourEstateBtn setBackgroundImage:[UIImage imageNamed:@"mainscreen_dosell_iPh5"] forState:UIControlStateNormal];
        
        [self.becomeBrokerBtn setFrame:CGRectMake(self.becomeBrokerBtn.frame.origin.x, self.becomeBrokerBtn.frame.origin.y + 58, self.becomeBrokerBtn.frame.size.width, self.becomeBrokerBtn.frame.size.height + 30)];
        
        [self.browseBrokersBtn setFrame:CGRectMake(self.browseBrokersBtn.frame.origin.x, self.browseBrokersBtn.frame.origin.y + 58, self.browseBrokersBtn.frame.size.width, self.browseBrokersBtn.frame.size.height + 30)];
        
         [self.becomeBrokerBtn setBackgroundImage:[UIImage imageNamed:@"mainscreen_Createoffice_iPh5"] forState:UIControlStateNormal];
         [self.browseBrokersBtn setBackgroundImage:[UIImage imageNamed:@"mainscreen_office_iPh5"] forState:UIControlStateNormal];
    }
    
    
    //customize welcome label of side menu:
    [self.welcomeLabel setBackgroundColor:[UIColor clearColor]];
    [self.welcomeLabel setTextAlignment:SSTextAlignmentRight];
    [self.welcomeLabel setTextColor:[UIColor whiteColor]];
    [self.welcomeLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:14.0] ];
    self.welcomeLabel.text = @"أهلاً بك";
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //customize side menu
    custoMenuArray=[[NSMutableArray alloc]init];
    custoIconMenuArray=[[NSMutableArray alloc]init];
    
    //[self customizeMenu];
    self.menuTableView.separatorColor = [UIColor colorWithRed:42.0/255 green:93.0/255 blue:109.0/255 alpha:1.0f];
    self.trackedViewName = @"Home Screen";
    
    [self customizeGestures];

    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if (savedProfile.hasStores) {
        
        [[GAI sharedInstance].defaultTracker sendView:@"Home Screen (Store)"];
        //[self.becomeBrokerBtn setBackgroundImage:[UIImage imageNamed:@"sim_home_open_store_btn.png"] forState:UIControlStateNormal];
    } else
        [[GAI sharedInstance].defaultTracker sendView:@"Home Screen (User)"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if (savedProfile) {
                //self.iPad_signInBtn.enabled = NO;
                [self.iPad_signInBtn setBackgroundImage:[UIImage imageNamed:@"iPad_home_icon_6.png"] forState:UIControlStateNormal];//log out
                [self.iPad_myAdsBtn setEnabled:YES];
                if (savedProfile.hasStores)
                    [self.iPad_storeOrdersBtn setEnabled:YES];
                else{
                    [self.iPad_storeOrdersBtn setEnabled:YES];
                    [self.iPad_manageStoreBtn setEnabled:NO];
                }
            }
            else {
                //self.iPad_signInBtn.enabled = YES;
                [self.iPad_signInBtn setBackgroundImage:[UIImage imageNamed:@"iPad_home_icon_5.png"] forState:UIControlStateNormal];//log in
                [self.iPad_myAdsBtn setEnabled:NO];
                [self.iPad_storeOrdersBtn setEnabled:NO];
                [self.iPad_manageStoreBtn setEnabled:NO];
            }
        }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //load the background
    int bkgID =  [[LocationManager sharedInstance] getSavedUserCountryID];
    [self.iPad_background setImage:[UIImage imageNamed:[NSString stringWithFormat:@"iPad_HomePage_%i.jpg",bkgID]]];
    if (!self.iPad_background.image) {
        [self.iPad_background setImage:[UIImage imageNamed:@"iPad_HomePage_def.jpg"]];
    }
    defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    if  (defaultIndex!= -1){
        chosenCountry =[countriesArray objectAtIndex:defaultIndex];
    }
    locationMngr = [LocationManager sharedInstance];
    defaultCountryID =  [[LocationManager sharedInstance] getSavedUserCountryID];
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self customizeMenu];
    } else {
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if (savedProfile) {
            //self.iPad_signInBtn.enabled = NO;
            [self.iPad_signInBtn setBackgroundImage:[UIImage imageNamed:@"iPad_home_icon_6.png"] forState:UIControlStateNormal];//log out
            [self.iPad_myAdsBtn setEnabled:YES];
            if (savedProfile.hasStores)
                [self.iPad_storeOrdersBtn setEnabled:YES];
            else
                [self.iPad_storeOrdersBtn setEnabled:YES];
        }
        else {
            //self.iPad_signInBtn.enabled = YES;
            [self.iPad_signInBtn setBackgroundImage:[UIImage imageNamed:@"iPad_home_icon_5.png"] forState:UIControlStateNormal];//log in
            [self.iPad_myAdsBtn setEnabled:NO];
            [self.iPad_storeOrdersBtn setEnabled:NO];
        }
        
        if (savedProfile.hasStores) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                [self.becomeBrokerBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                [self.becomeBrokerBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle side menu

- (void) showMenu {
    
    //slide the content view to the right to reveal the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         
                         [self.content setFrame:CGRectMake(-self.menuView.frame.size.width, self.content.frame.origin.y, self.content.frame.size.width, self.content.frame.size.height)];
                     }
     ];
    
}

- (void) hideMenu {
    
    //slide the content view to the left to hide the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         
                         [self.content setFrame:CGRectMake(0, self.content.frame.origin.y, self.content.frame.size.width, self.content.frame.size.height)];
                     }
     ];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return custoMenuArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SideMenuCell";
    SideMenuCell *cell = [self.menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SideMenuCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (SideMenuCell *) currentObject;
                break;
            }
        }
    }
    cell.cellImage.image=[UIImage imageNamed:[custoIconMenuArray objectAtIndex:indexPath.row]];
    [cell.titleLable setText:[custoMenuArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    [self hideMenu];
    
    if([menuArray containsObject:[custoMenuArray objectAtIndex:indexPath.row]]){
        NSInteger selectedIndex=[menuArray indexOfObject:[custoMenuArray objectAtIndex:indexPath.row]];
        switch (selectedIndex) {
            case 0:
            {
                
                //estates for rent
                ChooseCategoryViewController * chooseCategoryVc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
                
                chooseCategoryVc.browsingForSale = NO;
                chooseCategoryVc.tagOfCallXib = 1;
                chooseCategoryVc.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:chooseCategoryVc animated:YES completion:nil];
                
                break;
            }
            case 1:
                
            {
                
                //estates for sell
                ChooseCategoryViewController * chooseCategoryVc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
                
                chooseCategoryVc.browsingForSale = YES;
                chooseCategoryVc.tagOfCallXib = 1;
                chooseCategoryVc.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:chooseCategoryVc animated:YES completion:nil];
                break;
            }
            case 2:
                
            {
                
                //sell your estate
                ChooseCategoryViewController * chooseCategoryVc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
                
                chooseCategoryVc.browsingForSale = YES;
                chooseCategoryVc.tagOfCallXib = 2;
                chooseCategoryVc.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:chooseCategoryVc animated:YES completion:nil];
                break;
            }
            case 3:
            {
                
                //rent your estate
                ChooseCategoryViewController * chooseCategoryVc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
                
                chooseCategoryVc.browsingForSale = NO;
                chooseCategoryVc.tagOfCallXib = 2;
                chooseCategoryVc.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:chooseCategoryVc animated:YES completion:nil];
                break;

            }
            case 4:
            {
                
                //become a broker
                AddNewStoreViewController *vc;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    vc =[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController" bundle:nil];
                else
                    vc =[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController_iPad" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                break;
            }
            case 5:
            {
                
                //browse brokers
                ExhibitViewController *exVC;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    exVC=[[ExhibitViewController alloc] initWithNibName:@"ExhibitViewController" bundle:nil];
                else
                    exVC=[[ExhibitViewController alloc] initWithNibName:@"ExhibitViewController_iPad" bundle:nil];
                //exVC.countryID=chosenCountry.countryID;
                [self presentViewController:exVC animated:YES completion:nil];
                
                break;
            }
            case 6:
            {
                
                //store orders
                StoreOrdersViewController *vc;
                vc =[[StoreOrdersViewController alloc] initWithNibName:@"StoreOrdersViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                break;
            }
            case 10:
            {
                
                //about app
                AboutAppViewController *vc=[[AboutAppViewController alloc]initWithNibName:@"AboutAppViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                
                break;
            }
            case 7:
            {
                
                //browse favs
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
            case 8:
            {
                
                //settings
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
            case 9:
            {
                [self logout];
                break;
            }
            case 11:
            {
                [self hideMenu];
                UserDetailsViewController *vc=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                break;
            }
            case 12:
            {
                [self hideMenu];
                BrowseStoresViewController *vc=[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
                break;
            }
            case 13:
            {
                [self hideMenu];
                [self CotanctUs];
                break;
            }
            
            default:
                break;
        }
        
    }
    
}

-(void)CotanctUs
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Feedback"];
        [mailer setToRecipients:@[@"mobile@bezaat.com"]];
        
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"لا يوجد بريد إلكتروني مسجل على هذا الجهاز" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) customizeMenu{
    NSString *menuPlistPath = [[NSBundle mainBundle] pathForResource:@"HomeScreenChoices" ofType:@"plist"];
    
    menuArray = [[NSArray alloc] initWithContentsOfFile:menuPlistPath];
    iconMenuArray=[[NSArray alloc]initWithObjects:@"Menu_icon_01.png",@"Menu_icon_02.png",@"Menu_icon_03.png",@"Menu_icon_04.png",@"Menu_icon_05.png",@"Menu_icon_06.png",@"Menu_icon_07.png",@"Menu_icon_08.png",@"Menu_icon_09.png",@"Menu_icon_10.png",@"Menu_icon_11.png",@"Menu_icon_12.png",@"Menu_icon_13.png", nil];
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    // guest
    if(!savedProfile){
        [self.userNameLabel setText:@"زائر"];
        
        [custoMenuArray addObject:[menuArray objectAtIndex:0]];
        [custoMenuArray addObject:[menuArray objectAtIndex:1]];
        [custoMenuArray addObject:[menuArray objectAtIndex:2]];
        [custoMenuArray addObject:[menuArray objectAtIndex:3]];
        [custoMenuArray addObject:[menuArray objectAtIndex:4]];
        [custoMenuArray addObject:[menuArray objectAtIndex:5]];
        [custoMenuArray addObject:[menuArray objectAtIndex:7]];
        [custoMenuArray addObject:[menuArray objectAtIndex:8]];
        [custoMenuArray addObject:[menuArray objectAtIndex:10]];
        [custoMenuArray addObject:[menuArray objectAtIndex:13]];
        
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:0]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:4]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:5]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:11]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:12]];

    }
    // member
    else if (savedProfile){
        [self.userNameLabel setText:savedProfile.userName];
        
        if (savedProfile.hasStores) {
            [custoMenuArray addObject:[menuArray objectAtIndex:0]];
            [custoMenuArray addObject:[menuArray objectAtIndex:1]];
            [custoMenuArray addObject:[menuArray objectAtIndex:2]];
            [custoMenuArray addObject:[menuArray objectAtIndex:3]];
            [custoMenuArray addObject:[menuArray objectAtIndex:12]];
            [custoMenuArray addObject:[menuArray objectAtIndex:4]];
            [custoMenuArray addObject:[menuArray objectAtIndex:5]];
            [custoMenuArray addObject:[menuArray objectAtIndex:6]];
            [custoMenuArray addObject:[menuArray objectAtIndex:7]];
            [custoMenuArray addObject:[menuArray objectAtIndex:9]];
            [custoMenuArray addObject:[menuArray objectAtIndex:10]];
            [custoMenuArray addObject:[menuArray objectAtIndex:13]];

            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:0]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:4]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:5]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:6]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:7]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:11]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:12]];

        }else{
        [custoMenuArray addObject:[menuArray objectAtIndex:11]];
        [custoMenuArray addObject:[menuArray objectAtIndex:0]];
        [custoMenuArray addObject:[menuArray objectAtIndex:1]];
        [custoMenuArray addObject:[menuArray objectAtIndex:2]];
        [custoMenuArray addObject:[menuArray objectAtIndex:3]];
        [custoMenuArray addObject:[menuArray objectAtIndex:4]];
        [custoMenuArray addObject:[menuArray objectAtIndex:5]];
        [custoMenuArray addObject:[menuArray objectAtIndex:6]];
        [custoMenuArray addObject:[menuArray objectAtIndex:7]];
        [custoMenuArray addObject:[menuArray objectAtIndex:9]];
        [custoMenuArray addObject:[menuArray objectAtIndex:10]];
        [custoMenuArray addObject:[menuArray objectAtIndex:13]];
            
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:10]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:0]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:4]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:5]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:6]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:11]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:12]];

        }
    }
}

#pragma mark - LocationManager Delegate Methods

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

#pragma mark - UIAlertView Delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        
        HomePageViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
        else
            vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController_iPad" bundle:nil];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (alertView.tag == 0)
    {
        
    }
}

#pragma mark - helper methods

- (void) customizeGestures {
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftRecognizer];
    
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightRecognizer];
    
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


- (void) logout
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
    [self.iPad_signInBtn setBackgroundImage:[UIImage imageNamed:@"iPad_home_icon_5.png"] forState:UIControlStateNormal];//log in
    [self.iPad_myAdsBtn setEnabled:NO];
    [self.iPad_storeOrdersBtn setEnabled:NO];
    return;
    
}

- (void) handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    if(self.content.frame.origin.x == 0)
        [self showMenu];
}

- (void) handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(self.content.frame.origin.x != 0)
        [self hideMenu];
    
}

#pragma mark - actions

- (IBAction) countryBtnPressed:(id)sender {
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

- (IBAction) sideMenuBtnPressed:(id)sender {
    if(self.content.frame.origin.x == 0) //only show the menu if it is not already shown
        [self showMenu];
    else
        [self hideMenu];
}

- (IBAction) browseEstateForRentBtnPressed:(id)sender {
    
    BrowseAdsViewController_iPad* browseAdsVC_iPad;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        browseAdsVC_iPad = [[BrowseAdsViewController_iPad alloc] initWithNibName:@"BrowseAdsViewController_iPad" bundle:nil];
        browseAdsVC_iPad.currentSubCategoryID = -1;
        browseAdsVC_iPad.browsingForSale = NO;
        browseAdsVC_iPad.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:browseAdsVC_iPad animated:YES completion:nil];
    }else
    {
        ChooseCategoryViewController * chooseCategoryVc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
        
        chooseCategoryVc.browsingForSale = NO;
        chooseCategoryVc.tagOfCallXib = 1;
        chooseCategoryVc.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:chooseCategoryVc animated:YES completion:nil];
    }

    
    
    
    
}

- (IBAction) browseEstateForSellBtnPressed:(id)sender {

    
    BrowseAdsViewController_iPad* browseAdsVC_iPad;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        browseAdsVC_iPad = [[BrowseAdsViewController_iPad alloc] initWithNibName:@"BrowseAdsViewController_iPad" bundle:nil];
        browseAdsVC_iPad.currentSubCategoryID = -1;
        browseAdsVC_iPad.browsingForSale = YES;
        browseAdsVC_iPad.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:browseAdsVC_iPad animated:YES completion:nil];
    }else
    {

    ChooseCategoryViewController * chooseCategoryVc = [[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
    
    chooseCategoryVc.browsingForSale = YES;
    chooseCategoryVc.tagOfCallXib = 1;
    chooseCategoryVc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:chooseCategoryVc animated:YES completion:nil];
    }
}

- (IBAction) rentYourEstateBtnPressed:(id)sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [self hideMenu];
        ChooseCategoryViewController*vc=[[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
        vc.tagOfCallXib=2;
        vc.browsingForSale = NO;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if (savedProfile.hasStores) {
            AddNewStoreAdViewController_iPad *adNewCar=[[AddNewStoreAdViewController_iPad alloc] initWithNibName:@"AddNewStoreAdViewController_iPad" bundle:nil];
            adNewCar.browsingForSale = NO;
            //adNewCar.currentStore = self.currentStore;
            [self presentViewController:adNewCar animated:YES completion:nil];
        }
        else {
            AddNewCarAdViewController_iPad * vc = [[AddNewCarAdViewController_iPad alloc] initWithNibName:@"AddNewCarAdViewController_iPad" bundle:nil];
            vc.browsingForSale = NO;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }

}

- (IBAction) sellYourEstateBtnPressed:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [self hideMenu];
        ChooseCategoryViewController*vc=[[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
        vc.tagOfCallXib=2;
        vc.browsingForSale = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if (savedProfile.hasStores) {
            AddNewStoreAdViewController_iPad *adNewCar=[[AddNewStoreAdViewController_iPad alloc] initWithNibName:@"AddNewStoreAdViewController_iPad" bundle:nil];
            adNewCar.browsingForSale = YES;
             //adNewCar.currentStore = self.currentStore;
             [self presentViewController:adNewCar animated:YES completion:nil];
        }
        else {
            AddNewCarAdViewController_iPad * vc = [[AddNewCarAdViewController_iPad alloc] initWithNibName:@"AddNewCarAdViewController_iPad" bundle:nil];
            vc.browsingForSale = YES;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }


}

- (IBAction) becomeBrokerBtnPressed:(id)sender {
    [self hideMenu];
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if (savedProfile.hasStores) {
        BrowseStoresViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            vc=[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else{
            AddNewStoreViewController *vc;
            vc=[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController_iPad" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        
    }else{
        AddNewStoreViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController" bundle:nil];
        else
            vc =[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    //GA
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"uiAction"
                                                    withAction:@"buttonPress"
                                                     withLabel:@"Add new store"
                                                     withValue:[NSNumber numberWithInt:100]];

}

- (IBAction) browseBrokersBtnPressed:(id)sender {
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController5" bundle:nil];
        else
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        
        vc.returnPage = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if (savedProfile)
            [self logout];
        else {
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
            vc.returnPage = YES;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}

- (IBAction)iPad_myAdsBtnPressed:(id)sender {
    
    UserDetailsViewController *vc=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)iPad_storeOrdersBtnPressed:(id)sender {
    //Ahmad
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        StoreOrdersViewController *vc=[[StoreOrdersViewController alloc]initWithNibName:@"StoreOrdersViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        StoreOrdersViewController *vc=[[StoreOrdersViewController alloc]initWithNibName:@"StoreOrdersViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (IBAction)iPad_storeManagerBtnPressed:(id)sender {
    BrowseStoresViewController *vc=[[BrowseStoresViewController alloc]initWithNibName:@"BrowseStoresViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)iPad_settingsBtnPressed:(id)sender {
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedProfile) {
        GuestProfileViewController *vc=[[GuestProfileViewController alloc]initWithNibName:@"GuestProfileViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
        ProfileDetailsViewController *vc=[[ProfileDetailsViewController alloc]initWithNibName:@"ProfileDetailsViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}

- (IBAction)iPad_aboutAppBtnPressed:(id)sender {
    AboutAppViewController *vc=[[AboutAppViewController alloc]initWithNibName:@"AboutAppViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    /* WalkThroughVC *vc;
     vc =[[WalkThroughVC alloc]initWithNibName:@"WalkThroughVC_iPad" bundle:nil];
     
     [self presentViewController:vc animated:YES completion:nil];*/
}

- (IBAction)iPad_facebookBtnPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/bezaaty"]];
}

- (IBAction)iPad_twitterBtnPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/bezaaty"]];
}

- (IBAction)iPad_contactUsPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Feedback"];
        [mailer setToRecipients:@[@"mobile@bezaat.com"]];
        
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"لا يوجد بريد إلكتروني مسجل على هذا الجهاز" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
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
    self.iPad_background.image = nil;
    [self.iPad_background setImage:[UIImage imageNamed:[NSString stringWithFormat:@"iPad_HomePage_%i.jpg",defaultCountryID]]];
    if (!self.iPad_background.image) {
        [self.iPad_background setImage:[UIImage imageNamed:@"iPad_HomePage_def.jpg"]];
    }

}

- (IBAction) financeBtnPressed:(id)sender {
    
}
@end
