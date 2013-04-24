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

@interface ChooseActionViewController (){
    NSArray *menuArray;
    NSArray *iconMenuArray;
    NSMutableArray *custoMenuArray;
    NSMutableArray *custoIconMenuArray;
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
    [self customizeMenu];
       self.menuTableView.separatorColor = [UIColor clearColor];
    
    [self prepareImages];
    [self customGestures];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)AddNewCarAdBtnPressed:(id)sender {
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=1;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)BuyCarBtnPressed:(id)sender {
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=1;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)AddNewStoreBtnPressed:(id)sender {
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
    cell.titleLable.text=[custoMenuArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) customizeMenu{
    NSString *menuPlistPath = [[NSBundle mainBundle] pathForResource:@"HomeScreenChoices" ofType:@"plist"];
    
    menuArray = [[NSArray alloc] initWithContentsOfFile:menuPlistPath];
    iconMenuArray=[[NSArray alloc]initWithObjects:@"Menu_icon_01.png",@"Menu_icon_02.png",@"Menu_icon_03.png",@"Menu_icon_04.png",@"Menu_icon_05.png",@"Menu_icon_06.png",@"Menu_icon_07.png",@"Menu_icon_08.png",@"Menu_icon_09.png", nil];

     UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
       // gust
    if(!savedProfile){
        [self.userNameLabel setText:@"زائر"];
        [custoMenuArray addObject:[menuArray objectAtIndex:1]];
        [custoMenuArray addObject:[menuArray objectAtIndex:3]];
        [custoMenuArray addObject:[menuArray objectAtIndex:7]];
        
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:7]];
    }
    // member
    else if (savedProfile){
        [self.userNameLabel setText:savedProfile.userName];
      // IF store
        [custoMenuArray addObject:[menuArray objectAtIndex:1]];
        [custoMenuArray addObject:[menuArray objectAtIndex:2]];
        [custoMenuArray addObject:[menuArray objectAtIndex:3]];
        [custoMenuArray addObject:[menuArray objectAtIndex:6]];
        [custoMenuArray addObject:[menuArray objectAtIndex:8]];
        
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:2]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:6]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];

        // If member
        [custoMenuArray addObject:[menuArray objectAtIndex:0]];
        [custoMenuArray addObject:[menuArray objectAtIndex:1]];
        [custoMenuArray addObject:[menuArray objectAtIndex:3]];
        [custoMenuArray addObject:[menuArray objectAtIndex:6]];
        [custoMenuArray addObject:[menuArray objectAtIndex:8]];
        
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:0]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:1]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:3]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:6]];
        [custoIconMenuArray addObject:[iconMenuArray objectAtIndex:8]];

    
    }
}
#pragma mark - UITableView Delegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1){
        ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
        vc.tagOfCallXib=2;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if (indexPath.row==0) {
        labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    if (indexPath.row == 8) {
        ProfileDetailsViewController* vc = [[ProfileDetailsViewController alloc]initWithNibName:@"ProfileDetailsViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    if (indexPath.row == 5) {
        UserDetailsViewController* vc = [[UserDetailsViewController alloc]initWithNibName:@"UserDetailsViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
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


@end
