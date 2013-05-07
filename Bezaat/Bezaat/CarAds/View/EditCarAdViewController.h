//
//  EditCarAdViewController.h
//  Bezaat
//
//  Created by GALMarei on 5/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarAdsManager.h"

@interface EditCarAdViewController : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate,CLLocationManagerDelegate,LocationManagerDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (strong, nonatomic) IBOutlet UIView *addImagesView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) Model *currentModel;
@property (strong, nonatomic) IBOutlet UIPickerView *locationPickerView;
@property (strong, nonatomic) IBOutlet UIView *pickersView;

@property (strong, nonatomic) IBOutlet  UITextField *carAdTitle;
@property (strong, nonatomic) IBOutlet  UITextField *mobileNum;
@property (strong, nonatomic) IBOutlet  UITextField *distance;
@property (strong, nonatomic) IBOutlet  UITextField *carPrice;
@property (strong, nonatomic) IBOutlet  UITextView *carDetails;
@property (strong, nonatomic) IBOutlet  UIButton *productionYear;
@property (strong, nonatomic) IBOutlet  UIButton *currency;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *kiloMile;
@property (strong, nonatomic) IBOutlet  UIButton *countryCity;

#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)addBtnprss:(id)sender;

- (void) dismissSelfAfterFeaturing;

@end
