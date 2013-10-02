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
#import "CountryListViewController.h"

@interface AddNewStoreViewController () {
    Store *store;
    
    NSString* myStore;
    NSArray *countryArray;
    NSArray *cityArray;
    City * chosenCity;
    BOOL uploadingLOGO;
    NSString* myURL;
    UIImage *storeImage;
    Country *chosenCountry;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 *loadingHUD;
    MBProgressHUD2 *imgsLoadingHUD;

    BOOL locationBtnPressedOnce;
    BOOL guestCheck;
    IBOutlet UIToolbar *toolBar;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
    BOOL iPad_buyCarSegmentBtnChosen;
    BOOL iPad_addCarSegmentBtnChosen;
    BOOL iPad_browseGalleriesSegmentBtnChosen;
    BOOL iPad_addStoreSegmentBtnChosen;
    
    
}

@end

@implementation AddNewStoreViewController

@synthesize countryCity;

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
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
        [self.passwordField setHidden:YES];
        self.phoneField.frame = CGRectMake(self.phoneField.frame.origin.x, 235, self.phoneField.frame.size.width, self.phoneField.frame.size.height);
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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        //add some padding to textfields
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(self.userPassword.frame.size.width - 20, 0, 5, self.userPassword.frame.size.height)];
        self.nameField.rightView = paddingView1;
        self.nameField.rightViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(self.emailField.frame.size.width - 20, 0, 5, self.emailField.frame.size.height)];
        self.emailField.rightView = paddingView2;
        self.emailField.rightViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(self.passwordField.frame.size.width - 20, 0, 5, self.passwordField.frame.size.height)];
        self.passwordField.rightView = paddingView3;
        self.passwordField.rightViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(self.phoneField.frame.size.width - 20, 0, 5, self.phoneField.frame.size.height)];
        self.phoneField.rightView = paddingView4;
        self.phoneField.rightViewMode = UITextFieldViewModeAlways;
        
        self.descriptionField.layer.cornerRadius = 10.0;
        [self.descriptionField setNeedsDisplay];
    }
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Create store screen"];
    [TestFlight passCheckpoint:@"Create Store screen"];
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)chooseImageBtnPress:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"إلغاء"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"من الكاميرا", @"من مكتبة الصور", nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [as showInView:self.view];
    else { //iPad
        UIButton * senderBtn = (UIButton *) sender;
        [as showFromRect:senderBtn.frame inView:senderBtn animated:YES];
    }
    
}

- (IBAction)chooseCountry:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        self.locationPickerView.hidden = NO;
        [self showPicker];
        [self.locationPickerView reloadAllComponents];
        int selectedCountryIndex = 0;
        if (chosenCountry != nil) {
            selectedCountryIndex = [countryArray indexOfObject:chosenCountry];
        }
        else
        {
            selectedCountryIndex = [countryArray indexOfObject:0];
        }
        [self.locationPickerView selectRow:selectedCountryIndex inComponent:0 animated:YES];
        NSString* temp = [(Country*)[countryArray objectAtIndex:selectedCountryIndex] countryName];
        [self.countryCity setTitle:temp forState:UIControlStateNormal];
        locationBtnPressedOnce = YES;
    }
    else
    {
        CountryListViewController* vc;
        vc = [[CountryListViewController alloc]initWithNibName:@"CountriesPopOver_iPad" bundle:nil];
        self.iPad_countryPopOver = [[UIPopoverController alloc] initWithContentViewController:vc];
        //[self.iPad_countryPopOver setPopoverContentSize:vc.view.frame.size];
        //NSLog(@"w:%f, h:%f", vc.view.frame.size.width, vc.view.frame.size.height);
        [self dismissKeyboard];
        [self.iPad_countryPopOver setPopoverContentSize:CGSizeMake(500, 700)];
        vc.iPad_parentViewOfPopOver = self;
        [self.iPad_countryPopOver presentPopoverFromRect:self.countryCity.frame inView:self.countryCity.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)cancelBtnPress:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneBtnPrss:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self closePicker];
}

