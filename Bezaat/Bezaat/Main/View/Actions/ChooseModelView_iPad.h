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

- (void) DrawModels:(NSArray *) modelsArray ;

@end
