//
//  AddNewStoreAdViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/29/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewStoreAdViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "labelAdViewController.h"
#import "StaticAttrsLoader.h"

#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)


@interface AddNewStoreAdViewController (){
    
    UITapGestureRecognizer *tap1;
    UITapGestureRecognizer *tap2;
    
    // Arrays
    NSArray *globalArray;
    NSArray *currencyArray;
    NSArray *productionYearArray;
    NSArray *countryArray;
    NSArray *cityArray;
    NSArray *kiloMileArray;

    NSArray *carConditionArray;
    NSArray *gearTypeArray;
    NSArray *carTypeArray;
    NSArray *carBodyArray;
    
    NSMutableArray* allUserStore;
    
    NSInteger defaultCityID;
    NSString* defaultCityName;
    
    NSInteger defaultCountryID;
    NSString* defaultCountryName;
    
    NSInteger defaultStoreIndex;
    NSInteger myAdID;

    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;
    int chosenImgBtnTag;
    UIImage * currentImageToUpload;
    LocationManager * locationMngr;
    CLLocationManager * deviceLocationDetector;
    
    NSUInteger defaultIndex;
    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenYear;
    City * chosenCity;
    Country * chosenCountry;
    Country * myCountry;
    Store* myStore;
    
    
    bool kiloChoosen;
    bool conditionchoosen;
    int gearchoosen;
    int typechoosen;
    SingleValue * chosenBody;
    
    NSMutableArray * currentImgsUploaded;
    BOOL locationBtnPressedOnce;
    BOOL currencyBtnPressedOnce;
    BOOL yearBtnPressedOnce;
    BOOL bodyBtnPressedOnce;
    BOOL storeBtnPressedOnce;
    
    NSTimer *timer;
    IBOutlet UITextField *placeholderTextField;
    NSUInteger defaultCurrencyID;
    NSUInteger defaultcurrecncyIndex;

}



@end