- (IBAction)saveBtnPress:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Create store"
                         withValue:[NSNumber numberWithInt:100]];
    
    BOOL notAllDataFilled = [@"" isEqualToString:self.nameField.text] ||
                            [@"" isEqualToString:self.descriptionField.text] ||
                            [@"" isEqualToString:self.emailField.text] ||
                            [@"" isEqualToString:self.phoneField.text];
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
    if (![self validateEmail:self.emailField.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"الرجاء التأكد من إدخال البريد الإلكتروني بشكل صحيح"
                                                       delegate:nil cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (store == nil) {
        store = [[Store alloc] init];
    }
    store.name = self.nameField.text;
    store.desc = self.descriptionField.text;
    store.ownerEmail = self.emailField.text;
    store.phone = self.phoneField.text;
    store.countryID = chosenCountry.countryID;
    store.imageURL = myURL;
    
    UserProfile* savedPofile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedPofile && !guestCheck) { //guest
        //[self PasswordRequire];
        //return;
        store.storePassword = self.passwordField.text;
        guestCheck = YES;
    }else{
        store.storePassword = @"";
    }
    [self showLoadingIndicator];
   
    [StoreManager sharedInstance].delegate = self;
   [[StoreManager sharedInstance] createStore:store];
}

- (IBAction)whatIsStoreBtnPrss:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    WhyFeatureStoreAdViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[WhyFeatureStoreAdViewController alloc] initWithNibName:@"WhyFeatureStoreAdViewController" bundle:nil];
    else
        vc =[[WhyFeatureStoreAdViewController alloc] initWithNibName:@"WhyFeatureStoreAdViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}


-(void)PasswordRequire{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (textField == self.nameField) {
        //[descriptionField becomeFirstResponder];
    }
    else if (textField == self.emailField) {
        //[phoneField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        //[passwordField becomeFirstResponder];
    }
    else {
    
    }
    [self dismissKeyboard];
    [self saveBtnPress:nil];
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    [super textFieldDidBeginEditing:aTextField];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    aTextField.textAlignment = NSTextAlignmentRight;
    [self closePicker];
    
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [super textViewDidBeginEditing:textView];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self closePicker];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
    
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
    }
    else
    {
        textView.textAlignment = NSTextAlignmentRight;
    }
    
//textView.textAlignment=NSTextAlignmentRight;
}



#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (alertView.tag == 5) {
        FeatureStoreAdViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            vc=[[FeatureStoreAdViewController alloc] initWithNibName:@"FeatureStoreAdViewController" bundle:nil];
        }
        else
        {
            vc=[[FeatureStoreAdViewController alloc] initWithNibName:@"FeatureStoreAdViewController_iPad" bundle:nil];
        }
        
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.iPad_cameraPopOver)
        [self.iPad_cameraPopOver dismissPopoverAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    storeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:%f",storeImage.size.width);
    uploadingLOGO = YES;
    //storeImageView.image = storeImage;
    self.storeImageView.image = [GenericMethods imageWithImage:storeImage scaledToSize:self.storeImageView.frame.size];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.storeImageView.layer.masksToBounds = YES;
        self.storeImageView.layer.cornerRadius = 10.0f;
        [self.storeImageView setNeedsDisplay];
    }
    [self showLoadingIndicatorOnImages];
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] uploadLOGO:storeImage];
}

#pragma mark - picker methods

-(void)closePicker
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.pickersView setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                       [[UIScreen mainScreen] bounds].size.height,
                                       self.pickersView.frame.size.width,
                                       self.pickersView.frame.size.height
                                       );
    }];
}

-(void)showPicker
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissKeyboard];
    [self.pickersView setHidden:NO];
    [self.pickersView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickersView.frame = CGRectMake(self.pickersView.frame.origin.x,
                                       [[UIScreen mainScreen] bounds].size.height-self.pickersView.frame.size.height,
                                       self.pickersView.frame.size.width,
                                       self.pickersView.frame.size.height
                                       );
    }];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    chosenCountry=(Country *)[countryArray objectAtIndex:row];
    NSString *temp= chosenCountry.countryName;
    [self.countryCity setTitle:temp forState:UIControlStateNormal];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [countryArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Country *temp=(Country*)[countryArray objectAtIndex:row];
    return temp.countryName;
}
#pragma mark - LocationManagerDelegate Methods

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self hideLoadingIndicator];
    guestCheck = NO;
    if ([[error description] isEqualToString:@"WRONG_PASSWORD"]) {
        [GenericMethods throwAlertWithTitle:@"" message:@"البريد الإلكتروني مسجل لدينا مسبقا يرجى التأكد من كلمة السر" delegateVC:self];
    }else
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
}

- (void) storeCreationDidSucceedWithStoreID:(NSInteger)storeID andUser:(UserProfile *)theUser {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([@"" isEqualToString:textView.text]) {
        //placeholderTextField.placeholder = @"وصف المتجر (نبذة مختصرة)";
    }
    else {
        //placeholderTextField.placeholder = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [super textViewDidEndEditing:textView];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissKeyboard];
}



#pragma mark - Private Methods

-(void)dismissKeyboard {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self closePicker];
    [self.nameField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
            self.view.frame = CGRectMake(0, 0, 320, 568);
        else
            self.view.frame = CGRectMake(0, 0, 320, 480);
    }
}

