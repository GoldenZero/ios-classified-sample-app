//
//  FeatureAdCell.h
//  Bezaat
//
//  Created by GALMarei on 4/30/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeatureAdCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *periodLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itunesImg;
@property (strong, nonatomic) IBOutlet UIImageView *bankImg;
@property (strong, nonatomic) IBOutlet UIImageView *bkgImg;

@end
