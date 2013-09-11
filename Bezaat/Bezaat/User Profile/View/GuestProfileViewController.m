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

    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"User profile screen"];
    [TestFlight passCheckpoint:@"User profile screen"];
    
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
    
    
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                    
                    [cell.iconImg setImage:[UIImage imageNamed:@"setting_changecity.png"]];
                    cell.customLbl.text = @"المدينة";
                    cell.customTitle.text = defaultCityName;
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
                   
        default:
            break;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

@end
