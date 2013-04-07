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
    UITapGestureRecognizer *tap;
    OAuth *twOAuthObj;
}
@end

@implementation SignInViewController
@synthesize signInButton,signUpButton,skipButton,twButton,fbButton,userNameText,passwordText;

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
 
    //initialize facebook manager
    fbManager = [[FacebookManager alloc] initWithDelegate:self];
}

-(void)dismissKeyboard {
    [self.userNameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)signInBtnPressed:(id)sender {
    
    // check for internet connectivity
    //The manager checks it!
    
    //perform sign in operation
    [[ProfileManager sharedInstance] loginWithDelegate:self email:userNameText.text password:passwordText.text];
    
   
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
    
    if (!twOAuthObj)
        twOAuthObj = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
    
    TwitterDialog *td = [[TwitterDialog alloc] init];
    td.twitterOAuth = twOAuthObj;
    td.delegate = self;
    td.logindelegate = self;
    
    [td show];
}


#pragma mark - FacebookLogin Delegate
- (void) fbDidFinishLogging {
    
    [self hideLoadingIndicator];
    
    if ([SharedUser fbSharedSessionInstance].isOpen) {
        NSLog(@"Logged successfully");
        [fbManager getUserDataDictionary];
        
    } else {
        if ([SharedUser fbSharedSessionInstance].accessTokenData)
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل عملية تسجيل الدخول" delegateVC:self];
    }
    
}

#pragma mark - TwitterLoginDialog Delegate

- (void)twitterDidLogin {
    //Save Details
    [SharedUser setNewTwitterToken:twOAuthObj];
    
    /*
     NSLog(@"token = %@", oAuth.oauth_token);
     NSLog(@"token secret = %@", oAuth.oauth_token_secret);
     NSLog(@"user_id = %@", oAuth.user_id);
     NSLog(@"screen_name = %@", oAuth.screen_name);
     */
    
    [GenericMethods throwAlertWithTitle:@"Twitter" message:@"Sucessfully Authenticated to Twitter ^__^" delegateVC:self];
}

-(void)twitterDidNotLogin:(BOOL)cancelled {
    [SharedUser setNewTwitterToken:nil];//set the token to nil if twitter sign in fails.
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل عملية تسجيل الدخول" delegateVC:self];
}

#pragma mark - ProfileManager delegate methods
- (void) userDidLoginWithData:(UserProfile *)resultProfile {
    
    //set the current user's profiles
    [[SharedUser sharedInstance] setCurrentProfile:resultProfile];

    //save user's login data
    [[ProfileManager sharedInstance] storeLoginUseremail:resultProfile.emailAddress passwordMD5:resultProfile.passwordMD5];
    
    //hide loading indicator
    [self hideLoadingIndicator];
    
    //present the next view controller
    ChooseActionViewController * chooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    
    [self presentViewController:chooseActionVC animated:YES completion:nil];
    
}

- (void) userFailLoginWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
}


#pragma mark - helper methods

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
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



@end
