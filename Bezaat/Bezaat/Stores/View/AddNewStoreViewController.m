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

@interface AddNewStoreViewController () {
    Store *store;
    
    BOOL uploadingLOGO;
    UIImage *storeImage;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 *loadingHUD;
    
    IBOutlet UIImageView *storeImageView;
    IBOutlet UITextField *nameField;
    IBOutlet UITextView *descriptionField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *phoneField;
    IBOutlet UITextField *placeholderTextField;
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
    CGRect frame = placeholderTextField.frame;
    frame.size.height = descriptionField.frame.size.height;
    placeholderTextField.frame = frame;
    placeholderTextField.placeholder = @"وصف المتجر (نبذة مختصرة)";
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    loadingHUD = [[MBProgressHUD2 alloc] init];
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
    ChooseActionViewController *homeVC=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:homeVC animated:YES completion:nil];
}

- (IBAction)chooseImageBtnPress:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)cancelBtnPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    store.countryID =   [[LocationManager sharedInstance] getSavedUserCountryID];
    
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] createStore:store];
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

#pragma mark - StoreManagerDelegate
- (void) storeCreationDidFailWithError:(NSError *)error {
    [self hideLoadingIndicator];
}

- (void) storeCreationDidSucceedWithStoreID:(NSString *)storeID {
    [self hideLoadingIndicator];
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
