//
//  AddNewStoreAdViewController.h
//  Bezaat
//
//  Created by GALMarei on 4/29/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"
#import "CarAdsManager.h"
#import "FeatureStoreAdViewController.h"

@interface AddNewStoreAdViewController : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, StoreManagerDelegate,LocationManagerDelegate,StorePostAdDelegate>
{
    
}

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

#pragma mark - actions
- (IBAction)doneBtnPrss:(id)sender;

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)addBtnprss:(id)sender;
- (IBAction)selectModelBtnPrss:(id)sender;

@end