@implementation AddNewStoreAdViewController
@synthesize carAdTitle,mobileNum,distance,carDetails,carPrice,countryCity,currency,kiloMile,productionYear,condition,gear,body,type,theStore;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        globalArray=[[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    gearchoosen = 0;
    typechoosen = 0;
    
    allUserStore = [[NSMutableArray alloc]init];
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getUserStores];

    
    locationMngr = [LocationManager sharedInstance];
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    countryArray=[locationMngr getTotalCountries];
    
    
    if (countryArray && countryArray.count)
    {
        if (self.currentStore) {
            defaultIndex = [locationMngr getIndexOfCountry:self.currentStore.countryID];
        }else
        defaultIndex = [locationMngr getIndexOfCountry:[[SharedUser sharedInstance] getUserCountryID]];
        
        if  (defaultIndex!= -1){
            chosenCountry =[countryArray objectAtIndex:defaultIndex];
            cityArray=[chosenCountry cities];
            if (self.currentStore) {
               defaultCountryID = self.currentStore.countryID; 
            }else
            defaultCountryID = [[SharedUser sharedInstance] getUserCountryID];
            defaultCityID =  ((City *)chosenCountry.cities[0]).cityID;
        }
        
    }
    for (int i =0; i <= [countryArray count] - 1; i++) {
        chosenCountry=[countryArray objectAtIndex:i];
        if (chosenCountry.countryID == defaultCountryID) {
            cityArray=[chosenCountry cities];
            for (City* cit in cityArray) {
                if (cit.cityID == defaultCityID)
                {
                    myCountry = [countryArray objectAtIndex:i];
                    defaultCityID = [cityArray indexOfObject:cit];
                    chosenCity =[cityArray objectAtIndex:defaultCityID];
                    break;
                    //return;
                }
            }
        }
        
    }
    
    [self.locationPickerView reloadAllComponents];

    /*
    defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    if  (defaultIndex!= -1){
        chosenCountry =[countryArray objectAtIndex:defaultIndex];
        cityArray=[chosenCountry cities];
    }

    defaultCityID =  [[LocationManager sharedInstance] getSavedUserCityID];
    defaultCountryID = [[LocationManager sharedInstance] getSavedUserCountryID];
    NSLog(@"%i",defaultCityID);
    */
    
    //[locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    // Set the image piacker
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
    currentImgsUploaded = [NSMutableArray new];
    
    // Set the scroll view indicator
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(indicator:) userInfo:nil repeats:YES];
    
    // Set tapping gesture
    tap1 = [[UITapGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(dismissKeyboard)];
    [self.horizontalScrollView addGestureRecognizer:tap1];
    
    tap2 = [[UITapGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(dismissKeyboard)];
    [self.verticalScrollView addGestureRecognizer:tap2];
    
    
    locationBtnPressedOnce = NO;
    currencyBtnPressedOnce = NO;
    yearBtnPressedOnce = NO;
    bodyBtnPressedOnce = NO;
    storeBtnPressedOnce = NO;
    
    [self loadDataArray];
    [self addButtonsToXib];
    [self setImagesArray];
    [self setImagesToXib];
    
    [self closePicker];
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Create Store Ad screen"];
    //end GA
}

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    [self closePicker];
    [self.pickersView setHidden:YES];
}
-(void)indicator:(BOOL)animated{
    
    [self.horizontalScrollView flashScrollIndicators];
    
}
#pragma mark - location handler.
- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    [self hideLoadingIndicator];
    countryArray=resultArray;
}
/*
#pragma mark - location handler.
- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    [self hideLoadingIndicator];
    countryArray=resultArray;
    
    
    if (resultArray && resultArray.count)
    {
        defaultIndex = [locationMngr getIndexOfCountry:self.currentStore.countryID];
        
        if  (defaultIndex!= -1){
            chosenCountry =[countryArray objectAtIndex:defaultIndex];
            cityArray=[chosenCountry cities];
            defaultCountryID = self.currentStore.countryID;
            defaultCityID =  ((City *)chosenCountry.cities[0]).cityID;
        }
        
    }
    for (int i =0; i <= [countryArray count] - 1; i++) {
        chosenCountry=[countryArray objectAtIndex:i];
        if (chosenCountry.countryID == defaultCountryID) {
            cityArray=[chosenCountry cities];
            for (City* cit in cityArray) {
                if (cit.cityID == defaultCityID)
                {
                    myCountry = [countryArray objectAtIndex:i];
                    defaultCityID = [cityArray indexOfObject:cit];
                    chosenCity =[cityArray objectAtIndex:defaultCityID];
                    break;
                    //return;
                }
            }
        }
        
    }
    
    [self.locationPickerView reloadAllComponents];
}
*/
// This method loads the device location initialli, and afterwards the loading of country lists comes after
/*
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [deviceLocationDetector stopUpdatingLocation];
    
    //currentLocation = newLocation;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        MKPlacemark * mark = [[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
        NSString * code = mark.countryCode;
        
        [LocationManager sharedInstance].deviceLocationCountryCode = code;
        
        [locationMngr loadCountriesAndCitiesWithDelegate:self];
        
        //self initialize drop down lists
        [self.locationPickerView reloadAllComponents];
        
    }];
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    
    [deviceLocationDetector stopUpdatingLocation];
    
    [LocationManager sharedInstance].deviceLocationCountryCode = @"";
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
}
*/
- (void) loadDataArray{
    productionYearArray=[[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadModelYearValues]];
    currencyArray= [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    kiloMileArray=[[NSArray alloc] initWithObjects:@"كم",@"ميل", nil];
    carConditionArray = [[NSArray alloc] initWithObjects:@"مستعمل",@"جديد", nil];
    gearTypeArray = [[NSArray alloc] initWithObjects:@"عادي",@"اتوماتيك",@"تريبتونيك", nil];
    carTypeArray = [[NSArray alloc] initWithObjects:@"امامي",@"خلفي",@"4x4", nil];
    carBodyArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadBodyValues]];
   
    defaultCurrencyID=[[StaticAttrsLoader sharedInstance] getCurrencyIdOfCountry:[[SharedUser sharedInstance] getUserCountryID]];
    defaultcurrecncyIndex=0;
    while (defaultcurrecncyIndex<currencyArray.count) {
        if (defaultCurrencyID==[(SingleValue*)[currencyArray objectAtIndex:defaultcurrecncyIndex] valueID]) {
            break;
        }
        defaultcurrecncyIndex++;
    }
    chosenCurrency=[currencyArray objectAtIndex:defaultcurrecncyIndex];

    [self.modelNameLabel setText:self.currentModel.modelName];
    kiloChoosen=true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper methods
