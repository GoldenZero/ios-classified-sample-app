//
//  FriendsListViewController.h
//  Bezaat
//
//  Created by Noor Alssarraj on 3/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *unselectButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;


#pragma mark - Actions
- (IBAction)unSelectAllButton:(id)sender;
- (IBAction)selectAllButton:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
