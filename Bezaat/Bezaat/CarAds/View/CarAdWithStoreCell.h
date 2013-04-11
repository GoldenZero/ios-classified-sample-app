//
//  CarAdWithStoreCell.h
//  Bezaat
//
//  Created by Syrisoft on 4/9/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarAdWithStoreCell : UITableViewCell

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet HJManagedImageV *carImage;
@property (strong, nonatomic) IBOutlet UIImageView *distinguishImage;
@property (strong, nonatomic) IBOutlet UIImageView *storeImage;

@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsCarAd;
@property (strong, nonatomic) IBOutlet UILabel *carPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UILabel *kilometrageLabel;

@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *distingusishButton;
@end