- (void) setImagesToXib{
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
}

- (void) setImagesArray{
    
    [self.horizontalScrollView setContentSize:CGSizeMake(640, 119)];
    [self.horizontalScrollView setScrollEnabled:YES];
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:YES];
    
    for (int i=0; i<6; i++) {
        UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(95*i), 20, 77, 70)];
        [temp setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
        
        temp.tag = (i+1) * 10;
        [temp addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.horizontalScrollView addSubview:temp];
    }
}

- (void) uploadImage: (id)sender{
    
    UIButton * senderBtn = (UIButton *) sender;
    chosenImgBtnTag = senderBtn.tag;
    
    //display the action sheet for choosing 'existing photo' or 'use camera'
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"التقط صورة", @"اختر صورة", nil];
    
    [actionSheet showInView:self.view];
}

-(void) TakePhotoWithCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        static UIImagePickerController *picker = nil;
        if (!picker)
            picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void) SelectPhotoFromLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void) useImage:(UIImage *) image {
    
    currentImageToUpload = image;
    [self showLoadingIndicatorOnImages];
    [[CarAdsManager sharedInstance] uploadImage:image WithDelegate:self];
    
}

-(void)dismissKeyboard {
    [self closePicker];
    [carAdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [carPrice resignFirstResponder];
    [distance resignFirstResponder];
    [carDetails resignFirstResponder];
}

-(void)cancelNumberPad{
    [mobileNum resignFirstResponder];
    mobileNum.text = @"";
}

-(void)doneWithNumberPad{
    [mobileNum resignFirstResponder];
}


- (void) addButtonsToXib{
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 650)];
    [self.verticalScrollView setScrollEnabled:YES];
    [self.verticalScrollView setShowsVerticalScrollIndicator:YES];
    
    theStore=[[UIButton alloc] initWithFrame:CGRectMake(30,20 ,260 ,30)];
    [theStore setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [theStore setTitle:@"اختر المتجر" forState:UIControlStateNormal];
    // TODO set the Store to the current
    if (self.currentStore) {
        
    }
    [theStore setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [theStore addTarget:self action:@selector(chooseStore) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:theStore];
    
    countryCity=[[UIButton alloc] initWithFrame:CGRectMake(30,60,260 ,30)];
    [countryCity setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [countryCity setTitle:@"اختر البلد" forState:UIControlStateNormal];
    [countryCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [countryCity addTarget:self action:@selector(chooseCountryCity) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:countryCity];
    
    carAdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30,100,260 ,30)];
    [carAdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [carAdTitle setTextAlignment:NSTextAlignmentRight];
    [carAdTitle setPlaceholder:@"عنوان الإعلان"];
//    [carAdTitle setKeyboardType:UIKeyboardTypeAlphabet];
    [self.verticalScrollView addSubview:carAdTitle];
    carAdTitle.delegate=self;
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,140 ,260 ,80 )];
//[carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setBackgroundColor:[UIColor clearColor]];
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [carDetails setFont:[UIFont systemFontOfSize:17]];
    carDetails.delegate =self;
    
    placeholderTextField=[[UITextField alloc] initWithFrame:CGRectMake(30,140 ,260 ,30)];
    [placeholderTextField setTextAlignment:NSTextAlignmentRight];
    [placeholderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    CGRect frame = placeholderTextField.frame;
    frame.size.height = carDetails.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"تفاصيل الإعلان";
    [self.verticalScrollView addSubview:placeholderTextField];
    [self.verticalScrollView addSubview:carDetails];

    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,240 ,260 ,30)];  //610
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    mobileNum.delegate=self;
    
    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,290 ,160 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر (اختياري)"];
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    carPrice.delegate=self;
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 290, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_SM.png"] forState:UIControlStateNormal];
    [currency setTitle:@"العملة    " forState:UIControlStateNormal];
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];
    
    distance=[[UITextField alloc] initWithFrame:CGRectMake(130,350 ,160 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة المقطوعة"];
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];
    distance.delegate=self;
    
    kiloMile = [[UISegmentedControl alloc] initWithItems:kiloMileArray];
    kiloMile.frame = CGRectMake(30, 350, 80, 30);
    kiloMile.segmentedControlStyle = UISegmentedControlStylePlain;
    kiloMile.selectedSegmentIndex = 0;
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [kiloMile setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:kiloMile];
    
    condition = [[UISegmentedControl alloc] initWithItems:carConditionArray];
    condition.frame = CGRectMake(30, 410, 260, 40);
    condition.segmentedControlStyle = UISegmentedControlStylePlain;
    condition.selectedSegmentIndex = 0;
    [condition setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [condition addTarget:self action:@selector(chooseCarCondition) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:condition];
    
    gear = [[UISegmentedControl alloc] initWithItems:gearTypeArray];
    gear.frame = CGRectMake(30, 470, 260, 40);
    gear.segmentedControlStyle = UISegmentedControlStylePlain;
    gear.selectedSegmentIndex = 0;
    [gear setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [gear addTarget:self action:@selector(chooseGearType) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:gear];
    
    type = [[UISegmentedControl alloc] initWithItems:carTypeArray];
    type.frame = CGRectMake(30, 520, 260, 40);
    type.segmentedControlStyle = UISegmentedControlStylePlain;
    type.selectedSegmentIndex = 0;
    [type setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [type addTarget:self action:@selector(chooseCarType) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:type];
    
    body =[[UIButton alloc] initWithFrame:CGRectMake(30, 570, 260, 30)];
    [body setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [body setTitle:@"هيكل السيارة" forState:UIControlStateNormal];
    [body addTarget:self action:@selector(chooseBody) forControlEvents:UIControlEventTouchUpInside];
    [body setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:body];
    
    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 610, 260, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:@"عام الصنع" forState:UIControlStateNormal];
    [productionYear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [productionYear addTarget:self action:@selector(chooseProductionYear) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:productionYear];
    
    
   
    
    
}

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
    
}

- (void) showLoadingIndicatorOnImages {
    imgsLoadingHUD = [MBProgressHUD2 showHUDAddedTo:self.horizontalScrollView animated:YES];
    imgsLoadingHUD.mode = MBProgressHUDModeCustomView2;
    imgsLoadingHUD.labelText = @"";
    imgsLoadingHUD.detailsLabelText = @"";
    imgsLoadingHUD.dimBackground = YES;
    imgsLoadingHUD.opacity = 0.5;
}

- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
}

- (void) hideLoadingIndicatorOnImages {
    
    if (imgsLoadingHUD)
        [MBProgressHUD2 hideHUDForView:self.horizontalScrollView  animated:YES];
    imgsLoadingHUD = nil;
    
}
- (void) postTheAd {
    //call the post ad back end method
}

- (NSInteger) idForKilometerAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadDistanceValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"كم"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}


- (NSInteger) idForMileAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadDistanceValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"ميل"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

// for car condition
- (NSInteger) idForConditionNewAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadConditionValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"جديد"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

- (NSInteger) idForConditionUsedAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadConditionValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"مستعمل"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

// for gear type
- (NSInteger) idForGearNormalAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadGearValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"عادي"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

- (NSInteger) idForGearAutoAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadGearValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"اتوماتيك"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

- (NSInteger) idForGearTronicAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadGearValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"تريبتونيك"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}


