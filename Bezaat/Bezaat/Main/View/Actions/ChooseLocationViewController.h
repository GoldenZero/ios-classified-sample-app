//
//  ChooseLocationViewController.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 24/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This UI is displayed to the user the first time the application starts.
// It is responsible for displaying countries and cities with map images as background to let the user choose from.



#import <UIKit/UIKit.h>
#import "DropDownList.h"
#import "SignInViewController.h"
#import "LocationManager.h"

@interface ChooseLocationViewController : UIViewController <DropDownListDelegate,LocationManagerDelegate>

#pragma mark - properties

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backgroungImageView;

#pragma mark - actions
- (IBAction)nextBtnPressed:(id)sender;

@end