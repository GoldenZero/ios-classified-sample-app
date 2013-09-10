//
//  AddNewStoreAdViewController_iPad.m
//  Bezaat
//
//  Created by GALMarei on 4/29/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewStoreAdViewController_iPad.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "labelAdViewController.h"
#import "StaticAttrsLoader.h"
#import "ChooseModelView_iPad.h"
#import "BrandCell.h"
#import "ModelCell.h"

#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)


@interface AddNewStoreAdViewController_iPad (){
    
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
    StoreManager *advFeatureManager;

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

    BOOL choosingStore;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    UIActivityIndicatorView * iPad_imgsActivityIndicator;
    UIView * iPad_imgsLoadingView;
    
    UIImage * iPad_chooseBrandBtnImgOn;
    UIImage * iPad_chooseBrandBtnImgOff;
    
    UIImage * iPad_setPhotosBtnImgOn;
    UIImage * iPad_setPhotosBtnImgOff;
    
    UIImage * iPad_setDetailsBtnImgOn;
    UIImage * iPad_setDetailsBtnImgOff;
    
    //choose brand view related:
    NSMutableArray * brandCellsArray;
    Brand * chosenBrand;
    BOOL brandsOneSelectionMade;
    ChooseModelView_iPad * dropDownView;
    
    NSArray* currentBrands;
    NSArray* currentModels;
}

@end

