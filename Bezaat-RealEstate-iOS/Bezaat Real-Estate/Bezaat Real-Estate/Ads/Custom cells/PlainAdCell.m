//
//  PlainAdCell.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "PlainAdCell.h"

@implementation PlainAdCell

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
    
}

@end
