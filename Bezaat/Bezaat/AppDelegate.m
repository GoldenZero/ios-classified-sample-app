//
//  AppDelegate.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AppDelegate.h"

#import "ChooseLocationViewController.h"

#import "ChooseLocationVC.h"

#import "SplashViewController.h"

#import "ChooseActionViewController.h"

#import "FriendsListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    //1- hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //2- chooseLocationVC
    self.chooseLocationVC1 = [[ChooseLocationVC alloc]
                             initWithNibName:@"ChooseLocationVC" bundle:nil];
    self.homeVC=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    
    //3- splash view
    self.splashVC=[[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    self.window.rootViewController = self.splashVC;
    
    //  test friend list
    //self.friendVC=[[FriendsListViewController alloc] initWithNibName:@"FriendsListViewController" bundle:nil];
    //self.window.rootViewController = self.friendVC;

    //GA
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 50;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = NO;
    // Create tracker instance.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40430774-1"];
    //GA
    
    
    //4- visualize
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) onSplashScreenDone {
    [self.splashVC.view removeFromSuperview];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        self.window.rootViewController = self.chooseLocationVC1;
    }
    else{
        self.window.rootViewController = self.homeVC;
    }
    

    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //check if facebook token is saved
    /*
     if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
     {
     
     NSLog(@"-------------------\nthe user is still signed in");
     NSLog(@"%@", FBSession.activeSession.accessTokenData);
     
     }
     */
    // Facebook:
    // We need to properly handle activation of the application with regards to SSO
    // (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //[[SharedUser fbSharedSessionInstance] closeAndClearTokenInformation];
    [[SharedUser fbSharedSessionInstance] close];
}


#pragma mark - Facebook related

 - (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 
 //Handle the incoming facebook URL after authenticating the user through the facebook iOS app
 return [FBSession.activeSession handleOpenURL:url];
 }
@end
