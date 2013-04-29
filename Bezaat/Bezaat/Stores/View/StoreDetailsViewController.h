//
//  StoreDetailsViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"

@interface StoreDetailsViewController : UIViewController<UITableViewDataSource,StoreManagerDelegate>

@property (nonatomic, strong) Store *currentStore;

- (IBAction)backBtnPress:(id)sender;
- (IBAction)menueBtnPress:(id)sender;

@end
