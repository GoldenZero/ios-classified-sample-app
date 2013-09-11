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
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
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
    [TestFlight passCheckpoint:@"Send Email Screen"];
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
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}



@end
