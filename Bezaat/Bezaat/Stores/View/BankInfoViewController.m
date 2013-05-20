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
    self.bankScrollView.contentSize = CGSizeMake(320, 720);
    UserProfile* profile = [[SharedUser sharedInstance] getUserProfileData];
   
    if (self.type == 1) {
        self.titleTextView.text = [NSString stringWithFormat:@"عزيزنا العميل: %@\nشكرا لتعاملكم مع بيزات، لقد تم استلام طلبك رقم %@ الخاص بالإعلان رقم %i للإشتراك في باقة %@, وسيتم إنهاء الطلب بعد إتمام عملية الدفع يرجى استخدام احد حساباتنا التالية\n\nيرجى ارسال رقم او صورة عن التحويل البنكي الى البريد الالكتروني info@bezaat.com ،أو الاتصال على الرقم: (+966)-920004147",profile.userName,self.Order,self.AdID,self.ProductName];
        //GA
        [[GAI sharedInstance].defaultTracker sendView:@"FeatureAd bank-transfer screen"];
        //end GA
    }else {
    self.titleTextView.text = [NSString stringWithFormat:@"عزيزنا العميل: %@\nشكرا لتعاملكم مع بيزات، لقد تم استلام طلبك رقم %@ الخاص بمتجر %@ للإشتراك في باقة %@, وسيتم إنهاء الطلب بعد إتمام عملية الدفع يرجى استخدام احد حساباتنا التالية\n\nيرجى ارسال رقم او صورة عن التحويل البنكي الى البريد الالكتروني info@bezaat.com ،أو الاتصال على الرقم (+966)-920004147",profile.userName,self.Order,self.StoreName,self.ProductName];
        //GA
        [[GAI sharedInstance].defaultTracker sendView:@"Store bank-transfer screen"];
        //end GA
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
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"تمت عميلة النسخ" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
    return;
    
}

- (IBAction)uaeCopy:(id)sender {
    UIPasteboard* paste = [UIPasteboard generalPasteboard];
    paste.string = self.uaeTextView.text;
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"تمت عميلة النسخ" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
    return;

}

- (IBAction)egyptCopy:(id)sender {
    UIPasteboard* paste = [UIPasteboard generalPasteboard];
    paste.string = self.egyptTextView.text;
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"تمت عميلة النسخ" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
    return;
}
@end
