//
//  CarAdWithStoreNoImageCell.h
//  Bezaat
//
//  Created by Syrisoft on 4/9/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarAdWithStoreNoImageCell : UITableViewCell

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIImageView *cellBackgoundImage;
@property (strong, nonatomic) IBOutlet UIImageView *distingushingImage;
@property (strong, nonatomic) IBOutlet UIImageView *storeImage;

@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *carPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UILabel *carMileageLabel;
@property (strong, nonatomic) IBOutlet UILabel *watchingCountsLabel;

@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *specailButton;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;

@property (strong, nonatomic) IBOutlet UIImageView *countOfViewsTinyImg;
@end
