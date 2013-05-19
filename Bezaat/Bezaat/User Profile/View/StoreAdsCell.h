//
//  StoreAdsCell.h
//  Bezaat
//
//  Created by GALMarei on 4/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreAdsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HJManagedImageV *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carTitle;
@property (weak, nonatomic) IBOutlet UILabel *carPrice;
@property (weak, nonatomic) IBOutlet UILabel *adTime;
@property (weak, nonatomic) IBOutlet UILabel *carModel;
@property (weak, nonatomic) IBOutlet UILabel *carDistance;
@property (weak, nonatomic) IBOutlet UILabel *adViews;
@property (strong, nonatomic) IBOutlet UIView *bottomBarView;

@property (nonatomic, weak) IBOutlet UIButton *featureButton;
@property (nonatomic, weak) IBOutlet UIImageView *featureTagImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@property (nonatomic) BOOL isFeatured;

- (IBAction)featureBtnPress:(id)sender;

@end
