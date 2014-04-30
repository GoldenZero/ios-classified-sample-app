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

- (void) userFailLoginWithTwitterError:(NSError*) error;
- (void) userDidLoginWithTwitterData:(UserProfile *) resultProfile;

- (void) userFailLoginWithFacebookError:(NSError*) error;
- (void) userDidLoginWithFacebookData:(UserProfile *) resultProfile;

@end

@protocol ProfileRegisterDelegate <NSObject>
@required
- (void) userFailRegisterWithError:(NSError*) error;
- (void) userDidRegisterWithData:(UserProfile *) resultProfile;

@end

@protocol ProfileUpdateDelegate <NSObject>
@required
- (void) userUpdateWithData:(UserProfile *)newData;
- (void) userFailUpdateWithError:(NSError*) error;
@end

@protocol DeviceRegisterDelegate <NSObject>
@required
- (void) deviceFailRegisterWithError:(NSError*) error;
@end

@protocol FavoritesDelegate <NSObject>
@required
// add
- (void) FavoriteFailAddingWithError:(NSError*) error forAdID:(NSUInteger) adID;
- (void) FavoriteDidAddWithStatus:(BOOL) resultStatus forAdID:(NSUInteger) adID;

// remove
- (void) FavoriteFailRemovingWithError:(NSError*) error forAdID:(NSUInteger) adID;
- (void) FavoriteDidRemoveWithStatus:(BOOL) resultStatus forAdID:(NSUInteger) adID;

// remove Ad
- (void) AdFailRemovingWithError:(NSError*) error;
- (void) AdDidRemoveWithStatus:(NSString*) resultStatus;

@end


@interface ProfileManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <ProfileManagerDelegate> delegate;
@property (strong, nonatomic) id <ProfileUpdateDelegate> updateDelegate;
@property (strong, nonatomic) id <DeviceRegisterDelegate> deviceDelegate;
@property (strong, nonatomic) id <FavoritesDelegate> favDelegate;
@property (strong, nonatomic) id <ProfileRegisterDelegate> RegisterDelegate;

#pragma mark - methods

+ (ProfileManager *) sharedInstance;

+ (KeychainItemWrapper *) loginKeyChainItemSharedInstance;

// call login API
- (void) loginWithDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress password:(NSString *) plainPassword;

// call login Twitter API
- (void) loginWithTwitterDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress AndUserName:(NSString *) userName andTwitterid:(NSString*)twitterID;

// call login Facebook API
- (void) loginWithFacebookDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress AndUserName:(NSString *) userName andFacebookid:(NSString*)facebookID;


// call register API
- (void) registerWithDelegate:(id <ProfileRegisterDelegate>) del UserName:(NSString *) userName AndEmail:(NSString *) emailAdress andPassword:(NSString*)PWD;

// call device register API
- (void) registerDeviceWithDelegate:(id <DeviceRegisterDelegate>) del;

// call add to favorite API
- (void) addCarAd:(NSUInteger ) adID toFavoritesWithDelegate:(id <FavoritesDelegate>) del;

// call remove from favorite API
- (void) removeCarAd:(NSUInteger ) adID fromFavoritesWithDelegate:(id <FavoritesDelegate>) del;

// call remove from favorite API
- (void) removeAd:(NSUInteger ) adID fromAdsWithDelegate:(id <FavoritesDelegate>) del;

// update the stores status in keyChain
- (BOOL) updateStoreStateForCurrentUser:(BOOL) storeState;

// store user's data
- (void) storeUserProfile:(UserProfile * ) up;

// get the stored user data
- (UserProfile *) getSavedUserProfile;

// get the stored device token
- (NSString *) getSavedDeviceToken;

//call update user api
- (void) updateUserWithDelegate:(id <ProfileUpdateDelegate> )del userName:(NSString *)Name andPassword:(NSString*)pwd;
@end