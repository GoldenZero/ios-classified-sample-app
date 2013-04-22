//
//  Model.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize modelID;
@synthesize brandID;
@synthesize modelName;

- (id) initWithModelIDString:(NSString *) aModelIDString
               brandIDString:(NSString *) aBrandIDString
                   modelName:(NSString *) aModelName {
    self = [super init];
    if (self) {
        
        // modelID
        self.modelID = aModelIDString.integerValue;
        
        // brandID
        self.brandID = aBrandIDString.integerValue;
        
        // modelName
        self.modelName = aModelName;
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"owner brand ID: %i, model ID: %i, model name: %@", self.brandID, self.modelID, self.modelName];
}
@end
