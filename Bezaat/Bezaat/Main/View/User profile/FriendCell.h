//
//  FriendCell.h
//  Bezaat
//
//  Created by Syrisoft on 3/28/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIImageView *friendImage;
@property (strong, nonatomic) IBOutlet UILabel *friendNAmeLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendEmailLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectionButton;

@end
