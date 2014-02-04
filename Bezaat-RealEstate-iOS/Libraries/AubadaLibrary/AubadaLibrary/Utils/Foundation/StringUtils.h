//
//  StringUtils.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 1/4/13.
//  Copyright (c) 2013 SyriSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (StringUtils*) sharedInstance;

- (NSString*)stringFromUnicode:(NSString*)unicodeString;

@end
