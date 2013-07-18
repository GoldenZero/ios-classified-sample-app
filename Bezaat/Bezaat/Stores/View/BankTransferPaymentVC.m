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
    _DatePicker.hidden = NO;
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

-(void)bankTransferPaymentDidFailPostingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)bankTransferPaymentDidFinishPostingWithStatus:(BOOL)status
{
    [self hideLoadingIndicator];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"شكرا لقد اتممت العملية"
                                                   delegate:nil cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil, nil];
    [alert show];
    return;
}

@end
