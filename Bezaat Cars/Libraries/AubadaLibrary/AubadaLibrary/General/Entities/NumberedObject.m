//
//  NumberedObject.m
//  ClassifiedAds
//
//  Created by Aubada Taljo on 9/29/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "NumberedObject.h"

@implementation NumberedObject

- (id) initWithID:(int)objectID {
    if (self = [super init]) {
        self.ID = objectID;
    }
    
    return self;
}

@end
