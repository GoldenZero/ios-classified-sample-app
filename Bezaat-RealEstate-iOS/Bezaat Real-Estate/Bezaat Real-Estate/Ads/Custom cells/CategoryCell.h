//
//  CategoryCell.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/13/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell

#pragma mark - properties

@property (strong, nonatomic) IBOutlet UIImageView * catImageView;
@property (strong, nonatomic) IBOutlet SSLabel * catNameLabel;
@property (strong, nonatomic) IBOutlet UILabel * numberLabel;

@end
