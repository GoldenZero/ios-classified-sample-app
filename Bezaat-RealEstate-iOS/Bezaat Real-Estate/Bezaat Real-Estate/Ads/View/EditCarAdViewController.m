//
//  EditCarAdViewController.m
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "EditCarAdViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomePageViewController.h"
#import "ChooseCategoryViewController.h"
#import "labelAdViewController.h"
#import "SignInViewController.h"
#import "CarAdDetailsViewController.h"

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
    NSArray *roomsArray;
    NSArray *periodsArray;
    NSArray *countryArray;
    NSArray *cityArray;
    NSArray *serviceReqArray;
    NSArray *unitsArray;
    
    IBOutlet UITextField *placeholderTextField;
    
    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;
    UIImage * currentImageToUpload;
    LocationManager * locationMngr;
    CLLocationManager * deviceLocationDetector;
    CLLocation *PropertyLocation;
    
    NSUInteger defaultIndex;
    NSUInteger defaultCityIndex;
    NSUInteger defaultCurrencyID;
    NSUInteger defaultcurrecncyIndex;
    NSInteger myAdID;
    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenPeriod;
    SingleValue * chosenUnit;
    City * chosenCity;
    Country * chosenCountry;
    SingleValue * chosenRoom;
    
    NSString* defaultCityName;
    AdDetails* myAdInfo;
    
    float longitude;
    float latittude;
    
    bool requiredChoosen;
    bool showedChoosen;
    bool installmentChoosen;
    
    int chosenImgBtnTag;
    int chosenRemoveImgBtnTag;
    int removeCounter;
    BOOL firstRemove;
    
    
    BOOL guestCheck;
    NSString* guestEmail;
    
    NSMutableArray * currentImgsUploaded;
    NSMutableArray* CopyImageArr;
    
    BOOL locationBtnPressedOnce;
    BOOL currencyBtnPressedOnce;
    BOOL roomsBtnPressedOnce;
    BOOL periodBtnPressedOnce;
    BOOL mapLocationBtnPressedOnce;
    BOOL unitsBtnPressedOnce;
    
    NSTimer *timer;
    UIToolbar* numberToolbar;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}
@end

@implementation EditCarAdViewController
@synthesize AdTitle,mobileNum,unitPrice,propertyDetails,propertyPrice,countryCity,currency,serviceReq,adPeriod,adDetailLabel,roomsNum,propertySpace,propertyArea,mapLocation,phoneNum,units;
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
    myAdInfo = [[AdDetails alloc]init];
    
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
    [[GAI sharedInstance].defaultTracker sendView:@"Edit§ Ad screen"];
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
#pragma mark - location handler.

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countryArray=resultArray;
    [self hideLoadingIndicator];
    
    defaultIndex = [locationMngr getIndexOfCountry:self.myDetails.countryID];
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
    
    /*
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
     */
    
}

// This method loads the device location initialli, and afterwards the loading of country lists comes after
- (void) loadData {
    
    [locationMngr loadCountriesAndCitiesWithDelegate:self];
}

