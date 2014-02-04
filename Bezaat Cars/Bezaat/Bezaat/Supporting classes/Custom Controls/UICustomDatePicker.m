//
//  UICustomDatePicker.m
//  A2ABanking
//
//  Created by TEKLABZ on 3/4/12.
//  Copyright (c) 2012 TEKLABZ. All rights reserved.
//

#import "UICustomDatePicker.h"

@implementation UICustomDatePicker
@synthesize delegate;


- (void) doneInvoked {
    [self setModal:NO];
    [delegate datePickerDone:self];
}

- (void) setModal:(BOOL)modal {
    if (modal) {
        if (!modalLayer) {
            modalLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            modalLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        }
        
        [self.window addSubview:modalLayer];
    } else {
        if (modalLayer) {
            [modalLayer removeFromSuperview];
        }
    }
}

- (void) setHidden:(BOOL)hidden {
    if (self.superview) {
        CGFloat parentHeight = self.window.frame.size.height;
        CGFloat pickerHeight = self.frame.size.height;
        CGFloat toolbarHeight = 56;
        
        if (!_toolbar) {
            // add the toolbar
            _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, parentHeight, 320, toolbarHeight)];
            _toolbar.barStyle = UIBarStyleBlackTranslucent;
            [_toolbar sizeToFit];
            
            NSMutableArray* barItems = [[NSMutableArray alloc] init];
            UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            [barItems addObject:flexSpace];
            
            UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneInvoked)];
            [barItems addObject:doneBtn];
            
            [_toolbar setItems:barItems animated:YES];
            
            [self.window addSubview:_toolbar];
            [self.window bringSubviewToFront:_toolbar];
        }
        
        // animate the uipicker and toolbar
        if (!hidden) {
            [self setModal:YES];
            [_toolbar setFrame:CGRectMake(0, parentHeight, 320, toolbarHeight)];
            [self setFrame:CGRectMake(0, parentHeight + toolbarHeight, self.frame.size.width, self.frame.size.height)];
            [super setHidden:hidden];
            [_toolbar setHidden:hidden];
            [self.window bringSubviewToFront:self];
            [self.window bringSubviewToFront:_toolbar];
            [self.window addSubview:self];
        }

        _hidden = hidden;
        
        [UIView beginAnimations:@"ShowPicker" context:nil];
        [UIView setAnimationDuration:0.3];
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        
        if (!hidden) {
            [self setFrame:CGRectMake(0, parentHeight - pickerHeight, self.frame.size.width, self.frame.size.height)];
            [_toolbar setFrame:CGRectMake(0, (parentHeight - pickerHeight) - toolbarHeight, 320, 56)];
        } else {
            [_toolbar setFrame:CGRectMake(0, parentHeight, 320, toolbarHeight)];
            [self setFrame:CGRectMake(0, parentHeight + toolbarHeight, self.frame.size.width, self.frame.size.height)];
        }
        [UIView commitAnimations];
    } else {
        // called by the nib on vc init
        [super setHidden:hidden];
        [_toolbar setHidden:hidden];
    }
}

- (void) animationFinished:(NSString*) animationId finished:(BOOL)finished context:(void*) context {
    if ([animationId isEqualToString:@"ShowPicker"]) {
        [super setHidden:_hidden];
        [_toolbar setHidden:_hidden];
    }
}
@end
