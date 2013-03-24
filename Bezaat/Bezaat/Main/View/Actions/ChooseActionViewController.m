//
//  ChooseActionViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseActionViewController.h"
#import "BHCollectionViewController.h"

@interface ChooseActionViewController ()

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
    [super viewDidLoad];
    [self prepareImages];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)AddNewCarAdBtnPressed:(id)sender {
    
}

- (IBAction)BuyCarBtnPressed:(id)sender {
    BHCollectionViewController *vc=[[BHCollectionViewController alloc] initWithNibName:@"BHCollectionViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)AddNewStoreBtnPressed:(id)sender {
}

- (void) prepareImages {
    [AddCarButton setBackgroundImage:[UIImage imageNamed:@"home_addButton.png"] forState:UIControlStateNormal];
    [BuyCarButton setBackgroundImage:[UIImage imageNamed:@"home_buyButton.png"] forState:UIControlStateNormal];
    [AddStoreButton setBackgroundImage:[UIImage imageNamed:@"home_store.png"] forState:UIControlStateNormal];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"home_blueRectangle.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    UIImage * backBtnImg = [UIImage imageNamed:@"home_whiteButton.png"];
    UIButton * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60 , 40)];
    [customBtn setImage:backBtnImg forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    NSArray * items = [NSArray arrayWithObjects:button, nil];
    [toolBar setItems:items];
    
}
@end
