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
    if (!(errorCode == 200) && ([(NSString *)msg isEqualToString:@"ok"]))
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
    else if (!(errorCode == 200) && ([msg isEqualToString:@"ALREADY_REGISTERED_EMAIL"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"االبريد الإلكتروني مسجل لدينا"
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
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"VALIDATE_PASSWORD" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"الرجاء التأكد من كلمة السر"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"ALREADY_REGISTERED_EMAIL" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"االبريد الإلكتروني مسجل لدينا"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"EMAIL_ADDRESS_NOT_FOUND" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"ايرجى ادخال لبريد الإلكتروني بشكل صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"USER_BLOCKED" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لقد تم حجب المستخدم"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"TOO_QUICK" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى المحاولة مرة أخرى"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"PHONE_NUMBER_NOT_VALID" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"رقم الجوال غير صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"REQUIRED_ATTRIBUTE_MISSING" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى تعبئة جميع الحقول"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"NUMBER_VALIDATION_FAILED_OR_PRICE_VALUE_IS_NOT_VALID" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من حقل السعر"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"ALPHA_BETIC_VALUE_IS_NOT_VALID" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من تعبئة جميع الحقول بشكل صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"WHEN_AD_WILL_BE_EXPIRED_IS_UN_KNOWN" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من الصلاحية"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"Max length exceeded" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لقد تم تجاوز القيمة المحددة للحقل"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"GROUPED_VALUS_VALIDATION_FIALED" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"يرجى التأكد من السعر والعملة"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"SUCCESS" lowercaseString]]))
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
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"WRONG_PASSWORD" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"كلمة السر غير صحيحة"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"WRONG_EMAIL" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"البريد الإلكتروني غير صحيح"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:@"NOT_VERIFIED_USER_AD"]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لم يتم تفعيل الحساب ،يرجى تفعيل الحساب ثم المحاولة مرة أخرى"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (!(errorCode == 200) && ([msg isEqualToString:[@"NOT_VERIFIED_USER_AD" lowercaseString]]))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"لم يتم تفعيل الحساب ،يرجى تفعيل الحساب ثم المحاولة مرة أخرى"
                                                        delegate:vc
                                               cancelButtonTitle:@"موافق"
                                               otherButtonTitles:nil ];
        //[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"فشل في تحميل البيانات الرجاء المحاولة مره اخره"
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

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize {
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}

+ (CGSize) size: (CGSize) originalSize constrainedToSize: (CGSize) constraint {
    
    if (CGSizeEqualToSize(originalSize,CGSizeZero))
        //return CGSizeZero;
        return constraint;
    
    float widthRatio = constraint.width / originalSize.width;
    float heightRatio = constraint.height / originalSize.height;
    float scale = MIN(widthRatio, heightRatio);
    float imageWidth = scale * originalSize.width;
    float imageHeight = scale * originalSize.height;
 
    if (imageWidth > constraint.width)
        imageWidth = constraint.width;
    
    if (imageHeight > constraint.height)
        imageHeight = constraint.height;
    
    return CGSizeMake(imageWidth, imageHeight);
}

+ (NSInteger) dateDifferenceInMinutesFrom:(NSDate *) dateFrom To:(NSDate *) dateTo {
    
    NSTimeInterval distanceBetweenDates = [dateTo timeIntervalSinceDate:dateFrom];
    
    double minutesInAnHour = 60;
    NSInteger minutesBetweenDates = distanceBetweenDates / minutesInAnHour;
    
    return minutesBetweenDates;
}

+ (BOOL) cacheBannerAppearsForListingFromCounter:(NSNumber *) NumberOfAppear {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForBannerAppearsForListing];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    //2- check if file exists
    //BOOL cahcedFileExists = [GenericMethods fileExistsInDocuments:cacheFileName];
    
    //3- create the dictionary to be serialized to JSON
    NSMutableDictionary * dictToBeWritten = [NSMutableDictionary new];
    [dictToBeWritten setObject:NumberOfAppear forKey:@"BannerAppearsForMarket"];
    
    //4- convert dictionary to NSData
    NSError  *error;
    NSData * dataToBeWritten = [NSKeyedArchiver archivedDataWithRootObject:dictToBeWritten];
    if (![dataToBeWritten writeToFile:cacheFilePath options:NSDataWritingAtomic error:&error])
        return NO;
    else
        return YES;
    
}

+ (NSNumber *) getCachedBannerAppearsForListing {
    
    //1- get the file name same as request url
    NSString * cacheFileName = [self getCacheFileNameForBannerAppearsForListing];
    
    //2- get cache file path
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], cacheFileName];
    
    //check if the file expiration date
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attrs = [fm attributesOfItemAtPath:cacheFilePath error:nil];
    
    if (attrs) {
        
        NSDate * today = [NSDate date];
        //NSDate * fileCreationDate = (NSDate*)[attrs objectForKey: NSFileCreationDate];
        NSDate * fileModificationDate = [attrs fileModificationDate];
        
        NSInteger minutesDiff = [GenericMethods dateDifferenceInMinutesFrom:fileModificationDate To:today];
        
        /*
         NSLog(@"File last modified on: %@", fileModificationDate);
         NSLog(@"today is: %@", today);
         NSLog(@"difference in minutes is: %i", minutesDiff);
         */
        
        if (minutesDiff > 1) {
            NSError *error;
            if ([fm removeItemAtPath:cacheFilePath error:&error] == YES)
                //NSLog(@"File exceeded expiration limit, file has bee deleted");
                
                return nil;
        }
        
    }
    
    NSData *archiveData = [NSData dataWithContentsOfFile:cacheFilePath];
    if (!archiveData)
        return nil;
    
    NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    
    if (!dataDict)
        return nil;
    
    NSNumber * resultNum = [dataDict objectForKey:@"BannerAppearsForMarket"];
    return resultNum;
}


+ (NSString *) getCacheFileNameForBannerAppearsForListing
{
    
    //the file name is the string of listing URL without the page number and page size
    NSString * fullURLString = @"/CurrentAppearsForMarket";
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
    
    return [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


@end
