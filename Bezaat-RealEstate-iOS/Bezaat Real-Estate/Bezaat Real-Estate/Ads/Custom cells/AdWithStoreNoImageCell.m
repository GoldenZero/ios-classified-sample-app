//
//  AdWithStoreNoImageCell.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AdWithStoreNoImageCell.h"

@implementation AdWithStoreNoImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    
    //init properties of the details label
    [self.storeNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.storeNameLabel setTextAlignment:SSTextAlignmentRight];
    [self.storeNameLabel setTextColor:[UIColor blackColor]];
    [self.storeNameLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:11.0] ];
    
}


@end
