//
//  AddNewStoreAdViewController_iPad.m
//  Bezaat Real-Estate
//
//  Created by GALMarei on 12/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewStoreAdViewController_iPad.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "HomePageViewController.h"
#import "ChooseCategoryViewController.h"
#import "labelAdViewController.h"
#import "SignInViewController.h"
#import "CarAdDetailsViewController.h"
#import "labelStoreAdViewController_iPad.h"

#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)


@interface AddNewStoreAdViewController_iPad ()
{
    
    UITapGestureRecognizer *tap1;
    UITapGestureRecognizer *tap2;
    
    // Arrays
    NSArray *globalArray;
    NSArray *currencyArray;
    NSArray *roomsArray;
    NSArray *periodsArray;
    NSArray *countryArray;
    NSArray *cityArray;
    NSArray *serviceReqArray;
    NSArray *unitsArray;
    
    IBOutlet UITextField *placeholderTextField;
    
    NSMutableArray* allUserStore;

    NSInteger defaultCityID;
    NSString* defaultCityName;
    
    NSInteger defaultCountryID;
    NSString* defaultCountryName;
    
    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;
    int chosenImgBtnTag;
    UIButton * recentUploadedImageDelBtn;
    
    //int chosenRemoveImgBtnTag;
    //int removeCounter;
    //BOOL firstRemove;
    
    
    UIImage * currentImageToUpload;
    LocationManager * locationMngr;
    StoreManager *advFeatureManager;
    CLLocationManager * deviceLocationDetector;
    CLLocation *PropertyLocation;
    
    NSUInteger defaultIndex;
    NSUInteger defaultCityIndex;
    NSUInteger defaultCurrencyID;
    NSUInteger defaultcurrecncyIndex;
    
    NSInteger defaultStoreIndex;
    NSInteger myAdID;
    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenPeriod;
    SingleValue * chosenUnit;
    City * chosenCity;
    Country * chosenCountry;
    Store* myStore;

    SingleValue * chosenRoom;
    float longitude;
    float latittude;
    int RequiredService;
    BOOL choosingStore;

    BOOL guestCheck;
    NSString* guestEmail;
    
    NSMutableArray * currentImgsUploaded;
    BOOL locationBtnPressedOnce;
    BOOL currencyBtnPressedOnce;
    BOOL roomsBtnPressedOnce;
    BOOL periodBtnPressedOnce;
    BOOL mapLocationBtnPressedOnce;
    BOOL unitsBtnPressedOnce;
    BOOL storeBtnPressedOnce;

    NSTimer *timer;
    UIToolbar* numberToolbar;
    
    //iPad related
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
    NSMutableArray * CategoryCellsArray;
    Category1 * chosenCategory;
    BOOL CatOneSelectionMade;
    //ChooseModelView_iPad * dropDownView;
    
    NSArray* currentCategory;
    //NSArray* currentModels;
    
}
@end

