//
//  AddNewStoreAdViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/29/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewStoreAdViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomePageViewController.h"
#import "ChooseCategoryViewController.h"
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
    NSUInteger defaultIndex;
    NSUInteger defaultCityIndex;
    NSUInteger defaultCurrencyID;
    NSUInteger defaultcurrecncyIndex;
    
    NSInteger defaultStoreIndex;
    NSInteger myAdID;
    
    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;
    int chosenImgBtnTag;
    UIImage * currentImageToUpload;
    LocationManager * locationMngr;
    StoreManager *advFeatureManager;
    
    CLLocationManager * deviceLocationDetector;
    CLLocation *PropertyLocation;
    
    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenPeriod;
    SingleValue * chosenUnit;
    City * chosenCity;
    Country * chosenCountry;
    Store* myStore;
    
    SingleValue* chosenRoom;
    float longitude;
    float latittude;
    bool requiredChoosen;
    bool showedChoosen;
    bool installmentChoosen;
    bool kiloChoosen;
    bool conditionchoosen;
    int gearchoosen;
    int typechoosen;
    BOOL choosingStore;
    
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
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}




@end

@implementation AddNewStoreAdViewController
@synthesize AdTitle,mobileNum,unitPrice,propertyDetails,propertyPrice,countryCity,currency,serviceReq,adPeriod,adDetailLabel,roomsNum,propertySpace,propertyArea,mapLocation,phoneNum,units,theStore;


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
   // self.inputAccessoryView = [XCDFormInputAccessoryView new];
    
    locationMngr = [LocationManager sharedInstance];
    
    allUserStore = [[NSMutableArray alloc]init];
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getUserStores];
    
    advFeatureManager = [[StoreManager alloc] init];
    advFeatureManager.delegate = self;
    
    
    [self loadData];
    
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
    roomsBtnPressedOnce = NO;
    periodBtnPressedOnce = NO;
    mapLocationBtnPressedOnce = NO;
    unitsBtnPressedOnce = NO;
    
    [self loadDataArray];
    [self addButtonsToXib];
    [self setImagesArray];
    [self setImagesToXib];
    
    [self closePicker];
    
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

-(void)indicator:(BOOL)animated{
    
    [self.horizontalScrollView flashScrollIndicators];
    
}

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countryArray=resultArray;
    [self hideLoadingIndicator];
    currencyArray= [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    roomsArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadRoomsValues]];
    serviceReqArray=[[NSArray alloc] initWithObjects:@"معروض",@"مطلوب",@"تقسيط", nil];
    unitsArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadUnitValues]];
    periodsArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance]loadAddPeriodValues]];
    
    //[self.categoryNameLabel setText:self.currentModel.modelName];
    requiredChoosen=true;
    showedChoosen = true;
    installmentChoosen = true;
    
    // Setting default country
    //defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    chosenUnit = [unitsArray objectAtIndex:0];
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
        [self.locationPickerView reloadAllComponents];
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
- (void) setImagesToXib{
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
}

- (void) setImagesArray{
    
    [self.horizontalScrollView setContentSize:CGSizeMake(640, 119)];
    [self.horizontalScrollView setScrollEnabled:YES];
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:YES];
    
    for (int i=0; i<6; i++) {
        UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(95*i), 20, 77, 70)];
        [temp setImage:[UIImage imageNamed:@"takePhotobkg.png"] forState:UIControlStateNormal];
        
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
    actionSheet.tag = 1;
    
    [actionSheet showInView:self.view];
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
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void) useImage:(UIImage *) image {
    
    currentImageToUpload = image;
    [self showLoadingIndicatorOnImages];
    [[AdsManager sharedInstance] uploadImage:image WithDelegate:self];
}

