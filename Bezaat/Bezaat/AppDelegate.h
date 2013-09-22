//
//  AppDelegate.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "WalkThroughVC.h"

@class ChooseLocationViewController;
@class SplashViewController;
@class ChooseActionViewController;
@class ChooseLocationVC;
@class WalkThroughVC;

//@class FriendsListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@property (strong, nonatomic) ChooseLocationViewController * chooseLocationVC;
@property (strong, nonatomic) ChooseLocationVC * chooseLocationVC1;
@property (strong, nonatomic) SplashViewController *splashVC;
@property (strong, nonatomic) ChooseActionViewController *homeVC;
@property (strong, nonatomic) WalkThroughVC *walkThroughVC;
//@property (strong, nonatomic) FriendsListViewController *friendVC;
@property(nonatomic, retain) id<GAITracker> tracker;
@property (nonatomic) BOOL showingFBBrowserView;

- (void) setShowingFBBrowser:(BOOL) status;

- (void) onSplashScreenDone;
- (void) onWalkthroughScreenDone;
@end