// for car type
- (NSInteger) idForTypeFrontAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadCarTypeValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"امامي"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

- (NSInteger) idForTypeBackAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadCarTypeValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"خلفي"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

- (NSInteger) idForTypeFourAttribute {
    NSArray * mileageAttrs = [[StaticAttrsLoader sharedInstance] loadCarTypeValues];
    
    for (int i = 0; i < mileageAttrs.count; i++)
    {
        SingleValue * v = [mileageAttrs objectAtIndex:i];
        if ([v.valueString rangeOfString:@"4x4"].location != NSNotFound)
            return v.valueID;
    }
    return -1;
}

#pragma mark - picker methods

-(IBAction)closePicker
{
    [self.pickersView setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                            [[UIScreen mainScreen] bounds].size.height,
                                            self.pickersView.frame.size.width,
                                            self.pickersView.frame.size.height);
    }];
}

-(IBAction)showPicker
{
    [carAdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [carPrice resignFirstResponder];
    [distance resignFirstResponder];
    [carDetails resignFirstResponder];
    
    [self.pickersView setHidden:NO];
    [self.pickersView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                            [[UIScreen mainScreen] bounds].size.height-self.self.pickersView.frame.size.height,
                                            self.pickersView.frame.size.width,
                                            self.pickersView.frame.size.height);
    }];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if (pickerView==_locationPickerView) {
        return 1;
    }else if (pickerView == _bodyPickerView){
        return 1;
    }else if (pickerView == _storePickerView){
        return 1;
    }
    else {
        return 1;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==_locationPickerView) {
        cityArray=[myCountry cities];
        chosenCity=[cityArray objectAtIndex:row];
        NSString *temp= [NSString stringWithFormat:@"%@ : %@", myCountry.countryName , chosenCity.cityName];
        [countryCity setTitle:temp forState:UIControlStateNormal];
        locationBtnPressedOnce = YES;
        
    }else if (pickerView == _bodyPickerView)
    {
        SingleValue *choosen=[globalArray objectAtIndex:row];
        if ([carBodyArray containsObject:choosen]) {
            chosenBody=[globalArray objectAtIndex:row];
            [body setTitle:choosen.valueString forState:UIControlStateNormal];
        }
        bodyBtnPressedOnce = YES;

    }else if (pickerView == _storePickerView){
        myStore = [allUserStore objectAtIndex:row];
        [theStore setTitle:myStore.name forState:UIControlStateNormal];
        storeBtnPressedOnce = YES;
    }
    else {
        SingleValue *choosen=[globalArray objectAtIndex:row];
        if ([currencyArray containsObject:choosen]) {
            chosenCurrency=[globalArray objectAtIndex:row];
            [currency setTitle:choosen.valueString forState:UIControlStateNormal];
            currencyBtnPressedOnce = YES;
        }
        else{
            chosenYear=[globalArray objectAtIndex:row];
            [productionYear setTitle:[NSString stringWithFormat:@"%@",choosen.valueString] forState:UIControlStateNormal];
            yearBtnPressedOnce = YES;
        }
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==_locationPickerView) {
        
        return [cityArray count];
    
    }
    else if (pickerView==_bodyPickerView) {
        return [globalArray count];
        
    }else if (pickerView == _storePickerView)
    {
        return [allUserStore count];
    }
    else
    {
        return [globalArray count];
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView ==_locationPickerView) {
            City *temp=(City*)[cityArray objectAtIndex:row];
            return temp.cityName;
    }else if (pickerView == _bodyPickerView){
        return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
    }else if (pickerView == _storePickerView){
        myStore = [allUserStore objectAtIndex:row];
        return myStore.name;
    }
    else {
        return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
    }
    
    
}