-(void)dismissKeyboard {
    [self closePicker];
    [AdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [propertyPrice resignFirstResponder];
    [unitPrice resignFirstResponder];
    [phoneNum resignFirstResponder];
    [propertyDetails resignFirstResponder];
    [propertyArea resignFirstResponder];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
        self.view.frame = CGRectMake(0, 0, 320, 568);
    else
        self.view.frame = CGRectMake(0, 0, 320, 480);
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
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    
    theStore=[[UIButton alloc] initWithFrame:CGRectMake(30,20 ,260 ,30)];
    [theStore setBackgroundImage:[UIImage imageNamed: @"fieldWithDownArrow.png"] forState:UIControlStateNormal];
    [theStore setTitle:@"اختر المتجر" forState:UIControlStateNormal];
    // TODO set the Store to the current
    if (self.currentStore) {
        
    }
    [theStore setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [theStore addTarget:self action:@selector(chooseStore) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:theStore];
    
    
    countryCity=[[UIButton alloc] initWithFrame:CGRectMake(30,60 ,260 ,30)];
    [countryCity setBackgroundImage:[UIImage imageNamed: @"fieldWithDownArrow.png"] forState:UIControlStateNormal];
    [countryCity setTitle:@"اختر البلد" forState:UIControlStateNormal];
    [countryCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [countryCity addTarget:self action:@selector(chooseCountryCity) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:countryCity];
    
    serviceReq = [[UISegmentedControl alloc] initWithItems:serviceReqArray];
    serviceReq.frame = CGRectMake(30, 100, 260, 30);
    serviceReq.segmentedControlStyle = UISegmentedControlStylePlain;
    serviceReq.selectedSegmentIndex = 0;
    [serviceReq addTarget:self action:@selector(chooseServiceReq) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:serviceReq];
    
    roomsNum=[[UIButton alloc] initWithFrame:CGRectMake(30,140 ,260 ,30)];
    [roomsNum setBackgroundImage:[UIImage imageNamed: @"fieldWithDownArrow.png"] forState:UIControlStateNormal];
    [roomsNum setTitle:@"عدد الغرف" forState:UIControlStateNormal];
    [roomsNum setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [roomsNum addTarget:self action:@selector(chooseRoomsNum) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:roomsNum];
    
    propertySpace=[[UITextField alloc] initWithFrame:CGRectMake(30,180 ,260 ,30)];
    [propertySpace setBorderStyle:UITextBorderStyleRoundedRect];
    [propertySpace setTextAlignment:NSTextAlignmentRight];
    [propertySpace setPlaceholder:@"المساحة"];
    [self.verticalScrollView addSubview:propertySpace];
    propertySpace.delegate=self;
    
    mapLocation=[[UIButton alloc] initWithFrame:CGRectMake(30,212 ,260 ,43)];
    [mapLocation setBackgroundImage:[UIImage imageNamed: @"fieldWithArrowMap.png"] forState:UIControlStateNormal];
    [mapLocation setTitle:@"الموقع على الخريطة" forState:UIControlStateNormal];
    [mapLocation setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [mapLocation addTarget:self action:@selector(chooseMapLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:mapLocation];
    
    propertyArea=[[UITextField alloc] initWithFrame:CGRectMake(30,260 ,260 ,30)];
    [propertyArea setBorderStyle:UITextBorderStyleRoundedRect];
    [propertyArea setTextAlignment:NSTextAlignmentRight];
    [propertyArea setFont:[UIFont systemFontOfSize:13]];
    [propertyArea setPlaceholder:@"المنطقة/الحي"];
    [self.verticalScrollView addSubview:propertyArea];
    propertyArea.delegate=self;
    
    AdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30, 300,260 ,30)];
    [AdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [AdTitle setTextAlignment:NSTextAlignmentRight];
    [AdTitle setPlaceholder:@"عنوان الإعلان"];
    [self.verticalScrollView addSubview:AdTitle];
    AdTitle.delegate=self;
    
    adDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 335, 260, 20)];
    [adDetailLabel setText:@"تفاصيل الإعلان:"];
    [adDetailLabel setTextAlignment:NSTextAlignmentRight];
    [adDetailLabel setTextColor:[UIColor blackColor]];
    [adDetailLabel setFont:[UIFont systemFontOfSize:17]];
    [adDetailLabel setBackgroundColor:[UIColor clearColor]];
    [self.verticalScrollView addSubview:adDetailLabel];
    
    
    propertyDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,360 ,260 ,80 )];
    [propertyDetails setTextAlignment:NSTextAlignmentRight];
    [propertyDetails setKeyboardType:UIKeyboardTypeDefault];
    [propertyDetails setBackgroundColor:[UIColor whiteColor]];
    [propertyDetails setFont:[UIFont systemFontOfSize:17]];
    propertyDetails.delegate =self;
    
    placeholderTextField=[[UITextField alloc] initWithFrame:CGRectMake(30,360 ,260 ,30)];
    [placeholderTextField setTextAlignment:NSTextAlignmentRight];
    [placeholderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    CGRect frame = placeholderTextField.frame;
    frame.size.height = propertyDetails.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"تفاصيل الإعلان";
    //[self.verticalScrollView addSubview:placeholderTextField];
    [self.verticalScrollView addSubview:propertyDetails];
    
    propertyPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,450 ,160 ,30)];
    [propertyPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [propertyPrice setTextAlignment:NSTextAlignmentRight];
    [propertyPrice setPlaceholder:@"السعر (اختياري)"];
    [propertyPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:propertyPrice];
    propertyPrice.delegate=self;
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 450, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"fieldSmallWithDownArrow.png"] forState:UIControlStateNormal];
    //[currency setTitle:@"العملة   " forState:UIControlStateNormal];
    [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal];
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];
    
    unitPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,490 ,160 ,30)];
    [unitPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [unitPrice setTextAlignment:NSTextAlignmentRight];
    [unitPrice setPlaceholder:@"سعر الوحدة"];
    [unitPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:unitPrice];
    unitPrice.delegate=self;
    
    units =[[UIButton alloc] initWithFrame:CGRectMake(30, 490, 80, 30)];
    [units setBackgroundImage:[UIImage imageNamed: @"fieldSmallWithDownArrow.png"] forState:UIControlStateNormal];
    [units setTitle:chosenUnit.valueString forState:UIControlStateNormal];
    [units addTarget:self action:@selector(chooseUnits) forControlEvents:UIControlEventTouchUpInside];
    [units setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:units];
    
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,530 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    //mobileNum.inputAccessoryView = numberToolbar;
    mobileNum.delegate=self;
    
    phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(30,570 ,260 ,30)];
    [phoneNum setBorderStyle:UITextBorderStyleRoundedRect];
    [phoneNum setTextAlignment:NSTextAlignmentRight];
    [phoneNum setPlaceholder:@"رقم الهاتف"];
    [phoneNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:phoneNum];
    //mobileNum.inputAccessoryView = numberToolbar;
    phoneNum.delegate=self;
    
    adPeriod =[[UIButton alloc] initWithFrame:CGRectMake(30, 610, 260, 30)];
    [adPeriod setBackgroundImage:[UIImage imageNamed: @"fieldWithDownArrow.png"] forState:UIControlStateNormal];
    [adPeriod setTitle:@"فترة الاعلان" forState:UIControlStateNormal];
    [adPeriod setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [adPeriod addTarget:self action:@selector(choosePeriod) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:adPeriod];
    
    
    
    
    
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
    imgsLoadingHUD = [MBProgressHUD2 showHUDAddedTo:self.horizontalScrollView animated:YES];
    imgsLoadingHUD.mode = MBProgressHUDModeCustomView2;
    imgsLoadingHUD.dimBackground = YES;
    imgsLoadingHUD.opacity = 0.5;
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
    
    if (imgsLoadingHUD)
        [MBProgressHUD2 hideHUDForView:self.horizontalScrollView  animated:YES];
    imgsLoadingHUD = nil;
    
}
- (void) postTheAd {
    //call the post ad back end method
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
    roomsBtnPressedOnce = NO;
}


