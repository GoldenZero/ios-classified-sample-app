//
//  SharedUser.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SharedUser.h"

@interface SharedUser()
{
    @protected
        NSInteger countryID;
        NSInteger cityID;
        UserProfile * currentProfile;
}
@end

@implementation SharedUser
@synthesize registered;

- (id) init {
    self = [super init];
    if (self) {
        //initialy, set the country and city IDs to -1 to check if they are not loaded
        // load them from application keychain
        countryID = -1;
        cityID = -1;
        currentProfile = nil;
    }
    return self;
}

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

- (NSInteger) getUserCountryID {
    if (countryID == -1)
        countryID = [[LocationManager sharedInstance] getSavedUserCountryID];
    return countryID;
}

- (NSInteger) getUserCityID {
    if (cityID == -1)
        cityID = [[LocationManager sharedInstance] getSavedUserCityID];
    return cityID;
}

- (UserProfile *) getUserProfileData {
    //return a nil of user is a visitor
    if (!currentProfile)
        currentProfile =[[ProfileManager sharedInstance] getSavedUserProfile];
    return currentProfile;
}

@end
