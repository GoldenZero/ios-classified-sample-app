//
//  AboutAppViewController.m
//  Bezaat
//
//  Created by danat on 4/27/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController

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
    self.trackedViewName = @"About app Screen";
    self.imageScroll.contentSize = CGSizeMake(320, 720);
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addOpenInService:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.7;
    [self.imageScroll addGestureRecognizer:longPress];

    // Do any additional setup after loading the view from its nib.
}

- (void) addOpenInService: (UILongPressGestureRecognizer *) objRecognizer
{
    NSString* launchUrl = @"http://cherryapps.net";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contactUs:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Feedback"];
        [mailer setToRecipients:@[@"mobile@bezaat.com"]];
        
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"لا يوجد بريد إلكتروني مسجل على هذا الجهاز" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

}
@end
