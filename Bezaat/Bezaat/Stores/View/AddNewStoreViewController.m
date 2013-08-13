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
#import "WhyFeatureStoreAdViewController.h"

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
    IBOutlet UITextField *passwordField;
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
    
    self.inputAccessoryView = [XCDFormInputAccessoryView new];
    
    UserProfile* currentUser = [[SharedUser sharedInstance] getUserProfileData];
    
    uploadingLOGO = NO;
    locationBtnPressedOnce = NO;
    guestCheck = NO;
     if ([[UIScreen mainScreen] bounds].size.height == 568){
         self.mainScrollView.frame = CGRectMake(self.mainScrollView.frame.origin.x, self.mainScrollView.frame.origin.y, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height + 40);
         if (!currentUser) {
            self.mainScrollView.frame = CGRectMake(self.mainScrollView.frame.origin.x, self.mainScrollView.frame.origin.y, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height + 60);
         }
     }
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
    self.mainScrollView.contentSize = CGSizeMake(278, 418);
    
    if (currentUser) {
        [passwordField setHidden:YES];
        phoneField.frame = CGRectMake(phoneField.frame.origin.x, 235, phoneField.frame.size.width, phoneField.frame.size.height);
        //self.countryCity.frame = CGRectMake(self.countryCity.frame.origin.x, 235, self.countryCity.frame.size.width, self.countryCity.frame.size.height);
        self.saveBtn.frame = CGRectMake(self.saveBtn.frame.origin.x, 273, self.saveBtn.frame.size.width, self.saveBtn.frame.size.height);
        self.cancelBtn.frame = CGRectMake(self.cancelBtn.frame.origin.x, 273, self.cancelBtn.frame.size.width, self.cancelBtn.frame.size.height);
        self.whatIsStoreBtn.frame = CGRectMake(self.whatIsStoreBtn.frame.origin.x, 313, self.whatIsStoreBtn.frame.size.width, self.whatIsStoreBtn.frame.size.height);
        self.whatIsStoreImg.frame = CGRectMake(self.whatIsStoreImg.frame.origin.x, 321, self.whatIsStoreImg.frame.size.width, self.whatIsStoreImg.frame.size.height);
       self.mainScrollView.contentSize = CGSizeMake(278, 388);
        
    }
    
    
   
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    loadingHUD = [[MBProgressHUD2 alloc] init];
    [self showLoadingIndicator];
    [[LocationManager sharedInstance] loadCountriesAndCitiesWithDelegate:self];
    chosenCountry = (Country*)[countryArray objectAtIndex:0];
    [self closePicker];
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Create store screen"];
    //end GA
    
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
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Create store"
                         withValue:[NSNumber numberWithInt:100]];
    
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
    if (!savedPofile && !guestCheck) { //guest
        //[self PasswordRequire];
        //return;
        store.storePassword = passwordField.text;
        guestCheck = YES;
    }else{
        store.storePassword = @"";
    }
    [self showLoadingIndicator];
   
    [StoreManager sharedInstance].delegate = self;
   [[StoreManager sharedInstance] createStore:store];
}

- (IBAction)whatIsStoreBtnPrss:(id)sender {
    WhyFeatureStoreAdViewController *vc=[[WhyFeatureStoreAdViewController alloc] initWithNibName:@"WhyFeatureStoreAdViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
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
        //[descriptionField becomeFirstResponder];
    }
    else if (textField == emailField) {
        //[phoneField becomeFirstResponder];
    }
    else if (textField == passwordField) {
        //[passwordField becomeFirstResponder];
    }
    else {
        [self dismissKeyboard];
        [self saveBtnPress:nil];
    }
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.textAlignment = NSTextAlignmentRight;
    [self closePicker];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self closePicker];
    if ([[UIScreen mainScreen] bounds].size.height == 568)
        self.view.frame = CGRectMake(0, -100, 320, 568);
    else
        self.view.frame = CGRectMake(0, -100, 320, 480);
    
    if (!textView.editable && [textView baseWritingDirectionForPosition:[textView beginningOfDocument] inDirection:UITextStorageDirectionForward] == UITextWritingDirectionRightToLeft) {
        // if yes, set text alignment right
        textView.textAlignment = NSTextAlignmentRight;
    } else {
        // for all other cases, set text alignment left
        textView.textAlignment = NSTextAlignmentLeft;
    }
//textView.textAlignment=NSTextAlignmentRight;
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
    //NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:%f",storeImage.size.width);
    uploadingLOGO = YES;
    //storeImageView.image = storeImage;
    storeImageView.image = [GenericMethods imageWithImage:storeImage scaledToSize:storeImageView.frame.size];
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
    if ([[error description] isEqualToString:@"WRONG_PASSWORD"]) {
        [GenericMethods throwAlertWithTitle:@"" message:@"البريد الإلكتروني مسجل لدينا مسبقا يرجى التأكد من كلمة السر" delegateVC:self];
    }else
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
        //placeholderTextField.placeholder = @"وصف المتجر (نبذة مختصرة)";
    }
    else {
        //placeholderTextField.placeholder = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self dismissKeyboard];
}



#pragma mark - Private Methods

-(void)dismissKeyboard {
    
    [self closePicker];
    [nameField resignFirstResponder];
    [descriptionField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneField resignFirstResponder];
    [passwordField resignFirstResponder];
    if ([[UIScreen mainScreen] bounds].size.height == 568)
        self.view.frame = CGRectMake(0, 0, 320, 568);
    else
        self.view.frame = CGRectMake(0, 0, 320, 480);
}

- (void) showLoadingIndicator {
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        loadingHUD.dimBackground = YES;
    else
        loadingHUD.dimBackground = NO;
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
