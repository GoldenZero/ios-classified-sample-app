//
//  WhyFeatureStoreAdViewController.h
//  Bezaat
//
//  Created by GALMarei on 5/1/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhyFeatureStoreAdViewController : UIViewController<UIScrollViewDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

#pragma mark - actions

- (IBAction)backBtnPrss:(id)sender;
- (IBAction)changePage:(id)sender;

@end
