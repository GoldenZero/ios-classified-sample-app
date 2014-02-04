//
//  ViewController.h
//  TrySignInWithFBTW
//
//  Created by Roula Misrabi on 3/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is temporary until the login UI is done

#import <UIKit/UIKit.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccount.h>
#import "TWAccountsViewController.h"

@interface ViewController : UIViewController <ChooseTWAccountDelegate>

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) ACAccount *twitterAccount;


- (IBAction)signInFBPressed:(id)sender;
- (IBAction)signInTWPressed:(id)sender;

@end
