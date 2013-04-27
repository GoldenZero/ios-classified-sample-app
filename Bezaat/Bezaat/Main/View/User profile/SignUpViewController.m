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

    BOOL userSignedIn;
    FacebookManager * fbManager;
    //TwitterManager * twManager;
    MBProgressHUD2 * loadingHUD;
    UITapGestureRecognizer *tap;
    OAuth *twOAuthObj;

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
    [self.contentView addGestureRecognizer:tap];
    [self setBackgroundImages];
    
    //initialize facebook manager
    fbManager = [[FacebookManager alloc] initWithDelegate:self];
    
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
    // check for internet connectivity
    if (![GenericMethods connectedToInternet])
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل الاتصال بالإنترنت" delegateVC:self];
        return;
    }
    
    [self showLoadingIndicator];
    [fbManager performLogin];
}

- (IBAction)twButtonPressed:(id)sender {
    
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

- (IBAction)deleteButtonPressed:(id)sender {
    
    self.userText.text = @"";
    self.emailText.text = @"";
    self.passwordText.text = @"";
    self.confirmPasswordText.text = @"";
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [[ProfileManager sharedInstance] registerWithDelegate:self UserName:self.userText.text AndEmail:self.emailText.text andPassword:self.passwordText.text];
    
    
    
}

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    // [GenericMethods throwAlertWithTitle:@"Twitter" message:@"Sucessfully Authenticated to Twitter ^__^" delegateVC:self];
    
    [[ProfileManager sharedInstance] loginWithTwitterDelegate:self email:@"" AndUserName:twOAuthObj.screen_name andTwitterid:twOAuthObj.user_id];
}

-(void)twitterDidNotLogin:(BOOL)cancelled {
    [SharedUser setNewTwitterToken:nil];//set the token to nil if twitter sign in fails.
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل عملية تسجيل الدخول" delegateVC:self];
}

#pragma mark - ProfileManager delegate methods
- (void) userDidLoginWithData:(UserProfile *)resultProfile {
    
    //save user's data
    [[ProfileManager sharedInstance] storeUserProfile:resultProfile];
    
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


-(void)userDidLoginWithTwitterData:(UserProfile *)resultProfile
{
    
    //save user's data
    [[ProfileManager sharedInstance] storeUserProfile:resultProfile];
    
    //hide loading indicator
    [self hideLoadingIndicator];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم تسجيل الدخول بنجاح"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil, nil];
    
    alert.tag = 3;
    [alert show];
    
    
}

-(void)userFailLoginWithTwitterError:(NSError *)error
{
    // [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"الرجاء تزويدنا بالبريد الإلكتروني"
                                                    message:@"\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:@"إلغاء", nil];
    
    self.twitterEmail = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, 260, 25)];
    [self.twitterEmail setBackgroundColor:[UIColor whiteColor]];
    [self.twitterEmail setPlaceholder:@"123@eample.com"];
    [self.twitterEmail setTextAlignment:NSTextAlignmentCenter];
    self.twitterEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [alert addSubview:self.twitterEmail];
    
    // show the dialog box
    alert.tag = 4;
    [alert show];
    
    // set cursor and show keyboard
    [self.twitterEmail becomeFirstResponder];
    
}


-(void)userFailRegisterWithError:(NSError *)error
{
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)userDidRegisterWithData:(UserProfile *)resultProfile
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم التسجيل بنجاح"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil, nil];
    
    alert.tag = 2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 4) {
        if (buttonIndex == 1)
        {
            alertView.hidden = YES;
        }else if (buttonIndex == 0)
        {
            [[ProfileManager sharedInstance] loginWithTwitterDelegate:self email:self.twitterEmail.text AndUserName:twOAuthObj.screen_name andTwitterid:twOAuthObj.user_id];
        }
    }
    else if (alertView.tag == 3){
        
        //present the next view controller
        ChooseActionViewController * chooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
        
        [self presentViewController:chooseActionVC animated:YES completion:nil];
    }
    else if (alertView.tag == 2){
        
        //present the next view controller
        SignInViewController * chooseActionVC = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        
        [self presentViewController:chooseActionVC animated:YES completion:nil];
    }
    
}

#pragma mark -- custom methods
- (void) setBackgroundImages{
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
   }

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
}

@end
