//
//  AppDelegate.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class ChooseLocationViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@property (strong, nonatomic) UINavigationController * mainNavigationVC;
@property (strong, nonatomic) ChooseLocationViewController * chooseLocationVC;

@end
