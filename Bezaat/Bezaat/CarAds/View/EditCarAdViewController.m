//
//  EditCarAdViewController.m
//  Bezaat
//
//  Created by GALMarei on 5/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "EditCarAdViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "labelAdViewController.h"
#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)



@interface EditCarAdViewController ()
{
    UITapGestureRecognizer *tap1;
    UITapGestureRecognizer *tap2;
    
    // Arrays
    NSArray *globalArray;
    NSArray *currencyArray;
    NSArray *productionYearArray;
    NSArray *countryArray;
    NSArray *cityArray;
    NSArray *kiloMileArray;
    
    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;
    int chosenImgBtnTag;
    int chosenRemoveImgBtnTag;
    int removeCounter;
    BOOL firstRemove;
    
    UIImage * currentImageToUpload;
    LocationManager * locationMngr;
    CLLocationManager * deviceLocationDetector;
    
    NSUInteger defaultIndex;
    NSUInteger defaultCityIndex;
    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenYear;
    City * chosenCity;
    Country * chosenCountry;
    
    NSString* defaultCityName;
    CarAd* myAdInfo;
    
    NSMutableArray * currentImgsUploaded;
    NSMutableArray* CopyImageArr;
    
    BOOL titleChanged;
    BOOL detailsChanged;
    BOOL priceChanged;
    BOOL kiloChoosen;
    BOOL mobileChanged;
    BOOL distanceChanged;
    
    BOOL locationBtnPressedOnce;
    BOOL currencyBtnPressedOnce;
    BOOL yearBtnPressedOnce;
    
    NSTimer *timer;
    UIToolbar* numberToolbar;

}
@end

@implementation EditCarAdViewController
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
    myAdInfo = [[CarAd alloc]init];
    
    
    
    // Set the image piacker
    chosenImgBtnTag = -1;
    chosenRemoveImgBtnTag = -1;
    removeCounter = 1;
    
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
    [self loadData];
    [self addButtonsToXib];
    [self setImagesArray];
    [self setImagesToXib];
    
    [self closePicker];
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Edit Ad screen"];
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
    
    // Setting default country
    //defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    //defaultIndex = [locationMngr getIndexOfCountry:[[SharedUser sharedInstance] getUserCountryID]];
    defaultIndex = [locationMngr getIndexOfCountry:self.myDetails.countryID];
    if  (defaultIndex!= -1){
        chosenCountry =[countryArray objectAtIndex:defaultIndex];//set initial chosen country
        cityArray=[chosenCountry cities];
        if (cityArray && cityArray.count)
        {
            //defaultCityIndex = [locationMngr getIndexOfCity:[[SharedUser sharedInstance] getUserCityID] inCountry:chosenCountry];
            
            defaultCityIndex = -1;
            if (myAdInfo.cityName.integerValue > 0)
                defaultCityIndex = [locationMngr getIndexOfCity:myAdInfo.cityName.integerValue inCountry:chosenCountry];
            
            if (defaultCityIndex != -1)
                chosenCity=[cityArray objectAtIndex:defaultCityIndex];
            else
                chosenCity=[cityArray objectAtIndex:0];
        }
        [self.locationPickerView reloadAllComponents];
    }
    
 }

// This method loads the device location initialli, and afterwards the loading of country lists comes after
- (void) loadData {
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
}

- (void) loadDataArray{
    
    myAdInfo = (CarAd*)[self.myAdArray objectAtIndex:0];
    CopyImageArr = [[NSMutableArray alloc] initWithArray:self.myImageIDArray];
    
    for (CarAd* temp in CopyImageArr) {
        [currentImgsUploaded addObject:temp.thumbnailID];
    }
    
    productionYearArray=[[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadModelYearValues]];
    currencyArray= [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    kiloMileArray=[[NSArray alloc] initWithObjects:@"كم",@"ميل", nil];
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
    CarAd* cardADS;
    int remainingImg = [self.myImageIDArray count];
    for (int i=0; i<6; i++) {
        if ([self.myImageIDArray count] == 0 || remainingImg == 0) {
            UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(104*i), 15, 77, 70)];
            [temp setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
            
            temp.tag = (i+1) * 10;
            [temp addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
            [self.horizontalScrollView addSubview:temp];
        }else{
            cardADS = (CarAd*)[self.myImageIDArray objectAtIndex:i];
            UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(104*i), 15, 77, 70)];
            [temp setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cardADS.ImageURL]]] forState:UIControlStateNormal];
            temp.tag = (i+1) * 10;
            [temp addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
            [self.horizontalScrollView addSubview:temp];
            remainingImg-=1;
            
            UIButton* removeImg = [[UIButton alloc] initWithFrame:CGRectMake(20+(104*i), 85, 79, 25)];
            [removeImg setImage:[UIImage imageNamed:@"list_remove.png"] forState:UIControlStateNormal];
            removeImg.tag = (i+1) * 100;
            [removeImg addTarget:self action:@selector(ImageDelete:) forControlEvents:UIControlEventTouchUpInside];
            [self.horizontalScrollView addSubview:removeImg];
        }
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

