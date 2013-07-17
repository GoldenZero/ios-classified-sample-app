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
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "AURosetteView.h"
#import "AURosetteItem.h"
#import "CarDetailsManager.h"
#import "BrowseCarAdsViewController.h"
#import "CarsInGalleryViewController.h"
#import "StoreManager.h"
#import "GAI.h"
#import "FBPhotoBrowserViewController.h"
#import "SignInViewController.h"

@interface CarAdDetailsViewController : BaseViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, CarDetailsManagerDelegate, FavoritesDelegate,CarAdsManagerDelegate, StoreManagerDelegate,MFMessageComposeViewControllerDelegate, UITextViewDelegate, CommentsDelegate>

#pragma mark - properties
@property (strong, nonatomic) BrowseCarAdsViewController * parentVC;
@property (strong, nonatomic) CarsInGalleryViewController * secondParentVC;

//@property (strong, nonatomic) UIViewController * parentVC;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *labelsScrollView;
@property (strong, nonatomic) IBOutlet SSLabel *detailsLabel;
@property (strong, nonatomic) IBOutlet SSLabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearMiniLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yearMiniImg;
@property (strong, nonatomic) IBOutlet UILabel *watchingCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *kiloMiniLabel;
@property (strong, nonatomic) IBOutlet UIImageView *kiloMiniImg;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *featureBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editAdBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *topMostToolbar;
@property (strong, nonatomic) IBOutlet UIScrollView *distinguishingImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *countOfViewsTinyImg;
@property (weak, nonatomic) IBOutlet UIScrollView *detailsView;

@property (strong, nonatomic) IBOutlet UIView *callBarView;
@property (nonatomic) NSUInteger currentAdID;
@property (nonatomic) BOOL checkPage;
@property (strong, nonatomic) IBOutlet UIImageView *callBarImgBg;
@property (weak, nonatomic) IBOutlet UILabel *detailsTextLabel;

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

- (void) resetGalleryViewToNil;

@end