//
//  ExhibitViewController.h
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gallariesManager.h"
@interface ExhibitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GallariesManagerDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *viewTitle;
@property int countryID;

#pragma mark - Actions
- (IBAction)homeBtnPrss:(id)sender;

@end
