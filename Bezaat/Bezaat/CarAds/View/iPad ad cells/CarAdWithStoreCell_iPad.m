//
//  CarAdWithStoreCell.m
//  Bezaat
//
//  Created by Syrisoft on 4/9/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarAdWithStoreCell.h"

@implementation CarAdWithStoreCell_iPad

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
    [self.detailsLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailsLabel setTextAlignment:SSTextAlignmentRight];
    [self.detailsLabel setTextColor:[UIColor blackColor]];
    [self.detailsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
    
    //init properties of carPriceLabel
    [self.carPriceLabel setBackgroundColor:[UIColor clearColor]];
    [self.carPriceLabel setTextAlignment:SSTextAlignmentCenter];
    [self.carPriceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
    [self.carPriceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
}

@end
