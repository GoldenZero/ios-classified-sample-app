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
@synthesize brandInvertedImage;
@synthesize models;

- (id) initWithBrandIDString:(NSString *) aBrandIDString
                 brandNameAr:(NSString *) aBrandNameAr
                     urlName:(NSString *) aUrlName
                  brandImage:(UIImage *) aBrandImage
          brandInvertedImage:(UIImage *) aBrandInvertedImage {

    self = [super init];
    if (self) {
        
        // brandID
        self.brandID = aBrandIDString.integerValue;
        
        // brandNameAr
        self.brandNameAr = aBrandNameAr;
        
        // urlName
        self.urlName = aUrlName;
        
        // brandImage
        self.brandImage = aBrandImage;
        
        // brandInvertedImage
        self.brandInvertedImage = aBrandInvertedImage;
        
    }
    return self;
}
@end
