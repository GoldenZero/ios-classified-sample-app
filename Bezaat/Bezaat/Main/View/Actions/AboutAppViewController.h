//
//  AboutAppViewController.h
//  Bezaat
//
//  Created by danat on 4/27/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutAppViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backInvoked:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;

@end
