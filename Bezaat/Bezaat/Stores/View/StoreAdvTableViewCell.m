//
//  StoreAdvTableViewCell.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/28/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreAdvTableViewCell.h"

@interface StoreAdvTableViewCell () {
    NSString *title;
    NSString *price;
    NSURL *imageURL;
    BOOL isFeatured;
}

@end

@implementation StoreAdvTableViewCell

@synthesize bgImageView;
@synthesize featureTagImageView;
@synthesize AdvImageView;
@synthesize titleLabel;
@synthesize priceLabel;
@synthesize featureButton;

- (NSURL *)imageURL {
    return imageURL;
}

- (void)setImageURL:(NSURL *)_imageURL {
    imageURL = _imageURL;
    if (imageURL == nil) {
        self.AdvImageView.image = nil;
        [self.AdvImageView setNeedsDisplay];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                self.AdvImageView.image = [UIImage imageWithData:imageData];
                [self.AdvImageView setNeedsDisplay];
            });
        });
    }
}

- (NSString *) title {
    return title;
}

- (void)setTitle:(NSString *)_title {
    title = _title;
    titleLabel.text = title;
}

- (NSString *) price {
    return price;
}

- (void) setPrice:(NSString *)_price {
    price = _price;
    priceLabel.text = price;
}

- (BOOL) isFeatured {
    return isFeatured;
}

- (void) setIsFeatured:(BOOL)_isFeatured {
    isFeatured = _isFeatured;
    if (isFeatured) {
        [featureButton setImage:[UIImage imageNamed:@"MyStore_special_help"] forState:UIControlStateNormal];
        bgImageView.image = [UIImage imageNamed:@"MyStore_special_bg"];
        featureTagImageView.hidden = NO;
    }
    else {
        [featureButton setImage:[UIImage imageNamed:@"MyStore_icon_dollar"] forState:UIControlStateNormal];
        bgImageView.image = [UIImage imageNamed:@"MyStore_box_bg"];
        featureTagImageView.hidden = YES;
    }
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

#pragma mark - Actions

- (IBAction)featureBtnPress:(id)sender {
    
}

@end
