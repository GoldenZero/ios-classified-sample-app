//
//  ModelsViewController_iPad.h
//  Bezaat
//
//  Created by Roula Misrabi on 8/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "Store.h"


@protocol brandChoosingDelegate <NSObject>

- (void) didChooseModel:(Model *) model;

@end
@interface ModelsViewController_iPad : GAITrackedViewController<BrandManagerDelegate> {
    NSArray* currentBrands;
    NSArray* currentModels;
}

#pragma mark - properties

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property int tagOfCallXib;
@property (strong, nonatomic) Store* sentStore;

@property (nonatomic) BOOL displayedAsPopOver;

@property (strong, nonatomic) Brand * chosenBrand;
@property (strong, nonatomic) Model * chosenModel;
@property (strong, nonatomic) id <brandChoosingDelegate> choosingDelegate;

#pragma mark - properties of the separate Ui
@property (weak, nonatomic) IBOutlet SSLabel *titleLabel;


#pragma mark - methods
- (void) setFirstAppearance:(BOOL) status;

#pragma mark - actions of the separate UI
- (IBAction)closeBtnPressedInSeparateUI:(id)sender;
@end
