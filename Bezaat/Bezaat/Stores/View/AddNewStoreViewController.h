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

@interface AddNewStoreViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate,LocationManagerDelegate,StoreManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryCity;
@property (strong, nonatomic) UITextField* userPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIImageView *whatIsStoreImg;
@property (strong, nonatomic) IBOutlet UIButton *whatIsStoreBtn;

- (IBAction)homeBtnPress:(id)sender;
- (IBAction)chooseImageBtnPress:(id)sender;
- (IBAction)chooseCountry:(id)sender;
- (IBAction)cancelBtnPress:(id)sender;
- (IBAction)doneBtnPrss:(id)sender;
- (IBAction)saveBtnPress:(id)sender;
- (IBAction)whatIsStoreBtnPrss:(id)sender;

@end
