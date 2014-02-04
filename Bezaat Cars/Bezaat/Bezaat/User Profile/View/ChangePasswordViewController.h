//
//  ChangePasswordViewController.h
//  Bezaat
//
//  Created by GALMarei on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<ProfileUpdateDelegate>
{
     MBProgressHUD2 * loadingHUD;
    UserProfile* CurrentUser;
}

@property (weak, nonatomic) IBOutlet UILabel *usrNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTxt;

@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTxt;


- (IBAction)saveInvoked:(id)sender;
- (IBAction)backInvoked:(id)sender;
@end
