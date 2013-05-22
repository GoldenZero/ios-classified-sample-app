//
//  FBPhotoBrowserViewController.h
//  TryFBBrowser
//
//  Created by Roula Misrabi on 5/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FBPhotoBrowserViewController : UIViewController <UIScrollViewDelegate>

#pragma mark - properties

@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIView *activityView;

#pragma mark - actions
- (IBAction)doneBtnPressed:(id)sender;

#pragma mark - methods

//photos array should contain an array of URLs
//- (void) customizeScrollForPhotos:(NSArray *) photos firstImageID:(NSInteger) index;
- (void) setPhotosArray:(NSArray *) photos firstImageID:(NSInteger) index;
@end