- (void) loadDataArray{
    myAdInfo = (AdDetails*)[self.myAdArray objectAtIndex:0];
    CopyImageArr = [[NSMutableArray alloc] initWithArray:self.myImageIDArray];
    
    for (Ad* temp in CopyImageArr) {
        [currentImgsUploaded addObject:temp.thumbnailID];
    }
    
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
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



#pragma mark - helper methods
- (void) setImagesToXib{
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
}

- (void) setImagesArray{
    
    
    Ad* ADS;
    int remainingImg = [self.myImageIDArray count];
    for (int i=0; i<6; i++) {
        if ([self.myImageIDArray count] == 0 || remainingImg == 0) {
            UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(104*i), 15, 77, 70)];
            [temp setImage:[UIImage imageNamed:@"takePhotobkg.png"] forState:UIControlStateNormal];
            
            temp.tag = (i+1) * 10;
            [temp addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
            [self.horizontalScrollView addSubview:temp];
        }else{
            ADS = (Ad*)[self.myImageIDArray objectAtIndex:i];
            UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(104*i), 15, 77, 70)];
            [temp setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ADS.ImageURL]]] forState:UIControlStateNormal];
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
    [tappedBtn setImage:[UIImage imageNamed:@"takePhotobkg.png"] forState:UIControlStateNormal];
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
    
    NSArray* citiesArray;
    for (int i =0; i <= [countryArray count] - 1; i++) {
        
        citiesArray = [(Country *)[countryArray objectAtIndex:i] cities];
        for (City* cit in citiesArray) {
            if (cit.cityID == myAdInfo.cityID)
            {
                defaultCityName = cit.cityName;
                break;
                //return;
            }
        }
    }
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
    
    
    countryCity=[[UIButton alloc] initWithFrame:CGRectMake(30,20 ,260 ,30)];
    [countryCity setBackgroundImage:[UIImage imageNamed: @"fieldWithDownArrow.png"] forState:UIControlStateNormal];
    [countryCity setTitle:defaultCityName forState:UIControlStateNormal];
    [countryCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [countryCity addTarget:self action:@selector(chooseCountryCity) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:countryCity];
    
    serviceReq = [[UISegmentedControl alloc] initWithItems:serviceReqArray];
    serviceReq.frame = CGRectMake(30, 60, 260, 30);
    serviceReq.segmentedControlStyle = UISegmentedControlStylePlain;
    serviceReq.selectedSegmentIndex = 0;
    [serviceReq addTarget:self action:@selector(chooseServiceReq) forControlEvents: UIControlEventValueChanged];
    //[self.verticalScrollView addSubview:serviceReq];
    
    roomsNum=[[UIButton alloc] initWithFrame:CGRectMake(30,100 ,260 ,30)];
    [roomsNum setBackgroundImage:[UIImage imageNamed: @"fieldWithDownArrow.png"] forState:UIControlStateNormal];
    [roomsNum setTitle:myAdInfo.Rooms forState:UIControlStateNormal];
    [roomsNum setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [roomsNum addTarget:self action:@selector(chooseRoomsNum) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:roomsNum];
    
    propertySpace=[[UITextField alloc] initWithFrame:CGRectMake(30,140 ,260 ,30)];
    [propertySpace setBorderStyle:UITextBorderStyleRoundedRect];
    [propertySpace setTextAlignment:NSTextAlignmentRight];
    [propertySpace setText:myAdInfo.SpaceString];
    [self.verticalScrollView addSubview:propertySpace];
    propertySpace.delegate=self;
    
    mapLocation=[[UIButton alloc] initWithFrame:CGRectMake(30,172 ,260 ,43)];
    [mapLocation setBackgroundImage:[UIImage imageNamed: @"fieldWithArrowMap.png"] forState:UIControlStateNormal];
    [mapLocation setTitle:@"الموقع على الخريطة" forState:UIControlStateNormal];
    PropertyLocation = [[CLLocation alloc] initWithLatitude:myAdInfo.latitude longitude:myAdInfo.longitude];
    [mapLocation setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [mapLocation addTarget:self action:@selector(chooseMapLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.verticalScrollView addSubview:mapLocation];
    
    propertyArea=[[UITextField alloc] initWithFrame:CGRectMake(30,220 ,260 ,30)];
    [propertyArea setBorderStyle:UITextBorderStyleRoundedRect];
    [propertyArea setTextAlignment:NSTextAlignmentRight];
    //[propertyArea setPlaceholder:myAdInfo.area];
    [propertyArea setText:myAdInfo.area];
    [self.verticalScrollView addSubview:propertyArea];
    propertyArea.delegate=self;
    
    AdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30, 260,260 ,30)];
    [AdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [AdTitle setTextAlignment:NSTextAlignmentRight];
    [AdTitle setPlaceholder:@"عنوان الاعلان"];
    [AdTitle setText:myAdInfo.title];
    [self.verticalScrollView addSubview:AdTitle];
    AdTitle.delegate=self;
    
    adDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 295, 260, 20)];
    [adDetailLabel setText:myAdInfo.description];
    [adDetailLabel setTextAlignment:NSTextAlignmentRight];
    [adDetailLabel setTextColor:[UIColor blackColor]];
    [adDetailLabel setFont:[UIFont systemFontOfSize:17]];
    [adDetailLabel setBackgroundColor:[UIColor clearColor]];
    [self.verticalScrollView addSubview:adDetailLabel];
    
    
    propertyDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,320 ,260 ,80 )];
    [propertyDetails setTextAlignment:NSTextAlignmentRight];
    [propertyDetails setKeyboardType:UIKeyboardTypeDefault];
    [propertyDetails setBackgroundColor:[UIColor whiteColor]];
    [propertyDetails setFont:[UIFont systemFontOfSize:17]];
    [propertyDetails setText:myAdInfo.description];
    propertyDetails.delegate =self;
    
    placeholderTextField=[[UITextField alloc] initWithFrame:CGRectMake(30,320 ,260 ,30)];
    [placeholderTextField setTextAlignment:NSTextAlignmentRight];
    [placeholderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    CGRect frame = placeholderTextField.frame;
    frame.size.height = propertyDetails.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"تفاصيل الإعلان";
    //[self.verticalScrollView addSubview:placeholderTextField];
    [self.verticalScrollView addSubview:propertyDetails];
    
    propertyPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,410 ,160 ,30)];
    [propertyPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [propertyPrice setTextAlignment:NSTextAlignmentRight];
    [propertyPrice setPlaceholder:@"السعر (اختياري)"];
    [propertyPrice setText:[NSString stringWithFormat:@"%i",(int)myAdInfo.price]];
    [propertyPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:propertyPrice];
    propertyPrice.delegate=self;
    
    
    NSInteger defaultCurrencyID1 = myAdInfo.currencyString.integerValue;
    NSInteger defaultcurrecncyIndex1=0;
    while (defaultcurrecncyIndex1<currencyArray.count) {
        if (defaultCurrencyID1==[(SingleValue*)[currencyArray objectAtIndex:defaultcurrecncyIndex1] valueID]) {
            chosenCurrency=[currencyArray objectAtIndex:defaultcurrecncyIndex1];
            break;
        }
        defaultcurrecncyIndex1++;
    }
    
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 410, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"fieldSmallWithDownArrow.png"] forState:UIControlStateNormal];
    //[currency setTitle:@"العملة   " forState:UIControlStateNormal];
    if (chosenCurrency)
        [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal];
    else
        [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal];
    
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];
    
    unitPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,450 ,160 ,30)];
    [unitPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [unitPrice setTextAlignment:NSTextAlignmentRight];
    [unitPrice setPlaceholder:@"سعر الوحدة"];
    [unitPrice setText:myAdInfo.UnitPriceString];
    [unitPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:unitPrice];
    unitPrice.delegate=self;
    
    
    NSInteger defaultUnitID = myAdInfo.UnitTypeString.integerValue;
    NSInteger defaultunitIndex=0;
    while (defaultunitIndex<unitsArray.count) {
        if (defaultUnitID==[(SingleValue*)[unitsArray objectAtIndex:defaultunitIndex] valueID]) {
            chosenUnit=[currencyArray objectAtIndex:defaultunitIndex];
            break;
        }
        defaultunitIndex++;
    }
    
    units =[[UIButton alloc] initWithFrame:CGRectMake(30, 450, 80, 30)];
    [units setBackgroundImage:[UIImage imageNamed: @"fieldSmallWithDownArrow.png"] forState:UIControlStateNormal];
    [units setTitle:chosenUnit.valueString forState:UIControlStateNormal];
    [units addTarget:self action:@selector(chooseUnits) forControlEvents:UIControlEventTouchUpInside];
    [units setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:units];
    
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,490 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setText:myAdInfo.mobileNumber];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    //mobileNum.inputAccessoryView = numberToolbar;
    mobileNum.delegate=self;
    
    phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(30,530 ,260 ,30)];
    [phoneNum setBorderStyle:UITextBorderStyleRoundedRect];
    [phoneNum setTextAlignment:NSTextAlignmentRight];
    [phoneNum setPlaceholder:@"رقم الهاتف"];
    [phoneNum setText:myAdInfo.landlineNumber];
    [phoneNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:phoneNum];
    //mobileNum.inputAccessoryView = numberToolbar;
    phoneNum.delegate=self;
    
    NSInteger defaultPeriodID = myAdInfo.UnitTypeString.integerValue;
    NSInteger defaultperiodIndex=0;
    while (defaultperiodIndex<periodsArray.count) {
        if (defaultPeriodID==[(SingleValue*)[periodsArray objectAtIndex:defaultperiodIndex] valueID]) {
            chosenPeriod=[periodsArray objectAtIndex:defaultperiodIndex];
            break;
        }
        defaultperiodIndex++;
    }
    
    adPeriod =[[UIButton alloc] initWithFrame:CGRectMake(30, 570, 260, 30)];
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
    
    else {
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
        if (roomsBtnPressedOnce)
            return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
        else
            return [NSString stringWithFormat:@"%@",[(SingleValue*)[globalArray objectAtIndex:row] valueString]];
    }
    
    
}