-(IBAction)showPicker
{
    [AdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [propertyPrice resignFirstResponder];
    [unitPrice resignFirstResponder];
    [propertyDetails resignFirstResponder];
    
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
        return 2;
    }else if (pickerView == _pickerView){
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
    if (pickerView==_locationPickerView)
    {
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
    else if (pickerView == _pickerView)
    {
        SingleValue *choosen=[globalArray objectAtIndex:row];
        if ([currencyArray containsObject:choosen]) {
            chosenCurrency=[globalArray objectAtIndex:row];
            [currency setTitle:choosen.valueString forState:UIControlStateNormal];
            currencyBtnPressedOnce = YES;
        }
        else if ([periodsArray containsObject:choosen]){
            chosenPeriod=[globalArray objectAtIndex:row];
            [adPeriod setTitle:[NSString stringWithFormat:@"%@",choosen.valueString] forState:UIControlStateNormal];
            periodBtnPressedOnce = YES;
        }
        else if ([roomsArray containsObject:choosen]){
            chosenRoom=[globalArray objectAtIndex:row];
            [roomsNum setTitle:[NSString stringWithFormat:@"%@",chosenRoom.valueString] forState:UIControlStateNormal];
            roomsBtnPressedOnce = YES;
        }
        else {
            chosenUnit=[globalArray objectAtIndex:row];
            [units setTitle:[NSString stringWithFormat:@"%@",choosen.valueString] forState:UIControlStateNormal];
            unitsBtnPressedOnce = YES;
        }
    }
    else if (pickerView == _storePickerView)
    {
        myStore = [allUserStore objectAtIndex:row];
        [theStore setTitle:myStore.name forState:UIControlStateNormal];
        storeBtnPressedOnce = YES;
        
        defaultIndex = [locationMngr getIndexOfCountry:myStore.countryID];
        if  (defaultIndex!= -1){
            chosenCountry =[countryArray objectAtIndex:defaultIndex];
            //chosenCountry = [countryArray objectAtIndex:defaultIndex];
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
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==_locationPickerView) {
        if (component==0) {
            return [countryArray count];
        }
        else{
            return [cityArray count];
        }
    }
    else if (pickerView == _storePickerView)
    {
        return [allUserStore count];
    }
    else {
        return [globalArray count];
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
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
    else if (pickerView == _storePickerView){
        myStore = [allUserStore objectAtIndex:row];
        return myStore.name;
    }
    else {
        if (roomsBtnPressedOnce)
            return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
        else
            return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
    }
    
    
}

#pragma mark - Buttons Actions

-(void)chooseStore
{
    self.locationPickerView.hidden=YES;
    self.pickerView.hidden=YES;
    self.storePickerView.hidden = NO;
    [self dismissKeyboard];
    
    if ([allUserStore count] != 0) {
        NSString *temp= [NSString stringWithFormat:@"%@",[(Store*)[allUserStore objectAtIndex:0] name]];
        [theStore setTitle:temp forState:UIControlStateNormal];
    }
    
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

- (void) choosePeriod{
    
    self.locationPickerView.hidden=YES;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=NO;
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)[periodsArray objectAtIndex:0] valueString]];
    [adPeriod setTitle:temp forState:UIControlStateNormal];
    
    // fill picker with production period
    globalArray=periodsArray;
    [self.pickerView reloadAllComponents];
    if (!periodBtnPressedOnce)
    {
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenPeriod = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self showPicker];
    
}

- (void) chooseCurrency{
    
    self.locationPickerView.hidden=YES;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=NO;
    
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)chosenCurrency valueString]];
    [currency setTitle:temp forState:UIControlStateNormal];
    // fill picker with currency options
    globalArray=currencyArray;
    [self.pickerView reloadAllComponents];
    if (!currencyBtnPressedOnce)
    {
        [self.pickerView selectRow:defaultcurrecncyIndex inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenCurrency = (SingleValue *)[globalArray objectAtIndex:defaultcurrecncyIndex];
    }
    
    [self showPicker];
}

