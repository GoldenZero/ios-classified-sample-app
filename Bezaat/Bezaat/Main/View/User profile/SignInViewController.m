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
 
    //GA
    [[GAI sharedInstance].defaultTracker  sendView:@"Login screen"];
    // end GA
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
    
    [self.userNameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    
    NSString* userName = self.userNameText.text;
    NSString* newPassword = self.passwordText.text;
    
    
    if ([userName length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من إدخال اسم المستخدم"
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

    //The manager checks for internet connectivity
    //show loading indicator
    [self showLoadingIndicator];
    
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

- (IBAction)forgetPwdBtnPressed:(id)sender {
    NSString* launchUrl = @"http://www.bezaat.com/ksa/riyadh/account/forgot-password";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}


#pragma mark - FacebookLogin Delegate
- (void)fbDidFinishLogging:(FBSession *)session
                     state:(FBSessionState) state
                     error:(NSError *)error
{
    
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // NSLog(@"User session found");
                if (FBSession.activeSession.isOpen) {
                    [[FBRequest requestForMe] startWithCompletionHandler:
                     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                         if (!error) {
                             NSLog(@"User_Info: %@",user);
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
    
    /*
     [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
     
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"لم تتم عملية الدخول بنجاح"
                                  message:@""
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }*/
    [self hideLoadingIndicator];
    
    if ([SharedUser fbSharedSessionInstance].isOpen) {
        NSLog(@"Logged successfully");
        [fbManager getUserDataDictionary];
        
    } else {
        if ([SharedUser fbSharedSessionInstance].accessTokenData){
            [fbManager getUserDataDictionary];
        }
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
    
    [GAI sharedInstance].defaultTracker.sessionStart = YES;
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"app_flow"
                                                    withAction:@"sign_in"
                                                     withLabel:@"bezaat"
                                                     withValue:nil]; // First activity of new session.

    if (self.returnPage) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
    //present the next view controller
    ChooseActionViewController * chooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    
    [self presentViewController:chooseActionVC animated:YES completion:nil];
    }
}

- (void) userFailLoginWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
//    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
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
                                                    withAction:@"sign_in"
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
                        withAction:@"sign_in"
                         withLabel:@"facebook"
                         withValue:nil]; // First activity of new session.
    return;

}

-(void)userFailLoginWithFacebookError:(NSError *)error
{
    NSLog(@"failed");
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
    
    [self hideLoadingIndicator];
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
        if (self.returnPage) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
    //present the next view controller
    ChooseActionViewController * chooseActionVC = [[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    
    [self presentViewController:chooseActionVC animated:YES completion:nil];
        }
}

}

#pragma mark - helper methods

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    
    loadingHUD.labelText = @"يرجى الانتظار";
    loadingHUD.detailsLabelText = @"";

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        loadingHUD.dimBackground = YES;
    else
        loadingHUD.dimBackground = NO;
}

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationPortrait;
    else
        return UIInterfaceOrientationLandscapeLeft;
}
@end
