//
//  TableItemsViewController.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/27/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "TableItemsViewController.h"

#import "MBProgressHUD2.h"

#import "ItemDetailsViewController.h"
#import "TableItemCell.h"

#import "UIUtils.h"

@interface TableItemsViewController ()

@end

@implementation TableItemsViewController

- (void)viewWillAppear:(BOOL)animated {
    // Show the loading indicator
    [MBProgressHUD2 showHUDAddedTo:self.view
                              text:_message
                      detailedText:_subMessage
                          animated:YES];
    
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark UITableViewController Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get a used cell or build a new one
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"item_cell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:_cellNibName owner:self options:nil] objectAtIndex:0];
    }

    // Get the current item
    NSObject<ObjectParserProtocol>* currentItem = [_items objectAtIndex:indexPath.row];
    
    // Force the cell to be a customized cell
    TableItemCell* customCell = (TableItemCell*)cell;
    
    // Reload the data in the cell
    [customCell reloadViewWithData:currentItem];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_nextControllerClass != nil) {
        // Get the touched item
        NSObject<ObjectParserProtocol>* item = _items[indexPath.row];

        // Create the details view controller and pass the article to it
        ItemDetailsViewController* controller = [[_nextControllerClass alloc] init];
        controller.item = item;
        
        // Change the back button title
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"عودة"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:nil
                                                                         action:nil];
        self.navigationItem.backBarButtonItem = newBackButton;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -
#pragma mark Data Delegate Methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    // Hide the loading indicator
    [MBProgressHUD2 hideHUDForView:self.view animated:YES];
    
    // Show the error message
    [[UIUtils sharedInstance] showSimpleAlertWithTitle:@"خطأ في الاتصال" text:@"الرجاء التأكد من اتصالك بالإنترنت والمحاولة مرة أخرى"];
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSArray*) objects {
    // Build objects from the given data
    _items = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for (int i = 0; i < objects.count; i++) {
        _items[i] = [[_nextControllerItemClass alloc] initWithDictionary:objects[i]];
    }
    
    // Reload the table data
    [_tblItems reloadData];
    
    // Hide the loading indicator
    [MBProgressHUD2 hideHUDForView:self.view animated:YES];
}

@end
