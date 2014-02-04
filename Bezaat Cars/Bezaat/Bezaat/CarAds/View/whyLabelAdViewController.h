//
//  whyLabelAdViewController.h
//  Bezaat
//
//  Created by Noor Alssarraj on 4/23/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
@interface whyLabelAdViewController : UIViewController <UIScrollViewDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *toolBar;

#pragma mark - actions

- (IBAction)backBtnPrss:(id)sender;
- (IBAction)changePage:(id)sender;
@end
