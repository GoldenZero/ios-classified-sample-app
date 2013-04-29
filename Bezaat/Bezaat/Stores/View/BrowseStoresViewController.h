//
//  BrowseStoresViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"

@interface BrowseStoresViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StoreManagerDelegate>

- (IBAction)backBtnPress:(id)sender;

@end