#pragma mark - Buttons Actions


-(void)chooseStore
{
    self.locationPickerView.hidden=YES;
    self.bodyPickerView.hidden = YES;
    self.pickerView.hidden=YES;
    self.storePickerView.hidden = NO;
    [self dismissKeyboard];
    
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(Store*)[allUserStore objectAtIndex:0] name]];
    [theStore setTitle:temp forState:UIControlStateNormal];
    
    // fill picker with production year
    globalArray=allUserStore;
    //[self.pickerView reloadAllComponents];
    [self.storePickerView reloadAllComponents];
    if (!storeBtnPressedOnce)
    {
        [self.storePickerView selectRow:defaultStoreIndex inComponent:0 animated:YES];
        
        if (globalArray && globalArray.count)
            myStore = (Store *)[globalArray objectAtIndex:0];
    }

    [self showPicker];
}

- (void) chooseProductionYear{
    
    self.locationPickerView.hidden=YES;
    self.bodyPickerView.hidden = YES;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=NO;
    [self dismissKeyboard];
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)[productionYearArray objectAtIndex:0] valueString]];
    [productionYear setTitle:temp forState:UIControlStateNormal];
    
    // fill picker with production year
    globalArray=productionYearArray;
    [self.pickerView reloadAllComponents];
    if (!yearBtnPressedOnce)
    {
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenYear = (SingleValue *)[globalArray objectAtIndex:0];
    }

    [self showPicker];
    
}

