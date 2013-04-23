//
//  AddNewCarAdViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewCarAdViewController.h"
#import "ChooseActionViewController.h"

@interface AddNewCarAdViewController (){
    IBOutlet  UITextField *carAdTitle;
    IBOutlet  UITextField *mobileNum;
    IBOutlet  UITextField *phoneNum;
    IBOutlet  UITextField *externalColor;
    IBOutlet  UITextField *distance;
    IBOutlet  UITextField *carPrice;
    IBOutlet  UITextView *carDetails;
    IBOutlet  UIButton *serviceKind;
    IBOutlet  UIButton *adPeriod;
    IBOutlet  UIButton *productionYear;
    IBOutlet  UIButton *currency;
    IBOutlet  UIButton *receiveMail;
    IBOutlet  UIButton *kiloMile;
    
    UITapGestureRecognizer *tap;
    
    // Arrays
    NSArray *globalArray;
    NSArray *currencyArray;
    NSArray *adPeriodArray;
    NSArray *serviceKindArray;
    NSArray *kiloMileArray;
    
    NSArray *productionYearArray;
    
    MBProgressHUD2 *loadingHUD;
    int chosenImgBtnTag;
    UIImage * currentImageToUpload;
    
    //These objects should be set bt selecting the drop down menus.
    SingleValue * chosenPeriod;
    SingleValue * chosenCurrency;
    SingleValue * chosenKmVSmile;
    SingleValue * chosenService;
    SingleValue * chosenYear;
    
    bool recievMail;
}

@end

@implementation AddNewCarAdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        globalArray=[[NSArray alloc] init];
        currencyArray =[[NSArray alloc] initWithObjects:@"ريال",@"درهم",@"جنيه",@"دولار",@"يورو",@"دينار",@"ليرة",@"شيكل", nil];
        adPeriodArray =[[NSArray alloc] initWithObjects:@"١٤ يوم",@"١ شهر",@"٢ شهر", nil];
        serviceKindArray=[[NSArray alloc] initWithObjects:@"معروض للبيع",@"مطلوب للشراء",@"ايجار",@"تقسيط", nil];
        kiloMileArray=[[NSArray alloc] initWithObjects:@"كم",@"ميل", nil]; 
        productionYearArray=[[NSArray alloc] initWithObjects:@"٢٠١٢",@"٢٠١١",@"٢٠١٠",@"٢٠٠٠", nil];
        receiveMail=false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chosenImgBtnTag = -1;
    currentImageToUpload = nil;
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.verticalScrollView addGestureRecognizer:tap];
    [self.horizontalScrollView addGestureRecognizer:tap];
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];

    [carAdTitle setDelegate:(id)self];
    [mobileNum setDelegate:(id)self];
    [phoneNum setDelegate:(id)self];
    [externalColor setDelegate:(id)self];
    [distance setDelegate:(id)self];
    [carPrice setDelegate:(id)self];
    [carDetails setDelegate:(id)self];
    
    [self addButtonsToXib];
    [self setImagesArray];
    [self setImagesToXib];
    [self closePicker:self.pickerView];
    
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
    
    [self.horizontalScrollView setContentSize:CGSizeMake(960, 119)];
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
    [carAdTitle resignFirstResponder];
    [phoneNum resignFirstResponder];
    [mobileNum resignFirstResponder];
    [carPrice resignFirstResponder];
    [externalColor resignFirstResponder];
    [distance resignFirstResponder];
    [carDetails resignFirstResponder];
}



