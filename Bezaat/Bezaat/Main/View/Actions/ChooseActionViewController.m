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
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)BuyCarBtnPressed:(id)sender {
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];

    
}

- (IBAction)AddNewStoreBtnPressed:(id)sender {
}

- (void) prepareImages {
    [toolBar setBackgroundImage:[UIImage imageNamed:@"home_blueRectangle.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    UIImage * backBtnImg = [UIImage imageNamed:@"home_whiteButton.png"];
    UIButton * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [customBtn setImage:backBtnImg forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    NSArray * items = [NSArray arrayWithObjects:button, nil];
    [toolBar setItems:items];
    
}
@end
