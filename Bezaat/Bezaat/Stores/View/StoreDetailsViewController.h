//
//  StoreDetailsViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"
#import "StoreAdvTableViewCell.h"
#import "GAI.h"
#import "labelAdViewController.h"

@interface StoreDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,StoreManagerDelegate,FeatureingDelegate>

@property (nonatomic, strong) Store *currentStore;
@property (nonatomic) BOOL fromSubscribtion;

#pragma mark - iPad properties
@property (weak, nonatomic) IBOutlet UIButton *iPad_buyCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_browseGalleriesSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addStoreSegmentBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iPad_terminatedAdsImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iPad_nonTerminatedAdsImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iPad_specialAdsImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iPad_allAdsImgV;

@property (weak, nonatomic) IBOutlet UILabel *iPad_storeAdsCountLabel;


- (IBAction)backBtnPress:(id)sender;
- (IBAction)addNewAdvBtnPress:(id)sender;
- (IBAction)menueBtnPress:(id)sender;
- (void) updateAd:(NSInteger) theAdID WithFeaturedStatus:(BOOL) status;
- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState;
- (void) removeAdWithAdID:(NSUInteger) adID;

#pragma mark - iPad actions
- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender;

@end
