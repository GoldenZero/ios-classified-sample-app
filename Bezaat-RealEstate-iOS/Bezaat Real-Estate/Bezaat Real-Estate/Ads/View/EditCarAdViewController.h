//
//  EditCarAdViewController.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdsManager.h"
#import "FeaturingManager.h"
#import "GAI.h"
#import "XCDFormInputAccessoryView.h"
#import "MapLocationViewController.h"


@interface EditCarAdViewController : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate,CLLocationManagerDelegate,LocationManagerDelegate,MapsDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (strong, nonatomic) IBOutlet UIView *addImagesView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic) NSInteger currentSubCategoryID;
@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locationPickerView;
@property (strong, nonatomic) IBOutlet UIView *pickersView;

@property (strong, nonatomic) IBOutlet  UITextField *AdTitle;
@property (strong, nonatomic) IBOutlet  UILabel *adDetailLabel;
@property (strong, nonatomic) IBOutlet  UITextField *mobileNum;
@property (strong, nonatomic) IBOutlet  UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet  UITextField *unitPrice;
@property (strong, nonatomic) IBOutlet  UITextField *propertyPrice;
@property (strong, nonatomic) IBOutlet  UITextView *propertyDetails;
@property (strong, nonatomic) IBOutlet  UITextField *propertySpace;
@property (strong, nonatomic) IBOutlet  UITextField *propertyArea;
@property (strong, nonatomic) IBOutlet  UIButton *adPeriod;
@property (strong, nonatomic) IBOutlet  UIButton *currency;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *serviceReq;
@property (strong, nonatomic) IBOutlet  UIButton *countryCity;
@property (strong, nonatomic) IBOutlet  UIButton *roomsNum;
@property (strong, nonatomic) IBOutlet  UIButton *mapLocation;
@property (strong, nonatomic) IBOutlet  UIButton *units;

@property (strong, nonatomic) UITextField *emailAddress;
@property (nonatomic) BOOL browsingForSale;

@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;

@property (strong,nonatomic) NSArray* myAdArray;
@property (strong,nonatomic) NSArray* myImageIDArray;
@property (strong, nonatomic) AdDetails* myDetails;

#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)addBtnprss:(id)sender;

- (void) dismissSelfAfterFeaturing;

@end
