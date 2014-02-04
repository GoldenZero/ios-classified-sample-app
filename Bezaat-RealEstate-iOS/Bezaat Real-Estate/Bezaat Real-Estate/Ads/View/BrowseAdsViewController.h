//
//  BrowseAdsViewController.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"

@interface BrowseAdsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BrowseAdsDelegate,FavoritesDelegate,DropDownViewDelegate,UITextFieldDelegate,TableInPopUpChoosingDelegate>


@property (nonatomic) BOOL browsingForSale;

#pragma mark - properties
@property (weak, nonatomic) IBOutlet UIView * contentView;

@property (weak, nonatomic) IBOutlet UITableView * tableView;

@property (weak, nonatomic) IBOutlet SSLabel * categoryTitleLabel;
@property (nonatomic) NSInteger currentSubCategoryID;
@property (nonatomic, strong) NSString* currentTitle;

//side menu
@property (weak, nonatomic) IBOutlet UIView * menuView;
@property (weak, nonatomic) IBOutlet SSLabel * searchTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField * searchTextField;
@property (weak, nonatomic) IBOutlet UITextField * minPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField * maxPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField * areaTextField;
@property (weak, nonatomic) IBOutlet UITextField * roomsCountTextField;
@property (strong, nonatomic) IBOutlet UIButton *roomsNumBtn;

@property (weak, nonatomic) IBOutlet UIButton * searchWithImagesBtn;
@property (weak, nonatomic) IBOutlet UIButton * searchWithPriceBtn;


@property (strong, nonatomic) IBOutlet UIView *adBannerView;
@property (strong, nonatomic) IBOutlet UIImageView *nocarImg;


- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState;
- (void) removeAdWithAdID:(NSUInteger) adID;

#pragma mark - actions

- (IBAction)homeBtnPressed:(id)sender;
- (IBAction)searchBtnPressed:(id)sender;
- (IBAction)chooseCategoryBtnPressed:(id)sender;
- (IBAction)doneBtnPrss:(id)sender;

//side menu
- (IBAction)searchWithImagesBtnPressed:(id)sender;
- (IBAction)searchWithPriceBtnPressed:(id)sender;
- (IBAction)performSearchBtnPressed:(id)sender;
- (IBAction)cancelSearchBtnPressed:(id)sender;
- (IBAction)roomsBtnPressed:(id)sender;


- (void) loadAllCarsBtnPressed:(id) sender;

@end
