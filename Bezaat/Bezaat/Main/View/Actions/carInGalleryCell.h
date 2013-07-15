//
//  carInGalleryCell.h
//  Bezaat
//
//  Created by Syrisoft on 7/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface carInGalleryCell : UITableViewCell

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIImageView *cellBackgoundImage;
@property (strong, nonatomic) IBOutlet SSLabel *detailsLabel;
@property (strong, nonatomic) IBOutlet SSLabel *carPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UILabel *watchingCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *carMileageLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIImageView *distingushingImage;

@property (strong, nonatomic) IBOutlet UIImageView *yearTinyImg;
@property (strong, nonatomic) IBOutlet UIImageView *carMileageTinyImg;
@property (strong, nonatomic) IBOutlet UIImageView *countOfViewsTinyImg;

@property (strong, nonatomic) IBOutlet UIImageView *carImage;

@end
