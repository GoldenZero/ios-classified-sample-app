//
//  URLUtils.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/26/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils

+ (URLUtils*) sharedInstance {
    static URLUtils* instance = nil;
    if (instance == nil) {
        instance = [[URLUtils alloc] init];
    }
    
    return instance;
}

// This method opens the given link in an external Safari app
- (void) openURLInSafari:(NSString*)urlString {
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

/*
 * Returns: A dictionary of all the variables names and their values from the given URL
 * It returns nil if the no variables were found or if the url is invalid
 */
- (NSDictionary*)variablesFromURL:(NSString*)url {
    // Return nil if the string is invalid
    if ((url == nil) || ([url compare:@""] == NSOrderedSame)) {
        return nil;
    }
    
    // Try to split the string into two strings according to the "?"
    // The second part will contain the variables
    NSArray* twoPartsString = [url componentsSeparatedByString:@"?"];
    if ((twoPartsString == nil) || (twoPartsString.count != 2)) {
        return nil;
    }
    
    // Split the variables part using the "&"
    NSString* variablesString = twoPartsString[1];
    NSArray* variablesArray = [variablesString componentsSeparatedByString:@"&"];
    if ((variablesArray == nil) || (variablesArray.count == 0)) {
        return nil;
    }

    // Define the output dictionary and fill it from the pervious array
    NSMutableDictionary* variables = [[NSMutableDictionary alloc] initWithCapacity:variablesArray.count];
    for (NSString* variableDetails in variablesArray) {
        // Split the variable name and value
        NSArray* nameAndValue = [variableDetails componentsSeparatedByString:@"="];
        if ((nameAndValue != nil) && (nameAndValue.count == 2)) {
            NSString* name = nameAndValue[0];
            NSString* value = nameAndValue[1];
            
            // Add the variable to the dictionary
            variables[name] = value;
        }
    }

    // Check if values were added to the dictionary
    if (variables.count == 0) {
        return nil;
    }

    return variables;
}

/*
 * Returns: the value of the given QUERY STRING variable from the given URL
 * It returns nil if the variable doesn't exist or if the url is invalid
 */
- (NSString*)variableValue:(NSString*)name FromURL:(NSString*)url {
    // Get the variables in the URL
    NSDictionary* variables = [self variablesFromURL:url];
    if (variables == nil) {
        return nil;
    }
    
    return variables[name];
}

/*
 * This method changes the given youtube url to a valid youtube embed url in the below format
 * http://www.youtube.com/embed/youtube_video_id
 */
- (NSString*)youtubeEmbedUrl:(NSString*)url {
    // Get the "v" variable value which contains the video id
    NSString* videoID = [self variableValue:@"v" FromURL:url];
    return [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", videoID];
}

@end