- (void) chooseUnits{
    
    self.locationPickerView.hidden=YES;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=NO;
    
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)chosenUnit valueString]];
    [units setTitle:temp forState:UIControlStateNormal];
    // fill picker with currency options
    globalArray=unitsArray;
    [self.pickerView reloadAllComponents];
    if (!unitsBtnPressedOnce)
    {
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenUnit = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self showPicker];
}


- (void) chooseCountryCity{
    
    self.locationPickerView.hidden=NO;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=YES;
    
    NSString *temp= [NSString stringWithFormat:@"%@ :%@", chosenCountry.countryName , chosenCity.cityName];
    [countryCity setTitle:temp forState:UIControlStateNormal];
    
    [self.locationPickerView reloadAllComponents];
    if (!locationBtnPressedOnce)
    {
        if (defaultIndex!=-1) {
            [self.locationPickerView selectRow:defaultIndex inComponent:0 animated:YES];
            if (defaultCityIndex != -1)
                [self.locationPickerView selectRow:defaultCityIndex inComponent:1 animated:YES];
        }
    }
    [self showPicker];
    locationBtnPressedOnce = YES;
    
}

- (void) chooseRoomsNum{
    
    self.locationPickerView.hidden=YES;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=NO;
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)chosenRoom valueString]];
    [roomsNum setTitle:temp forState:UIControlStateNormal];
    
    // fill picker with currency options
    globalArray=roomsArray;
    [self.pickerView reloadAllComponents];
    if (!roomsBtnPressedOnce)
    {
        roomsBtnPressedOnce = YES;
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenRoom = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self showPicker];
    
}

- (void) chooseMapLocation{
    
    self.locationPickerView.hidden=YES;
    self.storePickerView.hidden = YES;
    self.pickerView.hidden=YES;
    
    //load location map page
    MapLocationViewController *vc=[[MapLocationViewController alloc] initWithNibName:@"MapLocationViewController" bundle:nil];
    vc.selectedMapDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)selectedMapLocationIs:(CLLocation *)pinLocation andAddress:(NSString *)Address
{
    PropertyLocation = pinLocation;
    [mapLocation setTitle:@"تم تحديد الموقع" forState:UIControlStateNormal];
    [propertyArea setText:Address];
}


