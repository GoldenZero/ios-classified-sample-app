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
    }
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"User profile screen"];
    [TestFlight passCheckpoint:@"User profile screen"];
    //end GA
    
}

-(void)viewWillAppear:(BOOL)animated
{
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
                break;
                //return;
            }
        }
    }
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
- (void) userDidLoginWithData:(UserProfile *)resultProfile {
    
    //save user's data
    [[ProfileManager sharedInstance] storeUserProfile:resultProfile];
    [self hideLoadingIndicator];
    [self.profileTable setNeedsDisplay];
    [self.profileTable reloadData];
}

- (void) userFailLoginWithError:(NSError *)error {
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (tableView == self.profileTable)
            return 3;
        return 0;
    }
    else {
        if (tableView == self.profileTable)
            return 2;
        else
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
            return 000;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                    cell.customLbl.font = [UIFont boldSystemFontOfSize:25];
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
    else {
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
                        case 2: {
                            
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
                        case 3: {
                            
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
                case 1:
                    switch ([indexPath row]) {
                        case 0:
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
                            cell.customLbl.font = [UIFont boldSystemFontOfSize:25];
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
                    break;
            }
            
            return nil;
        }
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                            
                            return;
                            break;
                        }
                        case 2:{
                            [self.iPad_changeNameView setHidden:YES];
                            [self.iPad_changePasswordView setHidden:YES];
                            [self.iPad_changeCountryView setHidden:NO];
                            return;
                            break;
                        }
                            
                        case 3:
                        {
                            
                            [self.iPad_changeNameView setHidden:YES];
                            [self.iPad_changePasswordView setHidden:NO];
                            [self.iPad_changeCountryView setHidden:YES];
                            
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
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideLoadingIndicator];
}

-(void)logout
{
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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

#pragma mark - 

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationPortrait;
    else
        return UIInterfaceOrientationLandscapeLeft;
}
@end
