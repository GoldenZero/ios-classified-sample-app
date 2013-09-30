//
//  EditCarAdViewController_iPad.m
//  Bezaat
//
//  Created by GALMarei on 5/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "EditCarAdViewController_iPad.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"
#import "ModelsViewController_iPad.h"
#import "labelAdViewController.h"
#import "ChooseModelView_iPad.h"
#import "BrandCell.h"
#import "ModelCell.h"
#import "CountryListViewController.h"

#pragma mark - literals for use in post ad
//These literals should used for posting any ad
#define AD_PERIOD_2_MONTHS_VALUE_ID     1189 //period = 2 months (fixed)
#define SERVICE_FOR_SALE_VALUE_ID       830  //service = for sale (fixed)
#define AD_COMMENTS_BY_MAIL             1    //always allow "true" receiving mails (fixed)



@interface EditCarAdViewController_iPad ()
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

@implementation EditCarAdViewController_iPad
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
    
    
    
    tap2 = [[UITapGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(dismissKeyboard)];
    [self.iPad_mainScrollView addGestureRecognizer:tap2];
    
    
    locationBtnPressedOnce = NO;
    currencyBtnPressedOnce = NO;
    yearBtnPressedOnce = NO;
    
    [self loadDataArray];
    [self loadData];
    //[self addButtonsToXib];
    [self customizeButtonsInXib];
    [self setImagesArray];
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
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Edit Ad screen"];
    [TestFlight passCheckpoint:@"Edit Ad screen"];
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
    CarAd* cardADS;
    int remainingImg = [self.myImageIDArray count];
    for (int i=0; i<6; i++) {
        if ([self.myImageIDArray count] == 0 || remainingImg == 0) {

            UIButton * temp = (UIButton *)[self.iPad_uploadPhotosView viewWithTag:((i+1) *10)];
            [temp setImage:[UIImage imageNamed:@"tb_add_individual3_add_image_btn.png"] forState:UIControlStateNormal];
            
            
        }else{
            cardADS = (CarAd*)[self.myImageIDArray objectAtIndex:i];
            UIButton * temp = (UIButton *)[self.iPad_setPhotoView viewWithTag:((i+1) *10)];
            [temp setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cardADS.ImageURL]]] forState:UIControlStateNormal];
            temp.tag = (i+1) * 10;
            remainingImg-=1;
        }
    }
}

- (void) uploadImage: (id)sender{
    
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

//- (void) addButtonsToXib{
- (void) customizeButtonsInXib {
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
    
    [countryCity setTitle:defaultCityName forState:UIControlStateNormal]; //TODO chosen city
    [countryCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
    [carAdTitle setText:myAdInfo.title]; //TODO ad Title
    
    [carDetails setText:myAdInfo.desc]; //TODO get Description
    
    [carPrice setText:[NSString stringWithFormat:@"%i",(int)myAdInfo.price]]; //TODO get Price
    
    
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

    [mobileNum setText:myAdInfo.mobileNum]; //TODO get mobile number
    
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
    /*
    [UIView animateWithDuration:0.3 animations:^{
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                            [[UIScreen mainScreen] bounds].size.height-self.self.pickersView.frame.size.height,
                                            self.pickersView.frame.size.width,
                                            self.pickersView.frame.size.height);
    }];*/

    [UIView animateWithDuration:0.3f animations:^{
        
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                            508.0f,
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

- (IBAction)chooseProductionYear:(id)sender{
    [self dismissKeyboard];
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

- (IBAction)chooseCurrency:(id)sender{
    [self dismissKeyboard];
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

- (IBAction)chooseCountryCity:(id)sender{
    
    /*
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
     */
    
    NSString *temp= [NSString stringWithFormat:@"%@ :%@", chosenCountry.countryName , chosenCity.cityName];
    [countryCity setTitle:temp forState:UIControlStateNormal];
    locationBtnPressedOnce = YES;
    
    CountryListViewController* vc;
    vc = [[CountryListViewController alloc]initWithNibName:@"CountriesPopOver_iPad" bundle:nil];
    self.iPad_countryPopOver = [[UIPopoverController alloc] initWithContentViewController:vc];
    [self.iPad_countryPopOver setPopoverContentSize:vc.view.frame.size];
    //[self.countryPopOver setPopoverContentSize:CGSizeMake(500, 800)];
    [self dismissKeyboard];
    vc.iPad_parentViewOfPopOver = self;
    //[self.iPad_countryPopOver presentPopoverFromRect:self.countryCity.frame inView:self.countryCity.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
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

- (IBAction)homeBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction) iPad_closeBtnPrss:(id) sender {
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
    /*if (!locationBtnPressedOnce)
    {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار بلد ومدينة مناسبين" delegateVC:self];
        return;
    }
    */
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
    if (!chosenCurrency)
    {
        //check price
        if ( [carPrice.text length] != 0 && ![carPrice.text isEqualToString:@"0"])
        {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار عملة مناسبة" delegateVC:self];
            return;
            
        }
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
    
    if ([distance.text length] == 0) {
        distance.text = @"";
    }
    if ([carPrice.text length] == 0) {
        carPrice.text = @"";
    }
    
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
    
    [[CarAdsManager sharedInstance] editAdOfEditadID:self.myDetails.EncEditID inCountryID:chosenCountry.countryID InCity:chosenCity.cityID userEmail:savedProfile.emailAddress title:carAdTitle.text description:carDetails.text price:carPrice.text periodValueID:AD_PERIOD_2_MONTHS_VALUE_ID mobile:mobileNum.text currencyValueID:chosenCurrency.valueID serviceValueID:SERVICE_FOR_SALE_VALUE_ID modelYearValueID:chosenYear.valueID  distance:distance.text color:@"" phoneNumer:@"" adCommentsEmail:YES kmVSmilesValueID:distanceUnitID nine52:(!myAdInfo.nine52 ? 0 :myAdInfo.nine52) five06:(!myAdInfo.five06 ? 0 :myAdInfo.five06) five02:(!myAdInfo.five02 ? 0 :myAdInfo.five02) nine06:(!myAdInfo.nine06 ? 0 :myAdInfo.nine06) one01:(!myAdInfo.one01 ? 0 :myAdInfo.one01) ninty8:(!myAdInfo.ninty8 ? 0 :myAdInfo.ninty8) imageIDs:currentImgsUploaded withDelegate:self];
    
    
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
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
    [self hideLoadingIndicatorOnImages];
    //if (chosenImgBtnTag > -1)
    //{
        //UIButton * tappedBtn = (UIButton *) [self.iPad_uploadPhotosView viewWithTag:chosenImgBtnTag];
        
        //[tappedBtn setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
    //}
    
    
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

#pragma mark - iPad actions

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

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
        (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
        [self dismissKeyboard];
    
}

@end
