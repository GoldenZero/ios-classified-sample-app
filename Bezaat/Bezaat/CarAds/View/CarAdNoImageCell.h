//
//  CarAdNoImageCell.h
//  Bezaat
//
//  Created by Syrisoft on 4/9/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarAdNoImageCell : UITableViewCell

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLAbel;
@property (strong, nonatomic) IBOutlet UILabel *watchingCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *kilometrageLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *distiguishButton;
@property (strong, nonatomic) IBOutlet UIImageView *distinguishImage;

@end
