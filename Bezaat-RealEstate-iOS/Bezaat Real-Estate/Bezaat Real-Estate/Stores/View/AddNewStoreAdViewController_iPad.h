//
//  AddNewStoreAdViewController_iPad.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 12/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"
#import "AdsManager.h"
#import "BrowseStoresViewController.h"
#import "FeaturingManager.h"
#import "Store.h"
#import "GAI.h"
#import "XCDFormInputAccessoryView.h"
#import "TableInPopUpTableViewController.h"
#import "CarAdDetailsViewController_iPad.h"

@interface AddNewStoreAdViewController_iPad : BaseViewController <UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate,CLLocationManagerDelegate,LocationManagerDelegate,PricingOptionsDelegate, UIPopoverControllerDelegate, TableInPopUpChoosingDelegate,MapsDelegate,StoreManagerDelegate,StorePostAdDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *verticalScrollView;
@property (nonatomic) NSInteger currentSubCategoryID;

@property (strong, nonatomic) IBOutlet UIView *addImagesView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

//@property (strong, nonatomic) Model *currentModel;
@property (strong, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (strong, nonatomic) IBOutlet UIView *pickersView;
@property (weak, nonatomic) IBOutlet UIPickerView *storePickerView;

@property (strong, nonatomic) IBOutlet  UITextField *carAdTitle;
@property (strong, nonatomic) IBOutlet  UILabel *carDetailLabel;
@property (strong, nonatomic) IBOutlet  UITextField *mobileNum;
@property (strong, nonatomic) IBOutlet  UITextField *propertySpace;
@property (strong, nonatomic) IBOutlet  UITextField *carPrice;
@property (strong, nonatomic) IBOutlet  UITextView *carDetails;
@property (strong, nonatomic) IBOutlet  UIButton *roomNum;
@property (strong, nonatomic) IBOutlet  UIButton *currency;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *kiloMile;
@property (strong, nonatomic) IBOutlet  UIButton *countryCity;
@property (strong, nonatomic) IBOutlet UIButton *mapLocation;
@property (strong, nonatomic) IBOutlet UITextField *propertyArea;
@property (strong, nonatomic) IBOutlet UIButton *adPeriod;
@property (strong, nonatomic) IBOutlet UITextField *unitPrice;
@property (strong, nonatomic) IBOutlet  UIButton *theStore;

@property (strong, nonatomic) IBOutlet UIButton *units;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) UITextField *emailAddress;

@property (strong, nonatomic) Store* currentStore;
@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;
@property (strong, nonatomic) UIViewController * parentStoreDetailsView;

#pragma mark - iPad properties
@property (strong, nonatomic) IBOutlet SSLabel *iPad_titleLabel;
@property (strong, nonatomic) IBOutlet SSLabel *iPad_uploadImagesTitleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *iPad_mainScrollView;

@property (strong, nonatomic) IBOutlet UIView *iPad_chooseBrandView;
@property (strong, nonatomic) IBOutlet UIScrollView *iPad_chooseBrandScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *iPad_chooseCategoryScrollView;

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
@property (strong, nonatomic) UIPopoverController * iPad_roomsPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_currencyPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_periodPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_unitsPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_storePopOver;


@property (strong, nonatomic) IBOutlet UIButton *iPad_requireBtn1;
@property (strong, nonatomic) IBOutlet UIButton *iPad_requireBtn2;
@property (strong, nonatomic) IBOutlet UIButton *iPad_requireBtn3;

@property (nonatomic) BOOL browsingForSale;


#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

//- (IBAction)homeBtnPrss:(id)sender;
- (IBAction) iPad_closeBtnPrss:(id) sender;
- (IBAction)addBtnprss:(id)sender;
- (IBAction)selectModelBtnPrss:(id)sender;
- (IBAction)uploadImage: (id)sender;

#pragma matk - iPad actions
- (IBAction) iPad_chooseBrandBtnPrss:(id) sender;
- (IBAction) iPad_setPhotosBtnPrss:(id) sender;
- (IBAction) iPad_setDetailsBtnPrss:(id) sender;

- (IBAction)iPad_deleteUploadedImage:(id)sender;
- (IBAction)iPad_kiloBtnPrss:(id)sender;
- (IBAction)iPad_mileBtnPrss:(id)sender;

- (IBAction)chooseStore:(id) sender;
- (IBAction)chooseRoomsNum:(id)sender;
- (IBAction)chooseCurrency:(id)sender;
- (IBAction)chooseCountryCity:(id)sender;
- (void) dismissSelfAfterFeaturing;
- (IBAction)chooseMapLocation:(id)sender;
- (IBAction)choosePeriod:(id)sender;
- (IBAction)chooseUnits:(id)sender;
- (IBAction)iPad_chooseRequiredService:(id)sender;

- (void) iPad_userDidEndChoosingCountryFromPopOver;


@end
