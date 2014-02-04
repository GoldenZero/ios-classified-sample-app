//
//  SignUpViewController.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 7/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"
#import "TwitterLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"
#import "TwitterDialog.h"
#import "GAI.h"

@interface SignUpViewController : BaseViewController<UITextViewDelegate,FacebookLoginDelegate, TwitterDialogDelegate, TwitterLoginDialogDelegate, ProfileManagerDelegate,ProfileRegisterDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UITextField *userText;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordText;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UITextField* twitterEmail;

#pragma mark - actions

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)clearBtnPressed:(id)sender;
- (IBAction)registerBtnPressed:(id)sender;
- (IBAction)fbBtnPressed:(id)sender;
- (IBAction)twButtonPressed:(id)sender;


@end