- (void) chooseCurrency{
    
    self.locationPickerView.hidden=YES;
    self.bodyPickerView.hidden = YES;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=NO;
    [self dismissKeyboard];

   NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)chosenCurrency valueString]];
    [currency setTitle:temp forState:UIControlStateNormal];
    // fill picker with currency options
    globalArray=currencyArray;
    [self.pickerView reloadAllComponents];
    
    if (!currencyBtnPressedOnce)
    {
        [self.pickerView selectRow:defaultcurrecncyIndex inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenCurrency = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self showPicker];
    
}

- (void) chooseCountryCity{
    
    self.locationPickerView.hidden=NO;
    self.pickerView.hidden=YES;
    self.bodyPickerView.hidden = YES;
    self.storePickerView.hidden = YES;
    [self dismissKeyboard];

    
    NSString *temp= [NSString stringWithFormat:@"%@ :%@", myCountry.countryName , chosenCity.cityName];
    [countryCity setTitle:temp forState:UIControlStateNormal];
    
    [self.locationPickerView reloadAllComponents];
    if (!locationBtnPressedOnce)
    {
        if (defaultIndex!=-1) {
            [self.locationPickerView selectRow:defaultIndex inComponent:0 animated:YES];
            
            
        }
    }
    
    [self showPicker];
    
}

- (void) chooseKiloMile{
    if (kiloMile.selectedSegmentIndex==0) {
        kiloChoosen=true;
    }
    else if (kiloMile.selectedSegmentIndex==1){
        
        kiloChoosen=false;
    }
    
}

-(void)chooseCarCondition
{
    if (condition.selectedSegmentIndex==0) {
        conditionchoosen=true;
    }
    else if (condition.selectedSegmentIndex==1){
        
        conditionchoosen=false;
    }
}

-(void) chooseGearType
{
    if (gear.selectedSegmentIndex==0) {
        gearchoosen = 0;
    }
    else if (gear.selectedSegmentIndex==1){
        
        gearchoosen = 1;
    }
    else if (gear.selectedSegmentIndex==2){
        
        gearchoosen = 2;
    }
}

-(void) chooseCarType
{
    if (type.selectedSegmentIndex==0) {
        typechoosen=0;
    }
    else if (type.selectedSegmentIndex==1){
        
        typechoosen=1;
    }
    else if (type.selectedSegmentIndex==2){
        
        typechoosen=2;
    }
}

-(void) chooseBody
{
    self.locationPickerView.hidden=YES;
    self.pickerView.hidden=YES;
    self.storePickerView.hidden = YES;
    self.bodyPickerView.hidden = NO;
    [self dismissKeyboard];
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)[carBodyArray objectAtIndex:0] valueString]];
    [body setTitle:temp forState:UIControlStateNormal];
    // fill picker with currency options
    globalArray=carBodyArray;
    [self.bodyPickerView reloadAllComponents];
    if (!bodyBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            chosenBody = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self showPicker];
}

- (IBAction)doneBtnPrss:(id)sender {
    [self closePicker];
}

