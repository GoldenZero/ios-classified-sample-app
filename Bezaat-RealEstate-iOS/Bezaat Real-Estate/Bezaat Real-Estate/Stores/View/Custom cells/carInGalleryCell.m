//
//  carInGalleryCell.m
//  Bezaat
//
//  Created by Syrisoft on 7/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "carInGalleryCell.h"

@implementation carInGalleryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    [self.carPriceLabel setTextAlignment:SSTextAlignmentRight];
    [self.carPriceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
    [self.carPriceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:12.0] ];
}

@end
