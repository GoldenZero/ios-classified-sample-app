//
//  CategoryCell.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/13/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

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
    
    //init properties of the catName label
    [self.catNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.catNameLabel setTextAlignment:SSTextAlignmentRight];
    [self.catNameLabel setTextColor:[UIColor blackColor]];
    [self.catNameLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:13.0] ];
    
}


@end
