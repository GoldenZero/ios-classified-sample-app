//
//  PListParser.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 1/4/13.
//  Copyright (c) 2013 SyriSoft. All rights reserved.
//

#import "PListParser.h"

@implementation PListParser

+ (PListParser*)sharedInstance {
    static PListParser* instance = nil;
    if (instance == nil) {
        instance = [[PListParser alloc] init];
    }
    
    return instance;
}

- (NSArray*)parsePListFile:(NSString*)filePath {
    // Try to parse an array and if it doesn't work, try to parse a dict and add it to array
    NSArray* result = [NSArray arrayWithContentsOfFile:filePath];
    if (result == nil) {
        // Try one dictionary
        NSDictionary* resultDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        result = @[resultDict];
    }
    
    return result;
}

- (NSArray*)parsePListData:(NSData*)data {
    // Get the temp file path
    NSString* tempFilePath = [[FileManager sharedInstance] filePathInTemp:@"PLISTPARSER_TEMP_FILE.plist"];
    [data writeToFile:tempFilePath atomically:NO];
    
    return [self parsePListFile:tempFilePath];
}

@end
