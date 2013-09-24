//
//  AddNewStoreViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"
#import "GAI.h"
#import "XCDFormInputAccessoryView.h"

@interface AddNewStoreViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate,LocationManagerDelegate,StoreManagerDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryCity;
@property (strong, nonatomic) UITextField* userPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIImageView *whatIsStoreImg;
@property (strong, nonatomic) IBOutlet UIButton *whatIsStoreBtn;
@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;


@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *placeholderTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPickerView;
@property (weak, nonatomic) IBOutlet UIView *pickersView;


@property (strong, nonatomic) UIPopoverController * iPad_countryPopOver;

@property (weak, nonatomic) IBOutlet UIButton *iPad_chooseImageBtn;


@property (weak, nonatomic) IBOutlet UIButton *iPad_buyCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addCarSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_browseGalleriesSegmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *iPad_addStoreSegmentBtn;


- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender;
- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender;
- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender;



- (IBAction)homeBtnPress:(id)sender;
- (IBAction)chooseImageBtnPress:(id)sender;
- (IBAction)chooseCountry:(id)sender;
- (IBAction)cancelBtnPress:(id)sender;
- (IBAction)doneBtnPrss:(id)sender;
- (IBAction)saveBtnPress:(id)sender;
- (IBAction)whatIsStoreBtnPrss:(id)sender;


@property (strong, nonatomic) UIPopoverController * countryPopOver;
@property (strong, nonatomic) UIPopoverController * iPad_cameraPopOver;
- (void) iPad_userDidEndChoosingCountryFromPopOver;


@end