@implementation AddNewStoreAdViewController_iPad
@synthesize carAdTitle,mobileNum,carDetails,carPrice,countryCity,currency,kiloMile,carDetailLabel;
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
    //self.inputAccessoryView = [XCDFormInputAccessoryView new];
    
    currentCategory = [NSMutableArray arrayWithArray:
                       [[AdsManager sharedInstance] getCategoriesForstatus:self.browsingForSale]];
    locationMngr = [LocationManager sharedInstance];
    
    allUserStore = [[NSMutableArray alloc]init];

    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getUserStores];
    
    advFeatureManager = [[StoreManager alloc] init];
    advFeatureManager.delegate = self;

    
    RequiredService = 2;
    [self loadData];
    
    // Set the image piacker
    chosenImgBtnTag = -1;
    //chosenRemoveImgBtnTag = -1;
    //removeCounter = 1;
    
    currentImageToUpload = nil;
    currentImgsUploaded = [NSMutableArray new];
    
    // Set tapping gesture
    tap2 = [[UITapGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(dismissKeyboard)];
    //[self.iPad_setPhotoView addGestureRecognizer:tap2];
    [self.iPad_mainScrollView addGestureRecognizer:tap2];
    
    
    locationBtnPressedOnce = NO;
    currencyBtnPressedOnce = NO;
    roomsBtnPressedOnce = NO;
    periodBtnPressedOnce = NO;
    mapLocationBtnPressedOnce = NO;
    unitsBtnPressedOnce = NO;
    storeBtnPressedOnce = NO;

    
    [self loadDataArray];
    //[self addButtonsToXib];
    
    [self closePicker];
    
    //set image names
    iPad_chooseBrandBtnImgOn = [UIImage imageNamed:@"iPad_add_option1_on.png"];
    iPad_chooseBrandBtnImgOff = [UIImage imageNamed:@"iPad_add_option1_off.png"];
    
    iPad_setPhotosBtnImgOn = [UIImage imageNamed:@"iPad_add_option2_on.png"];
    iPad_setPhotosBtnImgOff = [UIImage imageNamed:@"iPad_add_option2_off.png"];
    
    iPad_setDetailsBtnImgOn = [UIImage imageNamed:@"iPad_add_option3_on.png"];
    iPad_setDetailsBtnImgOff = [UIImage imageNamed:@"iPad_add_option3_off.png"];
    
    
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
    
    //self.carDetails.layer.cornerRadius = 10.0f;
    //[self.carDetails setNeedsDisplay];
    
    
    //add margins to textfields
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(self.carAdTitle.frame.size.width - 20, 0, 5, self.carAdTitle.frame.size.height)];
    self.carAdTitle.rightView = paddingView1;
    self.carAdTitle.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(self.mobileNum.frame.size.width - 20, 0, 5, self.mobileNum.frame.size.height)];
    self.mobileNum.rightView = paddingView2;
    self.mobileNum.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(self.carPrice.frame.size.width - 20, 0, 5, self.carPrice.frame.size.height)];
    self.carPrice.rightView = paddingView3;
    self.carPrice.rightViewMode = UITextFieldViewModeAlways;
    
    /*UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(self.distance.frame.size.width - 20, 0, 5, self.distance.frame.size.height)];
     self.distance.rightView = paddingView4;
     self.distance.rightViewMode = UITextFieldViewModeAlways;*/
    
    
    for (int i =0; i < 6; i++) {
        UIButton * delBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:((i+1) * 100)];
        [delBtn setHidden:YES];
    }
    
    recentUploadedImageDelBtn = nil;
    //choose brand view:
    //------------------
    CategoryCellsArray = [NSMutableArray new];
    
    chosenCategory = nil;
    choosingStore = NO;
    //self.currentModel = nil;
    
    CatOneSelectionMade = NO;
    //dropDownView = nil;
    
    //[[BrandsManager sharedInstance] getBrandsAndModelsForPostAdWithDelegate:self];
    
    
    [self iPad_srollToBrandsView];
    [self iPad_setStepViews]; //Todo create the table of categories
    
    
    /*
     //set the title of location button
     int defaultCountryID =  [[LocationManager sharedInstance] getSavedUserCountryID];
     int defaultCityID =  [[LocationManager sharedInstance] getSavedUserCityID];
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
     */
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Post Ad screen"];
    //[TestFlight passCheckpoint:@"Post Ad screen"];
    //end GA
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    [self closePicker];
    [self.pickersView setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - location handler.

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countryArray=resultArray;
    [self hideLoadingIndicator];
    currencyArray= [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    roomsArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadRoomsValues]];
    serviceReqArray=[[NSArray alloc] initWithObjects:@"معروض",@"مطلوب",@"تقسيط", nil];
    unitsArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadUnitValues]];
    periodsArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance]loadAddPeriodValues]];
    
    //[self.modelNameLabel setText:self.currentModel.modelName];
    // Setting default country
    //defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    defaultIndex = [locationMngr getIndexOfCountry:[[SharedUser sharedInstance] getUserCountryID]];
    if  (defaultIndex!= -1){
        chosenCountry =[countryArray objectAtIndex:defaultIndex];//set initial chosen country
        cityArray=[chosenCountry cities];
        if (cityArray && cityArray.count)
        {
            defaultCityIndex = [locationMngr getIndexOfCity:[[SharedUser sharedInstance] getUserCityID] inCountry:chosenCountry];
            if (defaultCityIndex != -1)
                chosenCity=[cityArray objectAtIndex:defaultCityIndex];
            else
                chosenCity=[cityArray objectAtIndex:0];
        }
        
        defaultCurrencyID=[[StaticAttrsLoader sharedInstance] getCurrencyIdOfCountry:[[SharedUser sharedInstance] getUserCountryID]];
        defaultcurrecncyIndex=0;
        while (defaultcurrecncyIndex<currencyArray.count) {
            if (defaultCurrencyID==[(SingleValue*)[currencyArray objectAtIndex:defaultcurrecncyIndex] valueID]) {
                break;
            }
            defaultcurrecncyIndex++;
        }
        chosenCurrency=[currencyArray objectAtIndex:defaultcurrecncyIndex];
    }
    
}

// This method loads the device location initialli, and afterwards the loading of country lists comes after
- (void) loadData {
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
}

