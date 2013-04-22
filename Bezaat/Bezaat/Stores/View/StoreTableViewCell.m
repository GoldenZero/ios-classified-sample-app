//
//  StoreTableViewCell.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreTableViewCell.h"

@interface StoreTableViewCell () {
    NSString *_logoURL;
}

@end

@implementation StoreTableViewCell

@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize LOGOImageView;
@synthesize defaultImage;

- (NSString *)logoURL {
    return _logoURL;
}

- (void)logoURL:(NSString *)url {
    _logoURL = url;
    if (_logoURL == nil) {
        LOGOImageView.image = self.defaultImage;
        [LOGOImageView setNeedsDisplay];
    }
    else {
        NSURL *imageURL = [NSURL URLWithString:_logoURL];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                LOGOImageView.image = [UIImage imageWithData:imageData];
                [LOGOImageView setNeedsDisplay];
            });
        });
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

@end
