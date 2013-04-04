#import "ChooseLocationViewController.h"
#import "BaseDataObject.h"
#import "GenericFonts.h"
#import "Country.h"
#import <AddressBook/AddressBook.h>


@interface ChooseLocationViewController ()
{
    UIPickerView *countriesPickerView;
    UIPickerView *citiesPickerView;
    
    NSUInteger defaultIndex;
    
    NSArray * countriesArray;
    NSArray * citiesArray;
    
    Country * chosenCountry;
    City * chosenCity;
    
    BOOL countryChosen;
    BOOL cityChosen;
    
    LocationManager * locationMngr;
    CLLocationManager * deviceLocationDetector;
    
    MBProgressHUD2 * loadingHUD;
   
    UIImageView *mapImageView;
    UIImageView *countryImage;
    
    CGPoint COUNTRIES_DROPDOWNLIST_ORIGIN;//
    CGPoint CITIES_DROPDOWNLIST_ORIGIN;//
    
}
@end

@implementation ChooseLocationViewController
@synthesize nextBtn, backgroungImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        countryChosen = NO;
        cityChosen = NO;
        citiesPickerView.delegate=self;
        countriesPickerView.delegate=self;
    }
    return self;
}

- (void)viewDidLoad
{
    // Set view.
    [self checkIphoneFive];
    [nextBtn setEnabled:YES];
    [self setBackgroundImages];
    
    // Location Manager
    locationMngr = [LocationManager sharedInstance];
    [self showLoadingIndicator];
    
    [self loadData];

    // Setting default country
    defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    chosenCountry =[countriesArray objectAtIndex:defaultIndex];
    citiesArray=[chosenCountry cities];
    
    [self translateMap:chosenCountry];
    //[locationMngr loadCountriesAndCitiesWithDelegate:self];
   
    //self initialize drop down lists
    [self initPickerViews];
    
}
- (void) didFinishLoading {
    [countriesPickerView selectRow:defaultIndex inComponent:1 animated:NO];
    [citiesPickerView selectRow:0 inComponent:1 animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)nextBtnPressed:(id)sender {
    [SharedUser sharedInstance].country = chosenCountry;
    [SharedUser sharedInstance].city = chosenCity;
    
    SignInViewController * signInVC = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [self presentViewController:signInVC animated:YES completion:nil];
}

#pragma mark - custom methods
- (void) checkIphoneFive{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
            
        {
            COUNTRIES_DROPDOWNLIST_ORIGIN.x= 30.0;
            COUNTRIES_DROPDOWNLIST_ORIGIN.y= 255.0;
            CITIES_DROPDOWNLIST_ORIGIN.x=30.0;
            CITIES_DROPDOWNLIST_ORIGIN.y=315.0;
        }
        
        if(result.height == 568)
            
        {
            COUNTRIES_DROPDOWNLIST_ORIGIN.x= 30.0;
            COUNTRIES_DROPDOWNLIST_ORIGIN.y= 340.0;
            CITIES_DROPDOWNLIST_ORIGIN.x=30.0;
            CITIES_DROPDOWNLIST_ORIGIN.y=400.0;
        }
    }
    
}

- (void) setBackgroundImages{

    // set map view
   if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        mapImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 2844, 1983)];
    }
   else {
        mapImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 1427, 993)];

   }
    mapImageView.image=[UIImage imageNamed:@"location_map.png"];
    [self.backgroungImageView addSubview:mapImageView ];


}

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countriesArray=resultArray;
    [self hideLoadingIndicator];
    
}

#pragma mark - handler show indecator delegate
- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
    
}

- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
}

#pragma mark - helper methods

- (void) translateMap : (Country*) country {
    
    // screen dimensions
    CGSize screenBounds = [[UIScreen mainScreen] bounds].size;
    float screenWidth=screenBounds.width;
    
    countryImage.image=nil;
    int countryid=[country countryID];
    
    // Init coutry image
    UIImage *temp;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        NSString *imagePath=[NSString stringWithFormat:@"%d_country@2x.png",countryid];
        temp =[UIImage imageNamed:imagePath];
        if (temp) {
            if ([country xCoord]!=-1) {
                CGAffineTransform translate = CGAffineTransformMakeTranslation((-[country xCoord]+((screenWidth/2)-(temp.size.width/2))), (-[country yCoord]+130));
                [mapImageView setTransform:translate];
                countryImage=[[UIImageView alloc] initWithFrame:CGRectMake([country xCoord], [country yCoord],temp.size.width, temp.size.height)];
            }
        }
        countryImage.image=temp;
    }
    else
    {
        NSString *imagePath=[NSString stringWithFormat:@"%d_country.png",countryid];
        temp =[UIImage imageNamed:imagePath];
        if (temp) {
            if ([country xCoord]!=-1) {
                CGAffineTransform translate = CGAffineTransformMakeTranslation((-[country xCoord]+((screenWidth/2)-(temp.size.width/2))), (-[country yCoord]+130));
                [mapImageView setTransform:translate];
                countryImage=[[UIImageView alloc] initWithFrame:CGRectMake([country xCoord]+5, [country yCoord]+1,temp.size.width, temp.size.height)];
            }
        }
        countryImage.image=temp;
        
    }
    [mapImageView addSubview:countryImage];
    [mapImageView insertSubview:countryImage aboveSubview:mapImageView];
    

    
}

