//
//  ChangeNameViewController.h
//  Bezaat
//
//  Created by GALMarei on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNameViewController : UIViewController<ProfileUpdateDelegate>
{
    MBProgressHUD2 * loadingHUD;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) NSString* theName;

- (IBAction)saveInvoked:(id)sender;
- (IBAction)backInvoked:(id)sender;
@end
