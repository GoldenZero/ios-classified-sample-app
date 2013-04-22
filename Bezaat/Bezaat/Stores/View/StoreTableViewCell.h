//
//  StoreTableViewCell.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *LOGOImageView;

@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) UIImage *defaultImage;

@end
