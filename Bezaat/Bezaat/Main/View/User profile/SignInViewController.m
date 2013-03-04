//
//  SignInViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
{
    BOOL userSignedIn;
}
@end

@implementation SignInViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)signInBtnPressed:(id)sender {
    
    //perform sign in operation
    //...
    userSignedIn = YES;
    if (userSignedIn)
    {
        ChooseActionViewController * ChooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
        
        [self.navigationController pushViewController:ChooseActionVC animated:YES];
    }
}

- (IBAction)signUpBtnPressed:(id)sender {
}

- (IBAction)skipBtnPressed:(id)sender {
    
    ChooseActionViewController * ChooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    
    [self.navigationController pushViewController:ChooseActionVC animated:YES];
}
@end
