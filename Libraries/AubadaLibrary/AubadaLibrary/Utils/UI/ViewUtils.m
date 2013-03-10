//
//  ViewUtils.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewUtils.h"

@implementation ViewUtils

+ (ViewUtils*) sharedInstance {
    static ViewUtils* instance = nil;
    if (instance == nil) {
        instance = [[ViewUtils alloc] init];
    }
    
    return instance;
}

- (void) centerView:(UIView*)smallView inView:(UIView*)bigView {
    // Get the frames of the views
    CGRect smallViewFrame = smallView.frame;
    CGRect bigViewFrame = bigView.frame;
    
    // Change the x and y of the small view to be in the center of the big one
    CGFloat newX = bigViewFrame.origin.x + ((bigViewFrame.size.width - smallViewFrame.size.width) / 2);
    CGFloat newY = bigViewFrame.origin.y + ((bigViewFrame.size.height - smallViewFrame.size.height) / 2);
    
    // Set the new x and y
    smallViewFrame.origin.x = newX;
    smallViewFrame.origin.y = newY;
    
    smallView.frame = smallViewFrame;
}

- (void) setX:(CGFloat)x forView:(UIView*)view {
    // Get the current frame of the view
    CGRect frame = view.frame;
    
    // Set the new x
    frame.origin.x = x;
    
    // Reassign the new frame for the view
    view.frame = frame;    
}

- (void) setY:(CGFloat)y forView:(UIView*)view {
    // Get the current frame of the view
    CGRect frame = view.frame;
    
    // Set the new y
    frame.origin.y = y;
    
    // Reassign the new frame for the view
    view.frame = frame;
}

- (void) setWidth:(CGFloat)width forView:(UIView*)view {
    // Get the current frame of the view
    CGRect frame = view.frame;
    
    // Set the new width
    frame.size.width = width;
    
    // Reassign the new frame for the view
    view.frame = frame;
}

- (void) setHeight:(CGFloat)height forView:(UIView*)view {
    // Get the current frame of the view
    CGRect frame = view.frame;
    
    // Set the new height
    frame.size.height = height;
    
    // Reassign the new frame for the view
    view.frame = frame;
}

/*
 * This method creates a UIView that contains a UILabel with the given title
 */
- (UIView*) buildNavigationTitleViewWithString:(NSString*)title {
    // The frame of the view should be as big as possible and iOS will reisze it according to the available space
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];

    // The view should be transparent
    view.backgroundColor = [UIColor redColor];
    
    // Build the label and add it to the parent view
    UILabel* lblTitle = [[UILabel alloc] initWithFrame:view.frame];
    lblTitle.tag = 1;
    lblTitle.textAlignment = NSTextAlignmentRight;
    lblTitle.text = title;
    [view addSubview:lblTitle];
    
    return view;
}

@end
