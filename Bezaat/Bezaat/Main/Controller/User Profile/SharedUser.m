//
//  SharedUser.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SharedUser.h"

@implementation SharedUser
@synthesize country;
@synthesize city;
@synthesize currentProfile;
@synthesize registered;


+ (SharedUser *) sharedInstance {
    static SharedUser * instance = nil;
    if (instance == nil) {
        instance = [[SharedUser alloc] init];
    }
    return instance;
}

#pragma mark - Facebook shared data

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

#pragma mark - Twitter shared data

//Twitter shared user token
static OAuth * twSharedToken;

+ (void) setNewTwitterToken:(OAuth *) token {
    twSharedToken = token;
}


+ (OAuth *) twTokenSharedInstance {
    return twSharedToken;
}
@end
