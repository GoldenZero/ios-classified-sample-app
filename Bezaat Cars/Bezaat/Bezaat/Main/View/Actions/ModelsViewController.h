//
//  ModelsViewController.h
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "Store.h"

@interface ModelsViewController : GAITrackedViewController<BrandManagerDelegate> {
    NSArray* currentBrands;
    NSArray* currentModels;
}

@property (weak, nonatomic) IBOutlet UITableView *tblModels;
@property (weak, nonatomic) IBOutlet UITableView *tblBrands;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UIImageView *blueBgImgV;
@property (strong, nonatomic) IBOutlet UIImageView *blackBgImgV;
@property (weak, nonatomic) IBOutlet UIButton *allCarsBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBrandsBtn;
@property int tagOfCallXib;
@property (strong, nonatomic) Store* sentStore;
- (IBAction)allCarsInvoked:(id)sender;

@end
