//
//  StringUtils.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 1/4/13.
//  Copyright (c) 2013 SyriSoft. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (StringUtils*) sharedInstance {
    static StringUtils* instance = nil;
    if (instance == nil) {
        instance = [[StringUtils alloc] init];
    }
    
    return instance;
}

- (NSString*)stringFromUnicode:(NSString*)unicodeString {
    return nil;
}

@end
