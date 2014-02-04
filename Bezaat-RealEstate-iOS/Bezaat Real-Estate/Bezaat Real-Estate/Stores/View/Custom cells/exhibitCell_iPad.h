//
//  exhibitCell_iPad.h
//  Bezaat
//
//  Created by Roula Misrabi on 8/28/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exhibitCell_iPad : UICollectionViewCell

#pragma mark- Properties
@property (strong, nonatomic) IBOutlet UIImageView *exhibImage;
@property (strong, nonatomic) IBOutlet UILabel *exhibNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *exhibDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIButton *numberButton;

@end