- (IBAction)homeBtnPrss:(id)sender {
    ChooseActionViewController *vc=[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)addBtnprss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Post Store Ad"
                         withValue:[NSNumber numberWithInt:100]];
    
    // CODE TODO for Roula
    // Variables are:
    //    kiloChoosen: bool;
    //    chosenCity : City;
    //    chosenCountry : Country;
    //    chosenCurrency : SingleValue;
    //    chosenYear : SingleValue;
    //    carAdTitle :UITextField;
    //    carDetails : UITextView;
    //    distance : UITextField;
    //    mobileNum :UITextField;
    //    carPrice : UITextField;
    
    if (!storeBtnPressedOnce)
    {
        if (self.currentStore) {
            myStore = self.currentStore;
        }else {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار المتجر" delegateVC:self];
            return;
        }
    }
    
    //check country & city
    if (!locationBtnPressedOnce)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار بلد ومدينة مناسبين" delegateVC:self];
        return;
    }
    
    if (!chosenCity)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار بيانات المكان صحيحة" delegateVC:self];
        return;
    }
    
    //check title
    if ([carAdTitle.text length] == 0)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال عنوان صحيح للإعلان" delegateVC:self];
        return;
    }
    
    //check description
    if ([carDetails.text length] == 0)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال تفاصيل للإعلان" delegateVC:self];
        return;
    }
    
    if ([[mobileNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""])
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال رقم هاتف" delegateVC:self];
        return;
    }
    
    //check currency
    if (!currencyBtnPressedOnce)
    {
        //check price
         if ( [carPrice.text length] != 0 )
        {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار عملة مناسبة" delegateVC:self];
            return;
            
        }
    }
   
   
    
    if (!bodyBtnPressedOnce)
    {
        
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار هيكل السيارة" delegateVC:self];
        return;
        
    }

    //check phone number
    if (!mobileNum.text)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال رقم هاتف" delegateVC:self];
        return;
    }
    
   
    
    
    
    NSInteger distanceUnitID;
    int conditionID = 0;
    int gearID = 0;
    int typeID = 0;
    
    if (kiloChoosen)
        distanceUnitID = [self idForKilometerAttribute];
    else
        distanceUnitID = [self idForMileAttribute];
    
    if (conditionchoosen)
        conditionID = [self idForConditionNewAttribute];
    else
        conditionID = [self idForConditionUsedAttribute];
    
    if (gearchoosen == 0) {
        gearID = [self idForGearAutoAttribute];
    }else if (gearchoosen == 1){
        gearID = [self idForGearNormalAttribute];
    }
    else if (gearchoosen == 2){
        gearID = [self idForGearTronicAttribute];
    }
    
    if (typechoosen == 0) {
        typeID = [self idForTypeFrontAttribute];
    }else if (typechoosen == 1){
        typeID = [self idForTypeBackAttribute];
    }
    else if (typechoosen == 2){
        typeID = [self idForTypeFourAttribute];
    }
    
    [self showLoadingIndicator];
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if ([distance.text length] == 0) {
        distance.text = @"";
    }
    if ([carPrice.text length] == 0) {
        carPrice.text = @"";
    }
    
    [[CarAdsManager sharedInstance] postStoreAdOfBrand:_currentModel.brandID myStore:myStore.identifier
                                                 Model:_currentModel.modelID
                                                InCity:chosenCity.cityID
                                             userEmail:(savedProfile ? savedProfile.emailAddress : @"")
                                                 title:carAdTitle.text
                                           description:carDetails.text
                                                 price:carPrice.text
                                         periodValueID:AD_PERIOD_2_MONTHS_VALUE_ID
                                                mobile: mobileNum.text
                                       currencyValueID:chosenCurrency.valueID
                                        serviceValueID:SERVICE_FOR_SALE_VALUE_ID
                                      modelYearValueID:chosenYear.valueID
                                              distance:distance.text
                                                 color:@""
                                            phoneNumer:myStore.ownerEmail
                                       adCommentsEmail:YES
                                      kmVSmilesValueID:distanceUnitID
                                              imageIDs:currentImgsUploaded
                                           conditionID:conditionID
                                            gearTypeID:gearID
                                             carTypeID:typeID
                                             carBodyID:chosenBody.valueID withCategory:_currentModel.brandID withCity1:chosenCity.cityID
                                          withDelegate:self];
    
}

