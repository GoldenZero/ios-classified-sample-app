//
//  PlainAdCell.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AD_NO_IMAGE_CELL_HEIGHT     150

@interface PlainAdCell : UITableViewCell

#pragma mark - shared properties

@property (strong, nonatomic) IBOutlet UIImageView * backgoundImage;
@property (strong, nonatomic) IBOutlet SSLabel * detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel * priceLabel;
@property (strong, nonatomic) IBOutlet UILabel * timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) IBOutlet UILabel * roomsLabel;
@property (strong, nonatomic) IBOutlet UILabel * areaLabel;
@property (strong, nonatomic) IBOutlet UILabel * viewCountLabel;
@property (strong, nonatomic) IBOutlet UILabel * locationLabel;

@property (strong, nonatomic) IBOutlet UIButton * favoriteBtn;
@property (strong, nonatomic) IBOutlet UIButton * labelBtn;
//@property (strong, nonatomic) IBOutlet UIButton * helpButton;

@property (strong, nonatomic) IBOutlet UIImageView * roomsTinyImg;
@property (strong, nonatomic) IBOutlet UIImageView * areaTinyImg;
@property (strong, nonatomic) IBOutlet UIImageView * viewCountTinyImg;

@property (weak, nonatomic) IBOutlet UIImageView *separatorLine;

@end
