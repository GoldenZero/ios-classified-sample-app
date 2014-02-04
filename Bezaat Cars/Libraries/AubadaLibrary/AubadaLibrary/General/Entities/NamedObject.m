//
//  NamedObject.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 7/27/12.
//  Copyright (c) 2012 aubada.com. All rights reserved.
//

#import "NamedObject.h"

@implementation NamedObject

- (id) initWithName:(NSString*)objectName {
    if (self = [super init]) {
        self.name = objectName;
    }
    
    return self;
}

@end
