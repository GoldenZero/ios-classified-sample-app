//
//  YoutubeViewController.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/29/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "YoutubeViewController.h"

#import "URLUtils.h"

@interface YoutubeViewController ()

@end

@implementation YoutubeViewController

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
	// Do any additional setup after loading the view.
    
    // Show the video in the webview
    _youtubeContainer.backgroundColor = [UIColor blackColor];
    _youtubeContainer.opaque = NO;
    
    // Reform the url to be a valid embed url
    _youtubeLink = [[URLUtils sharedInstance] youtubeEmbedUrl:_youtubeLink];
    
    // Hide the close button if needed
    if (! _showCloseButton) {
        _btnClose.hidden = YES;
    }
    
    // Show the video
    [self startVideo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)startVideo {
    NSString* videoHTML = [NSString stringWithFormat:@"\
                 <html>\
                 <head>\
                 <style type=\"text/css\">\
                 iframe {position:absolute; top:50%%; margin-top:-130px;}\
                 body {background-color:#000; margin:0;}\
                 </style>\
                 </head>\
                 <body>\
                 <iframe width=\"100%%\" height=\"240px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                 </body>\
                 </html>", _youtubeLink];
    [_youtubeContainer setAllowsInlineMediaPlayback:YES];
    [_youtubeContainer loadHTMLString:videoHTML baseURL:nil];
}

- (IBAction) btnCloseTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
