//
//  SignUpViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    [self setBackgroundImages];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- Actions

- (IBAction)fbButtonPressed:(id)sender {
}

- (IBAction)twButtonPressed:(id)sender {
}

- (IBAction)deleteButtonPressed:(id)sender {
}

- (IBAction)saveButtonPressed:(id)sender {
}
- (void)popSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- custom methods
- (void) setBackgroundImages{
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"home_blueRectangle.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    [self.facebookButton setBackgroundImage:[UIImage   imageNamed:@"SignUp_Facebook.png"] forState:UIControlStateNormal];
    [self.twitterButton setBackgroundImage:[UIImage   imageNamed:@"SignUp_Twitter.png"] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage   imageNamed:@"SignUp_rigester.png"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage   imageNamed:@"SignUp_Clear.png"] forState:UIControlStateNormal];
    UIImageView *background=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320, 480)];
    background.image=[UIImage imageNamed:@"SignUp_Bottom_bg.png"];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    self.titleView.image=[UIImage imageNamed:@"SignUp_Top_BG.png"];
    self.sepratorImage.image=[UIImage imageNamed:@"SignUp_Or_Slice.png"];
    
    UIImage * backBtnImg = [UIImage imageNamed:@"share_arrowButton.png"];
    UIButton * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40 , 40)];
    [customBtn setImage:backBtnImg forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    NSArray * items = [NSArray arrayWithObjects:button, nil];
    [self.toolBar setItems:items];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
