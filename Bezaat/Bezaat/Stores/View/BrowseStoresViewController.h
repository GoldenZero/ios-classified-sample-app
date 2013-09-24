//
//  BrowseStoresViewController.h
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManager.h"
#import "GAI.h"
@interface BrowseStoresViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,StoreManagerDelegate,LocationManagerDelegate>

- (IBAction)backBtnPress:(id)sender;

#pragma mark - iPad properties
@property (weak, nonatomic) IBOutlet SSLabel *iPad_titleLabel;

- (IBAction)iPad_addNewStoreBtnPress:(id)sender;
@end
