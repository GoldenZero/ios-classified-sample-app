//
//  SignInViewController.h
//  temp4BezaatRealEstate
//
//  Created by Roula Misrabi on 7/8/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "SignUpViewController.h"
#import "FacebookManager.h"

#import "TwitterLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"
#import "TwitterDialog.h"
#import "GAI.h"

@interface SignInViewController : UIViewController <FacebookLoginDelegate, TwitterDialogDelegate, TwitterLoginDialogDelegate, ProfileManagerDelegate>

#pragma mark - properties

@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *twButton;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UITextField *userNameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) UITextField* twitterEmail;

@property (nonatomic) BOOL returnPage;


#pragma mark - actions

- (IBAction)signInBtnPressed:(id)sender;
- (IBAction)signUpBtnPressed:(id)sender;
- (IBAction)skipBtnPressed:(id)sender;
- (IBAction)fbBtnPressed:(id)sender;
- (IBAction)twBtnPressed:(id)sender;
- (IBAction)forgetPwdBtnPressed:(id)sender;


@end
