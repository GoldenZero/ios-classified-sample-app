//
//  NSURLProtocolCustom.m
//  Argaam
//
//  Created by GALMarei on 9/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "NSURLProtocolCustom.h"

@implementation NSURLProtocolCustom

BOOL isApp;
BOOL isCssData;
BOOL isJsData;
BOOL isJs9Data;
BOOL isFontData;


+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    NSLog(@"%@",theRequest.URL);
    NSLog(@"%@",theRequest.URL.scheme);
    //adding applwwebdata for css
    //
    
    if ([theRequest.URL.scheme caseInsensitiveCompare:@"myapp"] == NSOrderedSame) {
        isApp = YES;
        isCssData = NO;
        isJsData = NO;
        isJs9Data = NO;
        isFontData = NO;
        return YES;
    }
    else if ([theRequest.URL.scheme caseInsensitiveCompare:@"myappcss"] == NSOrderedSame) {
        isCssData = YES;
        isApp = NO;
        isJsData = NO;
        isJs9Data = NO;
        isFontData = NO;
        return YES;
        
    }
    else if ([theRequest.URL.scheme caseInsensitiveCompare:@"myappjs"] == NSOrderedSame) {
        isJsData = YES;
        isCssData = NO;
        isApp = NO;
        isJs9Data = NO;
        isFontData = NO;
        return YES;
        
    }
    else if ([theRequest.URL.scheme caseInsensitiveCompare:@"myappjs9"] == NSOrderedSame) {
        isJs9Data = YES;
        isJsData = NO;
        isCssData = NO;
        isApp = NO;
        isFontData = NO;
        return YES;
        
    }
    else if ([theRequest.URL.scheme caseInsensitiveCompare:@"myappfont"] == NSOrderedSame) {
        isFontData = YES;
        isJs9Data = NO;
        isJsData = NO;
        isCssData = NO;
        isApp = NO;
        return YES;
        
    }
    
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)theRequest
{
    return theRequest;
}

- (void)startLoading
{
    NSLog(@"%@", self.request.URL);
    
    NSURLResponse *response;
   // NSString* temp = [self.request.URL absoluteString];
    NSString *FileName;
    NSString *imagePath;
    if (isApp)
    {
        response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                             MIMEType:@"image/png"
                                expectedContentLength:-1
                                     textEncodingName:nil];
      FileName = [[self.request.URL.absoluteString stringByReplacingOccurrencesOfString:@"myapp://" withString:@""] stringByReplacingOccurrencesOfString:@".png" withString:@""];
        imagePath = [[NSBundle mainBundle] pathForResource:FileName ofType:@"png"];
    }
    else if (isCssData)
    {
        response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                             MIMEType:@"file/css"
                                expectedContentLength:-1
                                     textEncodingName:nil];
       FileName = [[self.request.URL.absoluteString stringByReplacingOccurrencesOfString:@"myappcss://" withString:@""] stringByReplacingOccurrencesOfString:@".css" withString:@""];
        imagePath = [[NSBundle mainBundle] pathForResource:FileName ofType:@"css"];
    }else if (isJsData)
    {
        response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                             MIMEType:@"file/js"
                                expectedContentLength:-1
                                     textEncodingName:nil];
        FileName = [[self.request.URL.absoluteString stringByReplacingOccurrencesOfString:@"myappjs://" withString:@""] stringByReplacingOccurrencesOfString:@".js" withString:@""];
        imagePath = [[NSBundle mainBundle] pathForResource:FileName ofType:@"js"];
    }
    else if (isJs9Data)
    {
        response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                             MIMEType:@"file/js"
                                expectedContentLength:-1
                                     textEncodingName:nil];
        FileName = [[self.request.URL.absoluteString stringByReplacingOccurrencesOfString:@"myappjs9://" withString:@""] stringByReplacingOccurrencesOfString:@".js" withString:@""];
        imagePath = [[NSBundle mainBundle] pathForResource:FileName ofType:@"js"];
    }
    else if (isFontData)
    {
        response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                             MIMEType:@"file/ttf"
                                expectedContentLength:-1
                                     textEncodingName:nil];
        FileName = [[self.request.URL.absoluteString stringByReplacingOccurrencesOfString:@"myappfont://" withString:@""] stringByReplacingOccurrencesOfString:@".ttf" withString:@""];
        imagePath = [[NSBundle mainBundle] pathForResource:FileName ofType:@"ttf"];
    }
//    temp = [temp substringWithRange:NSMakeRange(8, 2)];
    
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    NSLog(@"request cancelled. stop loading the response, if possible");
}

@end
