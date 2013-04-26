//
//  AddNewCarAdViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is dislayed to the user to add a new car ad to his profile.

#import <UIKit/UIKit.h>
#import "CarAdsManager.h"

@interface AddNewCarAdViewController : BaseViewController<UIScrollViewDelegate,UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UploadImageDelegate, PostAdDelegate>

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (strong, nonatomic) IBOutlet UIView *addImagesView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) Model *currentModel;
@property (strong, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locationPickerView;


#pragma mark - actions

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)addBtnprss:(id)sender;
- (IBAction)selectModelBtnPrss:(id)sender;

@end
