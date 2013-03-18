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
- (void) fbDidLoginWithData:(NSDictionary *) userData;
- (void) fbDidFailLoginWithError:(NSError *) error;
@end

@interface FacebookManager : NSObject

#pragma  mark - properties

@property (strong, nonatomic) id <FacebookLoginDelegate> delegate;


#pragma mark - methods

// init
-(id) initWithDelegate: (id <FacebookLoginDelegate>) del;

// check for a valid session
- (BOOL) hasValidToken;

// start logging in
- (void) performLogin;

@end