#pragma mark - Buttons Actions


- (void) choosePeriod{
    
    self.locationPickerView.hidden=YES;
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
    self.pickerView.hidden=NO;
    
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(SingleValue*)chosenUnit valueString]];
    [units setTitle:temp forState:UIControlStateNormal];
    // fill picker with currency options
    globalArray=unitsArray;
    [self.pickerView reloadAllComponents];
    if (!unitsBtnPressedOnce)
    {
        unitsBtnPressedOnce = YES;
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if (globalArray && globalArray.count)
            chosenUnit = (SingleValue *)[globalArray objectAtIndex:0];
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
    locationBtnPressedOnce = YES;
    
}

- (void) chooseRoomsNum{
    
    self.locationPickerView.hidden=YES;
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
    vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)addBtnprss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Post Car Ad"
                         withValue:[NSNumber numberWithInt:100]];
    
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
        // post for sale
        //[[CarAdsManager sharedInstance] editAdOfEditadID:self.myDetails.EncEditID inCountryID:chosenCountry.countryID InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:carAdTitle.text description:carDetails.text price:carPrice.text periodValueID:AD_PERIOD_2_MONTHS_VALUE_ID mobile:mobileNum.text currencyValueID:chosenCurrency.valueID serviceValueID:SERVICE_FOR_SALE_VALUE_ID modelYearValueID:chosenYear.valueID  distance:distance.text color:@"" phoneNumer:@"" adCommentsEmail:YES kmVSmilesValueID:distanceUnitID nine52:(!myAdInfo.nine52 ? 0 :myAdInfo.nine52) five06:(!myAdInfo.five06 ? 0 :myAdInfo.five06) five02:(!myAdInfo.five02 ? 0 :myAdInfo.five02) nine06:(!myAdInfo.nine06 ? 0 :myAdInfo.nine06) one01:(!myAdInfo.one01 ? 0 :myAdInfo.one01) ninty8:(!myAdInfo.ninty8 ? 0 :myAdInfo.ninty8) imageIDs:currentImgsUploaded withDelegate:self];
        [[AdsManager sharedInstance] editAdForSaleOfEditadID:self.myDetails.EncEditID OfCategory:self.myDetails.CategoryID inCountryID:chosenCountry.countryID InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:AdTitle.text description:adDetailLabel.text adPeriod:chosenPeriod.valueID requireService:RequiredService price:propertyPrice.text currencyValueID:chosenCurrency.valueID unitPrice:unitPrice.text unitType:chosenUnit.valueID imageIDs:currentImgsUploaded longitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.latitude] roomNumber:(self.myDetails.CategoryID == 338 || self.myDetails.CategoryID == 648 ? @"" : chosenRoom.valueString) space:propertySpace.text area:propertyArea.text mobile:mobileNum.text phoneNumer:phoneNum.text withDelegate:self];
        
        
    }else
    {
        //post for rent
        [[AdsManager sharedInstance] editAdForRentOfEditadID:self.myDetails.EncEditID OfCategory:self.myDetails.CategoryID inCountryID:chosenCountry.countryID InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:AdTitle.text description:adDetailLabel.text adPeriod:chosenPeriod.valueID requireService:RequiredService price:propertyPrice.text currencyValueID:chosenCurrency.valueID unitPrice:unitPrice.text unitType:chosenUnit.valueID imageIDs:currentImgsUploaded longitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%f",PropertyLocation.coordinate.latitude] roomNumber:(self.myDetails.CategoryID == 338 || self.myDetails.CategoryID == 648 ? @"" : chosenRoom.valueString) space:propertySpace.text area:propertyArea.text mobile:mobileNum.text phoneNumer:phoneNum.text withDelegate:self];
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 2) {
        HomePageViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
        else
            vc =[[HomePageViewController alloc]initWithNibName:@"HomePageViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
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
        
        UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        int indexOfBtn = tappedBtn.tag / 10 - 1;
        if (indexOfBtn >= [CopyImageArr count]) {
            Ad* adTest = [[Ad alloc]initWithImageID:[NSString stringWithFormat:@"%i",ID] andImageURL:[url absoluteString]];
            [CopyImageArr addObject:adTest];
            [currentImgsUploaded addObject:[NSNumber numberWithInteger:ID]];
        }else {
            Ad* adTest = [[Ad alloc]initWithImageID:[NSString stringWithFormat:@"%i",ID] andImageURL:[url absoluteString]];
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


-(void)adDidFailEditingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
}

-(void)adDidFinishEditingWithAdID:(NSInteger)adID
{
    [self hideLoadingIndicator];
    NSLog(@"just finished");
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد قمت بتحديث إعلانك بنجاح ،لن يظهر اعلانك في القائمة حتى يتم الموافقة على التحديث" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
    
    
}
@end
