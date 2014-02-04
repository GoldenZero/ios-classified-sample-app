//
//  SideMenuCell.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 7/30/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SideMenuCell.h"

@implementation SideMenuCell

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
    [self.titleLable setBackgroundColor:[UIColor clearColor]];
    [self.titleLable setTextAlignment:SSTextAlignmentRight];
    [self.titleLable setTextColor:[UIColor darkGrayColor]];
    [self.titleLable setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:15.0] ];
    //[self.titleLable setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:15.0 ofType:@"ttf"] ];
}
@end