- (void) showLoadingIndicator {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        loadingHUD.dimBackground = YES;
    }
    else
    {
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    imgsLoadingHUD = [MBProgressHUD2 showHUDAddedTo:self.storeImageView animated:YES];
    imgsLoadingHUD.mode = MBProgressHUDModeCustomView2;
    imgsLoadingHUD.labelText = @"";
    imgsLoadingHUD.detailsLabelText = @"";
    imgsLoadingHUD.dimBackground = NO;
    imgsLoadingHUD.opacity = 0.1;
}

- (void) hideLoadingIndicator {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (imgsLoadingHUD)
        [MBProgressHUD2 hideHUDForView:self.storeImageView  animated:YES];
    imgsLoadingHUD = nil;
    
}

-(void) takePhotoWithCamera {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [self presentViewController:picker animated:YES completion:nil];
        //if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone))
        else
        {
            [self dismissKeyboard];
            self.iPad_cameraPopOver = [[UIPopoverController alloc] initWithContentViewController:picker];
            self.iPad_cameraPopOver.delegate = self;
            [self.iPad_cameraPopOver presentPopoverFromRect:self.iPad_chooseImageBtn.frame inView:self.iPad_chooseImageBtn permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
        }

    }
}


#pragma mark - iPad actions

- (IBAction)iPad_buyCarSegmentBtnPressed:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    iPad_buyCarSegmentBtnChosen = YES;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];

}

- (IBAction)iPad_addCarSegmentBtnPressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = YES;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
}

- (IBAction)iPad_browseGalleriesSegmentBtnPressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = YES;
    iPad_addStoreSegmentBtnChosen = NO;
    
    [self iPad_updateSegmentButtons];
}

- (IBAction)iPad_addStoreSegmentBtnPressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    iPad_buyCarSegmentBtnChosen = NO;
    iPad_addCarSegmentBtnChosen = NO;
    iPad_browseGalleriesSegmentBtnChosen = NO;
    iPad_addStoreSegmentBtnChosen = YES;
    
    [self iPad_updateSegmentButtons];
}

#pragma mark - iPad helper methods
- (void) iPad_updateSegmentButtons {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIImage * iPad_buyCarSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_buy_car_btn_white.png"];
    UIImage * iPad_buyCarSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_buy_car_btn.png"];
    
    UIImage * iPad_addCarSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_sell_car_btn_white.png"];
    UIImage * iPad_addCarSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_sell_car_btn.png"];
    
    UIImage * iPad_browseGalleriesSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_list_exhibition_btn_white.png"];
    UIImage * iPad_browseGalleriesSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_list_exhibition_btn.png"];
    
    UIImage * iPad_addStoreSegmentBtnSelectedImage = [UIImage imageNamed:@"tb_car_brand_open_store_btn_white.png"];
    UIImage * iPad_addStoreSegmentBtnUnselectedImage = [UIImage imageNamed:@"tb_car_brand_open_store_btn.png"];
    
    [self.iPad_buyCarSegmentBtn setBackgroundImage:(iPad_buyCarSegmentBtnChosen ? iPad_buyCarSegmentBtnSelectedImage : iPad_buyCarSegmentBtnUnselectedImage) forState:UIControlStateNormal];
    
    [self.iPad_addCarSegmentBtn setBackgroundImage:(iPad_addCarSegmentBtnChosen ?  iPad_addCarSegmentBtnSelectedImage: iPad_addCarSegmentBtnUnselectedImage) forState:UIControlStateNormal];
    
    [self.iPad_browseGalleriesSegmentBtn setBackgroundImage:(iPad_browseGalleriesSegmentBtnChosen ? iPad_browseGalleriesSegmentBtnSelectedImage :  iPad_browseGalleriesSegmentBtnUnselectedImage) forState:UIControlStateNormal];
    
    [self.iPad_addStoreSegmentBtn setBackgroundImage:(iPad_addStoreSegmentBtnChosen ? iPad_addStoreSegmentBtnSelectedImage : iPad_addStoreSegmentBtnUnselectedImage) forState:UIControlStateNormal];
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

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
            (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
            [self dismissKeyboard];
    }
}

@end

@implementation UIImagePickerController (NonRotating)

- (BOOL)shouldAutorotate
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return UIInterfaceOrientationPortrait;
}


@end
