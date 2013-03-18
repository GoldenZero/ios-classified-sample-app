//
//  GenericMethods.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This is a class that provides some generic static helper methods

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GenericMethods : NSObject

//This method takes a url string and validates it
+ (BOOL) validateUrl: (NSString *) candidate;

//This method takes a "true/false" string and returns YES/No
+ (BOOL) boolValueOfString:(NSString *) str;

// This method shows a simple alert view with ok button as a cancel button
+ (void) throwAlertWithTitle:(NSString *) aTitle message:(NSString *) aMessage delegateVC:(UIViewController *) vc;

//This method is used to handle the arabic connected Taa when loading custom fonts.
+ (NSString *) handleArabicTaa : (NSString *) input;
@end
