//
//  GuestProfileViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GuestProfileViewController.h"

@interface GuestProfileViewController ()
{
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    /*
     NSUInteger iPad_defaultIndex;
     NSInteger iPad_defaultCityID;
     NSString* iPad_defaultCityName;
     
     NSArray * iPad_countriesArray;
     NSArray * iPad_citiesArray;
     
     Country * iPad_chosenCountry;
     City * iPad_chosenCity;
     */
    BOOL iPad_countryChosen;
    BOOL iPad_cityChosen;
    
    NSIndexPath* CityIndex;
    
    NSString *dropDown1;
    NSString *dropDown2;
    
    BOOL dropDown1Open;
    BOOL dropDown2Open;
    BOOL dropDown3Open;
    BOOL dropDown4Open;
    BOOL dropDown5Open;
    BOOL dropDown6Open;
    BOOL dropDown7Open;
    BOOL dropDown8Open;
    BOOL dropDown9Open;
    BOOL dropDown10Open;
    BOOL dropDown11Open;
    BOOL dropDown12Open;
    BOOL dropDown13Open;
    BOOL dropDown14Open;
    BOOL dropDown15Open;
    BOOL dropDown16Open;
    BOOL dropDown17Open;
    BOOL dropDown18Open;
}
@end

@implementation GuestProfileViewController

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
    
    locationMngr = [LocationManager sharedInstance];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        iPad_countryChosen = NO;
        iPad_cityChosen = NO;
        
        /*
         iPad_defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
         if  (iPad_defaultIndex!= -1){
         iPad_chosenCountry =[countriesArray objectAtIndex:iPad_defaultIndex];
         iPad_citiesArray=[chosenCountry cities];
         }
         
         defaultCityID =  [[LocationManager sharedInstance] getSavedUserCityID];
         [locationMngr loadCountriesAndCitiesWithDelegate:self];
         */
    }
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"User profile screen"];
    //[TestFlight passCheckpoint:@"User profile screen"];
    
    //end GA
}

