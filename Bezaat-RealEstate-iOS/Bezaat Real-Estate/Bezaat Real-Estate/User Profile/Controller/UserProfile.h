//
//  UserProfile.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger userID;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * emailAddress;
@property (strong, nonatomic) NSString * passwordMD5;
@property (nonatomic) NSUInteger defaultCityID;
@property (nonatomic) BOOL isVerified;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL hasStores;

#pragma mark - actions
- (id) initWithUserIDString:(NSString *) aUserIDString
                   userName:(NSString *) aUserName
               emailAddress:(NSString *) aEmailAddress
                passwordMD5:(NSString *) aPasswordMD5
        defaultCityIDString:(NSString *) aDefaultCityIDString
           isVerifiedString:(NSString *) aIsVerifiedString
             isActiveString:(NSString *) aIsActiveString
            hasStoresString:(NSString *)aHasStoresString;

@end


