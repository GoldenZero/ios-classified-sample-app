//
//  FacebookManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager
@synthesize delegate;

-(id) initWithDelegate: (id <FacebookLoginDelegate>) del {
    self = [super init];
    if (self)
    {
        self.delegate = del;
    }
    return self;
}

- (void) performLogin {
    
    if ([SharedSession fbSharedInstance].isOpen) {
        //user is already logged in
        [delegate fbDidFinishLogging];
        
    } else {
        NSLog(@"%i", [SharedSession fbSharedInstance].state);
        if ([SharedSession fbSharedInstance].state == FBSessionStateCreated) {
            // Create a new, logged out session.
            [SharedSession initNewFbSession];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [[SharedSession fbSharedInstance] openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [delegate fbDidFinishLogging];
        }];
    }
}

- (void) performLogout {
    [[SharedSession fbSharedInstance] closeAndClearTokenInformation];
}

#pragma mark - helper methods


- (NSDictionary *) getUserDataDictionary {
    /*
    [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", appDelegate.session.accessTokenData.accessToken]
     */
    return [NSDictionary new];
}
@end
