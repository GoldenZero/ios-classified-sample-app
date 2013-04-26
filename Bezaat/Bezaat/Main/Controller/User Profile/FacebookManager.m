//
//  FacebookManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "FacebookManager.h"
@interface FacebookManager ()
{
    InternetManager * internetManager;
}
@end

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
    
    if ([SharedUser fbSharedSessionInstance].isOpen) {
        //user is already logged in
        [delegate fbDidFinishLogging];
        
    } else {
        NSLog(@"%i", [SharedUser fbSharedSessionInstance].state);
        if ([SharedUser fbSharedSessionInstance].state == FBSessionStateCreated) {
            // Create a new, logged out session.
            [SharedUser initNewFbSession];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [[SharedUser fbSharedSessionInstance] openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [delegate fbDidFinishLogging];
        }];
    }
}


- (void) performLogout {
    [[SharedUser fbSharedSessionInstance] closeAndClearTokenInformation];
}

#pragma mark - helper methods


- (void) getUserDataDictionary {
    
    if ([SharedUser fbSharedSessionInstance].isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //create a suitable dictionary according to the data needed by server API
                 //self.userNameLabel.text = user.name;
                 NSLog(@"%@", user.id);
                 NSLog(@"%@", user.name);
                 //return [NSDictionary new];
                 //self.userProfileImage.profileID = user.id;
             }
             else
             {
                 NSLog(@"%@", error.localizedDescription);
             }
         }];
    }
    
    /*
    [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", appDelegate.session.accessTokenData.accessToken]
     */
}
@end
