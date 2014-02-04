//
//  BaseInternetManager.h
//  ClassifiedAds
//
//  Created by Aubada Taljo on 9/28/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "BaseDataManager.h"

#import "DataDelegate.h"

@interface InternetManager : BaseDataManager {
    @protected    
    // This field represents the downloaded data so far
    NSMutableData* dataSoFar;
    
    // Temp file name to store the result data in it and load it into an array
    NSString* _tempFileName;
    
    // This is the rest of the url to request (after the base url)
    NSString* _url;
    
    // This is the response type (JSON or PLIST)
    NSString* _responseType;
}

#pragma mark -
#pragma mark Init Methods

/*
 * The response type is one of the below
 * JSON
 * PLIST
 */
- (id) initWithType:(NSString*)responseType;

- (id) initWithTempFileName:(NSString*)name url:(NSString*)url delegate:(id<DataDelegate>)delegate responseType:(NSString*)responseType;
- (id) initWithTempFileName:(NSString*)name url:(NSString*)url delegate:(id<DataDelegate>)delegate startImmediately:(BOOL)immediately responseType:(NSString*)responseType;

// extension
- (id) initWithTempFileName:(NSString*)name urlRequest:(NSURLRequest *) urlRequest delegate:(id<DataDelegate>)delegate startImmediately:(BOOL)immediately responseType:(NSString*)responseType;

#pragma mark -
#pragma mark URLs Dictionary

/* 
 * This dictionary holds all the urls needed to access the online data
 * The keys of the dictionary are in the readonly properties defined below
 */
+ (NSMutableDictionary*) urls;

// The keys of the above dictionary
+ (NSString*) URL_QUERIES;
+ (NSString*) URL_IMAGES;

#pragma mark -
#pragma mark Common Methods

+ (NSString*) urlByName:(NSString*)urlName;

- (void) start;

// extension
- (void) startWithURLRequest:(NSURLRequest * )request;

@end
