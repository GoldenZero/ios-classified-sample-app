//
//  GenericMethods.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GenericMethods.h"

@implementation GenericMethods

static NSString * documentsDirectoryPath;

+ (BOOL) boolValueOfString:(NSString *) str {
    
    NSString * _true = @"true";
    NSString * trueString = [_true lowercaseString];
    
    if ([[str lowercaseString] isEqualToString:trueString])
        return YES;
    
    return NO;
}

+ (void) throwAlertWithTitle:(NSString *) aTitle message:(NSString *) aMessage delegateVC:(UIViewController *) vc {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:aTitle
                                                     message:aMessage
                                                    delegate:vc
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil ];
    //[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

+ (NSString *) handleArabicTaa : (NSString *) input {
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^اأإآدذرزوؤء]ة" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString * output = input;
    
    NSArray * matches = [regex matchesInString:input options:0 range:NSMakeRange(0, input.length)];
    
    NSString * substring;
    NSString * replacement;
    
    for (NSTextCheckingResult * match in matches)
    {
        substring = [input substringWithRange:match.range];
        replacement = [substring
                       stringByReplacingOccurrencesOfString:@"ة" withString:@"ـة"];
        output = [output stringByReplacingOccurrencesOfString:substring withString:replacement];
    }
    
    return output;
    
}

+ (BOOL) connectedToInternet {
    
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
        return NO;

    return YES;
}

+ (NSString *) getDocumentsDirectoryPath {
    if (!documentsDirectoryPath)
    {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        documentsDirectoryPath = [pathArray objectAtIndex:0];

    }
    return documentsDirectoryPath;
}

+ (BOOL) fileExistsInDocuments:(NSString *) fileName {
    
    NSString * filePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];

    return fileExists;
}

+ (BOOL) deviceIsRetina {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return YES;
    }
    return NO;
}

+ (NSDate *) NSDateFromDotNetJSONString:(NSString *) string {
    
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

+ (NSString *) machineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString*) reverseString:(NSString *) input {
    
    NSMutableString *reversedStr;
    int len = [input length];
    
    // auto released string
    reversedStr = [NSMutableString stringWithCapacity:len];
    
    // quick-and-dirty implementation
    while ( len > 0 )
        [reversedStr appendString:[NSString stringWithFormat:@"%C",[input characterAtIndex:--len]]];
    
    return reversedStr;
}

+ (NSString *) formatPrice:(float) num {
    
    if ((int) num == 0)
        return @"";
    
    NSString * numStr = [NSString stringWithFormat:@"%i", (int) num ];
    
    NSString * inputStr = [GenericMethods reverseString:numStr];
    
    NSString * outputStr = @"";
    for (int i = 0; i < inputStr.length; i++)
    {
        int remainder = (i+1) % 3;
        if (( remainder == 0 ) && (i != 0))
            outputStr = [outputStr stringByAppendingFormat:@"%c,", [inputStr characterAtIndex:i]];
        else
            outputStr = [outputStr stringByAppendingFormat:@"%c", [inputStr characterAtIndex:i]];
    }
    return [GenericMethods reverseString:outputStr];
}

@end
