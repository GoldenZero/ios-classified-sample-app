//
//  AddNewStoreViewController.m
//  Bezaat
//
//  Created by Alaa Al-Zaibak on 4/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewStoreViewController.h"
#import "ChooseActionViewController.h"
#import "SignInViewController.h"
#import "FeatureStoreAdViewController.h"

@interface AddNewStoreViewController () {
    Store *store;
    
    NSString* myStore;
    
    BOOL uploadingLOGO;
    NSString* myURL;
    UIImage *storeImage;
    Country *chosenCountry;
    NSArray *countryArray;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;

    BOOL locationBtnPressedOnce;
    BOOL guestCheck;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIImageView *storeImageView;
    IBOutlet UITextField *nameField;
    IBOutlet UITextView *descriptionField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *phoneField;
    IBOutlet UITextField *placeholderTextField;
    IBOutlet UIPickerView *locationPickerView;
    IBOutlet UIView *pickersView;
}

@end

@implementation AddNewStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    uploadingLOGO = NO;
    locationBtnPressedOnce = NO;
    guestCheck = NO;
    
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    CGRect frame = placeholderTextField.frame;
    frame.size.height = descriptionField.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"وصف المتجر (نبذة مختصرة)";
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    loadingHUD = [[MBProgressHUD2 alloc] init];
    [self showLoadingIndicator];
    [[LocationManager sharedInstance] loadCountriesAndCitiesWithDelegate:self];
    chosenCountry = (Country*)[countryArray objectAtIndex:0];
    [self closePicker];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
      
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)homeBtnPress:(id)sender {
//    ChooseActionViewController *homeVC=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
//    [self presentViewController:homeVC animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseImageBtnPress:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"إلغاء"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"من الكاميرا", @"من مكتبة الصور", nil];
    
    [as showInView:self.view];
}

- (IBAction)chooseCountry:(id)sender {
    locationPickerView.hidden = NO;
   
    [self showPicker];
    [locationPickerView reloadAllComponents];
    int selectedCountryIndex = 0;
    if (chosenCountry != nil) {
        selectedCountryIndex = [countryArray indexOfObject:chosenCountry];
    }else{
       selectedCountryIndex = [countryArray indexOfObject:0];
    }
    [locationPickerView selectRow:selectedCountryIndex inComponent:0 animated:YES];
    NSString* temp = [(Country*)[countryArray objectAtIndex:selectedCountryIndex] countryName];
    [self.countryCity setTitle:temp forState:UIControlStateNormal];
    locationBtnPressedOnce = YES;

}

- (IBAction)cancelBtnPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneBtnPrss:(id)sender {
    [self closePicker];
}

- (IBAction)saveBtnPress:(id)sender {
    BOOL notAllDataFilled = [@"" isEqualToString:nameField.text] ||
                            [@"" isEqualToString:descriptionField.text] ||
                            [@"" isEqualToString:emailField.text] ||
                            [@"" isEqualToString:phoneField.text];
    if (notAllDataFilled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"معلومات ناقصة!"
                                                        message:@"لم يتم إدخال أحد الحقول."
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
        if (!locationBtnPressedOnce)
        {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"الرجاء اختيار مدينة مناسبة" delegateVC:self];
            return;
        }
    
    if (!uploadingLOGO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"يجب ان يتم تحميل صورة"
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![self validateEmail:emailField.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من إدخال البريد الإلكتروني بشكل صحيح"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (store == nil) {
        store = [[Store alloc] init];
    }
    store.name = nameField.text;
    store.desc = descriptionField.text;
    store.ownerEmail = emailField.text;
    store.phone = phoneField.text;
    store.countryID = chosenCountry.countryID;
    store.imageURL = myURL;
    
    UserProfile* savedPofile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedPofile && !guestCheck) {
        [self PasswordRequire];
        return;
    }else{
        store.storePassword = @"";
    }
    [self showLoadingIndicator];
   
    [StoreManager sharedInstance].delegate = self;
   [[StoreManager sharedInstance] createStore:store];
}


-(void)PasswordRequire{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"الرجاء تزويدنا بكلمة سر"
                                                    message:@"\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:@"إلغاء", nil];
    
    self.userPassword = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, 260, 25)];
    [self.userPassword setBackgroundColor:[UIColor whiteColor]];
    [self.userPassword setTextAlignment:NSTextAlignmentCenter];
    self.userPassword.keyboardType = UIKeyboardTypeEmailAddress;
    self.userPassword.secureTextEntry = YES;
    
    [alert addSubview:self.userPassword];
    
    // show the dialog box
    alert.tag = 4;
    [alert show];
    
    // set cursor and show keyboard
    [self.userPassword becomeFirstResponder];
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([@"من الكاميرا" isEqualToString:buttonTitle]) {
        [self takePhotoWithCamera];
    }
    else if ([@"من مكتبة الصور" isEqualToString:buttonTitle]) {
        [self selectPhotoFromLibrary];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == nameField) {
        [descriptionField becomeFirstResponder];
    }
    else if (textField == emailField) {
        [phoneField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [self saveBtnPress:nil];
    }
    return NO;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 5) {
        FeatureStoreAdViewController *vc=[[FeatureStoreAdViewController alloc] initWithNibName:@"FeatureStoreAdViewController" bundle:nil];
        //vc.currentAdID = adID;
        vc.storeID = store;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (alertView.tag == 4){
        if (buttonIndex == 0) {
        store.storePassword = self.userPassword.text;
        guestCheck = YES;
        [StoreManager sharedInstance].delegate = self;
        [[StoreManager sharedInstance] createStore:store];
        }else if (buttonIndex == 1){
            alertView.hidden = YES;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    storeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:%f",storeImage.size.width);
    uploadingLOGO = YES;
    storeImageView.image = storeImage;
    [self showLoadingIndicatorOnImages];
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] uploadLOGO:storeImage];
}

