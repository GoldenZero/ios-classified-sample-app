//
//  ChooseActionViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to choose on action button:
// - buy a car
// - add a car ad
// - open up a store
// The user here may be signed in or not.


#import <UIKit/UIKit.h>


@interface ChooseActionViewController : UIViewController

#pragma mark - properties

#pragma mark - actions
- (IBAction)AddNewCarAdBtnPressed:(id)sender;
- (IBAction)BuyCarBtnPressed:(id)sender;

- (IBAction)AddNewStoreBtnPressed:(id)sender;

@end
