//
//  CarModel.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel
@synthesize name, imageFileName, image, brandsArray;

- (id) initWithName:(NSString *) aName imageFileName:(NSString *) aImageFileName brandsArray:(NSArray *)aBrandsArray {

    self = [super init];
    if (self) {
        //init name
        self.name = aName;
        
        //init imageFileName
        self.imageFileName = aImageFileName;
        
        //load image
        self.image = [UIImage imageNamed:self.imageFileName];
        
        //brandsArray
        self.brandsArray = [NSArray arrayWithArray:aBrandsArray];
    }
    return self;
}



@end