- (void) chooseServiceReq{
    if (serviceReq.selectedSegmentIndex==0) {
        requiredChoosen=true;
        showedChoosen = false;
        installmentChoosen = false;
    }
    else if (serviceReq.selectedSegmentIndex==1){
        
        requiredChoosen=false;
        showedChoosen = true;
        installmentChoosen = false;
    }
    else if (serviceReq.selectedSegmentIndex==2){
        
        requiredChoosen=false;
        showedChoosen = false;
        installmentChoosen = true;
    }
}

- (IBAction)doneBtnPrss:(id)sender {
    [self closePicker];
}

- (IBAction)homeBtnPrss:(id)sender {
    HomePageViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    else
        vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)addBtnprss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Post Store Ad"
                         withValue:[NSNumber numberWithInt:100]];
    
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
    if ([AdTitle.text length] == 0)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال عنوان للإعلان" delegateVC:self];
        return;
    }
    
    //check description
    if ([propertyDetails.text length] == 0)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال تفاصيل للإعلان" delegateVC:self];
        return;
    }
    
    //check currency
    if (!chosenCurrency)
    {
        //check price
        if ( [propertyPrice.text length] != 0 && ![propertyPrice.text isEqualToString:@"0"])
        {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار عملة مناسبة" delegateVC:self];
            return;
            
        }
    }
    
    if (!chosenPeriod) {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إختيار فترة للإعلان" delegateVC:self];
        return;
    }
    
    
    [self showLoadingIndicator];
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if ([propertyDetails.text isEqualToString:@""]) {
        propertyDetails.text = placeholderTextField.text;
    }
    if ([propertyArea.text length] == 0) {
        propertyArea.text = @"";
    }
    if ([propertyPrice.text length] == 0) {
        propertyPrice.text = @"";
    }
    
    int RequiredService = 0;
    if (serviceReq.selectedSegmentIndex==0) {
        RequiredService = 2307;
    }
    else if (serviceReq.selectedSegmentIndex==1){
        RequiredService = 2305;
    }
    else if (serviceReq.selectedSegmentIndex==2){
        RequiredService = 2306;
    }

    
    if (self.browsingForSale) {
    [[AdsManager sharedInstance] postStoreAdForSaleOfCategory:self.currentSubCategoryID myStore:myStore.identifier InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:AdTitle.text description:propertyDetails.text adPeriod:chosenPeriod.valueID requireService:RequiredService price:propertyPrice.text currencyValueID:chosenCurrency.valueID unitPrice:unitPrice.text unitType:chosenUnit.valueID imageIDs:currentImgsUploaded longitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.latitude] roomNumber:chosenRoom.valueString space:propertySpace.text area:propertyArea.text mobile:mobileNum.text phoneNumer:mobileNum.text withDelegate:self];
    }
    else
    {
        [[AdsManager sharedInstance] postStoreAdForRentOfCategory:self.currentSubCategoryID myStore:myStore.identifier InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:AdTitle.text description:propertyDetails.text adPeriod:chosenPeriod.valueID requireService:RequiredService price:propertyPrice.text currencyValueID:chosenCurrency.valueID unitPrice:unitPrice.text unitType:chosenUnit.valueID imageIDs:currentImgsUploaded longitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.latitude] roomNumber:chosenRoom.valueString space:propertySpace.text area:propertyArea.text mobile:mobileNum.text phoneNumer:mobileNum.text withDelegate:self];
    }
    
}

- (IBAction)selectModelBtnPrss:(id)sender {
    ChooseCategoryViewController *vc=[[ChooseCategoryViewController alloc] initWithNibName:@"ChooseCategoryViewController" bundle:nil];
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

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
    
    [tappedBtn setImage:[GenericMethods imageWithImage:img scaledToSize:tappedBtn.frame.size] forState:UIControlStateNormal];
    
    [self useImage:img];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


#pragma mark - iploadImage Delegate

- (void) imageDidFailUploadingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
    [self hideLoadingIndicatorOnImages];
    if (chosenImgBtnTag > -1)
    {
        UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        
        [tappedBtn setImage:[UIImage imageNamed:@"takePhotobkg.png"] forState:UIControlStateNormal];
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
         
         //[tappedBtn setImage:currentImageToUpload forState:UIControlStateNormal];
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
        alert.tag = 6;
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

#pragma mark - UITextView
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
        self.view.frame = CGRectMake(0, -140, 320, 568);
    else
        self.view.frame = CGRectMake(0, -140, 320, 480);
    
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


#pragma mark - PricingOptions Delegate

- (void) optionsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
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
/*
-(BOOL)shouldAutorotate
{
    return  NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
*/
@end
