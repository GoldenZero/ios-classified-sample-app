//
//  StoreExpiredTableViewCell.m
//  Bezaat
//
//  Created by GALMarei on 5/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreExpiredTableViewCell.h"
#import "FeatureStoreAdViewController.h"

@interface StoreExpiredTableViewCell () {
    UILabel *_nameLabel;
    UILabel *countryLabel;
    UILabel *adsCountLabel;
    UIImageView *LOGOImageView;
    
    NSString *name;
    NSString *country;
    NSString *adsCount;
    NSString *logoURL;
}
@end

@implementation StoreExpiredTableViewCell

@synthesize nameLabel;
@synthesize countryLabel;
@synthesize adsCountLabel;
@synthesize LOGOImageView;
@synthesize defaultImage;

- (NSString *)name {
    return name;
}

- (void)setName:(NSString *)_name {
    name = _name;
    self.nameLabel.text = name;
}

- (NSString *)country {
    return country;
}

- (void)setCountry:(NSString *)_country {
    country = _country;
    self.countryLabel.text = _country;
}

- (NSString *)adsCount {
    return adsCount;
}

- (void)setAdsCount:(NSString *)_adsCount {
    adsCount = _adsCount;
    self.adsCountLabel.text = _adsCount;
}

- (NSString *)logoURL {
    return logoURL;
}

- (void)setLogoURL:(NSString *)_logoURL {
    logoURL = _logoURL;
    if (_logoURL == nil) {
        self.LOGOImageView.image = self.defaultImage;
        [self.LOGOImageView setNeedsDisplay];
    }
    else {
        NSURL *imageURL = [NSURL URLWithString:_logoURL];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                self.LOGOImageView.image = [UIImage imageWithData:imageData];
                [self.LOGOImageView setNeedsDisplay];
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


- (IBAction)activateStoreBtnPress:(id)sender {
    
}
@end
