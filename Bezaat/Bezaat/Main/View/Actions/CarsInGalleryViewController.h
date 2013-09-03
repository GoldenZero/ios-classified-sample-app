//
//  CarsInGalleryViewController.h
//  Bezaat
//
//  Created by Syrisoft on 7/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "CarsGallery.h"
#import "gallariesManager.h"
#import "ProfileManager.h"

@interface CarsInGalleryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CarsInGalleryDelegate, FavoritesDelegate, UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UIImageView *galleryImage;
@property (strong, nonatomic) IBOutlet UILabel *galleryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *galleryPhoneLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CarsGallery* gallery;
@property (weak, nonatomic) IBOutlet UIImageView *noAdsImageView;
@property (weak, nonatomic) IBOutlet SSLabel *noAdsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

#pragma mark - iPad properties
@property (strong, nonatomic) IBOutlet UILabel *iPad_galleryDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *iPad_countOfAdsLabel;

@property (weak, nonatomic) IBOutlet UIButton *iPad_buyCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_browseGalleriesSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addStoreSegmentBtn;

#pragma mark - Actions
- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)phoneBtnPrss:(id)sender;

- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender;

- (void) updateFavStateForAdID:(NSUInteger) adID withState:(BOOL) favState;
- (void) removeAdWithAdID:(NSUInteger) adID;

@end
