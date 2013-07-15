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

@interface CarsInGalleryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CarsInGalleryDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UIImageView *galleryImage;
@property (strong, nonatomic) IBOutlet UILabel *galleryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *galleryPhoneLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CarsGallery* gallery;

#pragma mark - Actions
- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)phoneBtnPrss:(id)sender;

@end
