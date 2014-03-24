//
//  StoreContactViewController.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 3/5/14.
//  Copyright (c) 2014 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface StoreContactViewController : UIViewController<MFMailComposeViewControllerDelegate>

- (IBAction)mailInvoked:(id)sender;
- (IBAction)callPhoneInvoked:(id)sender;
- (IBAction)backInvoked:(id)sender;
@end
