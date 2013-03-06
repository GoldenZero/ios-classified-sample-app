//
//  ModelBrandCell.h
//  TryBrandBubble
//
//  Created by Roula Misrabi on 3/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define BRAND_NAME_FONT         [UIFont systemFontOfSize:12.0]
#define BRAND_NAME_FONT_BOLD    [UIFont boldSystemFontOfSize:12.0]

@interface ModelBrandCell : UICollectionViewCell

#pragma mark - properties
@property (weak, nonatomic) UIButton * brandBtn;

@end
