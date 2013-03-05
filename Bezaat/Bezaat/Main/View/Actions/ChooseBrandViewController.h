//
//  ChooseBrandViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to choose a car brand and sub brand before browsing cars.

#import <UIKit/UIKit.h>
#import "BrandCell.h"

@interface ChooseBrandViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

#pragma mark - properties
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark - actions

@end
