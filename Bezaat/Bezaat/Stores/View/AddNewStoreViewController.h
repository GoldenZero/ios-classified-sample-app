//
//  AddNewStoreViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"

@interface AddNewStoreViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate,LocationManagerDelegate,StoreManagerDelegate>


@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIImageView *storeImageView;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *placeholderTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *locationPickerView;
@property (strong, nonatomic) IBOutlet UIView *pickersView;


- (IBAction)homeBtnPress:(id)sender;
- (IBAction)chooseImageBtnPress:(id)sender;
- (IBAction)chooseCountry:(id)sender;
- (IBAction)cancelBtnPress:(id)sender;
- (IBAction)doneBtnPrss:(id)sender;
- (IBAction)saveBtnPress:(id)sender;

@end
