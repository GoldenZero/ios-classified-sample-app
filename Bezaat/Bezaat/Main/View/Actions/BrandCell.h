//
//  BrandCell.h
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Brand;

@interface BrandCell : UITableViewCell {
    Brand* currentBrand;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgBrand;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;
@property (weak, nonatomic) IBOutlet UIImageView *imgUnselected;

- (void)reloadInformation:(Brand*)brand;

- (void)selectCell;
- (void)unselectCell;

@end
