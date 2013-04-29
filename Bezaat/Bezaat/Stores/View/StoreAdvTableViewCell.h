//
//  StoreAdvTableViewCell.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/28/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeatureingDelegate <NSObject>
@required
- (void)featureAdv:(NSInteger)advID;
- (void)unfeatureAdv:(NSInteger)advID;
@end

@class Store;

@interface StoreAdvTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *featureTagImageView;
@property (nonatomic, weak) IBOutlet UIImageView *AdvImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *featureButton;

@property (nonatomic) NSInteger advID;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic) BOOL isFeatured;

@property (nonatomic, weak) id<FeatureingDelegate>delegate;

- (IBAction)featureBtnPress:(id)sender;

@end