-(void) ImageDelete:(id)sender {
    UIButton* senderBtn = (UIButton *)sender;
    chosenRemoveImgBtnTag = senderBtn.tag / 10;
    
    UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenRemoveImgBtnTag];
    [tappedBtn setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
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
    [senderBtn setHidden:YES];
    removeCounter++;
}

-(void) TakePhotoWithCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
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
    NSArray* citiesArray;
    for (int i =0; i <= [countryArray count] - 1; i++) {

        citiesArray = [(Country *)[countryArray objectAtIndex:i] cities];
        for (City* cit in citiesArray) {
            if (cit.cityID == myAdInfo.cityName.integerValue)
            {
                defaultCityName = cit.cityName;
                break;
                //return;
            }
        }
    }
    
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
    
    [countryCity setTitle:defaultCityName forState:UIControlStateNormal]; //TODO chosen city
    [countryCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [countryCity addTarget:self action:@selector(chooseCountryCity) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:countryCity];
    
    carAdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30, 60,260 ,30)];
    [carAdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [carAdTitle setTextAlignment:NSTextAlignmentRight];
    [carAdTitle setPlaceholder:@"عنوان الإعلان"];
    [carAdTitle setText:myAdInfo.title]; //TODO ad Title
    [self.verticalScrollView addSubview:carAdTitle];
    carAdTitle.delegate=self;
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,100 ,260 ,80 )];
    [carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setText:myAdInfo.desc]; //TODO get Description
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [self.verticalScrollView addSubview:carDetails];
    carDetails.delegate =self;
    
    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,190 ,160 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر (اختياري)"];
    [carPrice setText:[NSString stringWithFormat:@"%i",(int)myAdInfo.price]]; //TODO get Price
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    carPrice.delegate=self;
    
    
   // NSInteger defaultCurrencyID=[[StaticAttrsLoader sharedInstance] getCurrencyIdOfCountry:myAdInfo.currencyString.integerValue];
    NSInteger defaultCurrencyID = myAdInfo.currencyString.integerValue;
    NSInteger defaultcurrecncyIndex=0;
    while (defaultcurrecncyIndex<currencyArray.count) {
        if (defaultCurrencyID==[(SingleValue*)[currencyArray objectAtIndex:defaultcurrecncyIndex] valueID]) {
            chosenCurrency=[currencyArray objectAtIndex:defaultcurrecncyIndex];
            break;
        }
        defaultcurrecncyIndex++;
    }
    
    
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 190, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_SM.png"] forState:UIControlStateNormal];
    [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal]; //TODO get currency
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];
    
    distance=[[UITextField alloc] initWithFrame:CGRectMake(130,240 ,160 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة المقطوعة"];
    [distance setText:myAdInfo.distance]; //TODO get distance
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];
    distance.delegate=self;
    
    kiloMile = [[UISegmentedControl alloc] initWithItems:kiloMileArray];
    kiloMile.frame = CGRectMake(30, 240, 80, 30);
    kiloMile.segmentedControlStyle = UISegmentedControlStylePlain;
    if (myAdInfo.distanceRangeInKm == 2675)
    kiloMile.selectedSegmentIndex = 0;
    else
       kiloMile.selectedSegmentIndex = 1; // TODO get index of KM/MILE
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:kiloMile];
    
    
    NSInteger defaultModelID = myAdInfo.modelYear;
    NSInteger defaultModelIndex=0;
    NSString* modelString;
    while (defaultModelIndex<productionYearArray.count) {
        if (defaultModelID==[(SingleValue*)[productionYearArray objectAtIndex:defaultModelIndex] valueID]) {
            modelString =[NSString stringWithFormat:@"%@",[(SingleValue*)[productionYearArray objectAtIndex:defaultModelIndex] valueString]];
            break;
        }
        defaultModelIndex++;
    }

    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 280, 260, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:modelString forState:UIControlStateNormal]; //TODO get the porduction year
    [productionYear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [productionYear addTarget:self action:@selector(chooseProductionYear) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:productionYear];
    
    
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,320 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setText:myAdInfo.mobileNum]; //TODO get mobile number
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    mobileNum.inputAccessoryView = numberToolbar;
    mobileNum.delegate=self;
    
    
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
        locationBtnPressedOnce = YES;
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
        if (globalArray && globalArray.count)
            chosenYear = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self showPicker];
}

