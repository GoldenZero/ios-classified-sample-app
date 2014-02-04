//
//  JSONParser.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 1/4/13.
//  Copyright (c) 2013 SyriSoft. All rights reserved.
//

#import "JSONParser.h"

#import "PListParser.h"

@implementation JSONParser

+ (JSONParser*)sharedInstance {
    static JSONParser* instance = nil;
    if (instance == nil) {
        instance = [[JSONParser alloc] init];
    }

    return instance;
}

- (NSArray*)parseJSONData:(NSData*)data {
    // Get the temp file path
    NSString* tempFilePath = [[FileManager sharedInstance] filePathInTemp:@"JSONPARSER_TEMP_FILE.plist"];
    NSError* error;
    [[NSJSONSerialization JSONObjectWithData:data
                                     options:0
                                       error:&error] writeToFile:tempFilePath atomically:YES];
    if (error) {
        return nil;
    }

    return [[PListParser sharedInstance] parsePListFile:tempFilePath];
}

@end
