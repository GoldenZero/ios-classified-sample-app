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

    [self.lblModel setText:model.modelName];
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
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (selected)
            [_bgImageView setHidden:NO];
        else
            [_bgImageView setHidden:YES];
    }
    else {
        if (selected) {
            [_bgImageView setHidden:YES];
            [_lblModel setTextColor:[UIColor colorWithRed:39.0f/255.0f green:132.0f/255.0f blue:195.0f/255.0f alpha:1.0f]];
        }
        else {
            [_bgImageView setHidden:NO];
            [_lblModel setTextColor:[UIColor whiteColor]];
        }
    }
}

@end
