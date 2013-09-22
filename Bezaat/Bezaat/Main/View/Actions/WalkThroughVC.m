//
//  WalkThroughVC.m
//  Argaam
//
//  Created by GALMarei on 9/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "WalkThroughVC.h"

@interface WalkThroughVC ()

@end

@implementation WalkThroughVC

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
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.WalkthroughWebView.scrollView setScrollEnabled:NO];
    [TestFlight passCheckpoint:@"Walkthrough Screen"];
    //[[GAI sharedInstance].defaultTracker sendView:@"Walkthrough Screen"];
    
    [NSURLProtocol registerClass:[NSURLProtocolCustom class]];
    
    NSString * localHtmlFilePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    
    NSString * localHtmlFileURL = [NSString stringWithFormat:@"file://%@", localHtmlFilePath];
    
    [self.WalkthroughWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:localHtmlFileURL]]];
    
    NSString *html = [NSString stringWithContentsOfFile:localHtmlFilePath encoding:NSUTF8StringEncoding error:nil];
    
    [self.WalkthroughWebView loadHTMLString:html baseURL:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mazaj-app.com/argaamapi/walkthrough/index.html"]];
    //[self.WalkthroughWebView loadRequest:request];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onWalkthroughScreenDone];
        NSLog(@"finish walkthorugh");
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}



@end
