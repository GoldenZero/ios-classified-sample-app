//
//  AddNewStoreAdViewController.h
//  Bezaat
//
//  Created by GALMarei on 4/29/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"
#import "AdsManager.h"
#import "BrowseStoresViewController.h"
#import "FeaturingManager.h"
#import "Store.h"
#import "CarAdDetailsViewController.h"
#import "GAI.h"
#import "XCDFormInputAccessoryView.h"
#import "MapLocationViewController.h"


@interface AddNewStoreAdViewController : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate,CLLocationManagerDelegate,LocationManagerDelegate,MapsDelegate,StoreManagerDelegate,StorePostAdDelegate>
{
    
}

#pragma mark - properties
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
@property (weak, nonatomic) IBOutlet UIPickerView *storePickerView;

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
@property (strong, nonatomic) IBOutlet  UIButton *theStore;

@property (strong, nonatomic) Store* currentStore;
@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;
@property (strong, nonatomic) UIViewController * parentStoreDetailsView;

@property (nonatomic) BOOL browsingForSale;

#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)addBtnprss:(id)sender;
- (IBAction)selectModelBtnPrss:(id)sender;

@end