@implementation AddNewStoreAdViewController_iPad
@synthesize carAdTitle,mobileNum,distance,carDetails,carPrice,countryCity,currency,kiloMile,productionYear,condition,gear,body,type,theStore,carDetailLabel;


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
    self.inputAccessoryView = [XCDFormInputAccessoryView new];
    gearchoosen = 0;
    typechoosen = 0;
    
    allUserStore = [[NSMutableArray alloc]init];
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getUserStores];

    
    locationMngr = [LocationManager sharedInstance];
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
    
    advFeatureManager = [[StoreManager alloc] init];
    advFeatureManager.delegate = self;
    
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

    
    //[self.locationPickerView reloadAllComponents];

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
    
    
    tap2 = [[UITapGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(dismissKeyboard)];
    //[self.verticalScrollView addGestureRecognizer:tap2];
    [self.iPad_mainScrollView addGestureRecognizer:tap2];
    
    
    locationBtnPressedOnce = NO;
    currencyBtnPressedOnce = NO;
    yearBtnPressedOnce = NO;
    bodyBtnPressedOnce = NO;
    storeBtnPressedOnce = NO;
    
    choosingStore = NO;
    
    //initial gear type
    gearchoosen = 1;        //automatic
    
    //initial car type
    typechoosen = 1;          //back wheel
    
    //initial car condition
    conditionchoosen = false; //used
        
    [self loadDataArray];
    //[self addButtonsToXib];
    //[self setImagesArray];
    [self setImagesToXib];
    
    [self closePicker];
    
    //set image names
    iPad_chooseBrandBtnImgOn = [UIImage imageNamed:@"tb_add_individual1_choose_brand_button_on"];
    iPad_chooseBrandBtnImgOff = [UIImage imageNamed:@"tb_add_individual1_choose_brand_button_off"];
    
    iPad_setPhotosBtnImgOn = [UIImage imageNamed:@"tb_add_individual1_car_images_button_on"];
    iPad_setPhotosBtnImgOff = [UIImage imageNamed:@"tb_add_individual1_car_images_button_off"];
    
    iPad_setDetailsBtnImgOn = [UIImage imageNamed:@"tb_add_individual1_ads_details_button_on"];
    iPad_setDetailsBtnImgOff = [UIImage imageNamed:@"tb_add_individual1_ads_details_button_off"];
    
    
    //title label
    [self.iPad_titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.iPad_titleLabel setTextAlignment:SSTextAlignmentCenter];
    [self.iPad_titleLabel setTextColor:[UIColor whiteColor]];
    [self.iPad_titleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:26.0] ];
    [self.iPad_titleLabel setText:@"إضافة إعلان"];
    
    //title label
    [self.iPad_uploadImagesTitleLabel setBackgroundColor:[UIColor clearColor]];
    [self.iPad_uploadImagesTitleLabel setTextAlignment:SSTextAlignmentCenter];
    [self.iPad_uploadImagesTitleLabel setTextColor:[UIColor darkGrayColor]];
    [self.iPad_uploadImagesTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:14.0] ];
    [self.iPad_uploadImagesTitleLabel setText:@"حمل الصور الآن"];
    
    [self.iPad_mainScrollView setContentSize:CGSizeMake((1024 * 3), self.iPad_mainScrollView.frame.size.height)];
    
    //choose brand view:
    //------------------
    brandCellsArray = [NSMutableArray new];
    
    chosenBrand = nil;
    self.currentModel = nil;
    
    brandsOneSelectionMade = NO;
    dropDownView = nil;
    
    //display a locing indicator on brands view until brands get loaded
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.hidden = NO;
    activityIndicator.center = CGPointMake(self.iPad_chooseBrandView.frame.size.width /2, self.iPad_chooseBrandView.frame.size.height/2);
    [self.iPad_chooseBrandView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [[BrandsManager sharedInstance] getBrandsAndModelsForPostAdWithDelegate:self];
    
    
    [self iPad_srollToBrandsView];
    [self iPad_setStepViews];
    
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

- (IBAction) uploadImage: (id)sender{
    //if a loading indicator is already added
    if (iPad_imgsLoadingView) {
        [GenericMethods throwAlertWithTitle:@"" message:@"الرجاء الانتظار حتى انتهاء رفع الصور السابقة" delegateVC:nil];
    }
    else {
        UIButton * senderBtn = (UIButton *) sender;
        chosenImgBtnTag = senderBtn.tag;
        
        //display the action sheet for choosing 'existing photo' or 'use camera'
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                        otherButtonTitles:@"التقط صورة", @"اختر صورة", nil];
        actionSheet.tag = 1;
        //[actionSheet showInView:self.view];
        [actionSheet showFromRect:senderBtn.frame inView:senderBtn animated:YES];
    }
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
        //[self presentViewController:picker animated:YES completion:nil];
        [self dismissKeyboard];
        self.iPad_cameraPopOver = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.iPad_cameraPopOver.delegate = self;
        [self.iPad_cameraPopOver presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
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
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
        self.view.frame = CGRectMake(0, 0, 320, 568);
    else
        self.view.frame = CGRectMake(0, 0, 320, 480);
}

- (BOOL) disablesAutomaticKeyboardDismissal {
    return NO;
}

-(void)cancelNumberPad{
    [mobileNum resignFirstResponder];
    mobileNum.text = @"";
}

-(void)doneWithNumberPad{
    [mobileNum resignFirstResponder];
}


- (void) addButtonsToXib{
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 670)];
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
    
    carDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 135, 260, 20)];
    [carDetailLabel setText:@"تفاصيل الإعلان:"];
    [carDetailLabel setTextAlignment:NSTextAlignmentRight];
    [carDetailLabel setTextColor:[UIColor blackColor]];
    [carDetailLabel setFont:[UIFont systemFontOfSize:17]];
    [carDetailLabel setBackgroundColor:[UIColor clearColor]];
    [self.verticalScrollView addSubview:carDetailLabel];
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,160 ,260 ,80 )];
    [carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [carDetails setBackgroundColor:[UIColor whiteColor]];
    [carDetails setFont:[UIFont systemFontOfSize:17]];
    carDetails.delegate =self;
    
    placeholderTextField=[[UITextField alloc] initWithFrame:CGRectMake(30,160 ,260 ,30)];
    [placeholderTextField setTextAlignment:NSTextAlignmentRight];
    [placeholderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    CGRect frame = placeholderTextField.frame;
    frame.size.height = carDetails.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"تفاصيل الإعلان";
    //[self.verticalScrollView addSubview:placeholderTextField];
    [self.verticalScrollView addSubview:carDetails];

    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,260 ,260 ,30)];  //610
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    mobileNum.delegate=self;
    
    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,310 ,160 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر (اختياري)"];
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    carPrice.delegate=self;
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 310, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_SM.png"] forState:UIControlStateNormal];
    [currency setTitle:@"العملة    " forState:UIControlStateNormal];
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];
    
    distance=[[UITextField alloc] initWithFrame:CGRectMake(130,370 ,160 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة المقطوعة"];
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];
    distance.delegate=self;
    
    kiloMile = [[UISegmentedControl alloc] initWithItems:kiloMileArray];
    kiloMile.frame = CGRectMake(30, 370, 80, 30);
    kiloMile.segmentedControlStyle = UISegmentedControlStylePlain;
    kiloMile.selectedSegmentIndex = 0;
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [kiloMile setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:kiloMile];
    
    condition = [[UISegmentedControl alloc] initWithItems:carConditionArray];
    condition.frame = CGRectMake(30, 430, 260, 40);
    condition.segmentedControlStyle = UISegmentedControlStylePlain;
    condition.selectedSegmentIndex = 0;
    [condition setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [condition addTarget:self action:@selector(chooseCarCondition) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:condition];
    
    gear = [[UISegmentedControl alloc] initWithItems:gearTypeArray];
    gear.frame = CGRectMake(30, 490, 260, 40);
    gear.segmentedControlStyle = UISegmentedControlStylePlain;
    gear.selectedSegmentIndex = 0;
    [gear setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [gear addTarget:self action:@selector(chooseGearType) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:gear];
    
    type = [[UISegmentedControl alloc] initWithItems:carTypeArray];
    type.frame = CGRectMake(30, 540, 260, 40);
    type.segmentedControlStyle = UISegmentedControlStylePlain;
    type.selectedSegmentIndex = 0;
    [type setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [type addTarget:self action:@selector(chooseCarType) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:type];
    
    body =[[UIButton alloc] initWithFrame:CGRectMake(30, 590, 260, 30)];
    [body setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [body setTitle:@"هيكل السيارة" forState:UIControlStateNormal];
    [body addTarget:self action:@selector(chooseBody) forControlEvents:UIControlEventTouchUpInside];
    [body setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:body];
    
    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 630, 260, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:@"عام الصنع" forState:UIControlStateNormal];
    [productionYear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [productionYear addTarget:self action:@selector(chooseProductionYear) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:productionYear];
    
    
   
    
    
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


- (void) showLoadingIndicatorOnImages {
    iPad_imgsLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    
    iPad_imgsLoadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    iPad_imgsLoadingView.clipsToBounds = YES;
    iPad_imgsLoadingView.layer.cornerRadius = 10.0;
    iPad_imgsLoadingView.center = CGPointMake(self.iPad_uploadPhotosView.frame.size.width / 2.0, self.iPad_uploadPhotosView.frame.size.height / 2.0);
    
    iPad_imgsActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    iPad_imgsActivityIndicator.frame = CGRectMake(18, 18, iPad_imgsActivityIndicator.bounds.size.width, iPad_imgsActivityIndicator.bounds.size.height);
    [iPad_imgsLoadingView addSubview:iPad_imgsActivityIndicator];
    
    
    [self.iPad_uploadPhotosView addSubview:iPad_imgsLoadingView];
    [iPad_imgsActivityIndicator startAnimating];
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

- (void) hideLoadingIndicatorOnImages {
    
    if ((iPad_imgsActivityIndicator) && (iPad_imgsLoadingView)) {
        [iPad_imgsActivityIndicator stopAnimating];
        [iPad_imgsLoadingView removeFromSuperview];
    }
    iPad_imgsActivityIndicator = nil;
    iPad_imgsLoadingView = nil;
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

    if (pickerView == _bodyPickerView){
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
    /*
     if (pickerView==_locationPickerView) {
        cityArray=[myCountry cities];
        chosenCity=[cityArray objectAtIndex:row];
        NSString *temp= [NSString stringWithFormat:@"%@ : %@", myCountry.countryName , chosenCity.cityName];
        [countryCity setTitle:temp forState:UIControlStateNormal];
        locationBtnPressedOnce = YES;
        
    }else */
    if (pickerView == _bodyPickerView)
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
        
        defaultIndex = [locationMngr getIndexOfCountry:myStore.countryID];
        if  (defaultIndex!= -1){
            chosenCountry =[countryArray objectAtIndex:defaultIndex];
            myCountry = [countryArray objectAtIndex:defaultIndex];
            cityArray=[chosenCountry cities];
            defaultCountryID = myStore.countryID;
            defaultCityID =  ((City *)chosenCountry.cities[0]).cityID;
            
            for (City* cit in cityArray) {
                if (cit.cityID == defaultCityID)
                {
                    chosenCity =[cityArray objectAtIndex:[cityArray indexOfObject:cit]];
                    break;
                }
            }
            
            NSString *temp= [NSString stringWithFormat:@"%@ : %@", chosenCountry.countryName , chosenCity.cityName];
            [countryCity setTitle:temp forState:UIControlStateNormal];
            [self.locationPickerView reloadAllComponents];
        }
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
    /*
     if (pickerView==_locationPickerView) {
        
        return [cityArray count];
    
    }
    else */
    if (pickerView==_bodyPickerView) {
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
    /*
     if (pickerView ==_locationPickerView) {
            City *temp=(City*)[cityArray objectAtIndex:row];
            return temp.cityName;
    }else */
    if (pickerView == _bodyPickerView){
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

- (IBAction)iPad_kiloBtnPrss:(id)sender {
    kiloChoosen = YES;
    
    [self.iPad_kiloBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_km_btn_on.png"] forState:UIControlStateNormal];
    [self.iPad_mileBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_mile_btn_off.png"] forState:UIControlStateNormal];
    
}
- (IBAction)iPad_mileBtnPrss:(id)sender {
    kiloChoosen = NO;
    
    [self.iPad_kiloBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_km_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_mileBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_mile_btn_on.png"] forState:UIControlStateNormal];
}

-(IBAction)chooseStore:(id) sender
{
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
    storeBtnPressedOnce = YES;
    choosingStore = YES;
    [self showPicker];
}

- (IBAction) chooseProductionYear:(id) sender{
    
    choosingStore = NO;
    
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

- (IBAction) chooseCurrency:(id) sender{
    
    choosingStore = NO;
    
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

- (IBAction) chooseCountryCity:(id) sneder{
    
    choosingStore = NO;
    /*
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
     */
    locationBtnPressedOnce = YES;
    CountryListViewController* vc;
    vc = [[CountryListViewController alloc]initWithNibName:@"CountriesPopOver_iPad" bundle:nil];
    self.iPad_countryPopOver = [[UIPopoverController alloc] initWithContentViewController:vc];
    //[self.iPad_countryPopOver setPopoverContentSize:vc.view.frame.size];
    [self dismissKeyboard];
    [self.iPad_countryPopOver setPopoverContentSize:CGSizeMake(500, 700)];
    vc.iPad_parentViewOfPopOver = self;
    [self.iPad_countryPopOver presentPopoverFromRect:self.countryCity.frame inView:self.countryCity.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

/*
- (void) chooseKiloMile{
    
    choosingStore = NO;
    
    if (kiloMile.selectedSegmentIndex==0) {
        kiloChoosen=true;
    }
    else if (kiloMile.selectedSegmentIndex==1){
        
        kiloChoosen=false;
    }
    
}

-(IBAction)chooseCarCondition:(id)sender
{
    choosingStore = NO;
    if (condition.selectedSegmentIndex==0) {
        conditionchoosen=true;
    }
    else if (condition.selectedSegmentIndex==1){
        
        conditionchoosen=false;
    }
}

-(IBAction) chooseGearType:(id)sender
{
    choosingStore = NO;
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

-(IBAction) chooseCarType:(id)sender
{
    choosingStore = NO;
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
*/

-(IBAction) chooseBody:(id)sender
{
    choosingStore = NO;
    
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

- (IBAction) iPad_closeBtnPrss:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneBtnPrss:(id)sender {
    if (choosingStore) {
        defaultIndex = [locationMngr getIndexOfCountry:myStore.countryID];
        if  (defaultIndex!= -1){
            chosenCountry =[countryArray objectAtIndex:defaultIndex];
            myCountry = [countryArray objectAtIndex:defaultIndex];
            cityArray=[chosenCountry cities];
            defaultCountryID = myStore.countryID;
            defaultCityID =  ((City *)chosenCountry.cities[0]).cityID;
            
            for (City* cit in cityArray) {
                if (cit.cityID == defaultCityID)
                {
                    chosenCity =[cityArray objectAtIndex:[cityArray indexOfObject:cit]];
                    break;
                }
            }
            
            NSString *temp= [NSString stringWithFormat:@"%@ : %@", chosenCountry.countryName , chosenCity.cityName];
            [countryCity setTitle:temp forState:UIControlStateNormal];
            [self.locationPickerView reloadAllComponents];
        }
    }
    [self closePicker];
}
/*
- (IBAction)homeBtnPrss:(id)sender {
    ChooseActionViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    else
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}
*/

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
    
    if (!chosenCurrency)
    {
        //check price
        if ( [carPrice.text length] != 0 && ![carPrice.text isEqualToString:@"0"])
        {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار عملة مناسبة" delegateVC:self];
            return;
            
        }
    }

    if (!chosenBody)
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
    
    /*if ([distance.text length] == 0)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال المسافه المقطوعه" delegateVC:self];
        return;
    }*/
    
   
    
    
    
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
    if (actionSheet.tag == 100) {
        if (buttonIndex == actionSheet.cancelButtonIndex)
        {
            CarAdDetailsViewController *details;
            
            if ([currentImgsUploaded count] > 0){   //ad with image
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
                else
                    details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
            }
            else {                            //ad with no image
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
                else
                    details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
            }
            
            details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            details.currentAdID=myAdID;
            details.checkPage = YES;
            [self presentViewController:details animated:YES completion:nil];

        }
        else {
        if ((myAdID == 0) || (myAdID == -1)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                            message:@"لم يتم تحديد إعلان."
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSInteger featureDays = 3;
        if ([@"٣ أيام" isEqualToString:buttonTitle]) {
            featureDays = 3;
        }
        else if ([@"اسبوع" isEqualToString:buttonTitle]) {
            featureDays = 7;
        }
        else if ([@"شهر" isEqualToString:buttonTitle]) {
            featureDays = 28;
        }
        if (myStore)
        {
            [advFeatureManager featureAdv:myAdID
                                  inStore:myStore.identifier
                              featureDays:featureDays];
            [self showLoadingIndicator];
        }
    }
    
    }
    else if (actionSheet.tag == 1){
        if (buttonIndex == 0)
        {
            [self TakePhotoWithCamera];
        }
        else if (buttonIndex == 1)
        {
            [self SelectPhotoFromLibrary];
        }
    }
}

- (void) dismissSelfAfterFeaturing {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenImgBtnTag];
    
    [tappedBtn setImage:[GenericMethods imageWithImage:img scaledToSize:tappedBtn.frame.size] forState:UIControlStateNormal];
    
    [self useImage:img];
    //[picker dismissViewControllerAnimated:YES completion:nil];
    if (self.iPad_cameraPopOver)
        [self.iPad_cameraPopOver dismissPopoverAnimated:YES];
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
        //UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenImgBtnTag];
        
        //[tappedBtn setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
    }
    
    
    //reset 'current' data
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
    
}

- (void) imageDidFinishUploadingWithURL:(NSURL *)url CreativeID:(NSInteger)ID {
    
    [self hideLoadingIndicatorOnImages];
    
    //1- show the image on the button
    /*
     if ((chosenImgBtnTag > -1) && (currentImageToUpload))
    {
        
        UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tappedBtn.frame.size.width, tappedBtn.frame.size.height)];
        
        [tappedBtn addSubview:imgv];
        [imgv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AddCar_Car_logo.png"]];
     
        
    }
     */
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
    [self hideLoadingIndicator];
    
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
        alertView.hidden = YES;
        [self featurecurrentStoreAd:myAdID];
     
    }
    else if (alertView.tag == 2) {
        [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:chosenCountry.countryID withDelegate:self];
        /*
        //[self dismissViewControllerAnimated:YES completion:nil];
        BrowseStoresViewController *vc=[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];*/
    }
    else if (alertView.tag == 3)
    {
        CarAdDetailsViewController *details;
        
        if ([currentImgsUploaded count] > 0){   //ad with image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
        }
        else {                            //ad with no image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
        }
        
        details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        details.currentAdID=myAdID;
        details.checkPage = YES;
        [self presentViewController:details animated:YES completion:nil];

    }
    else if (alertView.tag == 6)
    {
        labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
        vc.currentAdID = myAdID;
        vc.countryAdID = chosenCountry.countryID;
        vc.currentAdHasImages = NO;
        if (currentImgsUploaded && currentImgsUploaded.count)
            vc.currentAdHasImages = YES;
        
        [self presentViewController:vc animated:YES completion:nil];
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
/*
- (void)textViewDidChange:(UITextView *)textView {
    if ([@"" isEqualToString:textView.text]) {
        //placeholderTextField.placeholder = @"تفاصيل الإعلان";
    }
    else {
        //placeholderTextField.placeholder = @"";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([[UIScreen mainScreen] bounds].size.height == 568)
        self.view.frame = CGRectMake(0, -160, 320, 568);
    else
        self.view.frame = CGRectMake(0, -160, 320, 480);
    
    if (!textView.editable && [textView baseWritingDirectionForPosition:[textView beginningOfDocument] inDirection:UITextStorageDirectionForward] == UITextWritingDirectionRightToLeft) {
        // if yes, set text alignment right
        textView.textAlignment = NSTextAlignmentRight;
    } else {
        // for all other cases, set text alignment left
        textView.textAlignment = NSTextAlignmentLeft;
    }
    //textView.textAlignment=NSTextAlignmentRight;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self dismissKeyboard];
}
*/

#pragma mark - PricingOptions Delegate

- (void) optionsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    //CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    CarAdDetailsViewController *details;
    
    if (currentImgsUploaded && currentImgsUploaded.count) {  //ad with image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        else
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
    }
    else {                            //ad with no image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
        else
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
    }
   
    details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    details.currentAdID = myAdID;
    details.checkPage = YES;
    details.currentStore = self.currentStore;
    [self presentViewController:details animated:YES completion:nil];
    
}

- (void) optionsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    
    if (resultArray.count == 0) {
        //CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        
        CarAdDetailsViewController *details;
        
        if (currentImgsUploaded && currentImgsUploaded.count) {  //ad with image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
        }
        else {                            //ad with no image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
        }
        
        
        details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        details.currentAdID = myAdID;
        details.checkPage = YES;
        details.currentStore = self.currentStore;
        [self presentViewController:details animated:YES completion:nil];
    }else {
        UIAlertView* alert =[ [UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد تم اضافة اعلانك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        alert.tag = 6;
        [alert show];
        return;
    }
    
}


#pragma mark - featuring an ad related to a store

- (void)featurecurrentStoreAd:(NSInteger)advID {
    if (myStore)
    {
        if (myStore.remainingFreeFeatureAds <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                            message:@"لقد تجاوزت عدد الإعلانات المحجوزة."
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
        }
        else if (myStore.remainingDays < 3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                            message:@"عدد الأيام المتبقية لديك غير كاف."
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
        }
        else {
            UIActionSheet *actionSheet = nil;
            
            if (myStore.remainingDays < 7) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                          delegate:self
                                                 cancelButtonTitle:@"لاحقا"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"٣ أيام", nil];
            }
            else if (myStore.remainingDays < 28) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                          delegate:self
                                                 cancelButtonTitle:@"لاحقا"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"٣ أيام", @"اسبوع", nil];
            }
            else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                          delegate:self
                                                 cancelButtonTitle:@"لاحقا"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"٣ أيام", @"اسبوع", @"شهر", nil];
            }
            actionSheet.tag = 100;
            [actionSheet showInView:self.view];
        }
    }
}



#pragma mark -featuring store ad delegate methods

- (void) featureAdvDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تمييز الإعلان"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
}

- (void) featureAdvDidSucceed {
    [self hideLoadingIndicator];
    if (myStore)
    {
        myStore.remainingFreeFeatureAds--;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم تمييز الإعلان"
                                                    message:@"تم تمييز الإعلان بنجاح."
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    alert.tag = 3;
    [alert show];
    
    
   
}

#pragma mark - ipad actions
//gear type
- (IBAction)iPad_normalGearTypeBtnPrss:(id) sender {
    gearchoosen = 0;
    
    [self.iPad_normalGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_normal_btn_on.png"] forState:UIControlStateNormal];
    [self.iPad_automaticGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_auto_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_tiptronicGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_trebetonic_btn_off.png"] forState:UIControlStateNormal];
}

- (IBAction)iPad_automaticGearTypeBtnPrss:(id) sender {
    gearchoosen = 1;
    
    [self.iPad_normalGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_normal_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_automaticGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_auto_btn_on.png"] forState:UIControlStateNormal];
    [self.iPad_tiptronicGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_trebetonic_btn_off.png"] forState:UIControlStateNormal];
}

- (IBAction)iPad_tiptronicGearTypeBtnPrss:(id) sender {
    gearchoosen = 2;
    
    [self.iPad_normalGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_normal_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_automaticGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_auto_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_tiptronicGearTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_trebetonic_btn_on.png"] forState:UIControlStateNormal];
}

//car type
- (IBAction)iPad_frontWheelCarTypeBtnPrss:(id) sender {
    typechoosen = 0;
    
    [self.iPad_frontWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_amaie_btn_on.png"] forState:UIControlStateNormal];
    [self.iPad_backWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_behind_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_fourWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_4x4_btn_off.png"] forState:UIControlStateNormal];
    
}

- (IBAction)iPad_backWheelCarTypeBtnPrss:(id) sender {
    typechoosen = 1;
    
    [self.iPad_frontWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_amaie_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_backWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_behind_btn_on.png"] forState:UIControlStateNormal];
    [self.iPad_fourWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_4x4_btn_off.png"] forState:UIControlStateNormal];
}

- (IBAction)iPad_fourWheelCarTypeBtnPrss:(id) sender {
    typechoosen = 2;
    
    [self.iPad_frontWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_amaie_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_backWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_behind_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_fourWheelCarTypeBtn setImage:[UIImage imageNamed:@"tb_add_individual4_4x4_btn_on.png"] forState:UIControlStateNormal];
}

//car condition
- (IBAction)iPad_newCarConditionBtnPrss:(id) sender {
    conditionchoosen=true;
    
    [self.iPad_newCarConditionBtn setImage:[UIImage imageNamed:@"tb_add_individual4_new_btn_on"] forState:UIControlStateNormal];
    [self.iPad_usedCarConditionBtn setImage:[UIImage imageNamed:@"tb_add_individual4_used_btn_off.png"] forState:UIControlStateNormal];
}

- (IBAction)iPad_usedCarConditionBtnPrss:(id) sender {
    conditionchoosen=false;
    [self.iPad_newCarConditionBtn setImage:[UIImage imageNamed:@"tb_add_individual4_new_btn_off"] forState:UIControlStateNormal];
    [self.iPad_usedCarConditionBtn setImage:[UIImage imageNamed:@"tb_add_individual4_used_btn_on.png"] forState:UIControlStateNormal];
}

- (IBAction) iPad_chooseBrandBtnPrss:(id) sender {
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOff forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOff forState:UIControlStateNormal];
    
    [self iPad_srollToBrandsView];
}

- (IBAction) iPad_setPhotosBtnPrss:(id) sender {
    
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOff forState:UIControlStateNormal];
    
    [self iPad_srollToPhotosView];
}

- (IBAction) iPad_setDetailsBtnPrss:(id) sender {
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOn forState:UIControlStateNormal];
    
    [self iPad_srollToDetailsView];
    
}

#pragma mark - iPad helper methods

//In order to get these functions work properly, I needed to stop autolayout
- (void) iPad_srollToBrandsView {
    
    CGRect frame = self.iPad_mainScrollView.frame;
    frame.origin.x = frame.size.width * 2;
    frame.origin.y = 10;
    [self.iPad_mainScrollView scrollRectToVisible:frame animated:YES];
}

- (void) iPad_srollToPhotosView {
    
    CGRect frame = self.iPad_mainScrollView.frame;
    //frame.origin.x = frame.size.width * 1 - 10;
    frame.origin.x = frame.size.width * 1;
    frame.origin.y = 10;
    [self.iPad_mainScrollView scrollRectToVisible:frame animated:YES];
}

- (void) iPad_srollToDetailsView {
    
    CGRect frame = self.iPad_mainScrollView.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 10;
    [self.iPad_mainScrollView scrollRectToVisible:frame animated:YES];
}

- (void) iPad_setStepViews {
    ModelsViewController_iPad * modelsVC = [[ModelsViewController_iPad alloc] initWithNibName:@"ModelsViewController_iPad" bundle:nil];
    
    //vc.tagOfCallXib=2;
    modelsVC.displayedAsPopOver = NO;
    //[self presentViewController:modelsVC animated:YES completion:nil];
    
}

- (void) iPad_userDidEndChoosingCountryFromPopOver {
    if (self.iPad_countryPopOver) {
        locationBtnPressedOnce = YES;
        defaultCountryID =  [[LocationManager sharedInstance] getSavedUserCountryID];
        defaultCityID =  [[LocationManager sharedInstance] getSavedUserCityID];
        for (int i =0; i <= [countryArray count] - 1; i++) {
            if ([(Country *)[countryArray objectAtIndex:i] countryID] == defaultCountryID)
            {
                chosenCountry = [countryArray objectAtIndex:i];
                cityArray=[chosenCountry cities];
                for (int j = 0; j < chosenCountry.cities.count; j++) {
                    if ([(City *)[cityArray objectAtIndex:j] cityID] == defaultCityID)
                        chosenCity = [cityArray objectAtIndex:j];
                }
                NSString *temp= [NSString stringWithFormat:@"%@ : %@", chosenCountry.countryName , chosenCity.cityName];
                [countryCity setTitle:temp forState:UIControlStateNormal];
                break;
                //return;
            }
            
        }
        [self.iPad_countryPopOver dismissPopoverAnimated:YES];
    }
    self.iPad_countryPopOver = nil;
}

//------------------------------ LEVEL1: CHOOSING BRANDS ------------------------------
#pragma mark - LEVEL1: CHOOSING BRANDS

- (void) brandsDidFinishLoadingWithData:(NSArray*) resultArray {
    currentBrands=resultArray;
    currentModels=((Brand*)resultArray[0]).models;
    
    //currentModels = ((Brand*)resultArray[0]).models;
    chosenBrand =(Brand*)[currentBrands objectAtIndex:0];
    
    //hide the loading indicator in iPad_chooseBrandView
    UIActivityIndicatorView * activityView = nil;
    for (UIView * subview in self.iPad_chooseBrandView.subviews) {
        if ([subview class] == [UIActivityIndicatorView class]) {
            activityView = (UIActivityIndicatorView *) subview;
            break;
        }
    }
    
    if (activityView) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
    
    [self DrawBrands];
}

//This method is called for the first time the popover is created
- (void) selectFirstBrandCell {
    if (brandCellsArray && brandCellsArray.count) {
        UITapGestureRecognizer * tapOfFirstCell = [(BrandCell *) brandCellsArray[0] gestureRecognizers][0];
        [self didSelectBrandCell:tapOfFirstCell];
    }
    
}

- (void) DrawBrands {
    float currentX = 0;
    float currentY = 0;
    float totalHeight = 0;
    
    int rowCounter = 0;
    int colCounter = 0;
    
    CGRect brandFrame;
    
    for (int i = 0; i < currentBrands.count; i++) {
        Brand * currentItem = currentBrands[i];
        
        // Update the cell information
        BrandCell* brandCell;
        brandFrame = CGRectMake(-1, -1, 166, 166);//these are the dimensions of the brand cell
        brandCell = (BrandCell*)[[NSBundle mainBundle] loadNibNamed:@"BrandCell_iPad" owner:self options:nil][0];
        
        
        [brandCell reloadInformation:currentItem];
        
        if ((chosenBrand) && (chosenBrand.brandID == currentItem.brandID))
            [brandCell selectCell];
        
        if (i == 0)
            [brandCell selectCell];
        
        
        if (i != 0) {
            if (i % 6 == 0) {
                rowCounter ++;
                colCounter = 0;
            }
            else
                colCounter ++;
        }
        
        
        currentX = (colCounter * brandFrame.size.width) + ((colCounter + 1) * 4);
        currentY = (rowCounter * brandFrame.size.height) + ((rowCounter + 1) * 4);
        
        brandFrame.origin.x = currentX;
        brandFrame.origin.y = currentY;
        
        brandCell.frame = brandFrame;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectBrandCell:)];
        tap.numberOfTapsRequired = 1;
        [brandCell addGestureRecognizer:tap];
        
        [self.iPad_chooseBrandScrollView addSubview:brandCell];
        [brandCellsArray addObject:brandCell];
        //[brandsTapGesturesArray addObject:tap];
        
    }
    totalHeight = 1 + brandFrame.size.height + currentY + 15;
    [self.iPad_chooseBrandScrollView setContentSize:CGSizeMake(self.iPad_chooseBrandScrollView.contentSize.width, totalHeight)];
}

- (void) didSelectBrandCell:(id) sender {
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *) sender;
    BrandCell * senderCell = (BrandCell *) tap.view;
    int indexOfSenderCell = [self locateBrandCell:senderCell];
    chosenBrand = currentBrands[indexOfSenderCell];
    
    currentModels = chosenBrand.models;
    
    [senderCell selectCell];
    for (int i = 0; i < brandCellsArray.count; i++) {
        BrandCell * cell = (BrandCell *) brandCellsArray[i];
        
        if (cell.imgBrand.image != senderCell.imgBrand.image)
            [cell unselectCell];
    }
    
    CGRect newDropDownFrame = CGRectMake(25, 25, 590.0f, 200.0f);
    CGRect containerFrame = CGRectMake(0, 0, newDropDownFrame.size.width + 50, newDropDownFrame.size.height + 50);
    
    dropDownView = (ChooseModelView_iPad *)[[NSBundle mainBundle] loadNibNamed:@"ChooseModelView_iPad" owner:self options:nil][0];
    
    dropDownView.owner = senderCell;
    
    dropDownView.frame = newDropDownFrame;
    dropDownView.backgroundColor = [UIColor clearColor];
    if (indexOfSenderCell == -1)
        return ;
    
    int indexOfCurrentModel = -1;
    if (!self.currentModel)
        self.currentModel = currentModels[0]; //initially, the selected model is the first
    else {
        for (int i = 0; i < currentModels.count; i++) {
            if ([(Model *)currentModels[i] modelID] == self.currentModel.modelID) {
                indexOfCurrentModel = i;
                break;
            }
        }
    }
    [dropDownView drawModels:currentModels withIndexOfSelectedModel:(indexOfCurrentModel == -1 ? 0 : indexOfCurrentModel)];
    [self setModelsTapGestures];
    
    
    UIViewController * container = [[UIViewController alloc] init];
    container.view = [[UIView alloc] initWithFrame:containerFrame];
    dropDownView.containerViewController = container;
    
    //background
    CGRect bgRect = CGRectMake(-1, -1, containerFrame.size.width + 2, containerFrame.size.height + 2);
    UIImageView * bg = [[UIImageView alloc] initWithFrame:bgRect];
    [bg setImage:[UIImage imageNamed:@"tb_choose_brand_box1.png"]];
    [container.view addSubview:bg];
    
    //close button
    UIButton * closeModelsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [closeModelsButton setTitle:@"" forState:UIControlStateNormal];
    [closeModelsButton setBackgroundImage:[UIImage imageNamed:@"tb_add_individual_ads_close_btn.png"] forState:UIControlStateNormal];
    [closeModelsButton addTarget:self action:@selector(closeModelsBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [container.view addSubview:closeModelsButton];
    
    //models
    [container.view addSubview:dropDownView];
    
    container.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:container animated:YES completion:nil];
    container.view.superview.frame = containerFrame;
    container.view.superview.bounds = containerFrame;
    container.view.superview.center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 2));
    
    
    
    
}

- (void) didSelectModelCell:(id) sender {
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *) sender;
    ModelCell * senderCell = (ModelCell *) tap.view;
    int indexOfSenderCell = [self locateModelCell:senderCell];
    if (indexOfSenderCell != -1)
        self.currentModel = currentModels[indexOfSenderCell];
    
    [senderCell setSelected:YES];
    if (dropDownView) {
        for (id cell  in dropDownView.modelsScrollView.subviews) {
            if ( ([cell isKindOfClass:[ModelCell class]]) && (cell != senderCell))
                [cell setSelected:NO];
            
        }
        [dropDownView.containerViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) setModelsTapGestures {
    if (dropDownView) {
        for (id cell  in dropDownView.modelsScrollView.subviews) {
            if ([cell isKindOfClass:[ModelCell class]]) {
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectModelCell:)];
                tap.numberOfTapsRequired = 1;
                [cell addGestureRecognizer:tap];
            }
            
        }
    }
}

- (int) locateBrandCell:(BrandCell *) cell {
    if (brandCellsArray && brandCellsArray.count) {
        for (int i = 0; i < brandCellsArray.count; i++) {
            if (brandCellsArray[i] == cell)
                return i;
        }
        return -1;
    }
    else
        return -1;
}

- (int) locateModelCell:(ModelCell *) cell {
    if (dropDownView && dropDownView.modelCellsArray && dropDownView.modelCellsArray.count) {
        for (int i = 0; i < dropDownView.modelCellsArray.count; i++) {
            if (dropDownView.modelCellsArray[i] == cell)
                return i;
        }
        return -1;
    }
    else
        return -1;
}

- (void) closeModelsBtnPressed {    //this method is called on ly in the separate brands UI
    if (dropDownView) {
        [dropDownView.containerViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

//------------------------------- END OF LEVEL1: CHOOSING THE BRAND -------------------------------

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
