//
//  UserProfile.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

@synthesize userID;
@synthesize userName;
@synthesize emailAddress;
@synthesize passwordMD5;
@synthesize defaultCityID;
@synthesize isVerified;
@synthesize isActive;
@synthesize hasStores;


- (id) initWithUserIDString:(NSString *) aUserIDString
                   userName:(NSString *) aUserName
               emailAddress:(NSString *) aEmailAddress
                passwordMD5:(NSString *) aPasswordMD5
        defaultCityIDString:(NSString *) aDefaultCityIDString
           isVerifiedString:(NSString *) aIsVerifiedString
             isActiveString:(NSString *) aIsActiveString
            hasStoresString:(NSString *)aHasStoresString {
    
    self = [super init];
    
    if (self) {
        
        // userID
        self.userID = aUserIDString.integerValue;
        
        // userName
        self.userName = aUserName;
        
        // emailAddress
        self.emailAddress = aEmailAddress;
        
        // passwordMD5
        self.passwordMD5 = aPasswordMD5;
        
        // defaultCityID
        self.defaultCityID = aDefaultCityIDString.integerValue;
        
        // isVerified
        self.isVerified = aIsVerifiedString.boolValue;
        
        // isActive
        self.isActive = aIsActiveString.boolValue;
        
        //hasStores
        self.hasStores = aHasStoresString.boolValue;
        
    }
    return self;
}

@end