- (void) loadDataArray{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper methods

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
        CGRect popOverFrame = self.iPad_cameraPopOver.contentViewController.view.frame;
        [self.iPad_cameraPopOver setPopoverContentSize:popOverFrame.size];
        self.iPad_cameraPopOver.delegate = self;
        [self.iPad_cameraPopOver presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void) useImage:(UIImage *) image {
    
    currentImageToUpload = image;
    [self showLoadingIndicatorOnImages];
    [[AdsManager sharedInstance] uploadImage:image WithDelegate:self];
}

-(void)dismissKeyboard {
    //[self closePicker];
    [carAdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [carPrice resignFirstResponder];
    [_propertySpace resignFirstResponder];
    [_propertyArea resignFirstResponder];
    [_unitPrice resignFirstResponder];
    [_phoneNum resignFirstResponder];
    [carDetails resignFirstResponder];
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


- (void) showLoadingIndicator {
    
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
    
    if ((iPad_activityIndicator) && (iPad_loadingView)) {
        [iPad_activityIndicator stopAnimating];
        [iPad_loadingView removeFromSuperview];
    }
    iPad_activityIndicator = nil;
    iPad_loadingView = nil;
    iPad_loadingLabel = nil;
}

- (void) hideLoadingIndicatorOnImages {
    
    if ((iPad_imgsActivityIndicator) && (iPad_imgsLoadingView)) {
        [iPad_imgsActivityIndicator stopAnimating];
        [iPad_imgsLoadingView removeFromSuperview];
    }
    iPad_imgsActivityIndicator = nil;
    iPad_imgsLoadingView = nil;
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

#pragma mark - picker methods

-(IBAction)closePicker
{
    [self.pickersView setHidden:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        /*
         self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
         [[UIScreen mainScreen] bounds].size.height,
         self.pickersView.frame.size.width,
         self.pickersView.frame.size.height);
         */
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                            self.view.frame.size.height,
                                            self.pickersView.frame.size.width,
                                            self.pickersView.frame.size.height);
    }];
}


-(IBAction)showPicker
{
    [carAdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [carPrice resignFirstResponder];
    [_propertySpace resignFirstResponder];
    [_propertyArea resignFirstResponder];
    [_unitPrice resignFirstResponder];
    [_phoneNum resignFirstResponder];
    [carDetails resignFirstResponder];
    
    [self.pickersView setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                            508.0f,
                                            self.pickersView.frame.size.width,
                                            self.pickersView.frame.size.height);
        
    }];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    /*
     if (pickerView==_locationPickerView) {
     return 2;
     }
     else {
     */
    return 1;
    //}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*
     if (pickerView==_locationPickerView) {
     if (component==0) {
     chosenCountry=(Country *)[countryArray objectAtIndex:row];
     cityArray=[chosenCountry cities];
     if (cityArray && cityArray.count)
     chosenCity=[cityArray objectAtIndex:0];//set initial chosen city
     NSString *temp= [NSString stringWithFormat:@"%@ : %@", chosenCountry.countryName , chosenCity.cityName];
     [countryCity setTitle:temp forState:UIControlStateNormal];
     [pickerView reloadAllComponents];
     locationBtnPressedOnce = YES;
     }
     else{
     
     chosenCity=[cityArray objectAtIndex:row];
     NSString *temp= [NSString stringWithFormat:@"%@ : %@", chosenCountry.countryName , chosenCity.cityName];
     [countryCity setTitle:temp forState:UIControlStateNormal];
     [pickerView reloadAllComponents];
     locationBtnPressedOnce = YES;
     }
     
     }
     
     
     else {
     */
    SingleValue *choosen=[globalArray objectAtIndex:row];
    if ([currencyArray containsObject:choosen]) {
        chosenCurrency=[globalArray objectAtIndex:row];
        [currency setTitle:choosen.valueString forState:UIControlStateNormal];
        currencyBtnPressedOnce = YES;
    }
    else if ([periodsArray containsObject:choosen]){
        chosenPeriod=[globalArray objectAtIndex:row];
        [_adPeriod setTitle:[NSString stringWithFormat:@"%@",choosen.valueString] forState:UIControlStateNormal];
        periodBtnPressedOnce = YES;
    }
    else if ([roomsArray containsObject:choosen]){
        chosenRoom = [globalArray objectAtIndex:row];
        [self.roomNum setTitle:[NSString stringWithFormat:@"%@",chosenRoom.valueString] forState:UIControlStateNormal];
        roomsBtnPressedOnce = YES;
    }
    else {
        chosenUnit=[globalArray objectAtIndex:row];
        [_units setTitle:[NSString stringWithFormat:@"%@",choosen.valueString] forState:UIControlStateNormal];
        unitsBtnPressedOnce = YES;
    }
    //}
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    /*
     if (pickerView==_locationPickerView) {
     if (component==0) {
     return [countryArray count];
     }
     else{
     return [cityArray count];
     }
     }
     else {
     */
    return [globalArray count];
    //}
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    /*
     if (pickerView==_locationPickerView) {
     if (component==0) {
     Country *temp=(Country*)[countryArray objectAtIndex:row];
     return temp.countryName;
     }
     else{
     City *temp=(City*)[cityArray objectAtIndex:row];
     return temp.cityName;
     }
     }
     else {
     */
    return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
    //}
    
    
}

#pragma mark - Buttons Actions

-(IBAction)chooseStore:(id) sender
{
    self.pickerView.hidden=YES;
    [self dismissKeyboard];
    
    
    // fill picker with production year
    globalArray=allUserStore;
    if (!storeBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            myStore = (Store *)[globalArray objectAtIndex:0];
    }
    storeBtnPressedOnce = YES;
    choosingStore = YES;
    
    //NSString *temp= [NSString stringWithFormat:@"%@",[(Store*)[allUserStore objectAtIndex:0] name]];
    NSString *temp= [NSString stringWithFormat:@"%@",myStore.name];
    [_theStore setTitle:temp forState:UIControlStateNormal];
    
    [self iPad_dismissPopOvers];
    
    if (!self.iPad_storePopOver) {
        TableInPopUpTableViewController * storeVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        storeVC.choosingDelegate = self;
        storeVC.arrayValues = globalArray;
        
        storeVC.showingPeriodRangeObjects = NO;
        storeVC.showingRoomsObjects = NO;
        storeVC.showingUnitsObjects = NO;
        storeVC.showingSingleValueObjects = NO;
        storeVC.showingStores = YES;
        
        self.iPad_storePopOver = [[UIPopoverController alloc] initWithContentViewController:storeVC];
        storeBtnPressedOnce = YES;
    }
    
    CGRect popOverFrame = self.iPad_storePopOver.contentViewController.view.frame;
    [self.iPad_storePopOver setPopoverContentSize:popOverFrame.size];
    [self.iPad_storePopOver presentPopoverFromRect:[(UIButton *)sender frame] inView:[(UIButton *)sender superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    //[self showPicker];
}


- (IBAction) chooseCurrency:(id) sender
{
    self.pickerView.hidden=YES;
    [self dismissKeyboard];
    
    // fill picker with production year
    globalArray=currencyArray;
    
    //[self.pickerView reloadAllComponents];
    
    if (!currencyBtnPressedOnce)
    {
        //[self.pickerView selectRow:defaultcurrecncyIndex inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenCurrency = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    //[self showPicker];
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)chosenCurrency valueString]];
    [currency setTitle:temp forState:UIControlStateNormal];
    
    [self iPad_dismissPopOvers];
    
    if (!self.iPad_currencyPopOver) {
        TableInPopUpTableViewController * currencyVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        currencyVC.choosingDelegate = self;
        currencyVC.arrayValues = globalArray;
        currencyVC.showingPeriodRangeObjects = NO;
        currencyVC.showingRoomsObjects = NO;
        currencyVC.showingUnitsObjects = NO;
        currencyVC.showingSingleValueObjects = YES;
        currencyVC.showingStores = NO;
        
        self.iPad_currencyPopOver = [[UIPopoverController alloc] initWithContentViewController:currencyVC];
        currencyBtnPressedOnce = YES;
    }
    
    CGRect popOverFrame = self.iPad_currencyPopOver.contentViewController.view.frame;
    [self.iPad_currencyPopOver setPopoverContentSize:popOverFrame.size];
    [self.iPad_currencyPopOver presentPopoverFromRect:[(UIButton *)sender frame] inView:[(UIButton *)sender superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

}

- (IBAction)chooseCountryCity:(id)sender{
    
    CountryListViewController* vc;
    vc = [[CountryListViewController alloc]initWithNibName:@"CountriesPopOver_iPad" bundle:nil];
    self.iPad_countryPopOver = [[UIPopoverController alloc] initWithContentViewController:vc];
    [self.iPad_countryPopOver setPopoverContentSize:vc.view.frame.size];
    //NSLog(@"w:%f, h:%f", vc.view.frame.size.width, vc.view.frame.size.height);
    [self dismissKeyboard];
    //[self.iPad_countryPopOver setPopoverContentSize:CGSizeMake(550, 700)];
    vc.iPad_parentViewOfPopOver = self;
    //[self.iPad_countryPopOver presentPopoverFromRect:self.countryCity.frame inView:self.countryCity.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.iPad_countryPopOver presentPopoverFromRect:self.countryCity.frame inView:self.countryCity permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (IBAction)chooseRoomsNum:(id)sender
{
    [self dismissKeyboard];
    self.pickerView.hidden=NO;
    
    // fill picker with room
    globalArray=roomsArray;
    
    if (!roomsBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            chosenRoom = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    NSString *temp= [NSString stringWithFormat:@"%@",chosenRoom.valueString];
    [_roomNum setTitle:temp forState:UIControlStateNormal];
    
    [self iPad_dismissPopOvers];
    
    if (!self.iPad_roomsPopOver) {
        TableInPopUpTableViewController * roomsVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        roomsVC.choosingDelegate = self;
        roomsVC.arrayValues = globalArray;
        
        roomsVC.showingPeriodRangeObjects = NO;
        roomsVC.showingRoomsObjects = YES;
        roomsVC.showingUnitsObjects = NO;
        roomsVC.showingSingleValueObjects = NO;
        roomsVC.showingStores = NO;
        
        self.iPad_roomsPopOver = [[UIPopoverController alloc] initWithContentViewController:roomsVC];
        
        roomsBtnPressedOnce = YES;
    }
    
    CGRect popOverFrame = self.iPad_roomsPopOver.contentViewController.view.frame;
    [self.iPad_roomsPopOver setPopoverContentSize:popOverFrame.size];
    [self.iPad_roomsPopOver presentPopoverFromRect:[(UIButton *)sender frame] inView:[(UIButton *)sender superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)chooseMapLocation:(id)sender {
    
    //load location map page
    MapLocationViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        vc =[[MapLocationViewController alloc] initWithNibName:@"MapLocationViewController" bundle:nil];
        vc.selectedMapDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else{
        vc =[[MapLocationViewController alloc] initWithNibName:@"MapLocationViewController_iPad" bundle:nil];
        vc.selectedMapDelegate = self;
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        vc.view.superview.frame = CGRectMake(100, 0, 800, 650);
        vc.view.superview.bounds = CGRectMake(100, 0, 800, 650);
        vc.view.superview.center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 2));
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    
}

-(void)selectedMapLocationIs:(CLLocation *)pinLocation andAddress:(NSString *)Address
{
    PropertyLocation = pinLocation;
    [_mapLocation setTitle:@"تم تحديد الموقع" forState:UIControlStateNormal];
    [_propertyArea setText:Address];
}

- (IBAction)choosePeriod:(id)sender {
    [self dismissKeyboard];
    self.pickerView.hidden=NO;
    
    // fill picker with room
    globalArray=periodsArray;
    
    if (!periodBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            chosenPeriod = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    NSString *temp= [NSString stringWithFormat:@"%@",chosenPeriod.valueString];
    [_adPeriod setTitle:temp forState:UIControlStateNormal];
    
    [self iPad_dismissPopOvers];
    
    if (!self.iPad_periodPopOver) {
        TableInPopUpTableViewController * periodVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        periodVC.choosingDelegate = self;
        periodVC.arrayValues = globalArray;
        
        periodVC.showingPeriodRangeObjects = YES;
        periodVC.showingRoomsObjects = NO;
        periodVC.showingUnitsObjects = NO;
        periodVC.showingSingleValueObjects = NO;
        periodVC.showingStores = NO;
        
        self.iPad_periodPopOver = [[UIPopoverController alloc] initWithContentViewController:periodVC];
        
        periodBtnPressedOnce = YES;
    }
    
    CGRect popOverFrame = self.iPad_periodPopOver.contentViewController.view.frame;
    [self.iPad_periodPopOver setPopoverContentSize:popOverFrame.size];
    [self.iPad_periodPopOver presentPopoverFromRect:[(UIButton *)sender frame] inView:[(UIButton *)sender superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)chooseUnits:(id)sender {
    [self dismissKeyboard];
    self.pickerView.hidden=NO;
    
    // fill picker with room
    globalArray=unitsArray;
    
    if (!unitsBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            chosenUnit = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    NSString *temp= [NSString stringWithFormat:@"%@",chosenUnit.valueString];
    [_units setTitle:temp forState:UIControlStateNormal];
    
    [self iPad_dismissPopOvers];
    
    if (!self.iPad_unitsPopOver) {
        TableInPopUpTableViewController * unitVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        unitVC.choosingDelegate = self;
        unitVC.arrayValues = globalArray;
        
        unitVC.showingPeriodRangeObjects = NO;
        unitVC.showingRoomsObjects = NO;
        unitVC.showingUnitsObjects = YES;
        unitVC.showingSingleValueObjects = NO;
        unitVC.showingStores = NO;
        
        self.iPad_unitsPopOver = [[UIPopoverController alloc] initWithContentViewController:unitVC];
        
        unitsBtnPressedOnce = YES;
    }
    
    CGRect popOverFrame = self.iPad_unitsPopOver.contentViewController.view.frame;
    [self.iPad_unitsPopOver setPopoverContentSize:popOverFrame.size];
    [self.iPad_unitsPopOver presentPopoverFromRect:[(UIButton *)sender frame] inView:[(UIButton *)sender superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)iPad_chooseRequiredService:(id)sender {
    UIButton* btn = (UIButton*)sender;
    switch (btn.tag) {
        case 1:
            [self.iPad_requireBtn1 setSelected:YES];
            [self.iPad_requireBtn2 setSelected:NO];
            [self.iPad_requireBtn3 setSelected:NO];
            RequiredService = 2307;
            break;
            
        case 2:
            [self.iPad_requireBtn1 setSelected:NO];
            [self.iPad_requireBtn2 setSelected:YES];
            [self.iPad_requireBtn3 setSelected:NO];
            RequiredService = 2305;
            break;
            
        case 3:
            [self.iPad_requireBtn1 setSelected:NO];
            [self.iPad_requireBtn2 setSelected:NO];
            [self.iPad_requireBtn3 setSelected:YES];
            RequiredService = 2306;
            break;
            
        default:
            break;
    }
}



- (IBAction)doneBtnPrss:(id)sender {
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
 
 }*/

- (IBAction) iPad_closeBtnPrss:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addBtnprss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Post Car Ad"
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
    
    
    if ([allUserStore count] == 0) {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"لا يوجد لديك متاجر" delegateVC:self];
        return;
        
    }
    
    
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
    
    if ((!chosenCountry) || (!chosenCity))
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
    
    /*
     //check price
     if ( ([[carPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""])
     ||
     ([[carPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] integerValue] == 0) )
     {
     [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال قيمة سعر صحيحة للإعلان" delegateVC:self];
     return;
     }
     
     //check distance
     if ( ([[distance.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""])
     ||
     ([[distance.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] integerValue] == 0) )
     {
     [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال قيمة مسافة صحيحة للإعلان" delegateVC:self];
     return;
     }
     */
    //check currency
    if (!chosenCurrency)
    {
        //check price
        if ( [carPrice.text length] != 0 && ![carPrice.text isEqualToString:@"0"])
        {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار عملة مناسبة" delegateVC:self];
            return;
            
        }
    }
    
    /*   //check year
     if (!yearBtnPressedOnce)
     {
     [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار تاريخ للصنع" delegateVC:self];
     return;
     }
     */
    //check phone number
    if (!mobileNum.text)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال رقم هاتف" delegateVC:self];
        return;
    }
    
    
    
    
    
    
    [self showLoadingIndicator];
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedProfile && !guestCheck) {
        [self EmailRequire];
        return;
    }
    
    if ([carDetails.text isEqualToString:@""]) {
        carDetails.text = placeholderTextField.text;
    }
    if ([_propertySpace.text length] == 0) {
        _propertySpace.text = @"";
    }
    if ([carPrice.text length] == 0) {
        carPrice.text = @"";
    }
    
    /*[[AdsManager sharedInstance] postAdOfBrand:1
     Model:1
     InCity:chosenCity.cityID
     userEmail:(savedProfile ? savedProfile.emailAddress : guestEmail)
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
     phoneNumer:guestEmail
     adCommentsEmail:YES
     kmVSmilesValueID:distanceUnitID
     imageIDs:currentImgsUploaded
     withDelegate:self];*/
    
    
    
    if (self.browsingForSale) {
        // post for sale
        [[AdsManager sharedInstance] postStoreAdForSaleOfCategory:self.currentSubCategoryID myStore:myStore.identifier InCity:chosenCity.cityID userEmail:(savedProfile ? savedProfile.emailAddress : guestEmail) title:carAdTitle.text description:carDetails.text adPeriod:chosenPeriod.valueID requireService:RequiredService price:carPrice.text currencyValueID:chosenCurrency.valueID unitPrice:_unitPrice.text unitType:chosenUnit.valueID imageIDs:currentImgsUploaded longitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.latitude] roomNumber:chosenRoom.valueString space:_propertySpace.text area:_propertyArea.text mobile:mobileNum.text phoneNumer:_phoneNum.text withDelegate:self];
        
    }else
    {
        //post for rent
        [[AdsManager sharedInstance] postStoreAdForRentOfCategory:self.currentSubCategoryID myStore:myStore.identifier InCity:chosenCity.cityID userEmail:(savedProfile ? savedProfile.emailAddress : guestEmail) title:carAdTitle.text description:carDetails.text adPeriod:chosenPeriod.valueID requireService:RequiredService price:carPrice.text currencyValueID:chosenCurrency.valueID unitPrice:_unitPrice.text unitType:chosenUnit.valueID imageIDs:currentImgsUploaded longitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.latitude] roomNumber:chosenRoom.valueString space:_propertySpace.text area:_propertyArea.text mobile:mobileNum.text phoneNumer:_phoneNum.text withDelegate:self];
    }
    
    
}

-(void)EmailRequire{
    [self hideLoadingIndicator];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"الرجاء تزويدنا بالبريد الإلكتروني"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:@"إلغاء", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //self.emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, 260, 25)];
    //[self.emailAddress setBackgroundColor:[UIColor whiteColor]];
    //[self.emailAddress setPlaceholder:@"123@eample.com"];
    //[self.emailAddress setTextAlignment:NSTextAlignmentCenter];
    //self.emailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    
    //[alert addSubview:self.emailAddress];
    
    // show the dialog box
    alert.tag = 4;
    [alert show];
    
    // set cursor and show keyboard
    //[self.emailAddress becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        alertView.hidden = YES;
        [self featurecurrentStoreAd:myAdID];
        
    }
    else if (alertView.tag == 2) {
        NSString* purpose;
        if (self.browsingForSale)
            purpose = @"sale";
        else
            purpose = @"rent";
        [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:chosenCountry.countryID forPurpose:purpose withDelegate:self];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        BrowseStoresViewController *vc=[[BrowseStoresViewController alloc] initWithNibName:@"BrowseStoresViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
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
        labelAdViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
        else
            vc =[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
        vc.currentAdID = myAdID;
        vc.countryAdID = chosenCountry.countryID;
        vc.currentAdHasImages = NO;
        if (currentImgsUploaded && currentImgsUploaded.count)
            vc.currentAdHasImages = YES;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (IBAction)selectModelBtnPrss:(id)sender {
    ChooseCategoryViewController *vc=[[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
    vc.tagOfCallXib=2;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void) dismissSelfAfterFeaturing {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [self SelectPhotoFromLibrary];
    }
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenImgBtnTag];
    
    tappedBtn.clipsToBounds = YES;
    //tappedBtn.layer.cornerRadius = 10.0f;
    
    [tappedBtn setImage:[GenericMethods imageWithImage:img scaledToSize:tappedBtn.frame.size] forState:UIControlStateNormal];
    [tappedBtn setUserInteractionEnabled:NO];
    
    UIButton * delBtn;// = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:(chosenImgBtnTag * 10)];
    
    for (UIView * subView in tappedBtn.superview.subviews) {
        if (([subView class] == [UIButton class]) && (subView.tag != tappedBtn.tag))
            delBtn = (UIButton *) subView;
    }
    
    [delBtn setHidden:NO];
    recentUploadedImageDelBtn = delBtn;
    
    [self useImage:img];
    if (self.iPad_cameraPopOver)
        [self.iPad_cameraPopOver dismissPopoverAnimated:YES];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - iploadImage Delegate

- (void) imageDidFailUploadingWithError:(NSError *)error {
    
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
    
    //add image data to this ad
    [currentImgsUploaded addObject:[NSNumber numberWithInteger:ID]];
    
    recentUploadedImageDelBtn.tag = ID;
    
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
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

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
        [_theStore setTitle:self.currentStore.name forState:UIControlStateNormal];
    }
    //[self.storePickerView reloadAllComponents];
    [self hideLoadingIndicator];
}

- (void) adDidFailPostingWithError:(NSError *)error {
    [self hideLoadingIndicator];
    NSLog(@"%@",[error description]);
    if ([[error description] isEqualToString:@"validate_password"]) {
        UIAlertView* alert =[ [UIAlertView alloc]initWithTitle:@"" message:@"البريد الإلكنروني مسجل لدينا يرجى تسجيل الدخول" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        alert.tag = 5;
        [alert show];
    }else
        [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
}

- (void) adDidFinishPostingWithAdID:(NSInteger)adID {
    
    myAdID = adID;
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"Success"
                         withLabel:@"Post Car Ad"
                         withValue:[NSNumber numberWithInt:100]];
    NSString* purpose;
    if (self.browsingForSale)
        purpose = @"sale";
    else
        purpose = @"rent";
    
    [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:chosenCountry.countryID forPurpose:purpose withDelegate:self];
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:@"تمت إضافة إعلانك بنجاج" delegateVC:self];
    
    
    
    
}

#pragma mark - PricingOptions Delegate

- (void) optionsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    CarAdDetailsViewController *details;
    CarAdDetailsViewController_iPad * vc;
    if (currentImgsUploaded && currentImgsUploaded.count) {  //ad with image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
            details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            details.currentAdID = myAdID;
            details.checkPage = YES;
            [self presentViewController:details animated:YES completion:nil];
            
        }
        else{
            vc = [[CarAdDetailsViewController_iPad alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.currentAdID = myAdID;
            vc.checkPage = YES;
            [self presentViewController:vc animated:YES completion:nil];
            
        }
        
    }
    else {                            //ad with no image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
            details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            details.currentAdID = myAdID;
            details.checkPage = YES;
            [self presentViewController:details animated:YES completion:nil];
        }
        else{
            vc = [[CarAdDetailsViewController_iPad alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.currentAdID = myAdID;
            vc.checkPage = YES;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
    
}

- (void) optionsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    
    if (resultArray.count == 0) {
        //CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        CarAdDetailsViewController *details;
        CarAdDetailsViewController_iPad * vc;
        if (currentImgsUploaded && currentImgsUploaded.count) {  //ad with image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
                details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                details.currentAdID = myAdID;
                details.checkPage = YES;
                [self presentViewController:details animated:YES completion:nil];
                
            }
            else{
                vc = [[CarAdDetailsViewController_iPad alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                vc.currentAdID = myAdID;
                vc.checkPage = YES;
                [self presentViewController:vc animated:YES completion:nil];
                
            }
            
        }
        else {                            //ad with no image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
                details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                details.currentAdID = myAdID;
                details.checkPage = YES;
                [self presentViewController:details animated:YES completion:nil];
            }
            else{
                vc = [[CarAdDetailsViewController_iPad alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                vc.currentAdID = myAdID;
                vc.checkPage = YES;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        
        
        
    }else {
        labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
        vc.currentAdID = myAdID;
        vc.countryAdID = chosenCountry.countryID;
        //vc.iPad_parentNewCarVC = self;
        vc.currentAdHasImages = NO;
        if (currentImgsUploaded && currentImgsUploaded.count)
            vc.currentAdHasImages = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

#pragma mark - featuring an ad related to a store

- (void)featurecurrentStoreAd:(NSInteger)advID {
    if (myStore)
    {
        labelStoreAdViewController_iPad *vc=[[labelStoreAdViewController_iPad alloc] initWithNibName:@"labelStoreAdViewController_iPad" bundle:nil];
        vc.currentAdID = myAdID;
        vc.countryAdID = chosenCountry.countryID;
        vc.iPad_currentStore = myStore;
        vc.currentAdHasImages = NO;
        vc.isReturn = NO;
        if (currentImgsUploaded && currentImgsUploaded.count)
            vc.currentAdHasImages = YES;
        
        [self presentViewController:vc animated:YES completion:nil];
        //}
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


#pragma mark - iPad actions

- (IBAction) iPad_chooseBrandBtnPrss:(id) sender {
    [self dismissKeyboard];
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOff forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOff forState:UIControlStateNormal];
    
    [self iPad_srollToBrandsView];
}

- (IBAction) iPad_setPhotosBtnPrss:(id) sender {
    [self dismissKeyboard];
    
    //if (!_currentModel)
    //{
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار نوع السيارة" delegateVC:self];
    //return;
    // }
    
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOff forState:UIControlStateNormal];
    
    [self iPad_srollToPhotosView];
}

- (IBAction) iPad_setDetailsBtnPrss:(id) sender {
    [self dismissKeyboard];
    
    //check country & city
    if (!locationBtnPressedOnce)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار بلد ومدينة مناسبين" delegateVC:self];
        return;
    }
    
    if ((!chosenCountry) || (!chosenCity))
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار بيانات المكان صحيحة" delegateVC:self];
        return;
    }
    
    if (!myStore)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار المتجر" delegateVC:self];
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
    
    
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOn forState:UIControlStateNormal];
    
    [self iPad_srollToDetailsView];
    
}

- (IBAction)iPad_deleteUploadedImage:(id)sender {
    //NSLog(@"No api method provided for deleting an uploaded image");
    
    if (iPad_imgsLoadingView) {
        [GenericMethods throwAlertWithTitle:@"" message:@"الرجاء الانتظار حتى انتهاء رفع الصور السابقة" delegateVC:nil];
        return;
    }
    UIButton* senderBtn = (UIButton *)sender;
    UIButton * originalImgBtn;
    for (UIView * subView in senderBtn.superview.subviews) {
        if (([subView class] == [UIButton class]) && (subView.tag != senderBtn.tag))
            originalImgBtn = (UIButton *) subView;
    }
    [originalImgBtn setImage:[UIImage imageNamed:@"tb_add_individual3_add_image_btn.png"] forState:UIControlStateNormal];
    [originalImgBtn setUserInteractionEnabled:YES];
    
    [self ImageDelete:sender];
}


-(IBAction) ImageDelete:(id)sender {
    
    UIButton* senderBtn = (UIButton *)sender;
    //chosenRemoveImgBtnTag = senderBtn.tag / 10;
    //chosenRemoveImgBtnTag = senderBtn.tag;
    
    [senderBtn setHidden:YES];
    int index = -1;
    for (int i = 0; i < currentImgsUploaded.count; i++) {
        if (senderBtn.tag == [(NSNumber *) currentImgsUploaded[i] integerValue])
            index  =i;
    }
    
    if (index != -1)
        [currentImgsUploaded removeObjectAtIndex:index];
    /*
     if (firstRemove) {
     
     if (chosenRemoveImgBtnTag/10 - removeCounter <= 0) {
     removeCounter--;
     while (chosenRemoveImgBtnTag/10 - removeCounter < 0) {
     removeCounter--;
     }
     
     }
     
     }
     if ([currentImgsUploaded count] == 1)
     [currentImgsUploaded removeObjectAtIndex:0];
     else
     [currentImgsUploaded removeObjectAtIndex:chosenRemoveImgBtnTag/10 - removeCounter];
     
     firstRemove = YES;
     
     removeCounter++;
     */
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
    int categories_x = 500;
    int categories_y = 0;
    for (int i = 0; i < [currentCategory count]; i++) {
        Category1* categ = [currentCategory objectAtIndex:i];
        
        UIView* CatContainer = [[UIView alloc] initWithFrame:CGRectMake(categories_x, categories_y, 250, 50)];
        CatContainer.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0f];
        
        UIImageView* CatImg = [[UIImageView alloc] initWithFrame:CGRectMake(220, 15, 20, 20)];
        CatImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"small_default-Cat-%i",categ.categoryID]];
        
        UILabel* CatLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 50)];
        CatLbl.text = categ.categoryName;
        CatLbl.textAlignment = NSTextAlignmentRight;
        CatLbl.backgroundColor = [UIColor clearColor];
        CatLbl.textColor = [UIColor blackColor];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 250, 50);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = categ.categoryID;
        [btn addTarget:self action:@selector(iPad_userDidEndChoosingCategoryFromPopOver:) forControlEvents:UIControlEventTouchUpInside];
        
        [CatContainer addSubview:CatImg];
        [CatContainer addSubview:CatLbl];
        [CatContainer addSubview:btn];
        
        categories_y+=51;
        if (categories_y == 459) {
            categories_x -= 251;
            categories_y = 0;
        }
        [self.iPad_chooseCategoryScrollView addSubview:CatContainer];
        if (categories_x == -2 && categories_y == 408) {
            UIView* CatContainer = [[UIView alloc] initWithFrame:CGRectMake(categories_x, categories_y, 250, 50)];
            CatContainer.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0f];
            [self.iPad_chooseCategoryScrollView addSubview:CatContainer];
        }
        
    }
    /* ModelsViewController_iPad * modelsVC = [[ModelsViewController_iPad alloc] initWithNibName:@"ModelsViewController_iPad" bundle:nil];
     
     //vc.tagOfCallXib=2;
     modelsVC.displayedAsPopOver = NO;*/
    //[self presentViewController:modelsVC animated:YES completion:nil];
    
}

- (void) iPad_userDidEndChoosingCountryFromPopOver {
    if (self.iPad_countryPopOver) {
        locationBtnPressedOnce = YES;
        int defaultCountryID =  [[LocationManager sharedInstance] getSavedUserCountryID];
        int defaultCityID =  [[LocationManager sharedInstance] getSavedUserCityID];
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

-(void)iPad_userDidEndChoosingCategoryFromPopOver:(UIButton*)sender
{
    NSLog(@"category ID : %i",sender.tag);
    self.currentSubCategoryID = sender.tag;
    
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOff forState:UIControlStateNormal];
    
    [self iPad_srollToPhotosView];
    
}

//------------------------------ LEVEL1: CHOOSING BRANDS ------------------------------
#pragma mark - LEVEL1: CHOOSING BRANDS

- (void) brandsDidFinishLoadingWithData:(NSArray*) resultArray {
    currentCategory=resultArray;
    currentCategory=((Category1*)resultArray[0]);
    
    //currentModels = ((Brand*)resultArray[0]).models;
    chosenCategory =(Category1*)[currentCategory objectAtIndex:0];
    
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
    /*   if (brandCellsArray && brandCellsArray.count) {
     UITapGestureRecognizer * tapOfFirstCell = [(BrandCell *) brandCellsArray[0] gestureRecognizers][0];
     [self didSelectBrandCell:tapOfFirstCell];
     }*/
    
}

- (void) DrawBrands {
    float currentX = 0;
    float currentY = 0;
    float totalHeight = 0;
    
    int rowCounter = 0;
    int colCounter = 0;
    
    CGRect brandFrame;
    /*
     for (int i = 0; i < currentCategory.count; i++) {
     Category1 * currentItem = currentCategory[i];
     
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
     [self.iPad_chooseBrandScrollView setContentSize:CGSizeMake(self.iPad_chooseBrandScrollView.contentSize.width, totalHeight)];*/
}

- (void) didSelectBrandCell:(id) sender {
    
    /*  UITapGestureRecognizer * tap = (UITapGestureRecognizer *) sender;
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
     //if (!self.currentModel)
     //self.currentModel = currentModels[0]; //initially, the selected model is the first
     //else {
     if (self.currentModel) {
     for (int i = 0; i < currentModels.count; i++) {
     if ([(Model *)currentModels[i] modelID] == self.currentModel.modelID) {
     indexOfCurrentModel = i;
     break;
     }
     }
     }
     //[dropDownView drawModels:currentModels withIndexOfSelectedModel:(indexOfCurrentModel == -1 ? 0 : indexOfCurrentModel)];
     [dropDownView drawModels:currentModels withIndexOfSelectedModel:indexOfCurrentModel];
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
     
     
     */
    
}

- (void) didSelectModelCell:(id) sender {
    
    /*  UITapGestureRecognizer * tap = (UITapGestureRecognizer *) sender;
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
     //[self iPad_srollToPhotosView];
     [self iPad_setPhotosBtnPrss:nil];
     }*/
}

- (void) setModelsTapGestures {
    /* if (dropDownView) {
     for (id cell  in dropDownView.modelsScrollView.subviews) {
     if ([cell isKindOfClass:[ModelCell class]]) {
     UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectModelCell:)];
     tap.numberOfTapsRequired = 1;
     [cell addGestureRecognizer:tap];
     }
     
     }
     }*/
}

/*- (int) locateBrandCell:(BrandCell *) cell {
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
 */
- (void) closeModelsBtnPressed {    //this method is called on ly in the separate brands UI
    /* if (dropDownView) {
     [dropDownView.containerViewController dismissViewControllerAnimated:YES completion:nil];
     }*/
}

//------------------------------- END OF LEVEL1: CHOOSING THE BRAND -------------------------------
#pragma mark - TableInPopUpChoosingDelegate method
- (void) didChooseTableItemWithObject:(id) obj {
    
    //NSLog(@"user chose distance: %@", obj.rangeName);
    if (globalArray == roomsArray) {
        chosenRoom = (SingleValue *) obj;
        [_roomNum setTitle:[NSString stringWithFormat:@"%@",chosenRoom.valueString] forState:UIControlStateNormal];
    }
    else if (globalArray == currencyArray) {
        chosenCurrency = (SingleValue *) obj;
        [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal];
    }
    else if (globalArray == periodsArray) {
        chosenPeriod = (SingleValue *) obj;
        [_adPeriod setTitle:chosenPeriod.valueString forState:UIControlStateNormal];
    }else if (globalArray == unitsArray) {
        chosenUnit = (SingleValue *) obj;
        [_units setTitle:chosenUnit.valueString forState:UIControlStateNormal];
    }
    else if (globalArray == allUserStore) {
        myStore = (Store *) obj;
        [_theStore setTitle:myStore.name forState:UIControlStateNormal];
    }
    
    //distanceObj= (DistanceRange *)obj;
    [self iPad_dismissPopOvers];
}

- (void) iPad_dismissPopOvers {
    if (self.iPad_roomsPopOver)
        [self.iPad_roomsPopOver dismissPopoverAnimated:YES];
    
    if (self.iPad_periodPopOver)
        [self.iPad_periodPopOver dismissPopoverAnimated:YES];
    
    if (self.iPad_unitsPopOver)
        [self.iPad_unitsPopOver dismissPopoverAnimated:YES];
    
    if (self.iPad_currencyPopOver)
        [self.iPad_currencyPopOver dismissPopoverAnimated:YES];
    
    if (self.iPad_storePopOver)
        [self.iPad_storePopOver dismissPopoverAnimated:YES];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
        (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
        [self dismissKeyboard];
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
