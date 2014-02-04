//
//  SplashViewController.m
//  Bezaat
//
//  Created by Syrisoft on 3/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SplashViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface SplashViewController ()

@end

@implementation SplashViewController


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
    self.trackedViewName = @"Splash Screen";
    //[self rotationWheel:self.wheelView];
     [self.indicatorView startAnimating];
    //clear keychain data if first launch before any loading of brands data
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        //reset keychains only on first launch
        [[LocationManager locationKeyChainItemSharedInstance] resetKeychainItem];
        [[ProfileManager loginKeyChainItemSharedInstance] resetKeychainItem];
    }
    
    //call the device registeration
    if ([[[ProfileManager sharedInstance] getSavedDeviceToken] isEqualToString:@""])
        [[ProfileManager sharedInstance] registerDeviceWithDelegate:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(stopAnimatingWheel) userInfo:nil repeats:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) stopAnimatingWheel {
    [self.indicatorView stopAnimating];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] onSplashScreenDone];
}


@end
