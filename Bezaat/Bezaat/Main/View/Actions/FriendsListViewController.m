//
//  FriendsListViewController.m
//  Bezaat
//
//  Created by Noor Alssarraj on 3/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendCell.h"

// Number of friends delete it from the code when adding frinds array, REPLACE it with friendsArray.count.
static int numberOfFriends=3;

@interface FriendsListViewController (){
    NSMutableArray *selectedFriends;
}

@end

@implementation FriendsListViewController
@synthesize tableView,toolBar,friendsArray;

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
    selectedFriends =[[NSMutableArray alloc] init];
   
    // replace here with friendsArrsay.count
    for (int i=0; i<numberOfFriends; i++) {
        [selectedFriends addObject:[NSNumber numberWithBool:NO]];
    }
    
    // Set the background images
    tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shareGradient.png"]];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table handling


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return friendsArray.count;
    return numberOfFriends;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    FriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (FriendCell *) currentObject;
                break;
            }
        }
    }

    BOOL b = [[selectedFriends objectAtIndex:indexPath.row] boolValue];
    if (b==YES) {
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"share_blueCircle.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"share_whiteCircle.png"] forState:UIControlStateNormal]; 
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL b = [[selectedFriends objectAtIndex:indexPath.row] boolValue];
    if (b==YES) {
        NSNumber *temp=[NSNumber numberWithBool:NO];
        [selectedFriends replaceObjectAtIndex:indexPath.row withObject:temp];
    }
    else{
        NSNumber *temp=[NSNumber numberWithBool:YES];
        [selectedFriends replaceObjectAtIndex:indexPath.row withObject:temp];
    }
    [self.tableView reloadData];
    
}



#pragma mark - Actions
- (IBAction)unSelectAllButton:(id)sender {
    NSNumber *temp=[NSNumber numberWithBool:NO];
    for (int i=0; i<selectedFriends.count; i++) {
        [selectedFriends replaceObjectAtIndex:i withObject:temp];
    }
    [self.tableView reloadData];
}

- (IBAction)selectAllButton:(id)sender {
    NSNumber *temp=[NSNumber numberWithBool:YES];
    for (int i=0; i<selectedFriends.count; i++) {
        [selectedFriends replaceObjectAtIndex:i withObject:temp];
    }
    [self.tableView reloadData];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)shareBtnPressed:(id)sender {
    // Return selectedFriends array
}

@end
