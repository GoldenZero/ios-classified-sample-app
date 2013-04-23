//
//  ModelsViewController.h
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelsViewController : UIViewController<BrandManagerDelegate> {
    NSArray* currentBrands;
    NSArray* currentModels;
}

@property (weak, nonatomic) IBOutlet UITableView *tblModels;
@property (weak, nonatomic) IBOutlet UITableView *tblBrands;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UIImageView *blueBgImgV;
@property (strong, nonatomic) IBOutlet UIImageView *blackBgImgV;
@property int tagOfCallXib;

@end
