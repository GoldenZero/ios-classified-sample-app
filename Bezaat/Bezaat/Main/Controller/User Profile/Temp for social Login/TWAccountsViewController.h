//
//  TWAccountsViewController.h
//  TrySignInWithFBTW
//
//  Created by Roula Misrabi on 3/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This class is responsible for displaying the list of twitter accounts for the user
// (This table may be changed to a custom control later)

#import <UIKit/UIKit.h>

#import <Accounts/ACAccount.h>

@protocol ChooseTWAccountDelegate <NSObject>
@required
- (void) didChooseAccountWithIndex:(NSUInteger) accountIndex;
@end

@interface TWAccountsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

#pragma mark - properties
@property (strong, nonatomic) NSArray * accountsArray;
@property (strong, nonatomic) id <ChooseTWAccountDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView * tableView;

@end
