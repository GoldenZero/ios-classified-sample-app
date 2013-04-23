//
//  BrowseStoresViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BrowseStoresViewController.h"
#import "StoreTableViewCell.h"
#import "StoreManager.h"

@interface BrowseStoresViewController () {
    NSArray *allUserStores;
    IBOutlet UITableView *tableView;
}

@end

@implementation BrowseStoresViewController

static NSString *storeTableCellIdentifier = @"storeTableCellIdentifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            Store *store = [[Store alloc] init];
            store.name = [NSString stringWithFormat:@"Store_%d",i];
            store.desc = [NSString stringWithFormat:@"Store_%d Description",i];
            store.imageURL = @"http://content.bezaat.com/bd4ec47c-18a6-4860-898a-db267cc1254e.jpg";
            [result addObject:store];
        }
        allUserStores = result;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//
//    [tableView registerClass:[StoreTableViewCell class] forCellReuseIdentifier:storeTableCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)backBtnPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allUserStores count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreTableViewCell *cell = (StoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:storeTableCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoreTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Store *store = [allUserStores objectAtIndex:indexPath.row];
    cell.name = store.name;
    cell.country = [NSString stringWithFormat:@"c%d",store.countryID];
    cell.logoURL = store.imageURL;
    
    return cell;
}

@end
