//
//  GenericMethods.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GenericMethods.h"

@implementation GenericMethods

+ (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

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
@end
