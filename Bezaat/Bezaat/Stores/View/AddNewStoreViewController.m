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
    UIImage *storeImage;
    Country *chosenCountry;
    NSArray *countryArray;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 *loadingHUD;
    
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
    // Do any additional setup after loading the view from its nib.
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
    [self closePicker];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (savedProfile == nil) {
        // goto login view
        if ([[UIScreen mainScreen] bounds].size.height == 568){
        SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController5" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
        }else {
            SignInViewController *vc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
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
    [self showPicker];
    [locationPickerView reloadAllComponents];
    int selectedCountryIndex = 0;
    if (chosenCountry != nil) {
        selectedCountryIndex = [countryArray indexOfObject:chosenCountry];
    }
    [locationPickerView selectRow:selectedCountryIndex inComponent:0 animated:YES];
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
    if (uploadingLOGO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"هل أنت متأكد من حفظ المتجر بدون صورة؟"
                                                       delegate:self
                                              cancelButtonTitle:@"لا"
                                              otherButtonTitles:@"نعم", nil];
        [alert show];
        return;
    }
    
    [self showLoadingIndicator];
    if (store == nil) {
        store = [[Store alloc] init];
    }
    store.name = nameField.text;
    store.desc = descriptionField.text;
    store.ownerEmail = emailField.text;
    store.phone = phoneField.text;
    store.countryID = chosenCountry.countryID;
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] createStore:store];
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
        vc.storeID = myStore;
        [self presentViewController:vc animated:YES completion:nil];
    }
    NSLog(@"buttonIndex:%d",buttonIndex);
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    storeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:%f",storeImage.size.width);
    uploadingLOGO = YES;

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
}

- (void) storeCreationDidSucceedWithStoreID:(NSString *)storeID {
    [self hideLoadingIndicator];
    myStore = storeID;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"شكرا"
                                                    message:@"لقد تم انشاء المتجر"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    alert.tag = 5;
    [alert show];
}

- (void) storeLOGOUploadDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تحميل الصورة"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    uploadingLOGO = NO;
}

- (void) storeLOGOUploadDidSucceedWithImageURL:(NSString *)imageURL {
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
    }
    
    uploadingLOGO = NO;
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

- (void) hideLoadingIndicator {
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
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
