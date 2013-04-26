//
//  SignUpViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to add a new user profile.

#import <UIKit/UIKit.h>
#import "ChooseActionViewController.h"
#import "FacebookManager.h"
#import "SignInViewController.h"
#import "TwitterLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"
#import "TwitterDialog.h"


@interface SignUpViewController : BaseViewController<UITextViewDelegate,FacebookLoginDelegate, TwitterDialogDelegate, TwitterLoginDialogDelegate, ProfileManagerDelegate,ProfileRegisterDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIImageView *titleView;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIImageView *sepratorImage;
@property (strong, nonatomic) IBOutlet UITextField *userText;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordText;
@property (strong, nonatomic) UITextField* twitterEmail;

@property (strong, nonatomic) IBOutlet UIView *contentView;

#pragma mark - actions
- (IBAction)fbButtonPressed:(id)sender;
- (IBAction)twButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)backBtnPrss:(id)sender;
@end
