//
//  AddNewCarAdViewController_iPad.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "AddNewCarAdViewController_iPad.h"
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "labelAdViewController.h"
#import "SignInViewController.h"
#import "CarAdDetailsViewController.h"
#import "ChooseModelView_iPad.h"
#import "BrandCell.h"
#import "ModelCell.h"

#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)


@interface AddNewCarAdViewController_iPad (){
        
    UITapGestureRecognizer *tap1;
    UITapGestureRecognizer *tap2;
    
    // Arrays
    NSArray *globalArray;
    NSArray *currencyArray;
    NSArray *productionYearArray;
    NSArray *countryArray;
    NSArray *cityArray;
    NSArray *kiloMileArray;
    
    IBOutlet UITextField *placeholderTextField;

    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;
    int chosenImgBtnTag;
    UIImage * currentImageToUpload;
    LocationManager * locationMngr;
    CLLocationManager * deviceLocationDetector;
    
    NSUInteger defaultIndex;
    NSUInteger defaultCityIndex;
    NSUInteger defaultCurrencyID;
    NSUInteger defaultcurrecncyIndex;
    NSInteger myAdID;
    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenYear;
    City * chosenCity;
    Country * chosenCountry;
    bool kiloChoosen;
    BOOL guestCheck;
    NSString* guestEmail;
    
    NSMutableArray * currentImgsUploaded;
    BOOL locationBtnPressedOnce;
    BOOL currencyBtnPressedOnce;
    BOOL yearBtnPressedOnce;
    
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
    NSMutableArray * brandCellsArray;
    Brand * chosenBrand;
    BOOL brandsOneSelectionMade;
    ChooseModelView_iPad * dropDownView;
    
    NSArray* currentBrands;
    NSArray* currentModels;
    
}

@end

@implementation AddNewCarAdViewController_iPad
@synthesize carAdTitle,mobileNum,distance,carDetails,carPrice,countryCity,currency,kiloMile,productionYear,carDetailLabel;
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
    
    locationMngr = [LocationManager sharedInstance];
    
    [self loadData];

    // Set the image piacker
    chosenImgBtnTag = -1;
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
    yearBtnPressedOnce = NO;
    
    [self loadDataArray];
    //[self addButtonsToXib];
   
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
    [self.iPad_titleLabel setText:@"بيع سيارتك"];
    
    //title label
    [self.iPad_uploadImagesTitleLabel setBackgroundColor:[UIColor clearColor]];
    [self.iPad_uploadImagesTitleLabel setTextAlignment:SSTextAlignmentCenter];
    [self.iPad_uploadImagesTitleLabel setTextColor:[UIColor darkGrayColor]];
    [self.iPad_uploadImagesTitleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:14.0] ];
    [self.iPad_uploadImagesTitleLabel setText:@"حمل الصور الآن"];
    
    [self.iPad_mainScrollView setContentSize:CGSizeMake((1024 * 3), self.iPad_mainScrollView.frame.size.height)];
    
    self.carDetails.layer.cornerRadius = 10.0f;
    [self.carDetails setNeedsDisplay];
    
    
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
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(self.distance.frame.size.width - 20, 0, 5, self.distance.frame.size.height)];
    self.distance.rightView = paddingView4;
    self.distance.rightViewMode = UITextFieldViewModeAlways;
    
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
    [TestFlight passCheckpoint:@"Post Ad screen"];
    //end GA
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    [self closePicker];
    [self.pickersView setHidden:YES];
}

