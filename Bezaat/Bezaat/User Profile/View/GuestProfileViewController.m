//
//  GuestProfileViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/24/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GuestProfileViewController.h"

@interface GuestProfileViewController ()

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
                    CountryListViewController* vc = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController" bundle:nil];
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
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        loadingHUD.dimBackground = YES;
    else
        loadingHUD.dimBackground = NO;
    
}

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
