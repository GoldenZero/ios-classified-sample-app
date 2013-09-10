//
//  EditStoreAdViewController_iPad.m
//  Bezaat
//
//  Created by GALMarei on 5/14/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "EditStoreAdViewController_iPad.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "labelAdViewController.h"
#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)

@interface EditStoreAdViewController_iPad ()
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
    
    NSArray *carConditionArray;
    NSArray *gearTypeArray;
    NSArray *carTypeArray;
    NSArray *carBodyArray;
    NSMutableArray* allUserStore;
    
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
    NSInteger defaultCityID;
    NSUInteger defaultCityIndex;
    
    NSInteger defaultCountryID;
    NSString* defaultCountryName;
    
    NSInteger defaultStoreIndex;
    NSInteger myAdID;

    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenYear;
    City * chosenCity;
    Country * chosenCountry;
    Country * myCountry;
    Store* myStore;
    
    NSString* defaultCityName;
    CarAd* myAdInfo;
    
    NSMutableArray * currentImgsUploaded;
    NSMutableArray* CopyImageArr;
    
    bool conditionchoosen;
    int gearchoosen;
    int typechoosen;
    SingleValue * chosenBody;
    
    BOOL titleChanged;
    BOOL detailsChanged;
    BOOL priceChanged;
    BOOL kiloChoosen;
    BOOL mobileChanged;
    BOOL distanceChanged;
    
    BOOL locationBtnPressedOnce;
    BOOL currencyBtnPressedOnce;
    BOOL yearBtnPressedOnce;
    BOOL bodyBtnPressedOnce;
    BOOL storeBtnPressedOnce;
    
    NSTimer *timer;
    UIToolbar* numberToolbar;
    IBOutlet UITextField *placeholderTextField;
    NSUInteger defaultCurrencyID;
    NSUInteger defaultcurrecncyIndex;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}

@end

@implementation EditStoreAdViewController_iPad

@synthesize carAdTitle,mobileNum,distance,carDetails,carPrice,countryCity,currency,kiloMile,productionYear,theStore,condition,type,gear,body;
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
    
    locationMngr = [LocationManager sharedInstance];
    myAdInfo = [[CarAd alloc]init];
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getUserStores];
    
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
    bodyBtnPressedOnce = NO;
    storeBtnPressedOnce = NO;
    
    
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
   // [self hideLoadingIndicator];
    /*
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
    }*/
[self hideLoadingIndicator];
countryArray=resultArray;
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

