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
#import "ChooseModelView_iPad.h"
#import "BrandCell.h"
#import "ModelCell.h"

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
    
    
    [self loadDataArray];
    [self loadData];
    [self customizeButtonsInXib];
    [self setImagesArray];
    
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

- (void) setImagesArray{
    
    CarAd* cardADS;
    int remainingImg = [self.myImageIDArray count];
    for (int i=0; i<6; i++) {
        if ([self.myImageIDArray count] == 0 || remainingImg == 0) {
            
            UIButton * temp = (UIButton *)[self.iPad_setPhotoView viewWithTag:((i+1) *10)];
            [temp setImage:[UIImage imageNamed:@"tb_add_individual3_add_image_btn.png"] forState:UIControlStateNormal];
        }else{
            cardADS = (CarAd*)[self.myImageIDArray objectAtIndex:i];
            
            UIButton * temp = (UIButton *)[self.iPad_setPhotoView viewWithTag:((i+1) *10)];
            [temp setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cardADS.ImageURL]]] forState:UIControlStateNormal];
            
            remainingImg-=1;
            
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
    
    //[actionSheet showInView:self.view];
    [actionSheet showFromRect:senderBtn.frame inView:senderBtn animated:YES];
}

-(IBAction) ImageDelete:(id)sender {
    UIButton* senderBtn = (UIButton *)sender;
    chosenRemoveImgBtnTag = senderBtn.tag / 10;
    
    UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenRemoveImgBtnTag];
    //[tappedBtn setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
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
}

-(void)cancelNumberPad{
    [mobileNum resignFirstResponder];
    mobileNum.text = @"";
}

-(void)doneWithNumberPad{
    [mobileNum resignFirstResponder];
}

- (void) customizeButtonsInXib{
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
    
    [theStore setTitle:self.myDetails.storeName forState:UIControlStateNormal]; // TODO set the Store to the current
    
    [countryCity setTitle:defaultCityName forState:UIControlStateNormal]; //TODO chosen city
    
    [carAdTitle setText:myAdInfo.title]; //TODO ad Title
    
    [carDetails setText:myAdInfo.desc]; //TODO get Description
    
    [mobileNum setText:myAdInfo.mobileNum]; //TODO get mobile number
    
    [carPrice setText:[NSString stringWithFormat:@"%i",(int)myAdInfo.price]]; //TODO get Price
    
    NSInteger defaultCurrencyID1 = myAdInfo.currencyString.integerValue;
    NSInteger defaultcurrecncyIndex1=0;
    while (defaultcurrecncyIndex1<currencyArray.count) {
        if (defaultCurrencyID1==[(SingleValue*)[currencyArray objectAtIndex:defaultcurrecncyIndex1] valueID]) {
            chosenCurrency=[currencyArray objectAtIndex:defaultcurrecncyIndex1];
            break;
        }
        defaultcurrecncyIndex1++;
    }
    
    [currency setTitle:chosenCurrency.valueString forState:UIControlStateNormal]; //TODO get currency
    
    [distance setText:myAdInfo.distance]; //TODO get distance
    
    
    if (myAdInfo.distanceRangeInKm == 2675) {
        kiloChoosen=true;
        [self iPad_kiloBtnPrss:nil];
    }
    else {
        kiloChoosen=true;
        [self iPad_mileBtnPrss:nil];
    }
    
    if (myAdInfo.carCondition == 1000626) {
        //condition.selectedSegmentIndex = 0;
        conditionchoosen=true;
        [self iPad_newCarConditionBtnPrss:nil];
    }
    else {
        //condition.selectedSegmentIndex = 1;
        conditionchoosen=false;
        [self iPad_usedCarConditionBtnPrss:nil];
    }
    
    if (myAdInfo.gearType == 1000628) {
        //gear.selectedSegmentIndex = 0;
        gearchoosen = 0;
        [self iPad_normalGearTypeBtnPrss:nil];
    }
    else if (myAdInfo.gearType == 1000629) {
        //gear.selectedSegmentIndex = 1;
        gearchoosen = 1;
        [self iPad_automaticGearTypeBtnPrss:nil];
    }
    else {
        //gear.selectedSegmentIndex = 2;
        gearchoosen = 2;
        [self iPad_tiptronicGearTypeBtnPrss:nil];
    }
    
    if (myAdInfo.carType == 1000664) {
        //type.selectedSegmentIndex = 0;
        typechoosen = 0;
        [self iPad_frontWheelCarTypeBtnPrss:nil];
    }
    else if (myAdInfo.carType == 1000665) {
        //type.selectedSegmentIndex = 1;
        typechoosen = 1;
        [self iPad_backWheelCarTypeBtnPrss:nil];
    }
    else {
        //type.selectedSegmentIndex = 2;
        typechoosen = 2;
        [self iPad_fourWheelCarTypeBtnPrss:nil];
    }
    
    
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
    
    [body setTitle:bodyString forState:UIControlStateNormal];
    
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
    
    [productionYear setTitle:modelString forState:UIControlStateNormal]; //TODO get the porduction year
    
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
        locationBtnPressedOnce = YES;
        cityArray=[myCountry cities];
        chosenCity=[cityArray objectAtIndex:row];
        NSString *temp= [NSString stringWithFormat:@"%@ : %@", myCountry.countryName , chosenCity.cityName];
        [countryCity setTitle:temp forState:UIControlStateNormal];
    }else*/
    if (pickerView == _bodyPickerView)
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
    /*
     if (pickerView==_locationPickerView) {
        return [cityArray count];
    }else*/
    if (pickerView==_bodyPickerView) {
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
    /*
     if (pickerView==_locationPickerView) {
        City *temp=(City*)[cityArray objectAtIndex:row];
        return temp.cityName;
    }else*/
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


- (IBAction) chooseProductionYear:(id) sender {
    
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

- (IBAction) chooseCurrency:(id) sender{
    
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

- (IBAction) chooseCountryCity:(id) sneder{
    /*
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
     */
    // locationBtnPressedOnce = YES;
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
 */

-(IBAction) chooseBody:(id)sender
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

- (IBAction) iPad_closeBtnPrss:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneBtnPrss:(id)sender {
    [self closePicker];
}

/*
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
*/

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
    UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenImgBtnTag];
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
    /*
     if (chosenImgBtnTag > -1)
    {
        UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        
        [tappedBtn setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
    }
     */
    
    
    //reset 'current' data
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
    
}

- (void) imageDidFinishUploadingWithURL:(NSURL *)url CreativeID:(NSInteger)ID {
    
    [self hideLoadingIndicatorOnImages];
    
    //1- show the image on the button
    if ((chosenImgBtnTag > -1) && (currentImageToUpload))
    {
        
        UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenImgBtnTag];
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
/*
 - (void)textViewDidChange:(UITextView *)textView {
 if ([@"" isEqualToString:textView.text]) {
 placeholderTextField.placeholder = @"تفاصيل الإعلان";
 }
 else {
 placeholderTextField.placeholder = @"";
 }
 }
 */
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
