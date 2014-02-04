//
//  ProfileCell.m
//  Bezaat
//
//  Created by GALMarei on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ProfileCell.h"
#import <CoreImage/CoreImage.h>

@implementation ProfileCell

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

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (selected) {
            if (![self.customLbl.text isEqualToString:@"تسجيل الخروج"]) {
                self.backgroundColor = [UIColor colorWithRed:31/255.0f green:119/255.0f blue:206/255.0f alpha:1.0f];
                self.customLbl.textColor = [UIColor whiteColor];
                self.customTitle.textColor = [UIColor whiteColor];
            }
        }
        else {
            if (![self.customLbl.text isEqualToString:@"تسجيل الخروج"]) {
                self.backgroundColor = [UIColor whiteColor];
                self.customLbl.textColor = [UIColor darkGrayColor];
                self.customTitle.textColor = [UIColor colorWithRed:51/255.0f green:102/255.0f blue:153/255.0f alpha:1.0f];
            }
        }
    }
}

@end
