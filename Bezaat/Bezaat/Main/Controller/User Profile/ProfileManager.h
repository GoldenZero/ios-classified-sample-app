//
//  ProfileManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"
#import "CustomError.h"
#import "NSString+MD5.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "DeviceRegistration.h"

@protocol ProfileManagerDelegate <NSObject>
@required
- (void) userFailLoginWithError:(NSError*) error;
- (void) userDidLoginWithData:(UserProfile *) resultProfile;
@end

@protocol DeviceRegisterDelegate <NSObject>
@required
- (void) deviceFailRegisterWithError:(NSError*) error;
@end

@interface ProfileManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <ProfileManagerDelegate> delegate;
@property (strong, nonatomic) id <DeviceRegisterDelegate> deviceDelegate;

#pragma mark - methods

+ (ProfileManager *) sharedInstance;

+ (KeychainItemWrapper *) loginKeyChainItemSharedInstance;

// call login API
- (void) loginWithDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress password:(NSString *) plainPassword;

// call device register API
- (void) registerDeviceWithDelegate:(id <DeviceRegisterDelegate>) del;

// store user's data
- (void) storeUserProfile:(UserProfile * ) up;

// get the stored user data
- (UserProfile *) getSavedUserProfile;

// get the stored device token
- (NSString *) getSavedDeviceToken;
@end
