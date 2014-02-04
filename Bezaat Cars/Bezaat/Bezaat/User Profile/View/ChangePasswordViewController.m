//
//  ChangePasswordViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChangePasswordViewController.h"
@interface ChangePasswordViewController ()
{
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}
@end

@implementation ChangePasswordViewController

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
    CurrentUser = [[UserProfile alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveInvoked:(id)sender {
    [self.oldPwdTxt resignFirstResponder];
    [self.pwdNewTxt resignFirstResponder];
    [self.confirmPwdTxt resignFirstResponder];
    CurrentUser = [[ProfileManager sharedInstance] getSavedUserProfile];
    
    
    NSString* oldPassword = self.oldPwdTxt.text;
    NSString* newPassword = self.pwdNewTxt.text;
    NSString* newPassword2 = self.confirmPwdTxt.text;
    
    
    if ([oldPassword length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من كلمة السر القديمة"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([newPassword length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من كلمة السر الجديدة"
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
    [self changePwd:newPassword anduserName:CurrentUser.userName];
    
    
}

-(void)changePwd:(NSString*)newPwd anduserName:(NSString*)name
{
    
    [[ProfileManager sharedInstance] updateUserWithDelegate:self userName:name andPassword:newPwd];
}

-(void)userUpdateWithData:(UserProfile *)newData
{
   // NSLog(@"%@",newData);
    [[ProfileManager sharedInstance] storeUserProfile:newData];
    [self hideLoadingIndicator];
    
    self.oldPwdTxt.text = @"";
    self.pwdNewTxt.text = @"";
    self.confirmPwdTxt.text = @"";
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"تمت العملة بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [alert show];
    
    return;
}

-(void)userFailUpdateWithError:(NSError *)error
{
    
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void) showLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        loadingHUD.dimBackground = YES;
    }
    else {
        iPad_loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
        
        iPad_loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        iPad_loadingView.clipsToBounds = YES;
        iPad_loadingView.layer.cornerRadius = 10.0;
        iPad_loadingView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        
        iPad_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        iPad_activityIndicator.frame = CGRectMake(65, 40, iPad_activityIndicator.bounds.size.width, iPad_activityIndicator.bounds.size.height);
        [iPad_loadingView addSubview:iPad_activityIndicator];
        
        iPad_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        iPad_loadingLabel.backgroundColor = [UIColor clearColor];
        iPad_loadingLabel.textColor = [UIColor whiteColor];
        iPad_loadingLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        iPad_loadingLabel.adjustsFontSizeToFitWidth = YES;
        iPad_loadingLabel.textAlignment = NSTextAlignmentCenter;
        iPad_loadingLabel.text = @"جاري تحميل البيانات";
        [iPad_loadingView addSubview:iPad_loadingLabel];
        
        [self.view addSubview:iPad_loadingView];
        [iPad_activityIndicator startAnimating];
    }
    
}

- (void) hideLoadingIndicator {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (loadingHUD)
            [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
        loadingHUD = nil;
    }
    else {
        if ((iPad_activityIndicator) && (iPad_loadingView)) {
            [iPad_activityIndicator stopAnimating];
            [iPad_loadingView removeFromSuperview];
        }
        iPad_activityIndicator = nil;
        iPad_loadingView = nil;
        iPad_loadingLabel = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}


@end
