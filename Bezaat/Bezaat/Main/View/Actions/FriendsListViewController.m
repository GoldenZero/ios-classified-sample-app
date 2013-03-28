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
@synthesize selectButton,unselectButton,tableView,toolBar,backButton;

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
    tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shareGradient.png"]];
    
    [toolBar setBackgroundImage:[UIImage imageNamed:@"share_blueRectangle.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    [selectButton setImage:[UIImage imageNamed:@"share_whiteCircBtn.png"]];
    [unselectButton setImage:[UIImage imageNamed:@"share_ring.png"]];
    [backButton setImage:[UIImage imageNamed:@"share_arrowButton.png"]];
    UIImageView *shareLabel =[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 320, 42)];
    shareLabel.image=[UIImage imageNamed:@"share_grayButton.png"];
    [self.view addSubview:shareLabel];
    [self.view insertSubview:shareLabel aboveSubview:toolBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table handling

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Replace it with friendsArray.count
    return numberOfFriends;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Selected
    UIImageView *selectCircle = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 24, 23)];
    [selectCircle setAlpha:1.0];
    selectCircle.opaque= NO;
    
    // Image
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(290,5, 24, 24)];
    
    // title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 220, 15)];
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentRight;
    title.font=[UIFont boldSystemFontOfSize:14];
    
    // subtitle
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, 220, 10)];
    subtitle.numberOfLines = 0;
    subtitle.textAlignment = NSTextAlignmentRight;
    subtitle.font=[UIFont systemFontOfSize:10];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
#pragma mark - set the information of friend in each cell -
    // replace it with friend's image
    imv.image=[UIImage imageNamed:@"share_picture.png"];
    // replace it with friend's name
    title.text=@"اسم الصديق";
    // replcae it with friend's mail
    subtitle.text=@"ايميل الصديق";
    
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:subtitle];
    [cell addSubview:imv];
    BOOL b = [[selectedFriends objectAtIndex:indexPath.row] boolValue];
    if (b==YES) {
        selectCircle.image=[UIImage imageNamed:@"share_blueCircle.png"];
        [cell.contentView addSubview:selectCircle];
    }
    else{
        selectCircle.image=[UIImage imageNamed:@"share_whiteCircle.png"];
        [cell.contentView addSubview:selectCircle];
        
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
}

@end