- (void) chooseCurrency{
    
    self.locationPickerView.hidden=YES;
    self.pickerView.hidden=NO;
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)[currencyArray objectAtIndex:0] valueString]];
    [currency setTitle:temp forState:UIControlStateNormal];
    // fill picker with currency options
    globalArray=currencyArray;
    [self.pickerView reloadAllComponents];
    if (!currencyBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            chosenCurrency = (SingleValue *)[globalArray objectAtIndex:0];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)addBtnprss:(id)sender {
    
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
    
        //check currency
    if (!currencyBtnPressedOnce)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار عملة مناسبة" delegateVC:self];
        return;
    }
    
    //check phone number
    if (!mobileNum.text)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال رقم هاتف" delegateVC:self];
        return;
    }
    
    if ([[mobileNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""])
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
   /* [[CarAdsManager sharedInstance] postAdOfBrand:_currentModel.brandID
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
                                       phoneNumer:@""
                                  adCommentsEmail:YES
                                 kmVSmilesValueID:distanceUnitID
                                         imageIDs:currentImgsUploaded
                                     withDelegate:self];*/
    
    [[CarAdsManager sharedInstance] editAdOfEditadID:self.myDetails.EncEditID inCountryID:chosenCountry.countryID InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:carAdTitle.text description:carDetails.text price:carPrice.text periodValueID:AD_PERIOD_2_MONTHS_VALUE_ID mobile:mobileNum.text currencyValueID:chosenCurrency.valueID serviceValueID:SERVICE_FOR_SALE_VALUE_ID modelYearValueID:chosenYear.valueID  distance:distance.text color:@"" phoneNumer:@"" adCommentsEmail:YES kmVSmilesValueID:distanceUnitID nine52:myAdInfo.nine52 five06:myAdInfo.five06 five02:myAdInfo.five02 nine06:myAdInfo.nine06 one01:myAdInfo.one01 ninty8:myAdInfo.ninty8 imageIDs:currentImgsUploaded withDelegate:self];
    
    
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
    [tappedBtn setImage:img forState:UIControlStateNormal];
    
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
        
         UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        int indexOfBtn = tappedBtn.tag / 10 - 1;
        if (indexOfBtn >= [CopyImageArr count]) {
            CarAd* adTest = [[CarAd alloc]initWithImageID:[NSString stringWithFormat:@"%i",ID] andImageURL:[url absoluteString]];
            [CopyImageArr addObject:adTest];
            [currentImgsUploaded addObject:[NSNumber numberWithInteger:ID]];
        }else {
        CarAd* adTest = [[CarAd alloc]initWithImageID:[NSString stringWithFormat:@"%i",ID] andImageURL:[url absoluteString]];
        [CopyImageArr replaceObjectAtIndex:indexOfBtn withObject:adTest];
        [currentImgsUploaded replaceObjectAtIndex:indexOfBtn withObject:[NSNumber numberWithInteger:ID]];
        }
        
    }
    //2- add image data to this ad
    //[currentImgsUploaded addObject:[NSNumber numberWithInteger:ID]];
    
    //reset 'current' data
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
    
}


#pragma mark - PostAd Delegate
- (void) adDidFailPostingWithError:(NSError *)error {
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
}

- (void) adDidFinishPostingWithAdID:(NSInteger)adID {
    
    [self hideLoadingIndicator];
    
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:@"تمت إضافة إعلانك بنجاج" delegateVC:self];
    
    ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)adDidFailEditingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشلت العملية يرجى المحاولة مرة أخرى" delegateVC:self];
}

-(void)adDidFinishEditingWithAdID:(NSInteger)adID
{
    [self hideLoadingIndicator];
    NSLog(@"just finished");
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد قمت بتحديث إعلانك بنجاح ،لن يظهر اعلانك في القائمة حتى يتم الموافقة على التحديث" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}


@end
