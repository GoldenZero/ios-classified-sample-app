//
//  SharedSession.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/19/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
// This class is kept to maintain the shared session instances
//

#import "SharedSession.h"

@implementation SharedSession

//Facebook shared session instance
static FBSession * fbSession;

+ (FBSession *) fbSharedInstance {
    return fbSession;
}

+ (void) initNewFbSession {
    fbSession = [[FBSession alloc] init];
}

@end
