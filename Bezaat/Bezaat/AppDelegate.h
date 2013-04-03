//
//  AppDelegate.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseLocationViewController;
@class SplashViewController;
@class ChooseActionViewController;
//@class FriendsListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@property (strong, nonatomic) ChooseLocationViewController * chooseLocationVC;
@property (strong, nonatomic) SplashViewController *splashVC;
@property (strong, nonatomic) ChooseActionViewController *homeVC;
//@property (strong, nonatomic) FriendsListViewController *friendVC;

- (void) onSplashScreenDone;
@end
