//
//  ModelBrand.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ModelBrand.h"

@implementation ModelBrand
@synthesize name;

- (id) initWithName:(NSString *) aName {
    self = [super init];
    if (self) {
        
        //init name
        self.name = aName;
        
    }
    return self;
}

@end
