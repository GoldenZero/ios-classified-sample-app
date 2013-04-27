//
//  AddNewCarAdViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewCarAdViewController.h"
#import "ChooseActionViewController.h"
#import "ModelsViewController.h"

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
    
    MBProgressHUD2 *loadingHUD;
    int chosenImgBtnTag;
    UIImage * currentImageToUpload;
  
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenCurrency;
    SingleValue * chosenYear;
    SingleValue * chosenCity;
    SingleValue * chosenCountry;
    bool kiloChoosen;

    NSTimer *timer;
}

@end

@implementation AddNewCarAdViewController
@synthesize carAdTitle,mobileNum,distance,carDetails,carPrice,countryCity,currency,kiloMile,productionYear;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        globalArray=[[NSArray alloc] init];
        countryArray =[[NSArray alloc] initWithObjects:@"سوريا",@"امارات",@"السعودية", nil];
        cityArray=[[NSArray alloc] initWithObjects:@"دمشق",@"حمص",@"حلب",@"حماه", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the image piacker
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
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
    
    // Set delegates of text fields
    [carAdTitle setDelegate:(id)self];
    [mobileNum setDelegate:(id)self];
    [distance setDelegate:(id)self];
    [carPrice setDelegate:(id)self];
    [carDetails setDelegate:(id)self];
    
    [self loadData];
    [self addButtonsToXib];
    [self setImagesArray];
    [self setImagesToXib];
   
    [self closePicker:self.locationPickerView];
    [self closePicker:self.pickerView];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
}
-(void)indicator:(BOOL)animated{
    
    [self.horizontalScrollView flashScrollIndicators];
 
}
- (void) loadData{
    productionYearArray=[[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadModelYearValues]];
    currencyArray= [[NSArray alloc] initWithArray:[[StaticAttrsLoader sharedInstance] loadCurrencyValues]];
    kiloMileArray=[[NSArray alloc] initWithObjects:@"كم",@"ميل", nil];
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

- (void) setImagesArray{
    
    [self.horizontalScrollView setContentSize:CGSizeMake(640, 119)];
    [self.horizontalScrollView setScrollEnabled:YES];
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:YES];
    
    for (int i=0; i<6; i++) {
        UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(104*i), 20, 77, 70)];
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
    [self showLoadingIndicator];
    [[CarAdsManager sharedInstance] uploadImage:image WithDelegate:self];
}

-(void)dismissKeyboard {
    [self closePicker:self.pickerView];
    [self closePicker:self.locationPickerView];
    [carAdTitle resignFirstResponder];
    [mobileNum resignFirstResponder];
    [carPrice resignFirstResponder];
    [distance resignFirstResponder];
    [carDetails resignFirstResponder];
}


- (void) addButtonsToXib{
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 420)];
    [self.verticalScrollView setScrollEnabled:YES];
    [self.verticalScrollView setShowsVerticalScrollIndicator:YES];
    
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
    [carAdTitle setKeyboardType:UIKeyboardTypeAlphabet];
    [self.verticalScrollView addSubview:carAdTitle];
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,100 ,260 ,80 )];
    [carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [self.verticalScrollView addSubview:carDetails];

    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(130,190 ,160 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر"];
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 190, 80, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [currency setTitle:@"العملة" forState:UIControlStateNormal];
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];

    distance=[[UITextField alloc] initWithFrame:CGRectMake(130,240 ,160 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة"];
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];

    kiloMile = [[UISegmentedControl alloc] initWithItems:kiloMileArray];
    kiloMile.frame = CGRectMake(30, 240, 80, 30);
    kiloMile.segmentedControlStyle = UISegmentedControlStylePlain;
    kiloMile.selectedSegmentIndex = 2;
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents: UIControlEventValueChanged];
    [self.verticalScrollView addSubview:kiloMile];
    
    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 280, 260, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:@"عام الصنع" forState:UIControlStateNormal];
    [productionYear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [productionYear addTarget:self action:@selector(chooseProductionYear) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:productionYear];


    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,320 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    

       
}

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
    
}

- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
}

- (void) postTheAd {
    //call the post ad back end method
}


#pragma mark - picker methods

-(IBAction)closePicker:(id)sender
{
    if (sender==_locationPickerView) {
        [self.locationPickerView setHidden:YES];
        [UIView animateWithDuration:0.3 animations:^{
            _locationPickerView.frame = CGRectMake(_locationPickerView.frame.origin.x,
                                                   [[UIScreen mainScreen] bounds].size.height,
                                                   _locationPickerView.frame.size.width,
                                                   _locationPickerView.frame.size.height);
        }];
        
    }
    else {
        [self.pickerView setHidden:YES];
        [UIView animateWithDuration:0.3 animations:^{
            _pickerView.frame = CGRectMake(_pickerView.frame.origin.x,
                                           [[UIScreen mainScreen] bounds].size.height,
                                           _pickerView.frame.size.width,
                                           _pickerView.frame.size.height);
        }];
    }
    

}

