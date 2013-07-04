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
    _brandNameLabel.text=currentBrand.brandNameAr;
}

- (void)selectCell {
    _imgSelected.hidden = NO;
    //_imgUnselected.hidden = YES;
    _imgBrand.image = currentBrand.brandInvertedImage;
    _brandNameLabel.textColor=[UIColor whiteColor];
}

- (void)unselectCell {
    _imgSelected.hidden = YES;
    //_imgUnselected.hidden = NO;
    _imgBrand.image = currentBrand.brandImage;
    _brandNameLabel.textColor=[UIColor colorWithRed:(49/255.f) green:(137/255.f) blue:(205/255.f) alpha:1.0];
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
