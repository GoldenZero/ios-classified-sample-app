//
//  DescribedObject.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 7/29/12.
//  Copyright (c) 2012 aubada.com. All rights reserved.
//

#import "DescribedObject.h"

@implementation DescribedObject

- (id) initWithDescription:(NSString*)descriptionToSet {
    if (self = [super init]) {
        self.description = descriptionToSet;
    }

    return self;
}

@end
