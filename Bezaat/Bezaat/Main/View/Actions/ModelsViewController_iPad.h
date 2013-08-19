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

@interface ModelsViewController_iPad : GAITrackedViewController<BrandManagerDelegate> {
    NSArray* currentBrands;
    NSArray* currentModels;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property int tagOfCallXib;
@property (strong, nonatomic) Store* sentStore;

@end
