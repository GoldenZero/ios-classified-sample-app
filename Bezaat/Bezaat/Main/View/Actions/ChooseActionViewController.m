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

@interface ChooseActionViewController (){
    NSArray *menuArray;
    NSArray *iconMenuArray;
    NSMutableArray *custoMenuArray;
    NSMutableArray *custoIconMenuArray;
    MBProgressHUD2 * loadingHUD;

}

@end

@implementation ChooseActionViewController
@synthesize AddCarButton,AddStoreButton,BuyCarButton,toolBar;
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
    [self prepareImages];
    [self customGestures];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        AddStoreButton.frame = CGRectMake(AddStoreButton.frame.origin.x, AddStoreButton.frame.origin.y + 30, AddStoreButton.frame.size.width, AddStoreButton.frame.size.height + 78);
        [AddStoreButton setImage:[UIImage imageNamed:@"iphone5_openstore.png"] forState:UIControlStateNormal];
        
        BuyCarButton.frame = CGRectMake(BuyCarButton.frame.origin.x, BuyCarButton.frame.origin.y, BuyCarButton.frame.size.width, BuyCarButton.frame.size.height + 30);
        [BuyCarButton setImage:[UIImage imageNamed:@"iphone5_addcar.png"] forState:UIControlStateNormal];
        
        AddCarButton.frame = CGRectMake(AddCarButton.frame.origin.x, AddCarButton.frame.origin.y, AddCarButton.frame.size.width, AddCarButton.frame.size.height + 30);
        [AddCarButton setImage:[UIImage imageNamed:@"iphone5_buycar.png"] forState:UIControlStateNormal];
    }else
    {
        AddStoreButton.frame = CGRectMake(AddStoreButton.frame.origin.x, AddStoreButton.frame.origin.y + 12, AddStoreButton.frame.size.width, AddStoreButton.frame.size.height);
        
        BuyCarButton.frame = CGRectMake(BuyCarButton.frame.origin.x + 2, BuyCarButton.frame.origin.y + 7, BuyCarButton.frame.size.width, BuyCarButton.frame.size.height);
        
        AddCarButton.frame = CGRectMake(AddCarButton.frame.origin.x - 1, AddCarButton.frame.origin.y + 7, AddCarButton.frame.size.width, AddCarButton.frame.size.height);

    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self customizeMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)AddNewCarAdBtnPressed:(id)sender {
    [self hideMenu];
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=1;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)BuyCarBtnPressed:(id)sender {
    [self hideMenu];
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (savedProfile) {
        ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
        vc.tagOfCallXib=2;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else{
        SignInViewController *vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    
}

- (IBAction)AddNewStoreBtnPressed:(id)sender {
    [self hideMenu];
    /*
    AddNewStoreViewController *vc=[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
     */
    NSString* launchUrl = @"http://bezaat.com/ksa/riyadh/account/create-store";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];

}

- (IBAction)sideMenuBtnPressed:(id)sender {
    
    if(self.content.frame.origin.x == 0) //only show the menu if it is not already shown
        [self showMenu];
    else
        [self hideMenu];
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
    iconMenuArray=[[NSArray alloc]initWithObjects:@"Menu_icon_01.png",@"Menu_icon_02.png",@"Menu_icon_03.png",@"Menu_icon_04.png",@"Menu_icon_05.png",@"Menu_icon_06.png",@"Menu_icon_07.png",@"Menu_icon_08.png",@"Menu_icon_09.png",@"Menu_icon_10.png", nil];

     UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];

    // gust
    if(!savedProfile){
        [self.userNameLabel setText:@"زائر"];
        
        [custoMenuArray addObject:[menuArray objectAtIndex:1]];
        [custoMenuArray addObject:[menuArray objectAtIndex:3]];
        [custoMenuArray addObject:[menuArray objectAtIndex:6]];
        [custoMenuArray addObject:[menuArray objectAtIndex:7]];
        [custoMenuArray addObject:[menuArray objectAtIndex:9]];
        
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:6]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:7]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];
    }
    // member
    else if (savedProfile){
        [self.userNameLabel setText:savedProfile.userName];
        if (savedProfile.hasStores) {
            [custoMenuArray addObject:[menuArray objectAtIndex:1]];
            [custoMenuArray addObject:[menuArray objectAtIndex:2]];
            [custoMenuArray addObject:[menuArray objectAtIndex:3]];
            [custoMenuArray addObject:[menuArray objectAtIndex:6]];
            [custoMenuArray addObject:[menuArray objectAtIndex:8]];
            [custoMenuArray addObject:[menuArray objectAtIndex:9]];
            
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:6]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];

        }
        
        else{
            [custoMenuArray addObject:[menuArray objectAtIndex:0]];
            [custoMenuArray addObject:[menuArray objectAtIndex:1]];
            [custoMenuArray addObject:[menuArray objectAtIndex:3]];
            [custoMenuArray addObject:[menuArray objectAtIndex:6]];
            [custoMenuArray addObject:[menuArray objectAtIndex:8]];
            [custoMenuArray addObject:[menuArray objectAtIndex:9]];
        
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:0]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:6]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];
            [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:9]];
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
                BrowseStoresViewController *vc=[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
             
                break;
            }
            case 3:
            {
                [self hideMenu];
                AddNewStoreViewController *vc=[[AddNewStoreViewController alloc] initWithNibName:@"AddNewStoreViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];

                break;
            }
            case 4:
            {
                // TODO CODE
                //_____________________
                // Notifications view
                //_____________________

                break;
            }
            case 5:
            {
                // TODO CODE
                //_____________________
                // Favorites view
                //_____________________

                break;
            }
            case 6:
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
            case 7:
            {
                [self hideMenu];
                if ([[UIScreen mainScreen] bounds].size.height == 568){
                    SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController5" bundle:nil];
                    [self presentViewController:vc animated:YES completion:nil];
                }else {
                    SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
                    [self presentViewController:vc animated:YES completion:nil];
                }

                break;
            }
            case 8:
            {
                [self logout];
                /*
                [self hideMenu];
                [self showLoadingIndicator];
                [[ProfileManager loginKeyChainItemSharedInstance] resetKeychainItem];
                
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد تم تسجيل الخروج" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [self hideLoadingIndicator];
                [alert show];
*/
                break;
            }
            case 9:
            {
                [self hideMenu];
                AboutAppViewController *vc=[[AboutAppViewController alloc]initWithNibName:@"AboutAppViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];

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
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
    
}

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
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
        ChooseActionViewController *vc=[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (alertView.tag == 0)
    {
        
    }
}

@end
