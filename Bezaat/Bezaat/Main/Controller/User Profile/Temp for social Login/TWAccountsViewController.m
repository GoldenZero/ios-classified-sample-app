//
//  TWAccountsViewController.m
//  TrySignInWithFBTW
//
//  Created by Roula Misrabi on 3/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "TWAccountsViewController.h"

@interface TWAccountsViewController ()
{
    NSUInteger selectedAccountIndex;
    BOOL didSelectOnce;
}
@end

@implementation TWAccountsViewController
@synthesize accountsArray, delegate, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoosingAccount)];
    
    self.navigationItem.rightBarButtonItem = doneBtn;
    selectedAccountIndex = 0;
    
    didSelectOnce = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.accountsArray)
        return self.accountsArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.accountsArray)
    {
        
        UITableViewCell *cell = [UITableViewCell new];
        
        ACAccount * twitterAccount = [self.accountsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = twitterAccount.username;
        if (!didSelectOnce)
        {
            if (indexPath.row == selectedAccountIndex)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!didSelectOnce)
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedAccountIndex inSection:0]].accessoryType = UITableViewCellAccessoryNone;

        
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType =UITableViewCellAccessoryCheckmark;
    selectedAccountIndex = indexPath.row;
    didSelectOnce = YES;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - helper methods
- (void) doneChoosingAccount {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate)
            [self.delegate didChooseAccountWithIndex:selectedAccountIndex];
    }];
}

@end

