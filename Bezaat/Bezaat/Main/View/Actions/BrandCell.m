//
//  BrandCell.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrandCell.h"

@implementation BrandCell
@synthesize brandImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,  frame.size.width, frame.size.height)];
        
        imgV.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:imgV];
        self.brandImageView = imgV;
    }
    return self;
}

@end
