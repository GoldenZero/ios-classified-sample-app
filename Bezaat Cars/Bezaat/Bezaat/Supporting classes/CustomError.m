//
//  CustomError.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CustomError.h"

@implementation CustomError
@synthesize descMessage;
@synthesize Code;

- (NSString *) description {
    
    return descMessage;
}

-(NSInteger) error {
    return Code;
}

@end
