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
@end

@interface FacebookManager : NSObject

#pragma  mark - properties

@property (strong, nonatomic) id <FacebookLoginDelegate> delegate;


#pragma mark - methods

// init
-(id) initWithDelegate: (id <FacebookLoginDelegate>) del;

// start logging in
- (void) performLogin;

// logout
- (void) performLogout;

// get userData
- (NSDictionary *) getUserDataDictionary;
@end
