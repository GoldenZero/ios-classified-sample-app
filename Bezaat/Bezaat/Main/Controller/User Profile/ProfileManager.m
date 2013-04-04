//
//  ProfileManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ProfileManager.h"
@interface ProfileManager ()
{
    @protected
        NSMutableData * dataSoFar;
}
@end

@implementation ProfileManager
@synthesize delegate;

//the login url is a POST url
static NSString * login_url = @"http://gfctest.edanat.com/v1.0/json/user-login";

static NSString * internetMngrTempFileName = @"mngrTmp";

- (id) init {
    
    self = [super init];
    
    if (self) {
        self.delegate = nil;
        dataSoFar = nil;
    }
    return self;
    
}

+ (ProfileManager *) sharedInstance {
    static ProfileManager * instance = nil;
    if (instance == nil) {
        instance = [[ProfileManager alloc] init];
    }
    return instance;
}

- (void) loginWithDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress password:(NSString *) plainPassword {
    
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    //if (![GenericMethods connectedToInternet])
    
    
    //3- start the request
    
}


#pragma mark - NSURLConnection Delegate methods


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    if (dataSoFar == nil) {
        dataSoFar = [[NSMutableData alloc] initWithData:data];
    }
    else {
        [dataSoFar appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    /*
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                 message:[error localizedDescription]
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                       otherButtonTitles:nil] show];
    */
    
    // Prepare the data object for the next request
    dataSoFar = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //handle the response of login that is received totally here
    
    //NSString *responseText = [[NSString alloc] initWithData:dataSoFar encoding:NSUTF8StringEncoding];
    
    // Prepare the data object for the next request
    dataSoFar = nil;
}

@end
