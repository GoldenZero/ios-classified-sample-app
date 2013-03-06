//
//  ChooseBrandViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to choose a car brand and sub brand before browsing cars.

#import <UIKit/UIKit.h>
#import "ModelCell.h"
#import "UIViewController+MJPopupViewController.h"
#import "MJDetailViewController.h"
#import "MJSecondDetailViewController.h"
#import "BrowseCarAdsViewController.h"
#import "CarModelLoader.h"

@interface ChooseBrandViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, MJSecondPopupDelegate>

#pragma mark - properties
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIBarButtonItem * okBtn;

#pragma mark - actions


@end
