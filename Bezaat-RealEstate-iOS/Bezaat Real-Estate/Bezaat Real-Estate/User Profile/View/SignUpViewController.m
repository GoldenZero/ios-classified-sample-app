//
//  SignUpViewController.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 7/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "HomePageViewController.h"

@interface SignUpViewController ()
{
    BOOL userSignedIn;
    FacebookManager * fbManager;
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
    
    //GA
    [[GAI sharedInstance].defaultTracker  sendView:@"Register screen"];
    // end GA
    //initialize facebook manager
    fbManager = [[FacebookManager alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)backBtnPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearBtnPressed:(id)sender {
    self.userText.text = @"";
    self.emailText.text = @"";
    self.passwordText.text = @"";
    self.confirmPasswordText.text = @"";
}

- (IBAction)registerBtnPressed:(id)sender {
    
    [self.userText resignFirstResponder];
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.confirmPasswordText resignFirstResponder];
    
    
    NSString* userName = self.userText.text;
    NSString* email = self.emailText.text;
    NSString* newPassword = self.passwordText.text;
    NSString* newPassword2 = self.confirmPasswordText.text;
    
    
    if ([userName length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من إدخال اسم المستخدم"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([email length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من إدخال البريد الإلكتروني"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![GenericMethods validateEmail:email]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من إدخال البريد الإلكتروني بشكل صحيح"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([newPassword length] < 5) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"كلمة السر يجب ان تكون 5 ارقام"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if ([newPassword length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من كلمة السر"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![newPassword isEqualToString:newPassword2]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"كلمة السر غير متوافقة"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    [self showLoadingIndicator];
    
    [[ProfileManager sharedInstance] registerWithDelegate:self UserName:self.userText.text AndEmail:self.emailText.text andPassword:self.passwordText.text];
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

#pragma mark - FacebookLogin Delegate

- (void)fbDidFinishLogging:(FBSession *)session
                     state:(FBSessionState) state
                     error:(NSError *)error {
    
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // NSLog(@"User session found");
                if (FBSession.activeSession.isOpen) {
                    [[FBRequest requestForMe] startWithCompletionHandler:
                     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                         if (!error) {
                             //NSLog(@"User_Info: %@",user);
                             [[ProfileManager sharedInstance] loginWithFacebookDelegate:self email:[user objectForKey:@"email"] AndUserName:user.name andFacebookid:user.id];
                         }
                     }];
                }
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"لم تتم عملية الدخول بنجاح"
                                  message:@""
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
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
    
    [[ProfileManager sharedInstance] loginWithTwitterDelegate:self email:@"" AndUserName:twOAuthObj.screen_name andTwitterid:twOAuthObj.user_id];
}

-(void)twitterDidNotLogin:(BOOL)cancelled {
    [SharedUser setNewTwitterToken:nil];//set the token to nil if twitter sign in fails.
}

#pragma mark - ProfileManager delegate methods

- (void) userDidLoginWithData:(UserProfile *)resultProfile {
    
    //save user's data
    [[ProfileManager sharedInstance] storeUserProfile:resultProfile];
    
    //hide loading indicator
    [self hideLoadingIndicator];
    
    //present the next view controller
    HomePageViewController * chooseActionVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    
    [self presentViewController:chooseActionVC animated:YES completion:nil];
    
    [GAI sharedInstance].defaultTracker.sessionStart = YES;
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"app_flow"
                                                    withAction:@"sign_in"
                                                     withLabel:@"bezaat"
                                                     withValue:nil]; // First activity of new session.
    
}

- (void) userFailLoginWithError:(NSError *)error {
    
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
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
    [GAI sharedInstance].defaultTracker.sessionStart = YES;
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"app_flow"
                                                    withAction:@"register"
                                                     withLabel:@"twitter"
                                                     withValue:nil]; // First activity of new session.
    
    
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

-(void)userDidLoginWithFacebookData:(UserProfile *)resultProfile
{
    NSLog(@"logged");
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
    [GAI sharedInstance].defaultTracker.sessionStart = YES;
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"app_flow"
                                                    withAction:@"register"
                                                     withLabel:@"facebook"
                                                     withValue:nil]; // First activity of new session.
    
    
}

-(void)userFailLoginWithFacebookError:(NSError *)error
{
    NSLog(@"failed");
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
}



-(void)userFailRegisterWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)userDidRegisterWithData:(UserProfile *)resultProfile
{
    [self hideLoadingIndicator];
    
    //save user's data
    [[ProfileManager sharedInstance] storeUserProfile:resultProfile];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم التسجيل بنجاح"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil, nil];
    
    alert.tag = 3;
    [alert show];
    [GAI sharedInstance].defaultTracker.sessionStart = YES;
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"app_flow"
                                                    withAction:@"register"
                                                     withLabel:@"bezaat"
                                                     withValue:nil]; // First activity of new session.
    
}

#pragma mark - UIAlertView Delegate methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 4) {
        if (buttonIndex == 1)
        {
            alertView.hidden = YES;
        }else if (buttonIndex == 0)
        {
            if (![GenericMethods validateEmail:self.emailText.text]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من إدخال البريد الإلكتروني بشكل صحيح"
                                                               delegate:nil cancelButtonTitle:@"موافق"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            [[ProfileManager sharedInstance] loginWithTwitterDelegate:self email:self.twitterEmail.text AndUserName:twOAuthObj.screen_name andTwitterid:twOAuthObj.user_id];
        }
    }
    else if (alertView.tag == 3){
        
        //present the next view controller
        HomePageViewController * chooseActionVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
        
        [self presentViewController:chooseActionVC animated:YES completion:nil];
    }
    else if (alertView.tag == 2){
        
        //present the next view controller
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else {
            SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}


- (void) showLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        // Add
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        
        loadingHUD.dimBackground = YES;
    }
    
}

- (void) hideLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (loadingHUD) {
            [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
        }
        loadingHUD = nil;
    }
    
}


#pragma mark - UITextField Delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - helper methods

- (void) dismissKeyboard {
    [self.userText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.confirmPasswordText resignFirstResponder];
    [self.emailText resignFirstResponder];
}

@end
