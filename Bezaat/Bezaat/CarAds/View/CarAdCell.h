//
//  CarAdCell.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarAdCell : UITableViewCell

# pragma mark - properties

@property (strong, nonatomic) IBOutlet UIImageView *cellBackgoundImage;
@property (strong, nonatomic) IBOutlet UIImageView *carImage;
@property (strong, nonatomic) IBOutlet UIImageView *distingushingImage;
@property (strong, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *carPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *adTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UILabel *watchingCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *carMileageLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *specailButton;

# pragma mark - actions
@end