-(void)viewWillAppear:(BOOL)animated
{
    [self showLoadingIndicator];
    [self.profileTable setNeedsDisplay];
    
    locationMngr = [LocationManager sharedInstance];
    defaultCityID =  [[SharedUser sharedInstance] getUserCityID];
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    [self.profileTable reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getThingsDone) userInfo:nil repeats:NO];
    }
    
}

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countriesArray = resultArray;
    for (int i =0; i <= [countriesArray count] - 1; i++) {
        chosenCountry=[countriesArray objectAtIndex:i];
        citiesArray=[chosenCountry cities];
        for (City* cit in citiesArray) {
            if (cit.cityID == defaultCityID)
            {
                defaultCityName = cit.cityName;
                CityIndex = [NSIndexPath indexPathForRow:[citiesArray indexOfObject:cit] inSection:i];
                break;
                //return;
            }
        }
    }
    [self.iPad_countriesTable reloadData];
    
    
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.profileTable)
        return 1;
    else    // iPad_countriesTable
        return [countriesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.profileTable) {
        // Return the number of rows in the section.
        switch (section) {
            case 0:
                return 1;
                break;
                
            default:
                return 1;
                break;
        }
    }
    else {
        // Return the number of rows in the section.
        switch (section) {
            case 0:
                chosenCountry=[countriesArray objectAtIndex:0];
                citiesArray=[chosenCountry cities];
                if (dropDown1Open) {
                    
                    return [citiesArray count] + 1;
                }
                else
                {
                    return 1;
                }
                break;
                
            case 1:
                chosenCountry=[countriesArray objectAtIndex:1];
                citiesArray=[chosenCountry cities];
                if (dropDown2Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 2:
                chosenCountry=[countriesArray objectAtIndex:2];
                citiesArray=[chosenCountry cities];
                if (dropDown3Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 3:
                chosenCountry=[countriesArray objectAtIndex:3];
                citiesArray=[chosenCountry cities];
                if (dropDown4Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 4:
                chosenCountry=[countriesArray objectAtIndex:4];
                citiesArray=[chosenCountry cities];
                if (dropDown5Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 5:
                chosenCountry=[countriesArray objectAtIndex:5];
                citiesArray=[chosenCountry cities];
                if (dropDown6Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 6:
                chosenCountry=[countriesArray objectAtIndex:6];
                citiesArray=[chosenCountry cities];
                if (dropDown7Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 7:
                chosenCountry=[countriesArray objectAtIndex:7];
                citiesArray=[chosenCountry cities];
                if (dropDown8Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 8:
                chosenCountry=[countriesArray objectAtIndex:8];
                citiesArray=[chosenCountry cities];
                if (dropDown9Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 9:
                chosenCountry=[countriesArray objectAtIndex:9];
                citiesArray=[chosenCountry cities];
                if (dropDown10Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 10:
                chosenCountry=[countriesArray objectAtIndex:10];
                citiesArray=[chosenCountry cities];
                if (dropDown11Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 11:
                chosenCountry=[countriesArray objectAtIndex:11];
                citiesArray=[chosenCountry cities];
                if (dropDown12Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 12:
                chosenCountry=[countriesArray objectAtIndex:12];
                citiesArray=[chosenCountry cities];
                if (dropDown13Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 13:
                chosenCountry=[countriesArray objectAtIndex:13];
                citiesArray=[chosenCountry cities];
                if (dropDown14Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 14:
                chosenCountry=[countriesArray objectAtIndex:14];
                citiesArray=[chosenCountry cities];
                if (dropDown15Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 15:
                chosenCountry=[countriesArray objectAtIndex:15];
                citiesArray=[chosenCountry cities];
                if (dropDown16Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 16:
                chosenCountry=[countriesArray objectAtIndex:16];
                citiesArray=[chosenCountry cities];
                if (dropDown17Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
            case 17:
                chosenCountry=[countriesArray objectAtIndex:17];
                citiesArray=[chosenCountry cities];
                if (dropDown18Open) {
                    return [citiesArray count]+ 1;
                }
                else
                {
                    return 1;
                }
                
            default:
                return 1;
                break;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.profileTable) {
        static NSString *CellIdentifier = @"Cell";
        static NSString *DropDownCellIdentifier = @"profileCell";
        
        switch ([indexPath section]) {
            case 0:
                switch ([indexPath row]) {
                    case 0: {
                        
                        ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                        
                        if (cell == nil){
                            NSLog(@"New Cell Made");
                            
                            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"ProfileCell" : @"ProfileCell_iPad") owner:nil options:nil];
                            
                            for(id currentObject in topLevelObjects)
                            {
                                if([currentObject isKindOfClass:[ProfileCell class]])
                                {
                                    cell = (ProfileCell *)currentObject;
                                    break;
                                }
                            }
                        }
                        
                        [cell.iconImg setImage:[UIImage imageNamed:@"setting_changecity.png"]];
                        
                        cell.customLbl.text = @"المدينة";
                        cell.customTitle.text = defaultCityName;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                        
                        break;
                    }
                    default: {
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell == nil) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        [[cell textLabel] setText:@""];
                        
                        // Configure the cell.
                        return cell;
                        
                        break;
                    }
                }
                break;
                
            default:
                break;
        }
        
        return nil;
    }
    else {  //countries table
        //static NSString *CellIdentifier = @"Cell";
        //static NSString *DropDownCellIdentifier = @"DropDownCell";
        
        static NSString *CellIdentifier = @"Cell_inSettings_iPad";
        
        static NSString *DropDownCellIdentifier = @"DropDownCell_inSettings_iPad";
        
        //for (int i =0; i <= [indexPath section]; i++) {
        switch ([indexPath row]) {
            case 0: {
                
                DropDownCell *cell = (DropDownCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                
                if (cell == nil){
                    
                    
                    NSArray *topLevelObjects;
                    
                    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell_settings_iPad" owner:nil options:nil];
                    
                    for(id currentObject in topLevelObjects)
                    {
                        if([currentObject isKindOfClass:[DropDownCell class]])
                        {
                            cell = (DropDownCell *)currentObject;
                            break;
                        }
                    }
                }
                chosenCountry=[countriesArray objectAtIndex:[indexPath section]];
                citiesArray=[chosenCountry cities];
                [[cell textLabel] setText:chosenCountry.countryName];
                [[cell flagImg] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",chosenCountry.countryNameEn]]];
                dropDown1 = chosenCountry.countryName;
                
                
                // Configure the cell.
                return cell;
                break;
            }
            default: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                chosenCountry=[countriesArray objectAtIndex:[indexPath section]];
                citiesArray=[chosenCountry cities];
                
                iPad_chosenCity = [citiesArray objectAtIndex:indexPath.row - 1];
                
                [[cell textLabel] setText:iPad_chosenCity.cityName];
                cell.textLabel.textAlignment = NSTextAlignmentRight;
                //if ([defaultCityName isEqualToString:iPad_chosenCity.cityName]) {
                //  cell.selected = YES;
                //}
                
                // Configure the cell.
                return cell;
                
                break;
            }
        }
        return nil;
        
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        switch ([indexPath section]) {
            case 0:
                switch ([indexPath row]) {
                    case 0:{
                        CountryListViewController* vc;
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                            vc = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController" bundle:nil];
                        else
                            vc = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController_iPad" bundle:nil];
                        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        [self presentViewController:vc animated:YES completion:nil];
                        return;
                        break;
                    }
                    default:
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        return;
                        break;
                }
            default:
                break;
        }
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        if (tableView == self.profileTable) {
            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
            
            [cell.iconImg setImage:[UIImage imageNamed:@"setting_changecity_inverted.png"]];
            [cell.arrowImg setImage:[UIImage imageNamed:@"arrow_inverted@2x.png"]];
        }
        //if (tableView == self.iPad_countriesTable)
        else
        {
            switch ([indexPath row]) {
                case 0:
                {
                    DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:indexPath];
                    chosenCountry=[countriesArray objectAtIndex:[indexPath section]];
                    citiesArray=[chosenCountry cities];
                    NSMutableArray *indexPathArray;
                    indexPathArray = [[NSMutableArray alloc] init];
                    for (int i = 1; i <= [citiesArray count]; i++) {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:[indexPath row]+i inSection:[indexPath section]];
                        [indexPathArray addObject:path];
                    }
                    if ([cell isOpen])
                    {
                        [cell setClosed];
                        if ([indexPath section] == 0)
                            dropDown1Open = [cell isOpen];
                        else if ([indexPath section] == 1)
                            dropDown2Open = [cell isOpen];
                        else if ([indexPath section] == 2)
                            dropDown3Open = [cell isOpen];
                        else if ([indexPath section] == 3)
                            dropDown4Open = [cell isOpen];
                        else if ([indexPath section] == 4)
                            dropDown5Open = [cell isOpen];
                        else if ([indexPath section] == 5)
                            dropDown6Open = [cell isOpen];
                        else if ([indexPath section] == 6)
                            dropDown7Open = [cell isOpen];
                        else if ([indexPath section] == 7)
                            dropDown8Open = [cell isOpen];
                        else if ([indexPath section] == 8)
                            dropDown9Open = [cell isOpen];
                        else if ([indexPath section] == 9)
                            dropDown10Open = [cell isOpen];
                        else if ([indexPath section] == 10)
                            dropDown11Open = [cell isOpen];
                        else if ([indexPath section] == 11)
                            dropDown12Open = [cell isOpen];
                        else if ([indexPath section] == 12)
                            dropDown13Open = [cell isOpen];
                        else if ([indexPath section] == 13)
                            dropDown14Open = [cell isOpen];
                        else if ([indexPath section] == 14)
                            dropDown15Open = [cell isOpen];
                        else if ([indexPath section] == 15)
                            dropDown16Open = [cell isOpen];
                        else if ([indexPath section] == 16)
                            dropDown17Open = [cell isOpen];
                        else if ([indexPath section] == 17)
                            dropDown18Open = [cell isOpen];
                        
                        
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                    }
                    else
                    {
                        [cell setOpen];
                        if ([indexPath section] == 0)
                            dropDown1Open = [cell isOpen];
                        else if ([indexPath section] == 1)
                            dropDown2Open = [cell isOpen];
                        else if ([indexPath section] == 2)
                            dropDown3Open = [cell isOpen];
                        else if ([indexPath section] == 3)
                            dropDown4Open = [cell isOpen];
                        else if ([indexPath section] == 4)
                            dropDown5Open = [cell isOpen];
                        else if ([indexPath section] == 5)
                            dropDown6Open = [cell isOpen];
                        else if ([indexPath section] == 6)
                            dropDown7Open = [cell isOpen];
                        else if ([indexPath section] == 7)
                            dropDown8Open = [cell isOpen];
                        else if ([indexPath section] == 8)
                            dropDown9Open = [cell isOpen];
                        else if ([indexPath section] == 9)
                            dropDown10Open = [cell isOpen];
                        else if ([indexPath section] == 10)
                            dropDown11Open = [cell isOpen];
                        else if ([indexPath section] == 11)
                            dropDown12Open = [cell isOpen];
                        else if ([indexPath section] == 12)
                            dropDown13Open = [cell isOpen];
                        else if ([indexPath section] == 13)
                            dropDown14Open = [cell isOpen];
                        else if ([indexPath section] == 14)
                            dropDown15Open = [cell isOpen];
                        else if ([indexPath section] == 15)
                            dropDown16Open = [cell isOpen];
                        else if ([indexPath section] == 16)
                            dropDown17Open = [cell isOpen];
                        else if ([indexPath section] == 17)
                            dropDown18Open = [cell isOpen];
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                    }
                    
                    break;
                }
                default:
                {
                    dropDown1 = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
                    
                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[indexPath section]];
                    DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:path];
                    chosenCountry=[countriesArray objectAtIndex:[indexPath section]];
                    citiesArray=[chosenCountry cities];
                    iPad_chosenCity = [citiesArray objectAtIndex:indexPath.row - 1];
                    [[cell textLabel] setText:iPad_chosenCity.cityName];
                    defaultCityName = iPad_chosenCity.cityName;
                    [self.profileTable reloadData];
                    [[LocationManager locationKeyChainItemSharedInstance] resetKeychainItem];
                    [[LocationManager sharedInstance] storeDataOfCountry:chosenCountry.countryID city:iPad_chosenCity.cityID];
                    
                    break;
                }
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideLoadingIndicator];
}


- (void) showLoadingIndicator {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        loadingHUD.dimBackground = YES;
    }
    else {
        iPad_loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
        
        iPad_loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        iPad_loadingView.clipsToBounds = YES;
        iPad_loadingView.layer.cornerRadius = 10.0;
        iPad_loadingView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        
        iPad_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        iPad_activityIndicator.frame = CGRectMake(65, 40, iPad_activityIndicator.bounds.size.width, iPad_activityIndicator.bounds.size.height);
        [iPad_loadingView addSubview:iPad_activityIndicator];
        
        iPad_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        iPad_loadingLabel.backgroundColor = [UIColor clearColor];
        iPad_loadingLabel.textColor = [UIColor whiteColor];
        iPad_loadingLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        iPad_loadingLabel.adjustsFontSizeToFitWidth = YES;
        iPad_loadingLabel.textAlignment = NSTextAlignmentCenter;
        iPad_loadingLabel.text = @"جاري تحميل البيانات";
        [iPad_loadingView addSubview:iPad_loadingLabel];
        
        [self.view addSubview:iPad_loadingView];
        [iPad_activityIndicator startAnimating];
    }
    
}

- (void) hideLoadingIndicator {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (loadingHUD)
            [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
        loadingHUD = nil;
    }
    else {
        if ((iPad_activityIndicator) && (iPad_loadingView)) {
            [iPad_activityIndicator stopAnimating];
            [iPad_loadingView removeFromSuperview];
        }
        iPad_activityIndicator = nil;
        iPad_loadingView = nil;
        iPad_loadingLabel = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------- COUNTRY LIST -------------------------------------
-(void)getThingsDone
{
    if (citiesArray) {
        if ([CityIndex section] > 10) {
            [self.iPad_countriesTable scrollToRowAtIndexPath:CityIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getTheIndexDraw) userInfo:nil repeats:NO];
    }
    
}

-(void)getTheIndexDraw
{
    
    DropDownCell *Cell = (DropDownCell*) [self.iPad_countriesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[CityIndex row] inSection:[CityIndex section]]];
    
    if (Cell == nil){
        
        NSArray *topLevelObjects;
        
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell_settings_iPad" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[DropDownCell class]])
            {
                Cell = (DropDownCell *)currentObject;
                break;
            }
        }
    }
    
    chosenCountry=[countriesArray objectAtIndex:[CityIndex section]];
    citiesArray=[chosenCountry cities];
    NSMutableArray *indexPathArray;
    indexPathArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= [citiesArray count]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0+i inSection:[CityIndex section]];
        [indexPathArray addObject:path];
    }
    
    [Cell setOpen];
    if ([CityIndex section] == 0)
        dropDown1Open = [Cell isOpen];
    else if ([CityIndex section] == 1)
        dropDown2Open = [Cell isOpen];
    else if ([CityIndex section] == 2)
        dropDown3Open = [Cell isOpen];
    else if ([CityIndex section] == 3)
        dropDown4Open = [Cell isOpen];
    else if ([CityIndex section] == 4)
        dropDown5Open = [Cell isOpen];
    else if ([CityIndex section] == 5)
        dropDown6Open = [Cell isOpen];
    else if ([CityIndex section] == 6)
        dropDown7Open = [Cell isOpen];
    else if ([CityIndex section] == 7)
        dropDown8Open = [Cell isOpen];
    else if ([CityIndex section] == 8)
        dropDown9Open = [Cell isOpen];
    else if ([CityIndex section] == 9)
        dropDown10Open = [Cell isOpen];
    else if ([CityIndex section] == 10)
        dropDown11Open = [Cell isOpen];
    else if ([CityIndex section] == 11)
        dropDown12Open = [Cell isOpen];
    else if ([CityIndex section] == 12)
        dropDown13Open = [Cell isOpen];
    else if ([CityIndex section] == 13)
        dropDown14Open = [Cell isOpen];
    else if ([CityIndex section] == 14)
        dropDown15Open = [Cell isOpen];
    else if ([CityIndex section] == 15)
        dropDown16Open = [Cell isOpen];
    else if ([CityIndex section] == 16)
        dropDown17Open = [Cell isOpen];
    else if ([CityIndex section] == 17)
        dropDown18Open = [Cell isOpen];
    
    [self.iPad_countriesTable insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
    
    
    [self.iPad_countriesTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[CityIndex row] + 1 inSection:[CityIndex section]] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.iPad_countriesTable scrollToRowAtIndexPath:CityIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
//-----------------------------------------------------------------------------------------------
@end
