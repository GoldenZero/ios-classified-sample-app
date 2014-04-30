//
//  EditCarAdViewController_iPad.h
//  Bezaat
//
//  Created by GALMarei on 5/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarAdsManager.h"
#import "CarDetails.h"
#import "GAI.h"
#import "TableInPopUpTableViewController.h"

@interface EditCarAdViewController_iPad : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate,CLLocationManagerDelegate,LocationManagerDelegate, BrandManagerDelegate, UIPopoverControllerDelegate, TableInPopUpChoosingDelegate>

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

@property (strong,nonatomic) NSArray* myAdArray;
@property (strong,nonatomic) NSArray* myImageIDArray;
@property (strong, nonatomic) CarDetails* myDetails;

#pragma mark - iPad properties
@property (strong, nonatomic) IBOutlet SSLabel *iPad_titleLabel;
@property (strong, nonatomic) IBOutlet SSLabel *iPad_uploadImagesTitleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *iPad_mainScrollView;

@property (strong, nonatomic) IBOutlet UIView *iPad_chooseBrandView;
@property (strong, nonatomic) IBOutlet UIScrollView *iPad_chooseBrandScrollView;
@property (strong, nonatomic) IBOutlet UIView *iPad_setPhotoView;
@property (strong, nonatomic) IBOutlet UIView *iPad_setDetailsView;

@property (strong, nonatomic) IBOutlet  UIButton *iPad_chooseBrandBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_setPhotosBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_setDetailsBtn;
@property (strong, nonatomic) IBOutlet  UIView *iPad_uploadPhotosView;

@property (strong, nonatomic) IBOutlet  UIButton *iPad_kiloBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_mileBtn;

@property (strong, nonatomic) UIPopoverController * iPad_cameraPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_countryPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_modelYearPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_currencyPopOver;

#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

- (IBAction) iPad_closeBtnPrss:(id) sender;
- (IBAction)addBtnprss:(id)sender;
- (IBAction)selectModelBtnPrss:(id)sender;
- (IBAction)uploadImage: (id)sender;

#pragma matk - iPad actions
- (IBAction) iPad_chooseBrandBtnPrss:(id) sender;
- (IBAction) iPad_setPhotosBtnPrss:(id) sender;
- (IBAction) iPad_setDetailsBtnPrss:(id) sender;

-(IBAction) ImageDelete:(id)sender;
- (IBAction)iPad_kiloBtnPrss:(id)sender;
- (IBAction)iPad_mileBtnPrss:(id)sender;

- (IBAction)chooseProductionYear:(id)sender;
- (IBAction)chooseCurrency:(id)sender;
- (IBAction)chooseCountryCity:(id)sender;
- (void) dismissSelfAfterFeaturing;
- (void) iPad_userDidEndChoosingCountryFromPopOver;
@end