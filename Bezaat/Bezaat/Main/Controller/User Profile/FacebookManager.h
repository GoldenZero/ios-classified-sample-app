//
//  FacebookManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>


@protocol FacebookLoginDelegate <NSObject>
@required
// This method is called after the login is finished either successfully or with error.
- (void) fbDidFinishLogging;

// These methods are called after loading user's data in an FBRequest with success/failure
- (void) fbDidLoadUserDataWithData:(NSDictionary *) userData;
- (void) fbDidFailLoadingUserDataWithError:(NSError*) error;

// These methods are called after Loading friends list with success/failure
- (void) fbDidFailLoadingFriendsListWithError:(NSError*) error;
- (void) fbDidFinishLoadingFriendsListWithData:(NSArray *) resultArray;
@end

@interface FacebookManager : NSObject <DataDelegate>

#pragma  mark - properties

@property (strong, nonatomic) id <FacebookLoginDelegate> delegate;


#pragma mark - methods

// init
-(id) initWithDelegate: (id <FacebookLoginDelegate>) del;

// start logging in
- (void) performLogin;

// logout
- (void) performLogout;

// get friends data
- (void) loadFriendsData;

// get userData
- (void) getUserDataDictionary;
@end
