//
//  StoreExpiredTableViewCell.h
//  Bezaat
//
//  Created by GALMarei on 5/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreExpiredTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *countryLabel;
@property (nonatomic, strong) IBOutlet UILabel *adsCountLabel;
@property (nonatomic, strong) IBOutlet UIImageView *LOGOImageView;
@property (strong, nonatomic) IBOutlet UILabel *remainingFeaturesLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainingDaysLabel;
@property (nonatomic) int myTag;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *adsCount;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) UIImage *defaultImage;
- (IBAction)activateStoreBtnPress:(id)sender;


@end