- (IBAction)selectModelBtnPrss:(id)sender {
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=2;
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self TakePhotoWithCamera];
    }
    else if (buttonIndex == 1)
    {
        [self SelectPhotoFromLibrary];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
    
    [tappedBtn setImage:[GenericMethods imageWithImage:img scaledToSize:tappedBtn.frame.size] forState:UIControlStateNormal];
    
    [self useImage:img];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - iploadImage Delegate

- (void) imageDidFailUploadingWithError:(NSError *)error {
    
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];

    [self hideLoadingIndicatorOnImages];
    if (chosenImgBtnTag > -1)
    {
        UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        
        [tappedBtn setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
    }
    
    
    //reset 'current' data
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
    
}

- (void) imageDidFinishUploadingWithURL:(NSURL *)url CreativeID:(NSInteger)ID {
    
    [self hideLoadingIndicatorOnImages];
    
    //1- show the image on the button
    if ((chosenImgBtnTag > -1) && (currentImageToUpload))
    {
        /*
        UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tappedBtn.frame.size.width, tappedBtn.frame.size.height)];
        
        [tappedBtn addSubview:imgv];
        [imgv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AddCar_Car_logo.png"]];
         */
        
    }
    //2- add image data to this ad
    [currentImgsUploaded addObject:[NSNumber numberWithInteger:ID]];
    
    //reset 'current' data
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
    
}


#pragma mark - PostAd Delegate
-(void)storeAdDidFailPostingWithError:(NSError *)error
{
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];

    [self hideLoadingIndicator];
}

-(void)storeAdDidFinishPostingWithAdID:(NSInteger)adID
{
    //[self hideLoadingIndicator];
    
    myAdID = adID;
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:@"تمت إضافة إعلانك بنجاج" delegateVC:self];
    if (adID != 0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"شكرا"
                                                    message:@"تمت إضافة إعلانك بنجاج"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
        return;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"نعتذر"
                                                        message:@"يرجى إعادة المحاولة"
                                                       delegate:nil
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:chosenCountry.countryID withDelegate:self];
        /*
        //[self dismissViewControllerAnimated:YES completion:nil];
        BrowseStoresViewController *vc=[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];*/
    }
}


#pragma mark - StoreManagerDelegate Methods

- (void) userStoresRetrieveDidFailWithError:(NSError *)error {
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تحميل المتاجر"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];*/
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    [self hideLoadingIndicator];
}

- (void) userStoresRetrieveDidSucceedWithStores:(NSArray *)stores {
   
    for (int i =0; i<[stores count]; i++) {
        Store* temp = [stores objectAtIndex:i];

        if (temp.status == 2) {
            [allUserStore addObject:temp];
        }
    }
     //  allUserStore = st;
    
    if (self.currentStore) {
        for (int i =0; i < [allUserStore count]; i++) {
            if (self.currentStore.identifier == [(Store *)[allUserStore objectAtIndex:i] identifier]) {
            defaultStoreIndex = [(Store *)[allUserStore objectAtIndex:i] identifier];
                break;
            }
        }
        [theStore setTitle:self.currentStore.name forState:UIControlStateNormal];
    }
    [self.storePickerView reloadAllComponents];
    [self hideLoadingIndicator];
}
/*

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self closePicker];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
*/
#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    if ([@"" isEqualToString:textView.text]) {
        placeholderTextField.placeholder = @"تفاصيل الإعلان";
    }
    else {
        placeholderTextField.placeholder = @"";
    }
}

#pragma mark - PricingOptions Delegate

- (void) optionsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    details.currentAdID = myAdID;
    details.checkPage = YES;
    [self presentViewController:details animated:YES completion:nil];
    
}

- (void) optionsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    
    if (resultArray.count == 0) {
        CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        details.currentAdID = myAdID;
        details.checkPage = YES;
        [self presentViewController:details animated:YES completion:nil];
    }else {
        labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
        vc.currentAdID = myAdID;
        vc.countryAdID = chosenCountry.countryID;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}


@end
