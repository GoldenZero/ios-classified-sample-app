//
//  BankInfoViewController.h
//  Bezaat
//
//  Created by GALMarei on 5/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *bankWebView;
@property (strong,nonatomic) NSString* Order;

- (IBAction)homeBtnPressed:(id)sender;
@end
