//
//  SharedUser.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SharedUser.h"

@implementation SharedUser

//Facebook shared session instance
static FBSession * fbSharedSession;

//Facebook shared user data instance
static fbUserData * fbSharedUserData;

+ (FBSession *) fbSharedSessionInstance {
    return fbSharedSession;
}

+ (void) initNewFbSession {
    fbSharedSession = [[FBSession alloc] init];
}

+ (fbUserData *) fbSharedUserDataInstance {
    return fbSharedUserData;
}

//+ (void) initFbUserDataWithUser
@end
