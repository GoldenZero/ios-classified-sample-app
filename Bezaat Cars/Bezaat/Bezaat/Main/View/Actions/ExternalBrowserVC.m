//
//  ExternalBrowserVC.m
//  Argaam
//
//  Created by GALMarei on 8/29/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ExternalBrowserVC.h"

@interface ExternalBrowserVC ()
{
    UIActivityIndicatorView* activity;

}
@end

@implementation ExternalBrowserVC

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
    [TestFlight passCheckpoint:@"External browser"];
    [[GAI sharedInstance].defaultTracker sendView:@"External browser"];
  
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.webBrowser.frame.size.width/2, self.webBrowser.frame.size.height/2, 25, 25)];
    
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activity startAnimating];
    
    [self.webBrowser addSubview:activity];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:self.externalLink];
    [self.webBrowser loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activity stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
*/
@end
