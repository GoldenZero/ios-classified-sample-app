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
#import <sys/utsname.h>

@interface GenericMethods : NSObject

//This method takes a "true/false" string and returns YES/No
+ (BOOL) boolValueOfString:(NSString *) str;

// This method shows a simple alert view with ok button as a cancel button
+ (void) throwAlertWithTitle:(NSString *) aTitle message:(NSString *) aMessage delegateVC:(UIViewController *) vc;

//This method is used to handle the arabic connected Taa when loading custom fonts.
+ (NSString *) handleArabicTaa : (NSString *) input;

// This method checks internet connectivity
+ (BOOL) connectedToInternet;

// This method gets the string path of documents directory
+ (NSString *) getDocumentsDirectoryPath;

// This method searches for a file in documnts path
+ (BOOL) fileExistsInDocuments:(NSString *) fileName;

// This method checks whether the device is retina display
+ (BOOL) deviceIsRetina;

// This method parses a JSON like date string into an NSDate
+ (NSDate *) NSDateFromDotNetJSONString:(NSString *) string;

// This method returns the device name and version
+ (NSString *) machineName;

// This method gives the reverse of a string
+ (NSString*) reverseString:(NSString *) input;

// This method formats the price value to remove the floating point and adds commas after each three digits
+ (NSString *) formatPrice:(float) num;

// This method converts NSDictionary --> NSData
+ (NSData *) NSDataFromDictionary:(NSDictionary *) input;

// This method converts NSDictionary --> NSData
+ (NSDictionary *) NSDictionaryFromData:(NSData *) data;
@end
