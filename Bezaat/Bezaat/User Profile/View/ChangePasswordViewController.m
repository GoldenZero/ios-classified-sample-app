//
//  ChangePasswordViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChangePasswordViewController.h"

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
        [alert show];
        return;
    }
    
    if (![newPassword isEqualToString:newPassword2]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"كلمة السر غير متوافقة"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
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
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
    
}

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}


@end
