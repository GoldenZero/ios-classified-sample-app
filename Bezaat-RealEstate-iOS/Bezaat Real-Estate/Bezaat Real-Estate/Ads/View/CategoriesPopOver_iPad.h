//
//  CategoriesPopOver_iPad.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/28/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol categoryChoosingDelegate <NSObject>

- (void) didChooseCategory:(Category1 *) category;

@end

@interface CategoriesPopOver_iPad : UIViewController

@property (nonatomic) BOOL browsingForSale;
@property (strong, nonatomic) id <categoryChoosingDelegate> choosingDelegate;

@end
