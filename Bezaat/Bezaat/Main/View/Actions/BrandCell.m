//
//  BrandCell.m
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrandCell.h"

#import "Brand.h"

@implementation BrandCell

- (void) reloadInformation:(Brand*)brand {
    currentBrand = brand;
    _imgBrand.image = currentBrand.brandImage;
}

- (void)selectCell {
    _imgSelected.hidden = NO;
    _imgBrand.image = currentBrand.brandInvertedImage;
}

- (void)unselectCell {
    _imgSelected.hidden = YES;
    _imgBrand.image = currentBrand.brandImage;
}

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

@end
