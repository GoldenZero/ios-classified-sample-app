//
//  distanceRangeTableViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 8/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "TableInPopUpTableViewController.h"
#import "DistanceRange.h"
#import "StaticAttrsLoader.h"
#import "Store.h"

@interface TableInPopUpTableViewController ()

@end

@implementation TableInPopUpTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 500.0)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ValueInPopupCell"];
    
    [self.tableView reloadData];
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
    if (self.arrayValues && self.arrayValues.count)
        return self.arrayValues.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ValueInPopupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (self.arrayValues && self.arrayValues) {
        cell.textLabel.textColor = [UIColor colorWithRed:39.0f/255.0f green:132.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (self.showingDistanceRangeObjects) {
            DistanceRange * item = self.arrayValues[indexPath.row];
            cell.textLabel.text = item.rangeName;
        }
        else if (self.showingSingleValueObjects) {
            //This is used for currency, moedl years, and body options
            SingleValue * item = self.arrayValues[indexPath.row];
            cell.textLabel.text = item.valueString.description;
        }
        else if (self.showingStores) {
            Store * item = self.arrayValues[indexPath.row];
            cell.textLabel.text = item.name;
        }

    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    /*
    if (self.showingDistanceRangeObjects) {
        DistanceRange * item = self.arrayValues[indexPath.row];
        [self.choosingDelegate didChooseTableItemWithObject:item];
    }
    else if (self.showingSingleValueObjects) {
        SingleValue * item = self.arrayValues[indexPath.row];
        [self.choosingDelegate didChooseTableItemWithObject:item];
    }
     */
    
    id item = self.arrayValues[indexPath.row];
    [self.choosingDelegate didChooseTableItemWithObject:item];
    

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
