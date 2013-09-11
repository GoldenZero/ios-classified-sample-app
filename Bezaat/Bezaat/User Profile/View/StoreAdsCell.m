//
//  StoreAdsCell.m
//  Bezaat
//
//  Created by GALMarei on 4/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreAdsCell.h"
@interface StoreAdsCell () {
    BOOL isFeatured;
 
}
@end

@implementation StoreAdsCell
@synthesize featureButton,featureTagImageView,bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL) isFeatured {
    return isFeatured;
}

- (void) setIsFeatured:(BOOL)_isFeatured {
    isFeatured = _isFeatured;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (isFeatured) {
            //[featureButton setImage:[UIImage imageNamed:@"MyStore_special_help"] forState:UIControlStateNormal];
            //[featureButton setImage:[UIImage imageNamed:@"scarified_dollar"] forState:UIControlStateNormal];
            [featureButton setHidden:YES];
            CGRect frame = featureButton.frame;
            frame.origin.y = 84;
            featureButton.frame = frame;
            bgImageView.image = [UIImage imageNamed:@"MyStore_special_bg"];
            featureTagImageView.hidden = NO;
            self.bottomBarView.frame = CGRectMake(self.bottomBarView.frame.origin.x, self.bottomBarView.frame.origin.y - 3, self.bottomBarView.frame.size.width, self.bottomBarView.frame.size.height);
            [self.bottomBarView setBackgroundColor:[UIColor colorWithRed:247.0/255 green:214.0/255 blue:185.0/255 alpha:1.0f]];
        }
        else {
            [featureButton setImage:[UIImage imageNamed:@"MyAds_icon_dollar"] forState:UIControlStateNormal];
            //CGRect frame = featureButton.frame;
            //frame.origin.y = 88;
            //featureButton.frame = frame;
            bgImageView.image = [UIImage imageNamed:@"MyStore_box_bg"];
            featureTagImageView.hidden = YES;
            [self.bottomBarView setBackgroundColor:[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0f]];
        }
    }
    else {
        if (isFeatured) {
            [featureButton setHidden:YES];
            CGRect frame = featureButton.frame;
            frame.origin.y = 84;
            featureButton.frame = frame;
            bgImageView.image = [UIImage imageNamed:@"tb_ads_view_orange_box"];
            
        }
        else {
            [featureButton setImage:[UIImage imageNamed:@"ads_view_sale_white_bg.png"] forState:UIControlStateNormal];
            bgImageView.image = [UIImage imageNamed:@"tb_ads_view_box.png"];
        }
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)featureBtnPress:(id)sender
{
    
}

@end
