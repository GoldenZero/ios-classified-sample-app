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

+ (void) throwAlertWithCode:(NSInteger)errorCode andMessageStatus:(NSString*)msg delegateVC:(UIViewController *) vc
{
    // for Post Ad
    if (!(errorCode == 200) && ([msg isEqualToString:@"ok"]))
    {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"تمت العملية بنجاح"
                                                    delegate:vc
                                           cancelButtonTitle:@"موافق"
                                           otherButtonTitles:nil ];
    //[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"VALIDATE_PASSWORD"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"الرجاء التأكد من كلمة السر"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"EMAIL_ADDRESS_NOT_FOUND"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"ايرجى ادخال لبريد الإلكتروني بشكل صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"USER_BLOCKED"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لقد تم حجب المستخدم"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"TOO_QUICK"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى المحاولة مرة أخرى"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"PHONE_NUMBER_NOT_VALID"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"رقم الجوال غير صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"REQUIRED_ATTRIBUTE_MISSING"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى تعبئة جميع الحقول"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"NUMBER_VALIDATION_FAILED_OR_PRICE_VALUE_IS_NOT_VALID"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من حقل السعر"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"ALPHA_BETIC_VALUE_IS_NOT_VALID"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من تعبئة جميع الحقول بشكل صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"WHEN_AD_WILL_BE_EXPIRED_IS_UN_KNOWN"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من الصلاحية"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"Max length exceeded"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لقد تم تجاوز القيمة المحددة للحقل"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"GROUPED_VALUS_VALIDATION_FIALED"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من السعر والعملة"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"SUCCESS"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لقد تمت العمية"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    
    
    // for sign in/up
    else if (!(errorCode == 200) && ([msg isEqualToString:@"WRONG_PASSWORD"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"كلمة السر غير صحيحة"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"WRONG_EMAIL"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"البريد الإلكتروني غير صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:msg
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
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
        if (( remainder == 0 ) && (i != 0) && (i != (inputStr.length -1) ))
            outputStr = [outputStr stringByAppendingFormat:@"%c,", [inputStr characterAtIndex:i]];
        else
            outputStr = [outputStr stringByAppendingFormat:@"%c", [inputStr characterAtIndex:i]];
    }
    return [GenericMethods reverseString:outputStr];
}

/*
+ (NSData *) NSDataFromDictionary:(NSDictionary *)input {
    
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:input forKey:@"NSData"];
    [archiver finishEncoding];

    return data;
}
*/

/*
+ (NSDictionary *) NSDictionaryFromData:(NSData *) data {
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary * dict = [unarchiver decodeObjectForKey:@"NSData"];
    [unarchiver finishDecoding];
    
    return dict;
}
*/
@end
