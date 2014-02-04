//
//  JSONParser.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 1/4/13.
//  Copyright (c) 2013 SyriSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (JSONParser*)sharedInstance;

- (NSArray*)parseJSONData:(NSData*)data;

@end
