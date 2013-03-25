//
//  BrandCell.h
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Brand;

@interface BrandCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgBrand;

- (void) reloadInformation:(Brand*)brand;

@end
