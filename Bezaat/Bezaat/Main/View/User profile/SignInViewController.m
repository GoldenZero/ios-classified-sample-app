//
//  SignInViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SignInViewController.h"
#import "FriendsListViewController.h"
@interface SignInViewController ()
{
    BOOL userSignedIn;
    FacebookManager * fbManager;
    //TwitterManager * twManager;
    MBProgressHUD2 * loadingHUD;
}
@end

@implementation SignInViewController
@synthesize signInButton,signUpButton,skipButton,twButton,fbButton;

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
    
    //initialize facebook manager
    [self prepareImages];
    fbManager = [[FacebookManager alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)signInBtnPressed:(id)sender {
    
    // check for internet connectivity
    if (![GenericMethods connectedToInternet])
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل الاتصال بالإنترنت" delegateVC:self];
        return;
    }
    
    //perform sign in operation
    //...
    userSignedIn = YES;
    if (userSignedIn)
    {
        ChooseActionViewController * chooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
        
        [self presentViewController:chooseActionVC animated:YES completion:nil];
    }
   
}

- (IBAction)signUpBtnPressed:(id)sender {
    
    SignUpViewController * signUpVC = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self presentViewController:signUpVC animated:YES completion:nil];
}

- (IBAction)skipBtnPressed:(id)sender {
    
    ChooseActionViewController * chooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    
    [self presentViewController:chooseActionVC animated:YES completion:nil];
}

- (IBAction)fbBtnPressed:(id)sender {
    
    // check for internet connectivity
    if (![GenericMethods connectedToInternet])
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل الاتصال بالإنترنت" delegateVC:self];
        return;
    }
    
    [self showLoadingIndicator];
    [fbManager performLogin];
    
}

- (IBAction)twBtnPressed:(id)sender {
    // check for internet connectivity
    if (![GenericMethods connectedToInternet])
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل الاتصال بالإنترنت" delegateVC:self];
        return;
    }
}


#pragma mark - FacebookLogin Delegate
- (void) fbDidFinishLogging {
    
    [self hideLoadingIndicator];
    
    if ([SharedUser fbSharedSessionInstance].isOpen) {
        NSLog(@"Logged successfully");
        [fbManager getUserDataDictionary];
        
    } else {
        if ([SharedUser fbSharedSessionInstance].accessTokenData)
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل عملسة تسجيل الدخول" delegateVC:self];
    }
    
}


#pragma mark - helper methods

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.navigationController.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    
    loadingHUD.labelText = @"يرجى الانتظار";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
}

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.navigationController.view  animated:YES];
    loadingHUD = nil;
}

- (void) prepareImages{
    UIImageView *backgroundBlue=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_blueGradient.png"]];
    UIImageView *backgroundGray=[[UIImageView alloc] initWithFrame:CGRectMake(0, 380, 320, 70)];

    backgroundGray.image= [UIImage imageNamed:@"LogIn_Bottom_BG.png"];
    [self.view addSubview:backgroundBlue];
    [self.view addSubview:backgroundGray];
    [self.view sendSubviewToBack:backgroundBlue];
    [self.view insertSubview:backgroundGray aboveSubview:backgroundBlue];
    [self.logoImageView setImage:[UIImage imageNamed:@"account_logo.png"]];

    [self.fbButton setBackgroundImage:[UIImage imageNamed:@"account_facebookButton.png"] forState:UIControlStateNormal];
    [self.twButton setBackgroundImage:[UIImage imageNamed:@"account_twitterButton.png"] forState:UIControlStateNormal];
    [self.signInButton setBackgroundImage:[UIImage imageNamed:@"account_loginButton.png"] forState:UIControlStateNormal];
    [self.signUpButton setBackgroundImage:[UIImage imageNamed:@"account_registrationButton.png"] forState:UIControlStateNormal];
    [self.skipButton setBackgroundImage:[UIImage imageNamed:@"account_skipButton.png"] forState:UIControlStateNormal];
    UIImageView *line=[[UIImageView alloc] initWithFrame:CGRectMake(0, 456, 320, 4)];
    line.image=[UIImage imageNamed:@"account_skipLine.png"];
    [self.view addSubview:line];
    UIImageView *whiteRectangle=[[UIImageView alloc] initWithFrame:CGRectMake(0, 320, 320, 70)];
    whiteRectangle.image=[UIImage imageNamed:@"account_whiteRectangle.png"];
    [self.view addSubview:whiteRectangle];
    [self.view insertSubview:whiteRectangle aboveSubview:backgroundGray];
    // [self.view insertSubview:line aboveSubview:backgroundGray];
    
    
    
}

@end
