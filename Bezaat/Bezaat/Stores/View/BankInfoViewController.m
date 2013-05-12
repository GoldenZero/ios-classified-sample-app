//
//  BankInfoViewController.m
//  Bezaat
//
//  Created by GALMarei on 5/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BankInfoViewController.h"
#import "ChooseActionViewController.h"

@interface BankInfoViewController ()

@end

@implementation BankInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bankScrollView.contentSize = CGSizeMake(320, 675);
    UserProfile* profile = [[SharedUser sharedInstance] getUserProfileData];
   
    if (self.type == 1) {
        self.titleTextView.text = [NSString stringWithFormat:@"عزيزنا العميل: %@\nشكرا لتعاملكم مع بيزات، لقد تم استلام طلبك رقم %@ الخاص بالإعلان رقم %i للإشتراك في باقة %@, وسيتم إنهاء الطلب بعد إتمام عملية الدفع يرجى استخدام احد حساباتنا التالية",profile.userName,self.Order,self.AdID,self.ProductName];
    }else {
    self.titleTextView.text = [NSString stringWithFormat:@"عزيزنا العميل: %@\nشكرا لتعاملكم مع بيزات، لقد تم استلام طلبك رقم %@ الخاص بمتجر %@ للإشتراك في باقة %@, وسيتم إنهاء الطلب بعد إتمام عملية الدفع يرجى استخدام احد حساباتنا التالية",profile.userName,self.Order,self.StoreName,self.ProductName];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeBtnPressed:(id)sender {
    ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];

}

- (IBAction)saudiCopy:(id)sender {
    UIPasteboard* paste = [UIPasteboard generalPasteboard];
    paste.string = self.saudiTextView.text;

    
}

- (IBAction)uaeCopy:(id)sender {
    UIPasteboard* paste = [UIPasteboard generalPasteboard];
    paste.string = self.uaeTextView.text;

}

- (IBAction)egyptCopy:(id)sender {
    UIPasteboard* paste = [UIPasteboard generalPasteboard];
    paste.string = self.egyptTextView.text;
}
@end