#pragma mark - picker methods

-(void)closePicker
{
    [pickersView setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        pickersView.frame = CGRectMake(pickersView.frame.origin.x,
                                       [[UIScreen mainScreen] bounds].size.height,
                                       pickersView.frame.size.width,
                                       pickersView.frame.size.height
                                       );
    }];
}

-(void)showPicker
{
    [self dismissKeyboard];
    [pickersView setHidden:NO];
    [pickersView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        pickersView.frame = CGRectMake(pickersView.frame.origin.x,
                                       [[UIScreen mainScreen] bounds].size.height-pickersView.frame.size.height,
                                       pickersView.frame.size.width,
                                       pickersView.frame.size.height
                                       );
    }];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    chosenCountry=(Country *)[countryArray objectAtIndex:row];
    NSString *temp= chosenCountry.countryName;
    [self.countryCity setTitle:temp forState:UIControlStateNormal];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [countryArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Country *temp=(Country*)[countryArray objectAtIndex:row];
    return temp.countryName;
}
#pragma mark - LocationManagerDelegate Methods

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countryArray=resultArray;
    [self hideLoadingIndicator];
    
    // Setting default country
    //defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    int defaultIndex = [[LocationManager sharedInstance] getIndexOfCountry:[[SharedUser sharedInstance] getUserCountryID]];
    if  (defaultIndex!= -1){
        chosenCountry =[countryArray objectAtIndex:defaultIndex];//set initial chosen country
    }
}

#pragma mark - StoreManagerDelegate

- (void) storeCreationDidFailWithError:(NSError *)error {
    [self hideLoadingIndicator];
    guestCheck = NO;
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
}

- (void) storeCreationDidSucceedWithStoreID:(NSInteger)storeID andUser:(UserProfile *)theUser {
    [self hideLoadingIndicator];
   // myStore = storeID;
    store.identifier = storeID;
    UserProfile* newUser = theUser;
    //save user's data
    [[ProfileManager sharedInstance] storeUserProfile:newUser];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"شكرا"
                                                    message:@"لقد تم انشاء المتجر"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    alert.tag = 5;
    [alert show];
}

- (void) storeLOGOUploadDidFailWithError:(NSError *)error {
    [self hideLoadingIndicatorOnImages];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تحميل الصورة"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    uploadingLOGO = NO;
}

- (void) storeLOGOUploadDidSucceedWithImageURL:(NSString *)imageURL {
   store.imageURL = imageURL;
    NSLog(@"%@",store.imageURL);
    myURL = imageURL;
    /*
    if (store == nil) {
        store = [[Store alloc] init];
    }
    store.imageURL = imageURL;
    if (imageURL != nil) {
        NSURL *_imageURL = [NSURL URLWithString:imageURL];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:_imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                storeImageView.image = [UIImage imageWithData:imageData];
                [storeImageView setNeedsDisplay];
            });
        });
    }*/
    [self hideLoadingIndicatorOnImages];
    uploadingLOGO = YES;
}

#pragma mark -

- (void)textViewDidChange:(UITextView *)textView {
    if ([@"" isEqualToString:textView.text]) {
        placeholderTextField.placeholder = @"وصف المتجر (نبذة مختصرة)";
    }
    else {
        placeholderTextField.placeholder = @"";
    }
}

#pragma mark - Private Methods

-(void)dismissKeyboard {
    [self closePicker];
    [nameField resignFirstResponder];
    [descriptionField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneField resignFirstResponder];
}

- (void) showLoadingIndicator {
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
}
- (void) showLoadingIndicatorOnImages {
    imgsLoadingHUD = [MBProgressHUD2 showHUDAddedTo:storeImageView animated:YES];
    imgsLoadingHUD.mode = MBProgressHUDModeCustomView2;
    imgsLoadingHUD.labelText = @"";
    imgsLoadingHUD.detailsLabelText = @"";
    imgsLoadingHUD.dimBackground = NO;
    imgsLoadingHUD.opacity = 0.1;
}

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
}
- (void) hideLoadingIndicatorOnImages {
    
    if (imgsLoadingHUD)
        [MBProgressHUD2 hideHUDForView:storeImageView  animated:YES];
    imgsLoadingHUD = nil;
    
}

-(void) takePhotoWithCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void) selectPhotoFromLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

@end

@implementation UIImagePickerController (NonRotating)

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



@end
