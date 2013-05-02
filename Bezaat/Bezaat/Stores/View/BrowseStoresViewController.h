//
//  BrowseStoresViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"

@interface BrowseStoresViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,StoreManagerDelegate,LocationManagerDelegate>

- (IBAction)backBtnPress:(id)sender;

@end
