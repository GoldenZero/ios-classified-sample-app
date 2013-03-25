//
//  Brand.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "Brand.h"

@implementation Brand

@synthesize brandID;
@synthesize brandNameAr;
@synthesize urlName;//EN name
@synthesize brandImage;
@synthesize models;

- (id) initWithBrandIDString:(NSString *) aBrandIDString
                 brandNameAr:(NSString *) aBrandNameAr
                     urlName:(NSString *) aUrlName
              brandImagePath:(NSString *) aBrandImagePath {

    self = [super init];
    if (self) {
        
        // brandID
        self.brandID = aBrandIDString.integerValue;
        
        // brandNameAr
        self.brandNameAr = aBrandNameAr;
        
        // urlName
        self.urlName = aUrlName;
        
        // brandImage
        if ([[NSFileManager defaultManager] fileExistsAtPath:aBrandImagePath])
            self.brandImage = [UIImage imageWithContentsOfFile:aBrandImagePath];
        else
            self.brandImage = nil;
        
    }
    return self;
}
@end
