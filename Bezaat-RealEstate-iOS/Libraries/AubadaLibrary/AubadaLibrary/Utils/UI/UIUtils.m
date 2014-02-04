//
//  UIUtils.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 9/21/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

// This is the singelton instance method
+ (UIUtils*) sharedInstance {
    static UIUtils* instance = nil;
    if (instance == nil) {
        instance = [[UIUtils alloc] init];
    }
    
    return instance;
}

#pragma mark Navigation Methods

// This method creates a navigation bar with the given color and style
- (UINavigationController*) buildNavigationControllerWithStyle:(UIBarStyle)style
                                                         color:(UIColor*)color {
    UINavigationController* navigationController = [[UINavigationController alloc] init];
    
    // Set the style and color of the controller's bar
    navigationController.navigationBar.barStyle = style;
    
    if (color != nil) {
        navigationController.navigationBar.tintColor = color;
    }
    
    return navigationController;
}

/*
 * This method creates a navigation controller with the given color and style
 * Then it creates a tab bar item with the given name and image and attaches it to the controller
 */
- (UINavigationController*) buildNavigationControllerWithStyle:(UIBarStyle)style
                                                         color:(UIColor*)color
                                                   tabBarImage:(NSString*)imageResourceName
                                                   tabBarTitle:(NSString*)title {
    // Create the navigation controller
    UINavigationController* controller = [self buildNavigationControllerWithStyle:style color:color];
    
    // Create the tab bar item
    controller.tabBarItem = [self buildTabBarItemWithTitle:title image:imageResourceName];
    
    return controller;
}

#pragma mark -
#pragma mark Tabs Methods

// This method builds a tab bar item with the given title and image
- (UITabBarItem*) buildTabBarItemWithTitle:(NSString*)title
                                     image:(NSString*)imageResouceName {
    // Load the image from the reouces
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:imageResouceName ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    
    // Build the tab bar item
    UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:title image:image tag:-1];
    return item;
}

/*
 * This method creates a tab bar item (which is actually a button) with the given title and image
 * The item is centered in the middle of the given tab bar
 */
- (void) buildTabBarItemWithImage:(NSString*)imageResouceName
                 inMiddleOfTabBar:(UITabBar*)tabBar
                           target:(id)target
                         selector:(SEL)selector {

    // Create the button with the given image
    UIImage *buttonImage = [UIImage imageNamed:imageResouceName];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setContentMode:UIViewContentModeCenter];
    [button resignFirstResponder];
    
    // Disable the middle item in the tab bar and clear its text so it won't appear
    UITabBarItem *item = tabBar.items[tabBar.items.count / 2];
    item.title = @"";
    item.enabled = NO;

    // Set the event of the button
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    // Center the button in the tab bar
    CGSize tabbarSize = tabBar.bounds.size;
    CGPoint center = CGPointMake(tabbarSize.width/2, tabbarSize.height/2);
    center.y = center.y - 9.5;
    button.center = center;
    
    // Add the new button to the tab bar
    [tabBar addSubview:button];
}

/* This method creates a tab bar controller from the given items
 * Its subview will have the given background color and height
 */
- (UITabBarController*) buildTabBarControllerWithItems:(NSArray*)items {
    // Build the tab bar controller
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    
    // Add the array of view controllers to it
    tabBarController.viewControllers = items;
    
    return tabBarController;
}

#pragma mark -
#pragma mark Alerts Methods

- (void) showSimpleAlertWithTitle:(NSString*)title text:(NSString*)text {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
