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

@protocol ProfileManagerDelegate <NSObject>

@required
- (void) userFailLoginWithError:(NSError*) error;
- (void) userDidLoginWithData:(UserProfile *) resultProfile;
@end

@interface ProfileManager : NSObject

#pragma mark - properties
@property (strong, nonatomic) id <ProfileManagerDelegate> delegate;

#pragma mark - actions

+ (ProfileManager *) sharedInstance;

- (void) loginWithDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress password:(NSString *) plainPassword;

@end
