//
//  BrowseAdsViewController_iPad.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "CarAdCell_iPad.h"
#import "CarAdWithStoreCell_iPad.h"
#import "DropDownView.h"
#import "GAI.h"
#import "AdsManager.h"
#import "ChooseCategoryViewController.h"
#import "TableInPopUpTableViewController.h"
#import "CategoriesPopOver_iPad.h"
//#import "AdsCell.h"

@interface BrowseAdsViewController_iPad : UIViewController<UITableViewDataSource, UITableViewDelegate, BrowseAdsDelegate, FavoritesDelegate,UITextFieldDelegate,DropDownViewDelegate, TableInPopUpChoosingDelegate,TableInPopUpChoosingYearFromDelegate,TableInPopUpChoosingYearToDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,categoryChoosingDelegate,GADBannerViewDelegate,TableInPopUpChoosingCurrencyDelegate>


@property (nonatomic) NSInteger currentSubCategoryID;
@property (nonatomic) BOOL browsingForSale;
@property (nonatomic) BOOL offeredSegmentBtnChosen;

@property (nonatomic, strong) NSString* currentTitle;

#pragma mark - properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (strong, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutlet UIButton *adWithImageButton;
@property (strong, nonatomic) IBOutlet UIButton *adWithPriceButton;

@property (strong, nonatomic) IBOutlet UIView *searchPanelView;
@property (strong, nonatomic) IBOutlet UITextField *carNameText;
@property (strong, nonatomic) IBOutlet UITextField *lowerPriceText;
@property (strong, nonatomic) IBOutlet UITextField *higherPriceText;
@property (strong, nonatomic) IBOutlet UIImageView *searchImageButton;
@property (strong, nonatomic) IBOutlet UITextField *areaTextField;

@property (weak, nonatomic) IBOutlet UIView *yearView;
@property (strong, nonatomic) IBOutlet UIButton *distanceButton;
@property (strong, nonatomic) IBOutlet UIButton *fromYearButton;
@property (strong, nonatomic) IBOutlet UIButton *toYearButton;
@property (strong, nonatomic) IBOutlet UILabel *distanceRangeLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromYearLabel;
@property (strong, nonatomic) IBOutlet UILabel *toYearLabel;

@property (strong, nonatomic) IBOutlet UIView *forTapping;
@property (strong, nonatomic) IBOutlet UIImageView *nocarImg;

@property (strong, nonatomic) IBOutlet UIImageView *viewBgImg;
//@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet UIView *tableContainer;
@property (weak, nonatomic) IBOutlet UIView *coach_view;

@property (assign) CGPoint lastScrollPosition;

#pragma mark - iPad properties
@property (weak, nonatomic) IBOutlet UIButton *iPad_searchSideMenuBtn;
@property (weak, nonatomic) IBOutlet UIView *iPad_searchSideMenuView;
@property (weak, nonatomic) IBOutlet UIView *iPad_contentView;
@property (weak, nonatomic) IBOutlet SSLabel * iPad_startSearchTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iPad_chooseBrandBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_chooseDistanceRangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_chooseCurrencyBtn;

@property (weak, nonatomic) IBOutlet SSLabel *iPad_modelYearTitleLabel;
@property (weak, nonatomic) IBOutlet SSLabel *iPad_priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPad_minYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPad_maxYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPad_distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *iPad_CategoryLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *iPad_collectionView;

@property (weak, nonatomic) IBOutlet UIButton *iPad_buyCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_browseGalleriesSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addStoreSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_searchPanelBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_chooseYearFromBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_chooseYearToBtn;

@property (strong, nonatomic) IBOutlet UIView *adBannerView;

@property (strong, nonatomic) UIPopoverController * brandsPopOver;
@property (strong, nonatomic) UIPopoverController * distanceRangePopOver;
@property (strong, nonatomic) UIPopoverController * yearFromRangePopOver;
@property (strong, nonatomic) UIPopoverController * yearToRangePopOver;
@property (strong, nonatomic) UIPopoverController * currencyRangePopOver;


#pragma mark - actions
- (IBAction)homeBtnPress:(id)sender;
- (IBAction)searchBtnPress:(id)sender;
- (IBAction)modelBtnPress:(id)sender;
- (IBAction)searchInPanelBtnPrss:(id)sender;
- (IBAction)clearInPanelBtnPrss:(id)sender;
- (IBAction)adWithImageBtnPrss:(id)sender;
- (IBAction)adWithPriceBtnPress:(id)sender;
- (IBAction)distanceBtnPrss:(id)sender;
- (IBAction)fromYearBtnPrss:(id)sender;
- (IBAction)toYearBtnPrss:(id)sender;


#pragma mark - iPad actions
- (IBAction)iPad_searchSideMenuBtn:(id)sender;
- (IBAction)iPad_chooseBrandBtnPressed:(id)sender;
- (IBAction)iPad_chooseDistanceRangeBtnPressed:(id)sender;
- (IBAction)iPad_chooseCurrencyBtnPressed:(id)sender;
- (IBAction)iPad_modelYearSliderValueChanged:(id)sender;
- (IBAction)iPad_chooseYearFromBtnPressed:(id)sender;
- (IBAction)iPad_chooseYearToBtnPressed:(id)sender;

- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender;
- (IBAction)iPad_refreshBtnPressed:(id)sender;

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState;
- (void) removeAdWithAdID:(NSUInteger) adID;


- (void) dismissBrandsPopOver:(id) sender;
- (void) loadAllCarsBtnPressed:(id) sender;
@end
