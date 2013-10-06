//
//  ProfileDetailsViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ProfileDetailsViewController.h"

@interface ProfileDetailsViewController ()
{
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    BOOL iPad_isLoggingOut;
    
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

@implementation ProfileDetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    //[self showLoadingIndicator];
    CurrentUser = [[UserProfile alloc]init];
    //[[ProfileManager sharedInstance] loginWithDelegate:self email:@"akbarbunere2@gmail.com" password:@"12345"];
    
    locationMngr = [LocationManager sharedInstance];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UITapGestureRecognizer * iPad_tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iPad_dismissKeyboard)];
        [self.iPad_changeNameView addGestureRecognizer:iPad_tap1];
        
        UITapGestureRecognizer * iPad_tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iPad_dismissKeyboard)];
        [self.iPad_changePasswordView addGestureRecognizer:iPad_tap2];
        
        iPad_isLoggingOut = NO;
        iPad_countryChosen = NO;
        iPad_cityChosen = NO;
    }
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"User profile screen"];
    [TestFlight passCheckpoint:@"User profile screen"];
    //end GA
    
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
    if (self.ButtonCheck) {
        [self.backBtn setImage:[UIImage imageNamed:@"buttons_back.png"] forState:UIControlStateNormal];
    }
    [self showLoadingIndicator];
    [self.profileTable setNeedsDisplay];
    
    CurrentUser = [[UserProfile alloc]init];
    //[[ProfileManager sharedInstance] loginWithDelegate:self email:@"akbarbunere2@gmail.com" password:@"12345"];
    
    locationMngr = [LocationManager sharedInstance];
    CurrentUser = [[ProfileManager sharedInstance] getSavedUserProfile];
    defaultCityID =  [[SharedUser sharedInstance] getUserCityID];
    // defaultCityID =  CurrentUser.defaultCityID;
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    [self.profileTable reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.iPad_userNameTextField.text = CurrentUser.userName;
        
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getThingsDone) userInfo:nil repeats:NO];
    }
    
}
@catch (NSException *exception) {
    [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
}

}

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    @try {
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
    
    if (!defaultCityName) {
        CountryListViewController* vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController" bundle:nil];
        else
            vc = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController_iPad" bundle:nil];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
    
}
- (void) userDidLoginWithData:(UserProfile *)resultProfile {
    @try {
    //save user's data
    [[ProfileManager sharedInstance] storeUserProfile:resultProfile];
    [self hideLoadingIndicator];
    [self.profileTable setNeedsDisplay];
    [self.profileTable reloadData];
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
}

- (void) userFailLoginWithError:(NSError *)error {
    @try {
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choseCityInvoked:(id)sender {
    
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)logoutInvoked:(id)sender {
}

- (IBAction)changePwdInvoked:(id)sender {
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    @try {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (tableView == self.profileTable)
            return 3;
        return 0;
    }
    else {
        if (tableView == self.profileTable)
            return 2;
        else
            return [countriesArray count];
    }
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Return the number of rows in the section.
        switch (section) {
            case 0:
                return 2;
                break;
                
            case 1:
                return 2;
                break;
                
            case 2:
                return 1;
                break;
                
            default:
                return 1;
                break;
        }
    }
    else {
        if (tableView == self.profileTable) {
            // Return the number of rows in the section.
            switch (section) {
                case 0:
                    return 4;
                    break;
                    
                case 1:
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
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
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
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil];
                                
                                for(id currentObject in topLevelObjects)
                                {
                                    if([currentObject isKindOfClass:[ProfileCell class]])
                                    {
                                        cell = (ProfileCell *)currentObject;
                                        break;
                                    }
                                }
                            }
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_user.png"]];
                            cell.customLbl.text = @"إسم المستخدم";
                            cell.customTitle.text = CurrentUser.userName;
                            // Configure the cell.
                            return cell;
                            
                            break;
                        }
                        case 1: {
                            
                            ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                            
                            if (cell == nil){
                                NSLog(@"New Cell Made");
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil];
                                
                                for(id currentObject in topLevelObjects)
                                {
                                    if([currentObject isKindOfClass:[ProfileCell class]])
                                    {
                                        cell = (ProfileCell *)currentObject;
                                        break;
                                    }
                                }
                            }
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_email.png"]];
                            cell.customLbl.text = @"البريد الإلكتروني";
                            cell.customTitle.text = CurrentUser.emailAddress;
                            [cell.arrowImg setImage:nil];
                            // Configure the cell.
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
                case 1:
                    switch ([indexPath row]) {
                        case 0: {
                            
                            ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                            
                            if (cell == nil){
                                NSLog(@"New Cell Made");
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil];
                                
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
                            // Configure the cell.
                            return cell;
                            
                            break;
                        }
                        case 1: {
                            
                            ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                            
                            if (cell == nil){
                                NSLog(@"New Cell Made");
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil];
                                
                                for(id currentObject in topLevelObjects)
                                {
                                    if([currentObject isKindOfClass:[ProfileCell class]])
                                    {
                                        cell = (ProfileCell *)currentObject;
                                        break;
                                    }
                                }
                            }
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_changePass.png"]];
                            cell.customLbl.text = @"تغيير كلمة السر";
                            cell.customTitle.text = @"";
                            // Configure the cell.
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
                case 2:
                {
                    ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                    
                    if (cell == nil){
                        NSLog(@"New Cell Made");
                        
                        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil];
                        
                        for(id currentObject in topLevelObjects)
                        {
                            if([currentObject isKindOfClass:[ProfileCell class]])
                            {
                                cell = (ProfileCell *)currentObject;
                                break;
                            }
                        }
                    }
                    
                    [cell.iconImg setImage:[UIImage imageNamed:@"setting_signOut.png"]];
                    cell.customLbl.text = @"تسجيل الخروج";
                    cell.customTitle.text = @"";
                    cell.customLbl.textAlignment = NSTextAlignmentLeft;
                    cell.customLbl.textColor = [UIColor whiteColor];
                    cell.customLbl.font = [UIFont boldSystemFontOfSize:23];
                    cell.backgroundColor = [UIColor colorWithRed:114.0/255 green:115.0/255 blue:115.0/255 alpha:1.0f];
                    //cell.backgroundColor = [UIColor blackColor];
                    [cell.arrowImg setImage:nil];
                    // Configure the cell.
                    return cell;
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            return nil;
        }
    }
    else {  //iPad
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
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell_iPad" owner:nil options:nil];
                                
                                for(id currentObject in topLevelObjects)
                                {
                                    if([currentObject isKindOfClass:[ProfileCell class]])
                                    {
                                        cell = (ProfileCell *)currentObject;
                                        break;
                                    }
                                }
                            }
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_user.png"]];
                            cell.customLbl.text = @"إسم المستخدم";
                            cell.customTitle.text = CurrentUser.userName;
                            // Configure the cell.
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                            
                            break;
                        }
                        case 1: {
                            
                            ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                            
                            if (cell == nil){
                                NSLog(@"New Cell Made");
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell_iPad" owner:nil options:nil];
                                
                                for(id currentObject in topLevelObjects)
                                {
                                    if([currentObject isKindOfClass:[ProfileCell class]])
                                    {
                                        cell = (ProfileCell *)currentObject;
                                        break;
                                    }
                                }
                            }
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_email.png"]];
                            cell.customLbl.text = @"البريد الإلكتروني";
                            cell.customTitle.text = CurrentUser.emailAddress;
                            [cell.arrowImg setImage:nil];
                            // Configure the cell.
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                            
                            break;
                        }
                        case 2: {
                            
                            ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                            
                            if (cell == nil){
                                NSLog(@"New Cell Made");
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell_iPad" owner:nil options:nil];
                                
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
                            // Configure the cell.
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                            
                            break;
                        }
                        case 3: {
                            
                            ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                            
                            if (cell == nil){
                                NSLog(@"New Cell Made");
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell_iPad" owner:nil options:nil];
                                
                                for(id currentObject in topLevelObjects)
                                {
                                    if([currentObject isKindOfClass:[ProfileCell class]])
                                    {
                                        cell = (ProfileCell *)currentObject;
                                        break;
                                    }
                                }
                            }
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_changePass.png"]];
                            cell.customLbl.text = @"تغيير كلمة السر";
                            cell.customTitle.text = @"";
                            // Configure the cell.
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
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                            
                            break;
                        }
                    }
                    break;
                case 1:
                    switch ([indexPath row]) {
                        case 0:
                        {
                            ProfileCell *cell = (ProfileCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                            
                            if (cell == nil){
                                NSLog(@"New Cell Made");
                                
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell_iPad" owner:nil options:nil];
                                
                                for(id currentObject in topLevelObjects)
                                {
                                    if([currentObject isKindOfClass:[ProfileCell class]])
                                    {
                                        cell = (ProfileCell *)currentObject;
                                        break;
                                    }
                                }
                            }
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_signOut.png"]];
                            cell.customLbl.text = @"تسجيل الخروج";
                            cell.customTitle.text = @"";
                            cell.customLbl.textAlignment = NSTextAlignmentLeft;
                            cell.customLbl.textColor = [UIColor whiteColor];
                            cell.customLbl.font = [UIFont boldSystemFontOfSize:23];
                            cell.backgroundColor = [UIColor colorWithRed:114.0/255 green:115.0/255 blue:115.0/255 alpha:1.0f];
                            //cell.backgroundColor = [UIColor blackColor];
                            [cell.arrowImg setImage:nil];
                            // Configure the cell.
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                            
                            break;
                        }
                            
                        default:
                            break;
                    }
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
    return nil;
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (tableView == self.profileTable) {
            switch ([indexPath section]) {
                case 0:
                    switch ([indexPath row]) {
                        case 0:
                        {
                            ChangeNameViewController* vc = [[ChangeNameViewController alloc]initWithNibName:@"ChangeNameViewController" bundle:nil];
                            vc.theName = CurrentUser.userName;
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
                case 1:
                    switch ([indexPath row]) {
                        case 0:{
                            CountryListViewController* vc;
                            
                            vc = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController" bundle:nil];
                            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                            [self presentViewController:vc animated:YES completion:nil];
                            
                            return;
                            break;
                        }
                            
                        case 1:
                        {
                            
                            ChangePasswordViewController* vc = [[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:nil];
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
                case 2:
                {
                    //logout
                    
                    [self logout];
                    return;
                    break;
                }
                    
                default:
                    break;
            }
            
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else {  //iPad
        if (tableView == self.profileTable) {
            switch ([indexPath section]) {
                case 0:
                    switch ([indexPath row]) {
                        case 0:
                        {
                            [self.iPad_changeNameView setHidden:NO];
                            [self.iPad_changePasswordView setHidden:YES];
                            [self.iPad_changeCountryView setHidden:YES];
                            
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_user_inverted.png"]]
                            ;
                            [cell.arrowImg setImage:[UIImage imageNamed:@"arrow_inverted@2x.png"]];
                            return;
                            break;
                        }
                        case 1:
                        {
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_email_inverted.png"]];
                            return;
                            break;
                        }
                        case 2:{
                            [self.iPad_changeNameView setHidden:YES];
                            [self.iPad_changePasswordView setHidden:YES];
                            [self.iPad_changeCountryView setHidden:NO];
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_changecity_inverted.png"]];
                            [cell.arrowImg setImage:[UIImage imageNamed:@"arrow_inverted@2x.png"]];
                            return;
                            break;
                        }
                            
                        case 3:
                        {
                            
                            [self.iPad_changeNameView setHidden:YES];
                            [self.iPad_changePasswordView setHidden:NO];
                            [self.iPad_changeCountryView setHidden:YES];
                            
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_changePass_inverted.png"]];
                            [cell.arrowImg setImage:[UIImage imageNamed:@"arrow_inverted@2x.png"]];
                            return;
                            break;
                        }
                            
                        default:
                            [tableView deselectRowAtIndexPath:indexPath animated:YES];
                            return;
                            break;
                            
                    }
                case 1:
                    //logout
                    [self logout];
                    return;
                    break;
                    
                default:
                    break;
            }
            
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else {  //contries table
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
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (tableView == self.profileTable) {
            switch ([indexPath section]) {
                case 0:
                    switch ([indexPath row]) {
                        case 0: {
                            //username cell
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_user.png"]];
                            [cell.arrowImg setImage:[UIImage imageNamed:@"arrow@2x.png"]];
                            //cell.customLbl.text = @"إسم المستخدم";
                            break;
                        }
                        case 1: {
                            //email cell
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_email.png"]];
                            //cell.customLbl.text = @"البريد الإلكتروني";
                            
                            break;
                        }
                        case 2: {
                            //city cell
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_changecity.png"]];
                            [cell.arrowImg setImage:[UIImage imageNamed:@"arrow@2x.png"]];
                            //cell.customLbl.text = @"المدينة";
                            
                            break;
                        }
                        case 3: {
                            //change password cell
                            ProfileCell *cell = (ProfileCell*) [tableView cellForRowAtIndexPath:indexPath];
                            
                            [cell.iconImg setImage:[UIImage imageNamed:@"setting_changePass.png"]];
                            [cell.arrowImg setImage:[UIImage imageNamed:@"arrow@2x.png"]];
                            //cell.customLbl.text = @"تغيير كلمة السر";
                            
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                case 1:
                    break;
            }
        }
    }
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideLoadingIndicator];
}

-(void)logout
{
    @try {
    [self showLoadingIndicator];
    //[[LocationManager locationKeyChainItemSharedInstance] resetKeychainItem];
    [FBSession.activeSession closeAndClearTokenInformation];
    [[ProfileManager loginKeyChainItemSharedInstance] resetKeychainItem];
    
    iPad_isLoggingOut = YES;
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد تم تسجيل الخروج" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [self hideLoadingIndicator];
    [alert show];
    return;
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    @try {
    if (alertView.tag == 0) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            //[self dismissViewControllerAnimated:YES completion:nil];
            ChooseActionViewController *vc;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
            else
                vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:nil];
        }
        else {
            if (iPad_isLoggingOut) {
                iPad_isLoggingOut = NO;
                ChooseActionViewController *vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:vc animated:YES completion:nil];
                
            }
        }
    }
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
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

#pragma mark - iPad actions

- (IBAction)iPad_saveNameInvoked:(id)sender {
    [self iPad_dismissKeyboard];
    NSString* Name = self.iPad_userNameTextField.text;
    
    
    if ([Name length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من تعبئة الحقل"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self iPad_changeName:Name];
}

- (IBAction)iPad_savePwdInvoked:(id)sender {
    
    [self iPad_dismissKeyboard];
    
    CurrentUser = [[ProfileManager sharedInstance] getSavedUserProfile];
    
    
    NSString* oldPassword = self.iPad_oldPwdTextField.text;
    NSString* newPassword = self.iPad_newPwdTextField.text;
    NSString* newPassword2 = self.iPad_confirmPwdTextField.text;
    
    
    if ([oldPassword length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من كلمة السر القديمة"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([newPassword length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من كلمة السر الجديدة"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    if (![newPassword isEqualToString:newPassword2]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"كلمة السر غير متوافقة"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    [self showLoadingIndicator];
    [self iPad_changePwd:newPassword anduserName:CurrentUser.userName];
}

#pragma mark - iPad helper methods

- (void) iPad_dismissKeyboard {
    [self.iPad_userNameTextField resignFirstResponder];
    [self.iPad_oldPwdTextField resignFirstResponder];
    [self.iPad_newPwdTextField resignFirstResponder];
    [self.iPad_confirmPwdTextField resignFirstResponder];
}

- (void) iPad_changeName :(NSString*)name
{
    [self showLoadingIndicator];
    [[ProfileManager sharedInstance] updateUserWithDelegate:self userName:name andPassword:@""];
    
}

-(void)iPad_changePwd:(NSString*)newPwd anduserName:(NSString*)name
{
    
    [[ProfileManager sharedInstance] updateUserWithDelegate:self userName:name andPassword:newPwd];
}

//-------------------------------------------- COUNTRY LIST -------------------------------------
-(void)getThingsDone
{
    @try {
    if (citiesArray) {
        if ([CityIndex section] > 10) {
            [self.iPad_countriesTable scrollToRowAtIndexPath:CityIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getTheIndexDraw) userInfo:nil repeats:NO];
    }
    }
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
    
}

-(void)getTheIndexDraw
{
    @try {
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
    @catch (NSException *exception) {
        [[GAI sharedInstance].defaultTracker sendException:NO withNSException:exception];
    }
}
//-----------------------------------------------------------------------------------------------

#pragma mark - profileUpdate delegate methods

-(void)userUpdateWithData:(UserProfile *)newData
{
    //NSLog(@"%@",newData);
    [[ProfileManager sharedInstance] storeUserProfile:newData];
    [self hideLoadingIndicator];
    
    self.iPad_oldPwdTextField.text = @"";
    self.iPad_newPwdTextField.text = @"";
    self.iPad_confirmPwdTextField.text = @"";
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"تمت العملية بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [alert show];
    
    return;
}

-(void)userFailUpdateWithError:(NSError *)error {
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
            (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
            [self iPad_dismissKeyboard];
    }
}
@end
