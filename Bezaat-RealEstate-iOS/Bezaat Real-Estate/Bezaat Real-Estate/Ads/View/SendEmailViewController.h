//
//  SendEmailViewController.h
//  Bezaat
//
//  Created by GALMarei on 5/20/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdsManager.h"
#import "AdDetails.h"
#import "GAI.h"

@interface SendEmailViewController : BaseViewController<SendEmailDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextView *subjectField;
@property (strong, nonatomic) AdDetails* DetailsObject;

- (IBAction)sendBtnPrss:(id)sender;
- (IBAction)cancelBtnPrss:(id)sender;
- (IBAction)backBtnPrss:(id)sender;
@end
