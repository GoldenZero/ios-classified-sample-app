//
//  AppDelegate.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 7/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//



#import "AppDelegate.h"
#import "ChooseLocationViewController.h"
#import "SignInViewController.h"
#import "HomePageViewController.h"
#import "SplashViewController.h"

#import <NewRelicAgent/NewRelicAgent.h>
#import <Parse/Parse.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    //NewRelic
    [NewRelicAgent startWithApplicationToken:@"AA9e046acc671b319dcf316d95e875cad7fce4d620"];
    //End NewRelic
    self.showingFBBrowserView = NO;

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
        
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.chooseLocationVC = [[ChooseLocationViewController alloc]
                                  initWithNibName:@"ChooseLocationViewController" bundle:nil];
    else
        self.chooseLocationVC = [[ChooseLocationViewController alloc]
                                  initWithNibName:@"ChooseLocationViewController_iPad" bundle:nil];
    
    //homePageVc    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.homePageVC =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    else
        self.homePageVC =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController_iPad" bundle:nil];
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.splashVC=[[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    else
        self.splashVC=[[SplashViewController alloc] initWithNibName:@"SplashViewController_iPad" bundle:nil];
    self.window.rootViewController = self.splashVC;

    
    //GA
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 50;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = NO;
    // Create tracker instance.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40430774-2"];
    //GA
    
    //parse notification
    [Parse setApplicationId:@"Ck54GtejP8t0jeBePO0xi54PSdmf88Qgx9iTNF3Q"
                  clientKey:@"ztqxekQ78aDmxqjRhm3VvhadxqP4JXiHA2gPQn6D"];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"RealEstate" forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    //load json categories
    [self performSelectorInBackground:@selector(loadCategories) withObject:nil];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void) onErrorScreen {
    //[self.errorPageVC.view removeFromSuperview];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.errorPageVC=[[ErrorPageVC alloc] initWithNibName:@"ErrorPageVC" bundle:nil];
    else
        self.errorPageVC=[[ErrorPageVC alloc] initWithNibName:@"ErrorPageVC_iPad" bundle:nil];
    
    self.window.rootViewController = self.errorPageVC;
    
    [self.window makeKeyAndVisible];
}

- (void) onSplashScreenDone {
    [self.splashVC.view removeFromSuperview];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.window.rootViewController = self.chooseLocationVC;
        }
        else
        {
            //self.walkThroughVC =[[WalkThroughVC alloc]initWithNibName:@"WalkThroughVC_iPad" bundle:nil];
            //self.window.rootViewController = self.walkThroughVC;
            self.window.rootViewController = self.chooseLocationVC;
        }
        //self.window.rootViewController = self.chooseLocationVC1;
    }
    else{
        self.window.rootViewController = self.homePageVC;
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
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SharedUser fbSharedSessionInstance] close];
}

//push notifications
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.showingFBBrowserView)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            return UIInterfaceOrientationMaskPortrait;
        else
            return (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
    }
    
}

- (void) setShowingFBBrowser:(BOOL) status {
    self.showingFBBrowserView = status;
}

#pragma mark - Facebook related

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //Handle the incoming facebook URL after authenticating the user through the facebook iOS app
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - helper methods
- (void) loadCategories {
    
    //This will fill up the categories arrays
    [[AdsManager sharedInstance] getCategoriesForstatus:YES];
    [[AdsManager sharedInstance] getCategoriesForstatus:NO];
}

@end
