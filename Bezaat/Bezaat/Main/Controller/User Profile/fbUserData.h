//
//  fbUserData.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fbUserData : NSObject

#pragma mark - properties
@property (strong, nonatomic) NSString * username;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * userID;

#pragma mark - methods
- (id) initWithUserName:(NSString *) aUsername email:(NSString *) aEmail userID:(NSString *) aUserId;

@end
