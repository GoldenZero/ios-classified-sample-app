//
//  UIUtils.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 9/21/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

// This is the singelton instance method
+ (UIUtils*) sharedInstance;

#pragma mark Navigation Methods

// This method creates a navigation bar with the given color and style
- (UINavigationController*) buildNavigationControllerWithStyle:(UIBarStyle)style
                                                         color:(UIColor*)color;

/* 
 * This method creates a navigation controller with the given color and style
 * Then it creates a tab bar item with the given name and image and attaches it to the controller
*/
- (UINavigationController*) buildNavigationControllerWithStyle:(UIBarStyle)style
                                                         color:(UIColor*)color
                                                   tabBarImage:(NSString*)imageResourceName
                                                   tabBarTitle:(NSString*)title;

#pragma mark -
#pragma mark Tabs Methods

// This method builds a tab bar item with the given title and image
- (UITabBarItem*) buildTabBarItemWithTitle:(NSString*)title
                                     image:(NSString*)imageResouceName;

/* This method creates a tab bar controller from the given items
 * Its subview will have the given background color and height
 */
- (UITabBarController*) buildTabBarControllerWithItems:(NSArray*)items;

/* 
 * This method creates a tab bar item (which is actually a button) with the given title and image
 * The item is centered in the middle of the given tab bar
 */
- (void) buildTabBarItemWithImage:(NSString*)imageResouceName
                 inMiddleOfTabBar:(UITabBar*)tabBar
                           target:(id)target
                         selector:(SEL)selector;

#pragma mark -
#pragma mark Alerts Methods

- (void) showSimpleAlertWithTitle:(NSString*)title text:(NSString*)text;

@end
