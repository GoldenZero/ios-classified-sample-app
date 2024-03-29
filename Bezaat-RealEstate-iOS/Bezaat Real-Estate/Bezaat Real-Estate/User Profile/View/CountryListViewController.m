//
//  CountryListViewController.m
//  Bezaat Real-Estate
//
//  Created by GALMarei on 9/11/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CountryListViewController.h"

@interface CountryListViewController ()
{
    int counting;
}
@end

@implementation CountryListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    counting = 0;
    countryChosen = NO;
    cityChosen = NO;
    
    locationMngr = [LocationManager sharedInstance];
    
    defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    if  (defaultIndex!= -1){
        chosenCountry =[countriesArray objectAtIndex:defaultIndex];
        citiesArray=[chosenCountry cities];
    }
    
    defaultCityID =  [[LocationManager sharedInstance] getSavedUserCityID];
    NSLog(@"%i",defaultCityID);
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    //[self.countriesTable reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    /*
     DropDownCell *cell = (DropDownCell*) [self.countriesTable cellForRowAtIndexPath:CityIndex];
     
     NSIndexPath *path0 = [NSIndexPath indexPathForRow:[CityIndex row] + 1 inSection:0];
     NSIndexPath *path1 = [NSIndexPath indexPathForRow:[CityIndex row] + 2 inSection:0];
     NSIndexPath *path2 = [NSIndexPath indexPathForRow:[CityIndex row] + 3 inSection:0];
     
     NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, nil];
     */
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getThingsDone) userInfo:nil repeats:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countriesArray=resultArray;
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
    
    [self.countriesTable reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [countriesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //static NSString *DropDownCellIdentifier = @"DropDownCell";
    
    static NSString *CellIdentifier;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        CellIdentifier = @"Cell";
    else
        CellIdentifier = @"Cell_iPad";
    
    static NSString *DropDownCellIdentifier;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        DropDownCellIdentifier = @"DropDownCell";
    else
        DropDownCellIdentifier = @"DropDownCell_iPad";
    
    //for (int i =0; i <= [indexPath section]; i++) {
    switch ([indexPath row]) {
        case 0: {
            
            DropDownCell *cell = (DropDownCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
            
            if (cell == nil){
                NSLog(@"New Cell Made");
                
                NSArray *topLevelObjects;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell" owner:nil options:nil];
                else {
                    if (self.iPad_parentViewOfPopOver)
                        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell_popOver_iPad" owner:nil options:nil];
                    else
                        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell_iPad" owner:nil options:nil];
                }
                
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
            
            chosenCity = [citiesArray objectAtIndex:indexPath.row - 1];
            
            [[cell textLabel] setText:chosenCity.cityName];
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            //if ([defaultCityName isEqualToString:chosenCity.cityName]) {
            //  cell.selected = YES;
            //}
            
            // Configure the cell.
            return cell;
            
            break;
        }
    }
    return nil;
}

-(void)getThingsDone
{
    if (citiesArray) {
        if ([CityIndex section] > 10) {
            [self.countriesTable scrollToRowAtIndexPath:CityIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getTheIndexDraw) userInfo:nil repeats:NO];
    }
    
}

-(void)getTheIndexDraw
{
    
    DropDownCell *Cell = (DropDownCell*) [self.countriesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[CityIndex row] inSection:[CityIndex section]]];
    
    if (Cell == nil){
        NSLog(@"New Cell Made");
        
        NSArray *topLevelObjects;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell" owner:nil options:nil];
        else
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell_iPad" owner:nil options:nil];
        
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
    
    [self.countriesTable insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
    
    
    [self.countriesTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[CityIndex row] + 1 inSection:[CityIndex section]] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.countriesTable scrollToRowAtIndexPath:CityIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
            chosenCity = [citiesArray objectAtIndex:indexPath.row - 1];
            [[cell textLabel] setText:chosenCity.cityName];
            [[LocationManager locationKeyChainItemSharedInstance] resetKeychainItem];
            [[LocationManager sharedInstance] storeDataOfCountry:chosenCountry.countryID city:chosenCity.cityID];
            if (self.iPad_parentViewOfPopOver)
                [self.iPad_parentViewOfPopOver performSelector:@selector(iPad_userDidEndChoosingCountryFromPopOver)];
            else
                [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 counting++;
 if (counting >= 10) {
 if ([CityIndex section] >= 10) {
 [self.countriesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:17] atScrollPosition:nil animated:YES];
 }
 }
 }
 */
- (IBAction)backInvoked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