- (void) initPickerViews {

    // 1- set the countries picker
    countriesPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 600, 80.0)];
    countriesPickerView.delegate = self;
    countriesPickerView.showsSelectionIndicator = YES;
    
    // 2- set scaling and trnsformation for countries picker
    CGAffineTransform s0 = CGAffineTransformMakeScale       (0.4, 0.36);
    CGAffineTransform t1 = CGAffineTransformMakeTranslation (-100-COUNTRIES_DROPDOWNLIST_ORIGIN.x, COUNTRIES_DROPDOWNLIST_ORIGIN.y);
    countriesPickerView.transform =  CGAffineTransformConcat(s0, t1);
    
    [self.view addSubview:countriesPickerView];
    
    // 3- set the cities picker
    citiesPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 600, 80.0)];
    citiesPickerView.delegate = self;
    citiesPickerView.showsSelectionIndicator = YES;
    
    // 4- set scaling and trnsformation for cities picker
    CGAffineTransform t2 = CGAffineTransformMakeTranslation (-100-CITIES_DROPDOWNLIST_ORIGIN.x, CITIES_DROPDOWNLIST_ORIGIN.y);
    citiesPickerView.transform =  CGAffineTransformConcat(s0, t2);
    
    [self.view addSubview:citiesPickerView];

    
}

// This method loads the device location initialli, and afterwards the loading of country lists comes after
- (void) loadData {
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) ||
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized))
        {
            if (!deviceLocationDetector)
                deviceLocationDetector = [[CLLocationManager alloc] init];
            
            deviceLocationDetector.delegate = self;
            deviceLocationDetector.distanceFilter = 500;
            deviceLocationDetector.desiredAccuracy = kCLLocationAccuracyKilometer;
            deviceLocationDetector.pausesLocationUpdatesAutomatically = YES;
            
            [deviceLocationDetector startUpdatingLocation];
        }
        else
            [LocationManager sharedInstance].deviceLocationCountryCode = @"";
    }
    else
        [LocationManager sharedInstance].deviceLocationCountryCode = @"";
}

#pragma  mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [deviceLocationDetector stopUpdatingLocation];
    
    //currentLocation = newLocation;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        MKPlacemark * mark = [[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
        NSString * code = mark.countryCode;
        //NSLog(@"city: %@", [mark.addressDictionary objectForKey:kABPersonAddressCityKey]);
        NSLog(@"city: %@", mark.locality);
        NSLog(@"subcity: %@", mark.subLocality);
        
        //NSLog(@"%@", code);
        
        [LocationManager sharedInstance].deviceLocationCountryCode = code;
        
        [locationMngr loadCountriesAndCitiesWithDelegate:self];
        
        //self initialize drop down lists
        [countriesPickerView reloadAllComponents];
        [citiesPickerView reloadAllComponents];
        
        /*
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Horraaay!" message:[NSString stringWithFormat:@"NewLocation %f %f, code = %@", newLocation.coordinate.latitude, newLocation.coordinate.longitude, code] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
         */
    }];
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    
    [deviceLocationDetector stopUpdatingLocation];
    
    [LocationManager sharedInstance].deviceLocationCountryCode = @"";
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    //self initialize drop down lists
   
    [countriesPickerView reloadAllComponents];
    [citiesPickerView reloadAllComponents];
}

#pragma mark - UIPicker view handler
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==countriesPickerView) {
        return countriesArray.count;
    }
    else{
        return citiesArray.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // set label
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 50.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:30.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    if (pickerView==countriesPickerView){
       
        [label setText:[[countriesArray objectAtIndex:row]countryName]];
        return label;
    }

    else if (pickerView==citiesPickerView){
      
        [label setText:[[[chosenCountry cities] objectAtIndex:row] cityName]];
        return label;
    }
return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==countriesPickerView) {
        chosenCountry=[countriesArray objectAtIndex:row];
        citiesArray=[chosenCountry cities];
        [self translateMap:chosenCountry];
        [countriesPickerView reloadAllComponents];
        [citiesPickerView reloadAllComponents];
    }
    else{
        chosenCity=[citiesArray objectAtIndex:row];
    }
}
@end