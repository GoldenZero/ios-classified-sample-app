//
//  Country.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "Country.h"

@implementation Country
@synthesize name, citiesArray;

- (id) initWithName:(NSString *) aName citiesArray:(NSArray *)aCitiesArray {
    self = [super init];
    if (self) {
        //name
        self.name = aName;
        
        //citiesArray
        self.citiesArray = [NSArray arrayWithArray:aCitiesArray];
    }
    return self;
}

@end
