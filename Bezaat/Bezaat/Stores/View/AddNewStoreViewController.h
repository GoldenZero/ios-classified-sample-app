//
//  AddNewStoreViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"

@interface AddNewStoreViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate,LocationManagerDelegate,StoreManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryCity;

- (IBAction)homeBtnPress:(id)sender;
- (IBAction)chooseImageBtnPress:(id)sender;
- (IBAction)chooseCountry:(id)sender;
- (IBAction)cancelBtnPress:(id)sender;
- (IBAction)doneBtnPrss:(id)sender;
- (IBAction)saveBtnPress:(id)sender;

@end
