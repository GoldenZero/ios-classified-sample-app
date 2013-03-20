//
//  fbUserData.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "fbUserData.h"

@implementation fbUserData
@synthesize username, email, userID;

- (id) initWithUserName:(NSString *) aUsername email:(NSString *) aEmail userID:(NSString *) aUserID {
    self = [super init];
    if (self)
    {
        //username
        self.username = aUsername;
        
        //email
        self.email = aEmail;
        
        //userID
        self.userID = aUserID;
    }
    return self;
}

@end
