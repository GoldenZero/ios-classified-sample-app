//
//  MJSecondDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelBrandCell.h"
#import "RFQuiltLayout.h"

@protocol MJSecondPopupDelegate;


@interface MJSecondDetailViewController : UIViewController <RFQuiltLayoutDelegate>

@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray * sourceArray;
@end



@protocol MJSecondPopupDelegate<NSObject>
@optional
//- (void)didSelectsubBrandOfNumber:(int) subBrandNumber;
- (void)cancelButtonClicked:(MJSecondDetailViewController*)secondDetailViewController;
@end