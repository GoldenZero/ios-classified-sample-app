//
//  UICustomDatePicker.h
//  A2ABanking
//
//  Created by TEKLABZ on 3/4/12.
//  Copyright (c) 2012 TEKLABZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICustomDatePickerDelegate;

@interface UICustomDatePicker : UIDatePicker {
    UIToolbar* _toolbar;
    BOOL _hidden;
    UIView* modalLayer;
}
@property (nonatomic, assign) id <UICustomDatePickerDelegate> delegate;
- (void) doneInvoked;
- (void) setModal:(BOOL)modal;
@end

@protocol UICustomDatePickerDelegate

@optional
- (void)datePickerDone:(UICustomDatePicker*)theDatePicker;

@end