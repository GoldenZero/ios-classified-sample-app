//
//  AddNewCarAdViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is dislayed to the user to add a new car ad to his profile.

#import <UIKit/UIKit.h>

@interface AddNewCarAdViewController : UIViewController

#pragma mark - properties
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UITextField *adAdressText;
@property (strong, nonatomic) IBOutlet UITextView *adDetailsText;
@property (strong, nonatomic) IBOutlet UITextField *kiloText;
@property (strong, nonatomic) IBOutlet UITextField *priceText;
@property (strong, nonatomic) IBOutlet UIView *addImagesView;

#pragma mark - actions

- (IBAction)homeBtnPrss:(id)sender;
- (IBAction)addBtnprss:(id)sender;

@end
