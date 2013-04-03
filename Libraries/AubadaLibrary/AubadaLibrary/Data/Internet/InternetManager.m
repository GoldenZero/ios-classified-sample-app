//
//  BaseInternetManager.m
//  ClassifiedAds
//
//  Created by Aubada Taljo on 9/28/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "InternetManager.h"

#import "FileManager.h"

@implementation InternetManager

/*
 * The response type is one of the below
 * JSON
 * PLIST
 */
- (id) initWithType:(NSString*)responseType {
    self = [super init];
    if (self) {
        // Reset the data
        dataSoFar = nil;
        
        _responseType = responseType;
    }
    
    return self;
}

- (id) initWithTempFileName:(NSString*)name url:(NSString*)url delegate:(id<DataDelegate>)delegate responseType:(NSString*)responseType {
    if (self = [self initWithType:responseType]) {
        _tempFileName = name;
        _url = url;
        self.delegate = delegate;
    }
    
    return self;
}

- (id) initWithTempFileName:(NSString*)name url:(NSString*)url delegate:(id<DataDelegate>)delegate startImmediately:(BOOL)immediately responseType:(NSString*)responseType {
    if (self = [self initWithTempFileName:name url:url delegate:delegate responseType:responseType]) {
        if (immediately) {
            [self start];
        }
    }
    
    return self;
}
/*
 * This dictionary holds all the urls needed to access the online data
 * The keys of the dictionary are in the readonly properties defined below
 */
+ (NSMutableDictionary*) urls {
    static NSMutableDictionary* urls = nil;
    if (urls == nil) {
        urls = [[NSMutableDictionary alloc] init];
    }
    
    return urls;
}

+ (NSString*) URL_QUERIES {
    return @"URL_QUERIES";
}

+ (NSString*) URL_IMAGES {
    return @"URL_IMAGES";
}

#pragma mark -
#pragma mark Common Methods

+ (NSString*) urlByName:(NSString*)urlName {
    NSDictionary* urls = [InternetManager urls];
    return urls[urlName];
}

- (void) start {
    NSURL* url = [[NSURL alloc] initWithString:_url];
    
    // Send the request
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark -
#pragma Connection Delegate

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    if (dataSoFar == nil) {
        dataSoFar = [[NSMutableData alloc] initWithData:data];
    }
    else {
        [dataSoFar appendData:data];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate manager:self connectionDidFailWithError:error];
    dataSoFar = nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection {
    // Get the temp file path
    NSString* tempFilePath = [[FileManager sharedInstance] filePathInTemp:_tempFileName];
    
    // If the data is JSON, parse it to PLIST first before writing it to the temp file
    if ([_responseType compare:@"JSON"] == NSOrderedSame) {
        NSError* error;
        //................................................
        
        //Replace the nullable values in the data with empty strings
        //1- convert data to string
        NSString * dataStr = [[NSString alloc]initWithData:dataSoFar encoding:NSUTF8StringEncoding];
        
        //2- replace (:null) occurences with (:"")
        NSString * dataStrWithNullReplaced = [dataStr stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
        
        //3- convert back to NSData
        NSData * dataWithNullReplaced = [dataStrWithNullReplaced dataUsingEncoding:NSUTF8StringEncoding];
        
        //Now WriteToFile won't cause any problems
        [[NSJSONSerialization JSONObjectWithData:dataWithNullReplaced
                                         options:0
                                           error:&error] writeToFile:tempFilePath atomically:YES];
        /*
        [[NSJSONSerialization JSONObjectWithData:dataSoFar
                                         options:0
                                           error:&error] writeToFile:tempFilePath atomically:YES];
         */
        //................................................
        if (error) {
            [self.delegate manager:self connectionDidSucceedWithObjects:nil];
            dataSoFar = nil;
            return;
        }
    }
    else {
        // Write the data to temp file
        [dataSoFar writeToFile:tempFilePath atomically:NO];
    }
    
    // Reload the data from .plist file to an array
    NSArray *result = [NSArray arrayWithContentsOfFile:tempFilePath];
    if (result == nil) {
        // Try one dictionary
        NSDictionary* resultDict = [NSDictionary dictionaryWithContentsOfFile:tempFilePath];
        result = @[resultDict];
    }
    
    // Send the data to the delegate
    [self.delegate manager:self connectionDidSucceedWithObjects:result];
    
    // Prepare the data object for the next request
    dataSoFar = nil;
}

@end
