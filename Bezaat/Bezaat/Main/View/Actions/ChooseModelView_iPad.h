//
//  ChooseModelView_iPad.h
//  Bezaat
//
//  Created by Roula Misrabi on 8/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandCell.h"

@interface ChooseModelView_iPad : UIView

@property (strong, nonatomic) BrandCell * owner;
@property (weak, nonatomic) IBOutlet UIScrollView *modelsScrollView;
@property (strong, nonatomic) NSMutableArray * modelCellsArray;
@property (strong, nonatomic) UIViewController * containerViewController;//this one is used only when displaying the full brands UI (not popOver)

- (void) drawModels:(NSArray *) modelsArray ;

@end
