//
//  URLUtils.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/26/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtils : NSObject

+ (URLUtils*) sharedInstance;

// This method opens the given link in an external Safari app
- (void)openURLInSafari:(NSString*)url;

/*
 * Returns: A dictionary of all the variables names and their values from the given URL
 * It returns nil if the no variables were found or if the url is invalid
 */
- (NSDictionary*)variablesFromURL:(NSString*)url;

/* 
 * Returns: the value of the given QUERY STRING variable from the given URL
 * It returns nil if the variable doesn't exist or if the url is invalid
 */
- (NSString*)variableValue:(NSString*)name FromURL:(NSString*)url;

/*
 * This method changes the given youtube url to a valid youtube embed url in the below format
 * http://www.youtube.com/embed/youtube_video_id
 */
- (NSString*)youtubeEmbedUrl:(NSString*)url;

@end
