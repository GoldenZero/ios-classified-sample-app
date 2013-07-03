//
//  gallariesManager.m
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "gallariesManager.h"
#import "CarsGallery.h"

#define GalleriesURL [NSURL URLWithString: @"http://http://gfctest.edanat.com/v1.1/json/get-stores-by-country"]
@interface gallariesManager () {
    NSMutableArray *result;
}
@end
@implementation gallariesManager


@synthesize delegate,countryID;

- (id) init {
    
    self = [super init];
    if (self) {
        result=[[NSMutableArray alloc]init];
    }
    return self;
}


+ (gallariesManager *) sharedInstance {
    static gallariesManager * instance = nil;
    if (instance == nil) {
        instance = [[gallariesManager alloc] init];
    }
    return instance;
}

- (NSArray*) getGallariesWithDelegate:(id <GallariesManagerDelegate>) del{
    
    NSString * post =[NSString stringWithFormat:@"countryid=%@",countryID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    
    [request setURL:GalleriesURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //get response
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary* returnedJson = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *gallaries=[returnedJson objectForKey:@"Data"];
    
    for (int i=0; i<gallaries.count; i++) {
        NSDictionary *temp=[gallaries objectAtIndex:i];
        CarsGallery * cg=[[CarsGallery alloc] init];
        cg.StoreID=[[temp objectForKey:@"StoreID"] integerValue];
        [result addObject:cg];
         
    }
    NSLog(@"%@",returnedJson);

    return result;
}

@end
