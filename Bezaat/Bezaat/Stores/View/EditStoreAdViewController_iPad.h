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


@interface EditStoreAdViewController_iPad : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate,CLLocationManagerDelegate,LocationManagerDelegate,StorePostAdDelegate,StoreManagerDelegate>

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

#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)addBtnprss:(id)sender;

- (void) dismissSelfAfterFeaturing;


@end
