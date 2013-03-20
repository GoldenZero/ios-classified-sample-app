//
//  SharedUser.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//  This class is kept to maintain the shared instances of current user
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "fbUserData.h"

@interface SharedUser : NSObject

// Return the shared instance of Facebook session
+ (FBSession *) fbSharedSessionInstance;

// Create a new, logged out session.
+ (void) initNewFbSession;

// Return the shared instance of Facebook user data
+ (NSDictionary *) fbSharedUserDataInstance;

@end
