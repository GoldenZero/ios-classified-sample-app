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

#pragma mark - HTTP header keys

#define DEVICE_TOKEN_HTTP_HEADER_KEY   @"DeviceToken"
#define USER_ID_HTTP_HEADER_KEY        @"UserID"
#define PASSWORD_HTTP_HEADER_KEY       @"Password"


@protocol ProfileManagerDelegate <NSObject>
@required
- (void) userFailLoginWithError:(NSError*) error;
- (void) userDidLoginWithData:(UserProfile *) resultProfile;
@end

@protocol DeviceRegisterDelegate <NSObject>
@required
- (void) deviceFailRegisterWithError:(NSError*) error;
@end

@protocol FavoritesDelegate <NSObject>
@required
- (void) FavoriteFailAddingWithError:(NSError*) error;
- (void) FavoriteDidAddWithStatus:(BOOL) resultStatus;
@end


@interface ProfileManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <ProfileManagerDelegate> delegate;
@property (strong, nonatomic) id <DeviceRegisterDelegate> deviceDelegate;
@property (strong, nonatomic) id <FavoritesDelegate> favDelegate;

#pragma mark - methods

+ (ProfileManager *) sharedInstance;

+ (KeychainItemWrapper *) loginKeyChainItemSharedInstance;

// call login API
- (void) loginWithDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress password:(NSString *) plainPassword;

// call device register API
- (void) registerDeviceWithDelegate:(id <DeviceRegisterDelegate>) del;

// call add to favorite API
- (void) addCarAd:(NSUInteger ) adID toFavoritesWithDelegate:(id <FavoritesDelegate>) del;

// store user's data
- (void) storeUserProfile:(UserProfile * ) up;

// get the stored user data
- (UserProfile *) getSavedUserProfile;

// get the stored device token
- (NSString *) getSavedDeviceToken;
@end
