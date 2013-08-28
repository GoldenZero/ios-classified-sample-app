//
//  BankTransferPaymentVC.m
//  Bezaat
//
//  Created by GALMarei on 7/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BankTransferPaymentVC.h"

@interface BankTransferPaymentVC ()
{
    UITapGestureRecognizer *tap;
    MBProgressHUD2 * loadingHUD;
    
    NSString* transferDate;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;

}
@end

@implementation BankTransferPaymentVC

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
    
    self.inputAccessoryView = [XCDFormInputAccessoryView new];
    
    // Set tapping gesture
    tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _DatePicker.delegate = self;
    [_DatePicker setDate:[NSDate date]];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* component = [cal components:(NSYearCalendarUnit) fromDate:[[NSDate alloc] init]];
    [component setYear:[component year] - 80];
    NSDate* dateFrom = [cal dateFromComponents:component];
    [_DatePicker setMinimumDate:dateFrom];
    [_DatePicker setMaximumDate:[NSDate date]];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd LL yyyy"];
    


}

- (void) datePickerDone:(UICustomDatePicker *)theDatePicker {
    _DatePicker.hidden = YES;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    if (_DatePicker.tag == 0) {
       // [_dateBirthCell setLabelText:[df stringFromDate:[_DatePicker date]]];
        [self.transferDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.transferDateBtn setTitle:[df stringFromDate:[_DatePicker date]] forState:UIControlStateNormal];
        transferDate = [df stringFromDate:[_DatePicker date]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard
{
    [self.senderText resignFirstResponder];
    [self.transferNumText resignFirstResponder];
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)payInvoked:(id)sender {
    [self.senderText resignFirstResponder];
    [self.transferNumText resignFirstResponder];
    
    
    NSString* senderName = self.senderText.text;
    NSString* transferNum = self.transferNumText.text;
    
    
    if ([senderName length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من تعبئة جميع الحقول"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([transferNum length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من تعبئة جميع الحقول"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;

        
    }
    if ([transferDate length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من تعبئة جميع الحقول"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;

        
    }
       
    [self showLoadingIndicator];

    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] postBankPaymentWithOrderID:self.currentOrder.OrderID andName:self.senderText.text andBankTransactionNum:[self.transferNumText.text integerValue] andTransactionDate:transferDate];
}

- (IBAction)dateInvoked:(id)sender {
    [self dismissKeyboard];
    _DatePicker.hidden = NO;
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

-(void)bankTransferPaymentDidFailPostingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)bankTransferPaymentDidFinishPostingWithStatus:(BOOL)status
{
    [self hideLoadingIndicator];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"شكرا لقد اتممت العملية"
                                                   delegate:self cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
