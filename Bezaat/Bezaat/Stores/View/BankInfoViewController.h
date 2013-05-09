//
//  BankInfoViewController.h
//  Bezaat
//
//  Created by GALMarei on 5/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankInfoViewController : UIViewController

@property (strong,nonatomic) NSString* Order;
@property (strong,nonatomic) NSString* StoreName;
@property (strong,nonatomic) NSString* ProductName;
@property (nonatomic) NSInteger AdID;
@property (nonatomic) NSInteger type;



@property (strong, nonatomic) IBOutlet UIScrollView *bankScrollView;
@property (strong, nonatomic) IBOutlet UITextView *saudiTextView;
@property (strong, nonatomic) IBOutlet UITextView *uaeTextView;
@property (strong, nonatomic) IBOutlet UITextView *egyptTextView;
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;

- (IBAction)homeBtnPressed:(id)sender;
- (IBAction)saudiCopy:(id)sender;
- (IBAction)uaeCopy:(id)sender;
- (IBAction)egyptCopy:(id)sender;
@end