#pragma mark - location handler.

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countryArray=resultArray;
    [self hideLoadingIndicator];
    productionYearArray=[[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadModelYearValues]];
    currencyArray= [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    kiloMileArray=[[NSArray alloc] initWithObjects:@"كم",@"ميل", nil];
    [self.modelNameLabel setText:self.currentModel.modelName];
    kiloChoosen=true;
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
    //[self closePicker];
    [carAdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [carPrice resignFirstResponder];
    [distance resignFirstResponder];
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

- (void) addButtonsToXib{
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 430)];
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
    

    countryCity=[[UIButton alloc] initWithFrame:CGRectMake(30,20 ,260 ,30)];
    [countryCity setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [countryCity setTitle:@"اختر البلد" forState:UIControlStateNormal];
    [countryCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [countryCity addTarget:self action:@selector(chooseCountryCity) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:countryCity];
    
    carAdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30, 60,260 ,30)];
    [carAdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [carAdTitle setTextAlignment:NSTextAlignmentRight];
    [carAdTitle setPlaceholder:@"عنوان الإعلان"];
//    [carAdTitle setKeyboardType:UIKeyboardTypeAlphabet];
    [self.verticalScrollView addSubview:carAdTitle];
    carAdTitle.delegate=self;
    
    carDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 95, 260, 20)];
    [carDetailLabel setText:@"تفاصيل الإعلان:"];
    [carDetailLabel setTextAlignment:NSTextAlignmentRight];
    [carDetailLabel setTextColor:[UIColor blackColor]];
    [carDetailLabel setFont:[UIFont systemFontOfSize:17]];
    [carDetailLabel setBackgroundColor:[UIColor clearColor]];
    [self.verticalScrollView addSubview:carDetailLabel];
    
    /*
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,120 ,260 ,80 )];
    [carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [carDetails setBackgroundColor:[UIColor whiteColor]];
    [carDetails setFont:[UIFont systemFontOfSize:17]];
    carDetails.delegate =self;
    */
    /*
    placeholderTextField=[[UITextField alloc] initWithFrame:CGRectMake(30,120 ,260 ,30)];
    [placeholderTextField setTextAlignment:NSTextAlignmentRight];
    [placeholderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    CGRect frame = placeholderTextField.frame;
    frame.size.height = carDetails.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"تفاصيل الإعلان";
    //[self.verticalScrollView addSubview:placeholderTextField];
    [self.verticalScrollView addSubview:carDetails];
   */
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,210 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    //mobileNum.inputAccessoryView = numberToolbar;
    mobileNum.delegate=self;

    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 260, 260, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:@"عام الصنع" forState:UIControlStateNormal];
    [productionYear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [productionYear addTarget:self action:@selector(chooseProductionYear) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:productionYear];


    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,300 ,160 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر (اختياري)"];
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    carPrice.delegate=self;
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 300, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_SM.png"] forState:UIControlStateNormal];
    //[currency setTitle:@"العملة   " forState:UIControlStateNormal];
    [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal];
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];

    distance=[[UITextField alloc] initWithFrame:CGRectMake(130,340 ,160 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة المقطوعة"];
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];
    distance.delegate=self;

    kiloMile = [[UISegmentedControl alloc] initWithItems:kiloMileArray];
    kiloMile.frame = CGRectMake(30, 340, 80, 30);
    kiloMile.segmentedControlStyle = UISegmentedControlStylePlain;
    kiloMile.selectedSegmentIndex = 0;
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:kiloMile];
    
          
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
    [distance resignFirstResponder];
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
    else{
        chosenYear=[globalArray objectAtIndex:row];
        [productionYear setTitle:[NSString stringWithFormat:@"%@",choosen.valueString] forState:UIControlStateNormal];
        yearBtnPressedOnce = YES;
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

- (IBAction)iPad_kiloBtnPrss:(id)sender {
    [self dismissKeyboard];
    kiloChoosen = YES;
    
    [self.iPad_kiloBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_km_btn_on.png"] forState:UIControlStateNormal];
    [self.iPad_mileBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_mile_btn_off.png"] forState:UIControlStateNormal];
    
}
- (IBAction)iPad_mileBtnPrss:(id)sender {
    [self dismissKeyboard];
    kiloChoosen = NO;
    
    [self.iPad_kiloBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_km_btn_off.png"] forState:UIControlStateNormal];
    [self.iPad_mileBtn setBackgroundImage:[UIImage imageNamed:@"tb_add_individual4_mile_btn_on.png"] forState:UIControlStateNormal];
}


- (IBAction)chooseProductionYear:(id)sender {
    [self dismissKeyboard];
    self.pickerView.hidden=NO;
    
    //NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)[productionYearArray objectAtIndex:0] valueString]];
    //[productionYear setTitle:temp forState:UIControlStateNormal];

    // fill picker with production year
    globalArray=productionYearArray;
    /*
    [self.pickerView reloadAllComponents];
    if (!yearBtnPressedOnce)
    {
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenYear = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self showPicker];
     */
    
    [self iPad_dismissPopOvers];
    
    if (!self.iPad_modelYearPopOver) {
        TableInPopUpTableViewController * modelYearVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        modelYearVC.choosingDelegate = self;
        modelYearVC.arrayValues = globalArray;
        
        modelYearVC.showingDistanceRangeObjects = NO;
        modelYearVC.showingSingleValueObjects = YES;
        
        self.iPad_modelYearPopOver = [[UIPopoverController alloc] initWithContentViewController:modelYearVC];
    }
    
    CGRect popOverFrame = self.iPad_modelYearPopOver.contentViewController.view.frame;
    [self.iPad_modelYearPopOver setPopoverContentSize:popOverFrame.size];
    [self.iPad_modelYearPopOver presentPopoverFromRect:[(UIButton *)sender frame] inView:[(UIButton *)sender superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

}

- (IBAction)chooseCurrency:(id)sender {
    [self dismissKeyboard];
    self.pickerView.hidden=NO;
    
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)chosenCurrency valueString]];
    [currency setTitle:temp forState:UIControlStateNormal];
    // fill picker with currency options
    globalArray=currencyArray;
    /*
    [self.pickerView reloadAllComponents];
    if (!currencyBtnPressedOnce)
    {
        [self.pickerView selectRow:defaultcurrecncyIndex inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenCurrency = (SingleValue *)[globalArray objectAtIndex:defaultcurrecncyIndex];
    }
    
    [self showPicker];
     */
    
    [self iPad_dismissPopOvers];
    
    if (!self.iPad_currencyPopOver) {
        TableInPopUpTableViewController * currencyVC = [[TableInPopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];

        currencyVC.choosingDelegate = self;
        currencyVC.arrayValues = globalArray;
        
        currencyVC.showingDistanceRangeObjects = NO;
        currencyVC.showingSingleValueObjects = YES;
        
        self.iPad_currencyPopOver = [[UIPopoverController alloc] initWithContentViewController:currencyVC];
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

- (void) chooseKiloMile{
    if (kiloMile.selectedSegmentIndex==0) {
        kiloChoosen=true;
    }
    else if (kiloMile.selectedSegmentIndex==1){
        
        kiloChoosen=false;
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
    
       

    
    NSInteger distanceUnitID;
    if (kiloChoosen)
        distanceUnitID = [self idForKilometerAttribute];
    else
        distanceUnitID = [self idForMileAttribute];
    
    [self showLoadingIndicator];
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedProfile && !guestCheck) {
        [self EmailRequire];
        return;
    }
    
    if ([carDetails.text isEqualToString:@""]) {
        carDetails.text = placeholderTextField.text;
    }
    if ([distance.text length] == 0) {
        distance.text = @"";
    }
    if ([carPrice.text length] == 0) {
        carPrice.text = @"";
    }
    
    [[CarAdsManager sharedInstance] postAdOfBrand:_currentModel.brandID
                                            Model:_currentModel.modelID
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
                                     withDelegate:self];


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
    
    if (alertView.tag == 4){
        self.emailAddress = [alertView textFieldAtIndex:0];
        if (buttonIndex == 0) {
        guestEmail = self.emailAddress.text;
            if ([self.emailAddress.text length] == 0) {
                [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء ادخال البريد الالكتروني" delegateVC:self];
                return;
            }
        guestCheck = YES;
            
            [self addBtnprss:self];
           
        }else if (buttonIndex == 1){
            alertView.hidden = YES;
        }
       
    }else if (alertView.tag == 5){
        //SignInViewController *vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        SignInViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        else
            vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
        vc.returnPage = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (IBAction)selectModelBtnPrss:(id)sender {
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=2;
    [self presentViewController:vc animated:YES completion:nil];

}

- (void) dismissSelfAfterFeaturing {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [self SelectPhotoFromLibrary];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenImgBtnTag];
    
    tappedBtn.clipsToBounds = YES;
    tappedBtn.layer.cornerRadius = 10.0f;
    
    [tappedBtn setImage:[GenericMethods imageWithImage:img scaledToSize:tappedBtn.frame.size] forState:UIControlStateNormal];

    [self useImage:img];
    if (self.iPad_cameraPopOver)
        [self.iPad_cameraPopOver dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];

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
    
    //reset 'current' data
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;

}


#pragma mark - PostAd Delegate
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
    [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:chosenCountry.countryID withDelegate:self];
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:@"تمت إضافة إعلانك بنجاج" delegateVC:self];
    
    
    
       
}

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
        [self presentViewController:details animated:YES completion:nil];
    }else {
        labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
        vc.currentAdID = myAdID;
        vc.countryAdID = chosenCountry.countryID;
        vc.iPad_parentNewCarVC = self;
        vc.currentAdHasImages = NO;
        if (currentImgsUploaded && currentImgsUploaded.count)
            vc.currentAdHasImages = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
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
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOff forState:UIControlStateNormal];
    
    [self iPad_srollToPhotosView];
}

- (IBAction) iPad_setDetailsBtnPrss:(id) sender {
    [self dismissKeyboard];
    [self.iPad_chooseBrandBtn setBackgroundImage:iPad_chooseBrandBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setPhotosBtn setBackgroundImage:iPad_setPhotosBtnImgOn forState:UIControlStateNormal];
    [self.iPad_setDetailsBtn setBackgroundImage:iPad_setDetailsBtnImgOn forState:UIControlStateNormal];
    
    [self iPad_srollToDetailsView];
    
}

- (IBAction)iPad_deleteUploadedImage:(id)sender {
    NSLog(@"No api method provided for deleting an uploaded image");
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
        //[self iPad_srollToPhotosView];
        [self iPad_setPhotosBtnPrss:nil];
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
#pragma mark - TableInPopUpChoosingDelegate method
- (void) didChooseTableItemWithObject:(id) obj {
    
    //NSLog(@"user chose distance: %@", obj.rangeName);
    if (globalArray == productionYearArray) {
        chosenYear = (SingleValue *) obj;
        [productionYear setTitle:[NSString stringWithFormat:@"%@",chosenYear.valueString] forState:UIControlStateNormal];
        yearBtnPressedOnce = YES;
    }
    else if (globalArray == currencyArray) {
        chosenCurrency = (SingleValue *) obj;
        [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal];
        currencyBtnPressedOnce = YES;
    }
    
    //distanceObj= (DistanceRange *)obj;
    [self iPad_dismissPopOvers];
}

- (void) iPad_dismissPopOvers {
    if (self.iPad_modelYearPopOver)
        [self.iPad_modelYearPopOver dismissPopoverAnimated:YES];
    
    if (self.iPad_currencyPopOver)
        [self.iPad_currencyPopOver dismissPopoverAnimated:YES];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
        (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
        [self dismissKeyboard];
    
}

@end
