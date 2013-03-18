//
//  SharedSession.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SharedSession : NSObject

+ (FBSession *) fbSharedInstance;

// Create a new, logged out session.
+ (void) initNewFbSession;
@end
