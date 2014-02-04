//
//  WalkThroughVC.h
//  Argaam
//
//  Created by GALMarei on 9/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLProtocolCustom.h"
#import "AppDelegate.h"

@interface WalkThroughVC : UIViewController<UIPopoverControllerDelegate>


@property (strong, nonatomic) IBOutlet UIWebView *WalkthroughWebView;
@property (strong, nonatomic) UIPopoverController *listMenu;

@end
