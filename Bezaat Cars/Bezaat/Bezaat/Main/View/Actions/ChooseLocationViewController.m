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
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
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
    
    [self loadData];
    
    
    //[locationMngr loadCountriesAndCitiesWithDelegate:self];
   
    //self initialize drop down lists
    [self initPickerViews];
    [citiesPickerView reloadAllComponents];
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
    
    [[LocationManager sharedInstance] storeDataOfCountry:chosenCountry.countryID city:chosenCity.cityID];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        //SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController5" bundle:nil];
        SignInViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController5" bundle:nil];
        else
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        //SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        SignInViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        else
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
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
    
    // Setting default country
    defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    if  (defaultIndex!= -1){
        chosenCountry =[countriesArray objectAtIndex:defaultIndex];//set initial chosen country
        citiesArray=[chosenCountry cities];
        if (citiesArray && citiesArray.count)
            chosenCity=[citiesArray objectAtIndex:0];//set initial chosen city
        [countriesPickerView reloadAllComponents];
        [citiesPickerView reloadAllComponents];
        [countriesPickerView selectRow:defaultIndex inComponent:0 animated:YES];
        [self translateMap:chosenCountry];
    }
    
}

#pragma mark - handler show indecator delegate
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
                [UIView beginAnimations:@"MoveAnimation" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:2.0];
                [mapImageView setTransform:translate];
                [UIView commitAnimations];
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
                [UIView beginAnimations:@"MoveAnimation" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:2.0];
                [mapImageView setTransform:translate];
                [UIView commitAnimations];
                countryImage=[[UIImageView alloc] initWithFrame:CGRectMake([country xCoord]+5, [country yCoord]+1,temp.size.width, temp.size.height)];
            }
        }
        countryImage.image=temp;
        
    }
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(addCountryImageToMap)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) addCountryImageToMap{
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
    [countriesPickerView reloadAllComponents];
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
    
    if (![GenericMethods connectedToInternet])
    {
        [LocationManager sharedInstance].deviceLocationCountryCode = @"";
        [locationMngr loadCountriesAndCitiesWithDelegate:self];
        return;
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) ||
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized))
        {
            if (!deviceLocationDetector)
                deviceLocationDetector = [[CLLocationManager alloc] init];
            
            [self showLoadingIndicator];
            deviceLocationDetector.delegate = self;
            deviceLocationDetector.distanceFilter = 500;
            deviceLocationDetector.desiredAccuracy = kCLLocationAccuracyKilometer;
            deviceLocationDetector.pausesLocationUpdatesAutomatically = YES;
            
            [deviceLocationDetector startUpdatingLocation];
        }
        else
        {
            [LocationManager sharedInstance].deviceLocationCountryCode = @"";
            [locationMngr loadCountriesAndCitiesWithDelegate:self];
        }
    }
    else
    {
        [LocationManager sharedInstance].deviceLocationCountryCode = @"";
        [locationMngr loadCountriesAndCitiesWithDelegate:self];
    }
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
        //NSLog(@"city: %@", mark.locality);
        //NSLog(@"subcity: %@", mark.subLocality);
        
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

    else {
      
        [label setText:[[citiesArray objectAtIndex:row] cityName]];
        return label;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==countriesPickerView) {
        chosenCountry=[countriesArray objectAtIndex:row];
        citiesArray=[chosenCountry cities];
        if (citiesArray && citiesArray.count)
            chosenCity=[citiesArray objectAtIndex:0];//set initial chosen city
        [self translateMap:chosenCountry];
        [citiesPickerView reloadAllComponents];
    }
    else{
        chosenCity=[citiesArray objectAtIndex:row];
    }
}
@end