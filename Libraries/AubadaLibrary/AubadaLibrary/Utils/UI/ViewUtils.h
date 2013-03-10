//
//  ViewUtils.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtils : NSObject

+ (ViewUtils*) sharedInstance;

- (void) centerView:(UIView*)smallView inView:(UIView*)bigView;

- (void) setX:(CGFloat)x forView:(UIView*)view;
- (void) setY:(CGFloat)y forView:(UIView*)view;
- (void) setWidth:(CGFloat)width forView:(UIView*)view;
- (void) setHeight:(CGFloat)height forView:(UIView*)view;

/*
 * This method creates a UIView that contains a UILabel with the given title
 */
- (UIView*) buildNavigationTitleViewWithString:(NSString*)title;

@end
