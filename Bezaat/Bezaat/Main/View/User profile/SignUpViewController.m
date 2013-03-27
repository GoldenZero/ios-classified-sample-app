//
//  SignUpViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController (){
     UITapGestureRecognizer *tap;
}

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
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self setBackgroundImages];
    
}
-(void)dismissKeyboard {
    [self.userText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.confirmPasswordText resignFirstResponder];
    [self.emailText resignFirstResponder];
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
