//
//  exhibitCell.h
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exhibitCell : UITableViewCell

#pragma mark- Properties
@property (strong, nonatomic) IBOutlet UIImageView *exhibImage;
@property (strong, nonatomic) IBOutlet UILabel *exhibNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *exhibDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIButton *numberButton;

@end
