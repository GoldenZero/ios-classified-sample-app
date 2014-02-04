//
//  PListParser.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 1/4/13.
//  Copyright (c) 2013 SyriSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListParser : NSObject

+ (PListParser*)sharedInstance;

- (NSArray*)parsePListData:(NSData*)data;
- (NSArray*)parsePListFile:(NSString*)filePath;

@end
