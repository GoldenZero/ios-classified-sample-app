//
//  SubBrandCell.m
//  TryBrandBubble
//
//  Created by Roula Misrabi on 3/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SubBrandCell.h"


@implementation SubBrandCell
@synthesize brandBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //button frame
        [btn setFrame:CGRectMake(0.0f, 0.0f,  frame.size.width, frame.size.height)];
        
        //button title label
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        //button border
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.layer.borderWidth = 0.5f;
        btn.layer.cornerRadius = 10.0f;
        
        [self addSubview:btn];
        self.brandBtn = btn;
    }
    return self;
}

@end
