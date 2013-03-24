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

#import "SplashViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //1- chooseLocationVC
    self.chooseLocationVC = [[ChooseLocationViewController alloc]
                             initWithNibName:@"ChooseLocationViewController" bundle:nil];
    
    
    //2- splash view
    self.splashVC=[[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    self.window.rootViewController = self.splashVC;
    
    //3- visualize
    [self.window makeKeyAndVisible];
    
    //4- timer for splash view
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(onSplashScreenDone) userInfo:nil repeats:NO];
    return YES;
}
-(void)onSplashScreenDone{
    [self.splashVC.view removeFromSuperview];
    self.window.rootViewController = self.chooseLocationVC;
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
    [[SharedUser fbSharedSessionInstance] close];
}


#pragma mark - Facebook related

/*
 - (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 
 //Handle the incoming facebook URL after authenticating the user through the facebook iOS app
 return [FBSession.activeSession handleOpenURL:url];
 }
 */


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // attempt to extract a token from the url
    return [[SharedUser fbSharedSessionInstance] handleOpenURL:url];
}
@end
