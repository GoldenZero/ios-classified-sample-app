//
//  BankTransferPaymentVC.h
//  Bezaat
//
//  Created by GALMarei on 7/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreOrder.h"
#import "StoreManager.h"
#import "UICustomDatePicker.h"
#import "XCDFormInputAccessoryView.h"

@interface BankTransferPaymentVC : BaseViewController<StoreManagerDelegate,UICustomDatePickerDelegate>

@property (strong, nonatomic) IBOutlet UICustomDatePicker *DatePicker;
@property (strong, nonatomic) IBOutlet UITextField *senderText;
@property (strong, nonatomic) IBOutlet UITextField *transferNumText;
@property (strong, nonatomic) IBOutlet UITextField *promoCodeText;
@property (strong, nonatomic) IBOutlet UIButton *transferDateBtn;
@property (strong, nonatomic) StoreOrder* currentOrder;

@property (strong, nonatomic) IBOutlet UIPopoverController *iPad_datePickerPopOver;
@property (strong, nonatomic) IBOutlet UIDatePicker *iPad_datePicker;

@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;

- (IBAction)backInvoked:(id)sender;
- (IBAction)payInvoked:(id)sender;
- (IBAction)dateInvoked:(id)sender;

- (IBAction)iPad_cancelInvoked:(id)sender;
@end