- (void) addButtonsToXib{
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 460)];
    [self.verticalScrollView setScrollEnabled:YES];
    [self.verticalScrollView setShowsHorizontalScrollIndicator:YES];
    
    carAdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30,20 ,260 ,30)];
    [carAdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [carAdTitle setTextAlignment:NSTextAlignmentRight];
    [carAdTitle setPlaceholder:@"عنوان الإعلان"];
    [carAdTitle setKeyboardType:UIKeyboardTypeAlphabet];
    [self.verticalScrollView addSubview:carAdTitle];
    
    phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(30,96 ,260 ,30)];
    [phoneNum setBorderStyle:UITextBorderStyleRoundedRect];
    [phoneNum setTextAlignment:NSTextAlignmentRight];
    [phoneNum setPlaceholder:@"رقم الهاتف"];
    [phoneNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:phoneNum];
    
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,134 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [mobileNum setKeyboardType:UIKeyboardTypePhonePad];
    [self.verticalScrollView addSubview:mobileNum];
    
    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(170,271 ,120 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر"];
    [carPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:carPrice];
    
    externalColor=[[UITextField alloc] initWithFrame:CGRectMake(170,348 ,120 ,30)];
    [externalColor setBorderStyle:UITextBorderStyleRoundedRect];
    [externalColor setTextAlignment:NSTextAlignmentRight];
    [externalColor setPlaceholder:@"اللون الخارجي"];
    [externalColor setKeyboardType:UIKeyboardTypeAlphabet];
    [self.verticalScrollView addSubview:externalColor];
    
    distance=[[UITextField alloc] initWithFrame:CGRectMake(170,310 ,120 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة"];
    [distance setKeyboardType:UIKeyboardTypeNumberPad];
    [self.verticalScrollView addSubview:distance];
    
    serviceKind =[[UIButton alloc] initWithFrame:CGRectMake(170, 58, 120, 30)];
    [serviceKind setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [serviceKind setTitle:@"الخدمة المطلوبة" forState:UIControlStateNormal];
    [serviceKind setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [serviceKind addTarget:self action:@selector(chooseServiceKind) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:serviceKind];
    
    adPeriod =[[UIButton alloc] initWithFrame:CGRectMake(30, 58, 120, 30)];
    [adPeriod setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [adPeriod setTitle:@"فترة الإعلان" forState:UIControlStateNormal];
    [adPeriod setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [adPeriod addTarget:self action:@selector(chooseAdPeriod) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:adPeriod];

    
    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 348, 120, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:@"عام الصنع" forState:UIControlStateNormal];
    [productionYear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [productionYear addTarget:self action:@selector(chooseProductionYear) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:productionYear];

    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 271, 120, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [currency setTitle:@"العملة" forState:UIControlStateNormal];
    [currency addTarget:self action:@selector(chooseCurrency) forControlEvents:UIControlEventTouchUpInside];
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];

    receiveMail =[[UIButton alloc] initWithFrame:CGRectMake(44, 390, 229, 46)];
    [receiveMail setBackgroundImage:[UIImage imageNamed: @"AddCar_check_gray.png"] forState:UIControlStateNormal];
    [receiveMail addTarget:self action:@selector(chooseReceiveMail) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:receiveMail];

    kiloMile =[[UIButton alloc] initWithFrame:CGRectMake(30, 310, 120, 30)];
    [kiloMile setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [kiloMile setTitle:@"كم/ميل" forState:UIControlStateNormal];
    [kiloMile setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [kiloMile addTarget:self action:@selector(chooseKiloMile) forControlEvents:UIControlEventTouchUpInside];
    [self.verticalScrollView addSubview:kiloMile];
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,178 ,260 ,85 )];
    [carDetails setTextAlignment:NSTextAlignmentRight];
    [carDetails setKeyboardType:UIKeyboardTypeDefault];
    [self.verticalScrollView addSubview:carDetails];
    
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
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.frame = CGRectMake(_pickerView.frame.origin.x,
                                       480, 
                                       _pickerView.frame.size.width,
                                       _pickerView.frame.size.height);
    }];
}

-(IBAction)showPicker:(id)sender
{
    [self.pickerView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.frame = CGRectMake(_pickerView.frame.origin.x,
                                       280,
                                       _pickerView.frame.size.width,
                                       _pickerView.frame.size.height);
    }];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *choosen=[globalArray objectAtIndex:row];
    if ([currencyArray containsObject:choosen]) {
        [currency setTitle:choosen forState:UIControlStateNormal];
    }
    else if ([adPeriodArray containsObject:choosen]) {
        [adPeriod setTitle:choosen forState:UIControlStateNormal];
    }
    else if ([serviceKindArray containsObject:choosen]) {
        [serviceKind  setTitle:choosen forState:UIControlStateNormal];
    }
    else if ([kiloMileArray containsObject:choosen]) {
        [kiloMile setTitle:choosen forState:UIControlStateNormal];
    }

    else if ([productionYearArray containsObject:choosen]) {
        [productionYear setTitle:choosen forState:UIControlStateNormal];
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [globalArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [globalArray objectAtIndex:row];
}

#pragma mark - Buttons Actions

- (void) chooseServiceKind{
    [self showPicker:self.pickerView];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    // fill picker with service options
    globalArray=serviceKindArray;
    
    [self.pickerView reloadAllComponents];
}

- (void) chooseAdPeriod{
    [self showPicker:self.pickerView];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    // fill picker with period of ad options
    globalArray= adPeriodArray;
    
    [self.pickerView reloadAllComponents];
}

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

- (void) chooseReceiveMail{
    if(recievMail==false){
        [receiveMail setBackgroundImage:[UIImage imageNamed: @"AddCar_check.png"] forState:UIControlStateNormal];
        recievMail=true;
        
    }
    else{
        [receiveMail setBackgroundImage:[UIImage imageNamed: @"AddCar_check_gray.png"] forState:UIControlStateNormal];
        recievMail=false;
    }
   
}

- (void) chooseKiloMile{
    [self showPicker:self.pickerView];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    // fill picker with distance options
    globalArray=kiloMileArray;
    [self.pickerView reloadAllComponents];
}

- (IBAction)homeBtnPrss:(id)sender {
    ChooseActionViewController *vc=[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)addBtnprss:(id)sender {
    
    // Add current Ad to the user's add
    // CODE HERE
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
