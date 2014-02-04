//
//  AppDelegate.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 7/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "ErrorPageVC.h"

@class HomePageViewController;
@class ChooseLocationViewController;
@class ErrorPageVC;
@class SplashViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#pragma mark - preperties

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ChooseLocationViewController * chooseLocationVC;
@property (strong, nonatomic) HomePageViewController *homePageVC;
@property (strong, nonatomic) ErrorPageVC *errorPageVC;
@property (strong, nonatomic) SplashViewController *splashVC;

@property(nonatomic, retain) id<GAITracker> tracker;
@property (nonatomic) BOOL showingFBBrowserView;

#pragma mark - methods
- (void) setShowingFBBrowser:(BOOL) status;
- (void) onErrorScreen;
- (void) onSplashScreenDone;

@end
