//
//  ExternalBrowserVC.h
//  Argaam
//
//  Created by GALMarei on 8/29/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface ExternalBrowserVC : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSURL* externalLink;
@property (strong, nonatomic) IBOutlet UIWebView *webBrowser;
- (IBAction)backInvoked:(id)sender;
@end
