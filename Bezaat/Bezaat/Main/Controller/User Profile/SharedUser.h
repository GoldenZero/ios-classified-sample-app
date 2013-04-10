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

#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"

#import "Country.h"
#import "UserProfile.h"

@interface SharedUser : NSObject

#pragma mark - properties

@property (nonatomic) BOOL registered;

#pragma mark - methods
// Get a shared instance of user's data
+ (SharedUser *) sharedInstance;

#pragma mark - Facebook shared data

// Return the shared instance of Facebook session
+ (FBSession *) fbSharedSessionInstance;

// Create a new, logged out session.
+ (void) initNewFbSession;

// Return the shared instance of Facebook user data
+ (NSDictionary *) fbSharedUserDataInstance;

#pragma mark - Twitter shared data

// Create a new token for the user
+(void) setNewTwitterToken:(OAuth *) token;

// Return the shared instance of twitter user token
+(OAuth *) twTokenSharedInstance;

// Return the country id global among the whole application
- (NSInteger) getUserCountryID;

// Return the city id global among the while application
- (NSInteger) getUserCityID;

// Return the user profile object global among the while application
- (UserProfile *) getUserProfileData;

@end
