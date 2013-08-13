//
//  SendEmailViewController.m
//  Bezaat
//
//  Created by GALMarei on 5/20/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SendEmailViewController.h"

@interface SendEmailViewController ()
{
     MBProgressHUD2 *loadingHUD;
}
@end

@implementation SendEmailViewController

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
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Send Email Screen"];
    //end GA
    
    UserProfile* user = [[SharedUser sharedInstance] getUserProfileData];
    if (user) {
        self.nameField.text = user.userName;
        self.emailField.text = user.emailAddress;
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)EmailDidFailSendingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)EmailDidFinishSendingWithStatus:(BOOL)Status
{
    [self hideLoadingIndicator];

    if (Status) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"لقد تم ارسال رسالتك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
        return;
        
    }
}

- (IBAction)sendBtnPrss:(id)sender {
    
    if ([self.nameField.text length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"يرجى اضافة الإسم" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.emailField.text length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"يرجى اضافة البريد الإلكتروني" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.subjectField.text length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"يرجى اضافة نص الرسالة" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self showLoadingIndicator];
    
    [[CarAdsManager sharedInstance] sendEmailofName:self.nameField.text withEmail:self.emailField.text phoneNumber:self.phoneNumberField.text.integerValue message:self.subjectField.text withAdID:self.DetailsObject.adID WithDelegate:self];
    
}

- (IBAction)cancelBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}



@end
