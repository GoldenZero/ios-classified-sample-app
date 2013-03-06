//
//  City.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "City.h"

@implementation City

@synthesize name, imageFileName, image;

- (id) initWithName:(NSString *) aName imageFileName:(NSString *) aImageFileName {
    self = [super init];
    if (self) {
        
        //name
        self.name = aName;
        
        //imageFileName
        self.imageFileName = aImageFileName;
        
        //load image
        self.image = [UIImage imageNamed:self.imageFileName];
        
    }
    return self;
}


@end
