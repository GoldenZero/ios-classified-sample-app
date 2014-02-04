//
//  CarAdDetailsViewController_iPad.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 14/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to show details of a car ad.

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <MapKit/MapKit.h>
#import "AdDetailsManager.h"
#import "BrowseAdsViewController.h"
#import "CarsInGalleryViewController.h"
#import "StoreDetailsViewController.h"
#import "StoreDetailsViewController_iPad.h"
#import "UserDetailsViewController.h"
#import "StoreManager.h"
#import "GAI.h"
#import "FBPhotoBrowserViewController.h"
#import "SignInViewController.h"
#import "SingleCommentView.h"
#import "ShareView.h"
//#import "AbuseViewController.h"
#import "ExternalBrowserVC.h"
#import "CommentsPopUpViewController.h"
#import "GADInterstitialDelegate.h"

@class BrowseAdsViewController_iPad;
@interface CarAdDetailsViewController_iPad : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, AdDetailsManagerDelegate, FavoritesDelegate,BrowseAdsDelegate, StoreManagerDelegate,MFMessageComposeViewControllerDelegate, UITextViewDelegate, CommentsDelegate, UITableViewDataSource, UITableViewDelegate,GADInterstitialDelegate,GADBannerViewDelegate,RequestEditStoreDelegate,RequestEditAdDelegate>

#pragma mark - properties
@property (strong, nonatomic) BrowseAdsViewController * parentVC;
@property (strong, nonatomic) BrowseAdsViewController_iPad * parentVC_iPad;
@property (strong, nonatomic) CarsInGalleryViewController * secondParentVC;
@property (strong, nonatomic) StoreDetailsViewController * storeParentVC;
@property (strong, nonatomic) StoreDetailsViewController_iPad * iPad_storeParentVC;
@property (strong, nonatomic) UserDetailsViewController * userDetailsParentVC;

//@property (strong, nonatomic) UIViewController * parentVC;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *labelsScrollView;
@property (strong, nonatomic) IBOutlet SSLabel *detailsLabel;
@property (strong, nonatomic) IBOutlet SSLabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearMiniLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yearMiniImg;
@property (strong, nonatomic) IBOutlet UILabel *watchingCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *kiloMiniLabel;
@property (strong, nonatomic) IBOutlet UIImageView *kiloMiniImg;
@property (strong, nonatomic) IBOutlet UILabel *periodLabel;
@property (strong, nonatomic) IBOutlet UIImageView *periodMiniImg;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *featureBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *editAdBtn;
@property (weak, nonatomic) IBOutlet UIView *topMostToolbar;
@property (strong, nonatomic) IBOutlet UIScrollView *distinguishingImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *countOfViewsTinyImg;
@property (weak, nonatomic) IBOutlet UIScrollView *detailsView;
@property (weak, nonatomic) IBOutlet UIView *iPad_detailsView;
@property (strong, nonatomic) IBOutlet UIButton *iPad_videoBtn;
@property (strong, nonatomic) IBOutlet UIButton *iPad_showComments;

@property (strong, nonatomic) IBOutlet UIView *callBarView;
@property (nonatomic) NSUInteger currentAdID;
@property (nonatomic) BOOL checkPage;
@property (strong, nonatomic) IBOutlet UIImageView *callBarImgBg;
@property (weak, nonatomic) IBOutlet UILabel *detailsTextLabel;
@property (strong, nonatomic) IBOutlet UIView *locationMapView;
@property (strong, nonatomic) IBOutlet UIView *iPad_firstTitleView;

// Store Bar content

@property (strong, nonatomic) IBOutlet UIView *storeView;
@property (strong, nonatomic) IBOutlet UIImageView *bgStoreView;
@property (strong, nonatomic) IBOutlet UIImageView *brandStoreImg;
@property (strong, nonatomic) IBOutlet SSLabel *nameStoreLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet SSLabel *viewInStoreLabel;
@property (strong, nonatomic) Store * currentStore;
@property (strong, nonatomic) UIViewController * parentStoreDetailsView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *commentsView;

#pragma mark - iPad properties
@property (weak, nonatomic) IBOutlet UIButton *iPad_buyCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_browseGalleriesSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addStoreSegmentBtn;
@property (weak, nonatomic) IBOutlet UIView *iPad_topLeftSideView;
@property (weak, nonatomic) IBOutlet UIView *iPad_bottomLeftSideView;

@property (weak, nonatomic) IBOutlet UIButton *iPad_featureBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_editAdBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_deleteAdBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iPad_isFeaturedTinyImg;
@property (weak, nonatomic) IBOutlet UIScrollView *iPad_commentsScrollView;
@property (strong, nonatomic) IBOutlet MKMapView *iPad_locationMap;

@property (strong, nonatomic) UIPopoverController * abusePopOver;
@property (strong, nonatomic) IBOutlet UIView *TempCommentTextView;
@property (strong, nonatomic) IBOutlet UITextView *TempTextView;

@property (strong, nonatomic) IBOutlet UIView *mpuBannerView;
#pragma mark - actions
- (IBAction)changePage:(id)sender;
- (IBAction)labelAdBtnPrss:(id)sender;
- (IBAction)editAdBtnPrss:(id)sender;
- (IBAction)modifyAdBtnPrss:(id)sender;
- (IBAction)backBtnPrss:(id)sender;
- (IBAction)sendMailBtnPrss:(id)sender;
- (IBAction)favoriteBtnPrss:(id)sender;
- (IBAction)callBtnPrss:(id)sender;
- (IBAction)smsBtnPrss:(id)sender;
- (IBAction)postCommentForCurrentAd:(id)sender;
- (IBAction)iPad_showCommentPressed:(id)sender;
- (IBAction)iPad_showVideoPressed:(id)sender;
- (IBAction)iPad_showInBrowserPressed:(id)sender;

//sharing actions
- (IBAction)twitterAction:(id)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)mailAction:(id)sender;


- (void) resetGalleryViewToNil;

@end