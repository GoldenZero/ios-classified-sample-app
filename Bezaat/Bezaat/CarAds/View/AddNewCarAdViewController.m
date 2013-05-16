//
//  AddNewCarAdViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AddNewCarAdViewController.h"
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "labelAdViewController.h"
#import "SignInViewController.h"

#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)


@interface AddNewCarAdViewController (){
        
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
}

@end

@implementation AddNewCarAdViewController
@synthesize carAdTitle,mobileNum,distance,carDetails,carPrice,countryCity,currency,kiloMile,productionYear;
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

    locationMngr = [LocationManager sharedInstance];
    
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
    yearBtnPressedOnce = NO;
    
    [self loadDataArray];
    [self addButtonsToXib];
    [self setImagesArray];
    [self setImagesToXib];
   
    [self closePicker];
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Post Ad screen"];
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

#pragma mark - UITextView 
- (void)textViewDidChange:(UITextView *)textView {
    if ([@"" isEqualToString:textView.text]) {
        placeholderTextField.placeholder = @"تفاصيل الإعلان";
    }
    else {
        placeholderTextField.placeholder = @"";
    }
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
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 420)];
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
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,100 ,260 ,80 )];
   // [carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [carDetails setBackgroundColor:[UIColor clearColor]];
    [carDetails setFont:[UIFont systemFontOfSize:17]];
    carDetails.delegate =self;
    
    placeholderTextField=[[UITextField alloc] initWithFrame:CGRectMake(30,100 ,260 ,30)];
    [placeholderTextField setTextAlignment:NSTextAlignmentRight];
    [placeholderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    CGRect frame = placeholderTextField.frame;
    frame.size.height = carDetails.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"تفاصيل الإعلان";
    [self.verticalScrollView addSubview:placeholderTextField];
    [self.verticalScrollView addSubview:carDetails];
   
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,190 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    mobileNum.inputAccessoryView = numberToolbar;
    mobileNum.delegate=self;

    
    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,240 ,160 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر (اختياري)"];
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    carPrice.delegate=self;
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 240, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_SM.png"] forState:UIControlStateNormal];
    //[currency setTitle:@"العملة   " forState:UIControlStateNormal];
    [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal];
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];

    distance=[[UITextField alloc] initWithFrame:CGRectMake(130,280 ,160 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة المقطوعة"];
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];
    distance.delegate=self;

    kiloMile = [[UISegmentedControl alloc] initWithItems:kiloMileArray];
    kiloMile.frame = CGRectMake(30, 280, 80, 30);
    kiloMile.segmentedControlStyle = UISegmentedControlStylePlain;
    kiloMile.selectedSegmentIndex = 0;
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:kiloMile];
    
    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 320, 260, 30)];
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
        return 2;
    }
    else {
        return 1;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
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
        if (component==0) {
            return [countryArray count];
        }
        else{
            return [cityArray count];
        }
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
    else {
        return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
    }
    
    
}

#pragma mark - Buttons Actions


- (void) chooseProductionYear{
    
    self.locationPickerView.hidden=YES;
    self.pickerView.hidden=NO;
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

- (void) chooseCountryCity{
    
    self.locationPickerView.hidden=NO;
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

- (IBAction)homeBtnPrss:(id)sender {
    ChooseActionViewController *vc=[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
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
    if ([[carAdTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""])
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
    if (!currencyBtnPressedOnce)
    {
        //check price
        if ( [carPrice.text length] != 0 )
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
                                                    message:@"\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:@"إلغاء", nil];
    
    self.emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, 260, 25)];
    [self.emailAddress setBackgroundColor:[UIColor whiteColor]];
    [self.emailAddress setPlaceholder:@"123@eample.com"];
    [self.emailAddress setTextAlignment:NSTextAlignmentCenter];
    self.emailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    
    [alert addSubview:self.emailAddress];
    
    // show the dialog box
    alert.tag = 4;
    [alert show];
    
    // set cursor and show keyboard
    [self.emailAddress becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 4){
        if (buttonIndex == 0) {
        guestEmail = self.emailAddress.text;
        guestCheck = YES;
            [self addBtnprss:self];
           
        }else if (buttonIndex == 1){
            alertView.hidden = YES;
        }
       
    }else if (alertView.tag == 5){
        SignInViewController *vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
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
        vc.parentNewCarVC = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

@end
