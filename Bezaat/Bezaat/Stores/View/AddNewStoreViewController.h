//
//  AddNewStoreViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"

@interface AddNewStoreViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,StoreManagerDelegate>

- (IBAction)homeBtnPress:(id)sender;
- (IBAction)chooseImageBtnPress:(id)sender;
- (IBAction)cancelBtnPress:(id)sender;
- (IBAction)saveBtnPress:(id)sender;

@end
