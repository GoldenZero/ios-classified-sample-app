//
//  StoreAdvTableViewCell.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/28/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Store;

@interface StoreAdvTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *featureTagImageView;
@property (nonatomic, weak) IBOutlet UIImageView *AdvImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *postedSinceLabel;
@property (nonatomic, weak) IBOutlet UILabel *modelYearLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceRangeLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *featureButton;

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic) NSInteger postedSince;
@property (nonatomic) NSInteger modelYear;
@property (nonatomic) NSInteger distanceRange;
@property (nonatomic) NSInteger viewCount;
@property (nonatomic) BOOL isFeatured;

- (IBAction)featureBtnPress:(id)sender;

@end
