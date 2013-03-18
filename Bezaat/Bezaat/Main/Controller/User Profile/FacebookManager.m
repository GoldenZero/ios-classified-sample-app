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

- (BOOL) hasValidToken {
    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
        return YES;
    
    return NO;
}


- (void) performLogin {
    if (![self hasValidToken])
        [self openSession];
    else
    {
        [delegate fbDidLoginWithData:[self getuserDataDictionaryWithSession:FBSession.activeSession]];
    }
}

#pragma mark - helper methods

// track session state
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen: {
            
            //NSLog(@"signed in with token: %@", session.accessTokenData);
            [delegate fbDidLoginWithData:[self getuserDataDictionaryWithSession:session]];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            //close session & clear data
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //LoginDidFail
            [self.delegate fbDidFailLoginWithError:error];
            break;
        default:
            break;
    }
}

// start a new session
- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

//get userData
- (NSDictionary *) getuserDataDictionaryWithSession:(FBSession *)session {
    return [NSDictionary new];
}
@end
