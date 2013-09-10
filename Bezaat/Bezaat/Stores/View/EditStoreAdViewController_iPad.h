//
//  EditStoreAdViewController_iPad.h
//  Bezaat
//
//  Created by GALMarei on 5/14/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarAdsManager.h"
#import "CarDetails.h"
#import "GAI.h"
#import "StoreManager.h"
#import "FeatureStoreAdViewController.h"
#import "BrowseStoresViewController.h"
#import "FeaturingManager.h"
#import "Store.h"
#import "CarAdDetailsViewController.h"


@interface EditStoreAdViewController_iPad : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate,CLLocationManagerDelegate,LocationManagerDelegate,StorePostAdDelegate,StoreManagerDelegate, BrandManagerDelegate, UIPopoverControllerDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (strong, nonatomic) IBOutlet UIView *addImagesView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *bodyPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *storePickerView;

@property (strong, nonatomic) Model *currentModel;
@property (strong, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locationPickerView;
@property (strong, nonatomic) IBOutlet UIView *pickersView;

@property (strong, nonatomic) IBOutlet  UIButton *theStore;
@property (strong, nonatomic) IBOutlet  UITextField *carAdTitle;
@property (strong, nonatomic) IBOutlet  UITextField *mobileNum;
@property (strong, nonatomic) IBOutlet  UITextField *distance;
@property (strong, nonatomic) IBOutlet  UITextField *carPrice;
@property (strong, nonatomic) IBOutlet  UITextView *carDetails;
@property (strong, nonatomic) IBOutlet  UIButton *productionYear;
@property (strong, nonatomic) IBOutlet  UIButton *currency;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *kiloMile;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *condition;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *gear;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *type;
@property (strong, nonatomic) IBOutlet  UIButton *body;

@property (strong, nonatomic) IBOutlet  UIButton *countryCity;
@property (strong, nonatomic) Store* currentStore;

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

//gear type
@property (strong, nonatomic) IBOutlet  UIButton *iPad_normalGearTypeBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_automaticGearTypeBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_tiptronicGearTypeBtn;

//car type
@property (strong, nonatomic) IBOutlet  UIButton *iPad_frontWheelCarTypeBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_backWheelCarTypeBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_fourWheelCarTypeBtn;

//car condition
@property (strong, nonatomic) IBOutlet  UIButton *iPad_newCarConditionBtn;
@property (strong, nonatomic) IBOutlet  UIButton *iPad_usedCarConditionBtn;

@property (strong, nonatomic) UIPopoverController * iPad_cameraPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_countryPopOver;


#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction) iPad_closeBtnPrss:(id) sender;
- (IBAction)addBtnprss:(id)sender;
- (IBAction)uploadImage: (id)sender;

- (void) dismissSelfAfterFeaturing;

#pragma matk - iPad actions
- (IBAction) iPad_chooseBrandBtnPrss:(id) sender;
- (IBAction) iPad_setPhotosBtnPrss:(id) sender;
- (IBAction) iPad_setDetailsBtnPrss:(id) sender;

- (IBAction)iPad_deleteUploadedImage:(id)sender;
- (IBAction)iPad_kiloBtnPrss:(id)sender;
- (IBAction)iPad_mileBtnPrss:(id)sender;

- (IBAction)chooseStore:(id) sender;
- (IBAction)chooseProductionYear:(id)sender;
- (IBAction)chooseCurrency:(id)sender;
- (IBAction)chooseCountryCity:(id)sender;

- (IBAction)chooseBody:(id)sender;

//gear type
- (IBAction)iPad_normalGearTypeBtnPrss:(id) sender;
- (IBAction)iPad_automaticGearTypeBtnPrss:(id) sender;
- (IBAction)iPad_tiptronicGearTypeBtnPrss:(id) sender;

//car type
- (IBAction)iPad_frontWheelCarTypeBtnPrss:(id) sender;
- (IBAction)iPad_backWheelCarTypeBtnPrss:(id) sender;
- (IBAction)iPad_fourWheelCarTypeBtnPrss:(id) sender;

//car condition
- (IBAction)iPad_newCarConditionBtnPrss:(id) sender;
- (IBAction)iPad_usedCarConditionBtnPrss:(id) sender;

-(IBAction) ImageDelete:(id)sender;
- (void) iPad_userDidEndChoosingCountryFromPopOver;

@end
