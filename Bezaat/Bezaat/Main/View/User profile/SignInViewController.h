//
//  SignInViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displaued to the user to let him either sign in with:
// - Bezaat profile.
// - facebook profile.
// - twitter profile.
// or to sign up. The user may choose none by tapping (skip).

#import <UIKit/UIKit.h>
#import "ChooseActionViewController.h"
#import "SignUpViewController.h"
#import "FacebookManager.h"

@interface SignInViewController : UIViewController <FacebookLoginDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UILabel *labelView;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *twButton;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;

#pragma mark - actions

- (IBAction)signInBtnPressed:(id)sender;
- (IBAction)signUpBtnPressed:(id)sender;
- (IBAction)skipBtnPressed:(id)sender;
- (IBAction)fbBtnPressed:(id)sender;
- (IBAction)twBtnPressed:(id)sender;

@end
