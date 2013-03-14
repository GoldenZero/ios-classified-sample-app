//
//  BHPhoto.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHPhoto.h"

@interface BHPhoto ()


@end

@implementation BHPhoto
@synthesize image,imageURL;
#pragma mark - Properties

- (UIImage *)image
{
    if (!image && self.imageURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        UIImage *imag = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        
        self.image = imag;
    }
    
    return image;
}

#pragma mark - Lifecycle

+ (BHPhoto *)photoWithImageURL:(NSURL *)imageURL
{
    return [[self alloc] initWithImageURL:imageURL];
}

- (id)initWithImageURL:(NSURL *)imagURL
{
    self = [super init];
    if (self) {
        self.imageURL = imagURL;
    }
    return self;
}

@end
