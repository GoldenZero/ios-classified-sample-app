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
    
    NSInteger postedSince;
    NSInteger modelYear;
    NSInteger distanceRange;
    NSInteger viewCount;
}

@end

@implementation StoreAdvTableViewCell

@synthesize bgImageView;
@synthesize featureTagImageView;
@synthesize AdvImageView;
@synthesize titleLabel;
@synthesize priceLabel;
@synthesize postedSinceLabel;
@synthesize modelYearLabel;
@synthesize distanceRangeLabel;
@synthesize viewCountLabel;
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (isFeatured) {
            //[featureButton setImage:[UIImage imageNamed:@"MyStore_special_help"] forState:UIControlStateNormal];
            [featureButton setImage:[UIImage imageNamed:@"scarified_dollar"] forState:UIControlStateNormal];
            CGRect frame = featureButton.frame;
            frame.origin.y = 84;
            featureButton.frame = frame;
            bgImageView.image = [UIImage imageNamed:@"MyStore_special_bg"];
            featureTagImageView.hidden = NO;
            self.bottomBarView.frame = CGRectMake(self.bottomBarView.frame.origin.x, self.bottomBarView.frame.origin.y - 3, self.bottomBarView.frame.size.width, self.bottomBarView.frame.size.height);
        }
        else {
            [featureButton setImage:[UIImage imageNamed:@"MyStore_icon_dollar"] forState:UIControlStateNormal];
            CGRect frame = featureButton.frame;
            frame.origin.y = 88;
            featureButton.frame = frame;
            bgImageView.image = [UIImage imageNamed:@"MyStore_box_bg"];
            featureTagImageView.hidden = YES;
        }
    }
    else {
        if (isFeatured) {
            //[featureButton setImage:[UIImage imageNamed:@"MyStore_special_help"] forState:UIControlStateNormal];
            [featureButton setImage:[UIImage imageNamed:@"ads_view_not_for_sale_pink_bg"] forState:UIControlStateNormal];
            bgImageView.image = [UIImage imageNamed:@"tb_ads_view_orange_box"];
            
        }
        else {
            [featureButton setImage:[UIImage imageNamed:@"ads_view_sale_white_bg"] forState:UIControlStateNormal];
            
            bgImageView.image = [UIImage imageNamed:@"tb_ads_view_box.png"];
            
        }
    }
}

- (NSInteger)postedSince {
    return postedSince;
}

- (void)setPostedSince:(NSInteger)since {
    postedSince = since;
    NSString *unit = @"ساعة";
    if ( (postedSince <= 10) && (postedSince >= 3) ) {
        unit = @"ساعات";
    }
    if (postedSince > 23) {
        unit = @"يوم";
        postedSince = postedSince/24;
    }
    postedSinceLabel.text = [NSString stringWithFormat:@"قبل %d %@", postedSince, unit];
    [postedSinceLabel setNeedsDisplay];
}

- (NSInteger)modelYear {
    return modelYear;
}

- (void)setModelYear:(NSInteger)year {
    modelYear = year;
    modelYearLabel.text = [NSString stringWithFormat:@"%d", modelYear];
    [modelYearLabel setNeedsDisplay];
}

- (NSInteger)distanceRange {
    return distanceRange;
}

- (void)setDistanceRange:(NSInteger)distance {
    distanceRange = distance;
    distanceRangeLabel.text = [NSString stringWithFormat:@"%d KM", distanceRange];
    [distanceRangeLabel setNeedsDisplay];
}

- (NSInteger)viewCount {
    return viewCount;
}

- (void)setViewCount:(NSInteger)count {
    viewCount = count;
    viewCountLabel.text = [NSString stringWithFormat:@"%d", viewCount];
    [viewCountLabel setNeedsDisplay];
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
    if (self.delegate) {
        if (isFeatured) {
            [self.delegate unfeatureAdv:self.advID];
        }
        else {
            [self.delegate featureAdv:self.advID];
        }
    }
}

@end
