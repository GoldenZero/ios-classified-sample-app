//
//  ModelCell.m
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ModelCell.h"

#import "Model.h"

@implementation ModelCell

- (void) reloadInformation:(Model*)model {
    _lblModel.text = model.modelName;
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

    if (selected)
        [_bgImageView setHidden:NO];
    else
        [_bgImageView setHidden:YES];
}

@end