-(IBAction)showPicker:(id)sender
{
    if (sender==_locationPickerView) {
        [self.locationPickerView setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            _locationPickerView.frame = CGRectMake(_locationPickerView.frame.origin.x,
                                           [[UIScreen mainScreen] bounds].size.height-self.locationPickerView.frame.size.height,
                                           _locationPickerView.frame.size.width,
                                           _locationPickerView.frame.size.height);
        }];

    }
    else {
        [self.pickerView setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            _pickerView.frame = CGRectMake(_pickerView.frame.origin.x,
                                           [[UIScreen mainScreen] bounds].size.height-self.locationPickerView.frame.size.height,
                                           _pickerView.frame.size.width,
                                           _pickerView.frame.size.height);
        }];
    }

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
            NSString *choosen=[countryArray objectAtIndex:row];
           // SET cities array
            [countryCity setTitle:choosen forState:UIControlStateNormal];
            [pickerView reloadAllComponents];
        }
        else{
            NSString *choosen=[cityArray objectAtIndex:row];
            [countryCity setTitle:choosen forState:UIControlStateNormal];
            [pickerView reloadAllComponents];
        }

    }

    else {
        NSString *choosen=[globalArray objectAtIndex:row];
        if ([currencyArray containsObject:choosen]) {
            chosenCurrency=[globalArray objectAtIndex:row];
            [currency setTitle:choosen forState:UIControlStateNormal];
        }
        else if ([productionYearArray containsObject:choosen]) {
            chosenYear=[globalArray objectAtIndex:row];
            [productionYear setTitle:choosen forState:UIControlStateNormal];
        }
    }

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (pickerView==_locationPickerView) {
        if (component==0) {
            return [countryArray objectAtIndex:row];
        }
        else{
            return [cityArray objectAtIndex:row];
        }
    }
    else {
        return [globalArray objectAtIndex:row];
    }
    
    
}

#pragma mark - Buttons Actions


- (void) chooseProductionYear{
    [self showPicker:self.pickerView];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    // fill picker with production year
    globalArray=productionYearArray;
    
    [self.pickerView reloadAllComponents];
}

- (void) chooseCurrency{
    [self showPicker:self.pickerView];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    // fill picker with currency options
    globalArray=currencyArray;
    
    [self.pickerView reloadAllComponents];
}

- (void) chooseCountryCity{
    [self showPicker:self.locationPickerView];
    [self.locationPickerView selectRow:0 inComponent:0 animated:YES];
    
    [self.locationPickerView reloadAllComponents];

    
}

- (void) chooseKiloMile{
    if (kiloMile.selectedSegmentIndex==2) {
        kiloChoosen=true;
    }
    else if (kiloMile.selectedSegmentIndex==1){
        
        kiloChoosen=false;
    }

}

- (IBAction)homeBtnPrss:(id)sender {
    ChooseActionViewController *vc=[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)addBtnprss:(id)sender {
    
    // CODE TODO for Roula
    // Variables are:
    //    kiloChoosen: bool;
    //    chosenCity : SingleValue;
    //    chosenCountry : SingleValue;
    //    chosenCurrency : SingleValue;
    //    chosenYear : SingleValue;
    //    carAdTitle :UITextField;
    //    carDetails : UITextView;
    //    distance : UITextField;
    //    mobileNum :UITextField;
    //    carPrice : UITextField;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (IBAction)selectModelBtnPrss:(id)sender {
    ModelsViewController *vc=[[ModelsViewController alloc] initWithNibName:@"ModelsViewController" bundle:nil];
    vc.tagOfCallXib=2;
    [self presentViewController:vc animated:YES completion:nil];

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
    
    [self useImage:img];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - iploadImage Delegate

- (void) imageDidFailUploadingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
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
    
    [self hideLoadingIndicator];
    
    //1- show the image on the button
    if ((chosenImgBtnTag > -1) && (currentImageToUpload))
    {
        UIButton * tappedBtn = (UIButton *) [self.horizontalScrollView viewWithTag:chosenImgBtnTag];
        [tappedBtn setImage:currentImageToUpload forState:UIControlStateNormal];
    }
    //2- add image data to this ad
    
    //reset 'current' data
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;

}


#pragma mark - PostAd Delegate
- (void) adDidFailPostingWithError:(NSError *)error {
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
}

- (void) adDidFinishPostingWithAdID:(NSInteger)adID {
    
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:@"تمت إضافة إعلانك بنجاج" delegateVC:self];
    
}
@end
