//
//  ChangeNameViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController ()

@end

@implementation ChangeNameViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    self.userNameText.text = self.theName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveInvoked:(id)sender {
    
    [self.userNameText resignFirstResponder];
    
    
    NSString* Name = self.self.userNameText.text;
    
    
    if ([Name length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من تعبئة الحقل"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self changeName:Name];
    
    
}

-(void)changeName:(NSString*)name
{
    [self showLoadingIndicator];
    [[ProfileManager sharedInstance] updateUserWithDelegate:self userName:name andPassword:@""];

}

-(void)userUpdateWithData:(UserProfile *)newData
{
    NSLog(@"%@",newData);
    [[ProfileManager sharedInstance] storeUserProfile:newData];
    [self hideLoadingIndicator];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"تمت العملية بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [alert show];
    
    return;

}

-(void)userFailUpdateWithError:(NSError *)error
{
    //NSLog(@"error: %@",error);
    //UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Request time out" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    // [alert show];
    //    return;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

@end
