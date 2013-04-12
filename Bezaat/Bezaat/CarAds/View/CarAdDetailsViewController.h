//
//  CarAdDetailsViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 14/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to show details of a car ad.

#import <UIKit/UIKit.h>
#import "AURosetteView.h"
#import "AURosetteItem.h"
#import "CarDetailsManager.h"

@interface CarAdDetailsViewController : UIViewController<UIScrollViewDelegate, CarDetailsManagerDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *labelsScrollView;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearMiniLabel;
@property (strong, nonatomic) IBOutlet UILabel *watchingCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *kiloMiniLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *featureBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *topMostToolbar;

@property (nonatomic) NSUInteger currentAdID;


#pragma mark - actions
- (IBAction)changePage:(id)sender;
- (IBAction)labelAdBtnPrss:(id)sender;
- (IBAction)editAdBtnPrss:(id)sender;
- (IBAction)backBtnPrss:(id)sender;
- (IBAction)sendMailBtnPrss:(id)sender;
- (IBAction)favoriteBtnPrss:(id)sender;
- (IBAction)callBtnPrss:(id)sender;

@end