// This method loads the device location initialli, and afterwards the loading of country lists comes after
- (void) loadData {
    defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    if  (defaultIndex!= -1){
        chosenCountry =[countryArray objectAtIndex:defaultIndex];
        cityArray=[chosenCountry cities];
    }
    
    defaultCityID =  [[LocationManager sharedInstance] getSavedUserCityID];
    defaultCountryID = [[LocationManager sharedInstance] getSavedUserCountryID];
    NSLog(@"%i",defaultCityID);
    
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
    carConditionArray = [[NSArray alloc] initWithObjects:@"مستعمل",@"جديد", nil];
    gearTypeArray = [[NSArray alloc] initWithObjects:@"عادي",@"اتوماتيك",@"تريبتونيك", nil];
    carTypeArray = [[NSArray alloc] initWithObjects:@"امامي",@"خلفي",@"4x4", nil];
    carBodyArray = [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadBodyValues]];

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
            
            UIButton* removeImg = [[UIButton alloc] initWithFrame:CGRectMake(19+(104*i), 82, 79, 25)];
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
        chosenCountry=[countryArray objectAtIndex:i];
        citiesArray = [chosenCountry cities];
        for (City* cit in citiesArray) {
            if (cit.cityID == myAdInfo.cityName.integerValue)
            {
                defaultCityName = cit.cityName;
                break;
                //return;
            }
        }
    }
    
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 650)];
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
    [theStore setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [theStore setTitle:self.myDetails.storeName forState:UIControlStateNormal];
    // TODO set the Store to the current
    [theStore setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [theStore addTarget:self action:@selector(chooseStore) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:theStore];
    
    
    countryCity=[[UIButton alloc] initWithFrame:CGRectMake(30,60 ,260 ,30)];
    [countryCity setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    
    [countryCity setTitle:defaultCityName forState:UIControlStateNormal]; //TODO chosen city
    [countryCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [countryCity addTarget:self action:@selector(chooseCountryCity) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:countryCity];
    
    carAdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30, 100,260 ,30)];
    [carAdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [carAdTitle setTextAlignment:NSTextAlignmentRight];
    [carAdTitle setPlaceholder:@"عنوان الإعلان"];
    [carAdTitle setText:myAdInfo.title]; //TODO ad Title
    [self.verticalScrollView addSubview:carAdTitle];
    carAdTitle.delegate=self;
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,140 ,260 ,80 )];
    [carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setText:myAdInfo.desc]; //TODO get Description
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [carDetails setFont:[UIFont systemFontOfSize:17]];
    [self.verticalScrollView addSubview:carDetails];
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
    
    
    
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,240 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setText:myAdInfo.mobileNum]; //TODO get mobile number
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    mobileNum.inputAccessoryView = numberToolbar;
    mobileNum.delegate=self;

    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,290 ,160 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر (اختياري)"];
    [carPrice setText:[NSString stringWithFormat:@"%i",(int)myAdInfo.price]]; //TODO get Price
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    carPrice.delegate=self;
    
    // NSInteger defaultCurrencyID=[[StaticAttrsLoader sharedInstance] getCurrencyIdOfCountry:myAdInfo.currencyString.integerValue];
    NSInteger defaultCurrencyID1 = myAdInfo.currencyString.integerValue;
    NSInteger defaultcurrecncyIndex1=0;
    while (defaultcurrecncyIndex1<currencyArray.count) {
        if (defaultCurrencyID1==[(SingleValue*)[currencyArray objectAtIndex:defaultcurrecncyIndex1] valueID]) {
            chosenCurrency=[currencyArray objectAtIndex:defaultcurrecncyIndex1];
            break;
        }
        defaultcurrecncyIndex1++;
    }
    
    
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 290, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_SM.png"] forState:UIControlStateNormal];
    [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal]; //TODO get currency
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];
    
    distance=[[UITextField alloc] initWithFrame:CGRectMake(130,350 ,160 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة المقطوعة"];
    [distance setText:myAdInfo.distance]; //TODO get distance
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];
    distance.delegate=self;
    
    kiloMile = [[UISegmentedControl alloc] initWithItems:kiloMileArray];
    kiloMile.frame = CGRectMake(30, 350, 80, 30);
    kiloMile.segmentedControlStyle = UISegmentedControlStylePlain;
    if (myAdInfo.distanceRangeInKm == 2675)
        kiloMile.selectedSegmentIndex = 0;
    else
        kiloMile.selectedSegmentIndex = 1; // TODO get index of KM/MILE
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:kiloMile];
    
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    
    condition = [[UISegmentedControl alloc] initWithItems:carConditionArray];
    condition.frame = CGRectMake(30, 410, 260, 40);
    condition.segmentedControlStyle = UISegmentedControlStylePlain;
    if (myAdInfo.carCondition == 1000626)
        condition.selectedSegmentIndex = 0;
    else
        condition.selectedSegmentIndex = 1;
    [condition setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [condition addTarget:self action:@selector(chooseCarCondition) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:condition];
    
    gear = [[UISegmentedControl alloc] initWithItems:gearTypeArray];
    gear.frame = CGRectMake(30, 470, 260, 40);
    gear.segmentedControlStyle = UISegmentedControlStylePlain;
    if (myAdInfo.gearType == 1000628)
        gear.selectedSegmentIndex = 0;
    else if (myAdInfo.gearType == 1000629)
        gear.selectedSegmentIndex = 1;
    else
        gear.selectedSegmentIndex = 2;
    
    [gear setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [gear addTarget:self action:@selector(chooseGearType) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:gear];
    
    type = [[UISegmentedControl alloc] initWithItems:carTypeArray];
    type.frame = CGRectMake(30, 520, 260, 40);
    type.segmentedControlStyle = UISegmentedControlStylePlain;
    if (myAdInfo.carType == 1000664)
        type.selectedSegmentIndex = 0;
    else if (myAdInfo.carType == 1000665)
        type.selectedSegmentIndex = 1;
    else
        type.selectedSegmentIndex = 2;
    [type setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [type addTarget:self action:@selector(chooseCarType) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:type];
    
    NSInteger defaultBodyID = myAdInfo.carBody;
    NSInteger defaultBodyIndex=0;
    NSString* bodyString;
    while (defaultBodyIndex < carBodyArray.count) {
        if (defaultBodyID==[(SingleValue*)[carBodyArray objectAtIndex:defaultBodyIndex] valueID]) {
            bodyString =[NSString stringWithFormat:@"%@",[(SingleValue*)[carBodyArray objectAtIndex:defaultBodyIndex] valueString]];
            break;
        }
        defaultBodyIndex++;
    }

    
    body =[[UIButton alloc] initWithFrame:CGRectMake(30, 570, 260, 30)];
    [body setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [body setTitle:bodyString forState:UIControlStateNormal];
    [body addTarget:self action:@selector(chooseBody) forControlEvents:UIControlEventTouchUpInside];
    [body setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:body];

    
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
    
    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 610, 260, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:modelString forState:UIControlStateNormal]; //TODO get the porduction year
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
    imgsLoadingHUD = [MBProgressHUD2 showHUDAddedTo:self.horizontalScrollView animated:YES];
    imgsLoadingHUD.mode = MBProgressHUDModeCustomView2;
    imgsLoadingHUD.labelText = @"";
    imgsLoadingHUD.detailsLabelText = @"";
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
        locationBtnPressedOnce = YES;
        cityArray=[myCountry cities];
        chosenCity=[cityArray objectAtIndex:row];
        NSString *temp= [NSString stringWithFormat:@"%@ : %@", myCountry.countryName , chosenCity.cityName];
        [countryCity setTitle:temp forState:UIControlStateNormal];
    }else if (pickerView == _bodyPickerView)
    {
        SingleValue *choosen=[globalArray objectAtIndex:row];
        if ([carBodyArray containsObject:choosen]) {
            chosenBody=[globalArray objectAtIndex:row];
            [body setTitle:choosen.valueString forState:UIControlStateNormal];
        }
        
    }else if (pickerView == _storePickerView){
        myStore = [allUserStore objectAtIndex:row];
        [theStore setTitle:myStore.name forState:UIControlStateNormal];
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
    }else if (pickerView==_bodyPickerView) {
        return [globalArray count];
        
    }else if (pickerView == _storePickerView)
    {
        return [allUserStore count];
    }
    else {
        return [globalArray count];
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView==_locationPickerView) {
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
    
    [self.storePickerView selectRow:defaultStoreIndex inComponent:0 animated:YES];
    
    NSString *temp= [NSString stringWithFormat:@"%@",[(Store*)[allUserStore objectAtIndex:0] name]];
    [theStore setTitle:temp forState:UIControlStateNormal];
    
    // fill picker with production year
    globalArray=allUserStore;
    //[self.pickerView reloadAllComponents];
    [self.storePickerView reloadAllComponents];
    if (!storeBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            myStore = (Store *)[globalArray objectAtIndex:0];
    }
    
    
    storeBtnPressedOnce = YES;
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
        if (globalArray && globalArray.count)
            chosenYear = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    yearBtnPressedOnce = YES;
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    
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
    if (!currencyBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            chosenCurrency = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:defaultcurrecncyIndex inComponent:0 animated:YES];
    
    currencyBtnPressedOnce = YES;
    
    [self showPicker];
    
}

- (void) chooseCountryCity{
    
    self.locationPickerView.hidden=NO;
    self.pickerView.hidden=YES;
    self.bodyPickerView.hidden = YES;
    self.storePickerView.hidden = YES;
    [self dismissKeyboard];
    
    [self showPicker];
    NSString *temp= [NSString stringWithFormat:@"%@ :%@", myCountry.countryName , chosenCity.cityName];
    [countryCity setTitle:temp forState:UIControlStateNormal];
    if (!locationBtnPressedOnce) {
    if (defaultIndex!=-1) {
        [self.locationPickerView selectRow:defaultCityID inComponent:0 animated:YES];
    }
    }
    [self.locationPickerView reloadAllComponents];
    
   // locationBtnPressedOnce = YES;
    
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
    if (!bodyBtnPressedOnce)
    {
        if (globalArray && globalArray.count)
            chosenBody = (SingleValue *)[globalArray objectAtIndex:0];
    }
    
    [self.bodyPickerView reloadAllComponents];
    bodyBtnPressedOnce = YES;
    
    [self showPicker];
}


- (IBAction)doneBtnPrss:(id)sender {
    [self closePicker];
}

- (IBAction)homeBtnPrss:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    ChooseActionViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    else
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
    vc.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
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
    
    if (!storeBtnPressedOnce)
    {
        if (self.myDetails.storeID) {
            myStore = self.currentStore;
        }else {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار المتجر" delegateVC:self];
            return;
        }
    }
    
   /* //check country & city
    if (!locationBtnPressedOnce)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار بلد ومدينة مناسبين" delegateVC:self];
        return;
    }*/
    
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
    
    if ([mobileNum.text length] == 0)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال رقم هاتف" delegateVC:self];
        return;
    }
    
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
    

    
    
    if (!bodyBtnPressedOnce)
    {
        
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار هيكل السيارة" delegateVC:self];
        return;
        
    }
    
    if ([distance.text length] == 0)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء إدخال المسافه المقطوعه" delegateVC:self];
        return;
    }

    
    
    
    NSInteger distanceUnitID;
    int conditionID = 0;
    int gearID = 0;
    int typeID = 0;
    
    if (kiloChoosen){
        distanceUnitID = [self idForKilometerAttribute];
        myAdInfo.distanceRangeInKm = [self idForKilometerAttribute];
    }
    else{
        distanceUnitID = [self idForMileAttribute];
        myAdInfo.distanceRangeInKm = [self idForMileAttribute];
    }
    
    if (conditionchoosen){
        conditionID = [self idForConditionNewAttribute];
    myAdInfo.carCondition = [self idForConditionNewAttribute];
    }else{
        conditionID = [self idForConditionUsedAttribute];
    myAdInfo.carCondition = [self idForConditionUsedAttribute];
    }
    if (gearchoosen == 0) {
        gearID = [self idForGearAutoAttribute];
        myAdInfo.gearType = [self idForGearAutoAttribute];
    }else if (gearchoosen == 1){
        gearID = [self idForGearNormalAttribute];
        myAdInfo.gearType = [self idForGearNormalAttribute];
    }
    else if (gearchoosen == 2){
        gearID = [self idForGearTronicAttribute];
        myAdInfo.gearType = [self idForGearTronicAttribute];
    }
    
    if (typechoosen == 0) {
        typeID = [self idForTypeFrontAttribute];
        myAdInfo.carType = [self idForTypeFrontAttribute];
    }else if (typechoosen == 1){
        typeID = [self idForTypeBackAttribute];
        myAdInfo.carType = [self idForTypeBackAttribute];
    }
    else if (typechoosen == 2){
        typeID = [self idForTypeFourAttribute];
        myAdInfo.carType = [self idForTypeFourAttribute];
    }
    
    [self showLoadingIndicator];
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if ([distance.text length] == 0) {
        distance.text = @"";
    }
    if ([carPrice.text length] == 0) {
        carPrice.text = @"";
    }

    /* [[CarAdsManager sharedInstance] postStoreAdOfBrand:_currentModel.brandID myStore:myStore.identifier
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
     withDelegate:self];*/
    
    [[CarAdsManager sharedInstance] editStoreAdOfEditadID:self.myDetails.EncEditID inCountryID:chosenCountry.countryID InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:carAdTitle.text description:carDetails.text price:carPrice.text periodValueID:AD_PERIOD_2_MONTHS_VALUE_ID mobile:mobileNum.text currencyValueID:chosenCurrency.valueID serviceValueID:SERVICE_FOR_SALE_VALUE_ID modelYearValueID:chosenYear.valueID  distance:distance.text color:@"" phoneNumer:@"" adCommentsEmail:YES kmVSmilesValueID:distanceUnitID nine52:myAdInfo.nine52 five06:myAdInfo.five06 advPeriod:myAdInfo.five02 nine06:myAdInfo.nine06 one01:myAdInfo.one01 ninty8:myAdInfo.ninty8 serviceName:myAdInfo.serviceName adCommentsEmail:myAdInfo.adComments carCondition:myAdInfo.carCondition gearType:myAdInfo.gearType carEngine:myAdInfo.carEngine carType:myAdInfo.carType carBody:myAdInfo.carBody carCD:myAdInfo.carCD carHeads:myAdInfo.carHeads storeID:myStore.identifier imageIDs:currentImgsUploaded withDelegate:self];
    
    
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
    
    ChooseActionViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    else
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)storeAdDidFailEditingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشلت العملية يرجى المحاولة مرة أخرى" delegateVC:self];
}

-(void)storeAdDidFinishEditingWithAdID:(NSInteger)adID
{
    [self hideLoadingIndicator];
    NSLog(@"just finished");
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد قمت بتحديث إعلانك بنجاح ،لن يظهر اعلانك في القائمة حتى يتم الموافقة على التحديث" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        ChooseActionViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
        else
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
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
    
    //if (self.currentStore) {
        for (int i =0; i < [allUserStore count]; i++) {
            if (self.myDetails.storeID == [(Store *)[allUserStore objectAtIndex:i] identifier]) {
                defaultStoreIndex = [(Store *)[allUserStore objectAtIndex:i] identifier];
                self.currentStore = (Store *)[allUserStore objectAtIndex:i];
                break;
            }
        }
        [theStore setTitle:self.currentStore.name forState:UIControlStateNormal];
   // }
    [self.storePickerView reloadAllComponents];
    [self hideLoadingIndicator];
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

@end
