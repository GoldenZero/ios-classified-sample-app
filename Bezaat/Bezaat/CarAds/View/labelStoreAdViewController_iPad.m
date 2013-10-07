//
//  labelStoreAdViewController_iPad.m
//  Bezaat
//
//  Created by Noor Alssarraj on 4/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "labelStoreAdViewController_iPad.h"
#import "labelAdCell.h"
#import "whylabelAdViewController.h"
#import "BankInfoViewController.h"
#import "CarAdDetailsViewController.h"
@interface labelStoreAdViewController_iPad ()
{
    //NSArray * productsArr;
    NSString *checkedImageName;
    NSString *unCheckedImageName;
    int choosenCell;
    
    MBProgressHUD2 * loadingHUD;
    //NSArray * pricingOptions;
    NSArray * options;
    //NSString * currentOrderID;
    //NSString * currentProductID;
    //PricingOption * chosenPricingOption;
    int featureDays;
    StoreManager * advFeatureManager;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}
@end

@implementation labelStoreAdViewController_iPad
@synthesize currentAdID, currentAdHasImages;
@synthesize laterBtn, nowBtn, parentNewCarVC;

static NSString * product_id_form = @"com.bezaat.cars.c.%i";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       checkedImageName=@"publish_check_ok.png";
       unCheckedImageName=@"publish_check.png";
        choosenCell=0;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    //register the current class as transaction observer
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //init the productsArr
    //productsArr = [NSArray new];
    
    //init the pricingOptions
    //pricingOptions = [NSArray new];
    featureDays = 3;
    
    //load the options
    [self loadPricingOptions];
    
    //currentOrderID = @"";
    //currentProductID = @"";
    //chosenPricingOption = nil;
    
    
    [self.iPad_titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.iPad_titleLabel setTextAlignment:SSTextAlignmentCenter];
    [self.iPad_titleLabel setTextColor:[UIColor whiteColor]];
    [self.iPad_titleLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:30.0] ];
    [self.iPad_titleLabel setText:@"ميز إعلانك في المتجر الخاص بك"];
    
    // horizontal table
    // -90 degrees rotation will move top of your tableview to the left
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    //Just so your table is not at a random place in your view
    self.tableView.frame = CGRectMake(0,
                                      0,
                                      self.iPad_pricingtableContainerView.frame.size.height,
                                      self.iPad_pricingtableContainerView.frame.size.width
                                      );
    if (self.iPad_currentStore) {
        [self.iPad_storeDetailsView setHidden:NO];
        self.iPad_storeCountOfRemainingDays.text = [NSString stringWithFormat:@"%i", self.iPad_currentStore.remainingDays];
        self.iPad_storeCountOfRemainingFeaturedAds.text = [NSString stringWithFormat:@"%i", self.iPad_currentStore.remainingFreeFeatureAds];
    }
    
    advFeatureManager = [[StoreManager alloc] init];
    advFeatureManager.delegate = self;

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)laterBtnPressed:(id)sender {
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.parentNewCarVC)
            [(AddNewCarAdViewController *)parentNewCarVC dismissSelfAfterFeaturing];
    }];*/
    //CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    
    
    CarAdDetailsViewController *details;

    if (currentAdHasImages) {   //ad with image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        else
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
    }
    else {                            //ad with no image
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
        else
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
    }
    
    details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    details.currentAdID= self.currentAdID;
    details.checkPage = YES;
    [self presentViewController:details animated:YES completion:nil];
   
//    ChooseActionViewController* vc = [[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
//    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:vc animated:YES completion:nil];
//    
    //[self dismissViewControllerAnimated:YES completion:nil];


}

- (IBAction)labelAdBtnPressed:(id)sender {
    /*
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Feature Ad iTunes"
                         withValue:[NSNumber numberWithInt:100]];
    
    
    if (chosenPricingOption)
    {
        [self showLoadingIndicator];
        //1- extract product ID from pricing option
        //Form is: com.bezaat.cars.[country_id].[pricing_id]
        currentProductID = [NSString stringWithFormat:product_id_form,
                            chosenPricingOption.pricingTierID
                            ];
        
        //2- carete the order
        [[FeaturingManager sharedInstance]
         createOrderForFeaturingAdID:currentAdID
         withPricingID:chosenPricingOption.pricingID WithDelegate:self];
    }
     */
    
    if ((self.iPad_currentStore) && (featureDays >= 3))
    {
        [advFeatureManager featureAdv:currentAdID
                              inStore:self.iPad_currentStore.identifier
                          featureDays:featureDays];
        [self showLoadingIndicator];
    }
    
}

- (IBAction)explainAdBtnPrss:(id)sender {
    /*
    whylabelStoreAdViewController_iPad *vc=[[whylabelStoreAdViewController_iPad alloc] initWithNibName:@"whylabelStoreAdViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
     */
}

- (IBAction)noServiceBackBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - handle table

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return 76;
    else
        return 210;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 3;
    if (options && options.count)
        return options.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((options) && (options.count))
    {
        labelAdCell * cell = (labelAdCell *)[[[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"labelAdCell" : @"labelAdCell_iPad") owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.checkButton addTarget:self action:@selector(chosenPeriodPressed) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row==choosenCell) {
            [cell.checkButton setBackgroundImage:[UIImage imageNamed:checkedImageName] forState:UIControlStateNormal];
        }
        else{
            [cell.checkButton setBackgroundImage:[UIImage imageNamed:unCheckedImageName] forState:UIControlStateNormal];
        }
        
        //PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:indexPath.row];
        //cell.costLabel.text = [NSString stringWithFormat:@"%@ دولار",[GenericMethods formatPrice:option.price]];
        //cell.costLabel.text = [NSString stringWithFormat:@"%@",[GenericMethods formatPrice:option.price]];
        cell.costLabel.text = @"";
        //cell.periodLabel.text = option.pricingName;
        cell.periodLabel.text = (NSString *)options[indexPath.row];
        cell.detailsLabel.text = @"";
        [cell.iPad_currencyLabel setHidden:YES];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cell.transform = CGAffineTransformMakeRotation(M_PI_2);
            //cell.frame = CGRectMake(0, 0, 172.0, 213.0);
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    choosenCell=indexPath.row;
    //chosenPricingOption = [pricingOptions objectAtIndex:indexPath.row];
    NSString * option = (NSString *) options[indexPath.row];
    if ([@"٣ أيام" isEqualToString:option]) {
        featureDays = 3;
    }
    else if ([@"اسبوع" isEqualToString:option]) {
        featureDays = 7;
    }
    else if ([@"شهر" isEqualToString:option]) {
        featureDays = 28;
    }

    [self.tableView reloadData];
}


#pragma mark - helper methods

- (void) loadPricingOptions {
    
    if (self.iPad_currentStore.remainingFreeFeatureAds <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                        message:@"لقد تجاوزت عدد الإعلانات المحجوزة، بإمكانك إلغاء إعلان آخر ثم تمييز هذا الإعلان."
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
        return;
    }
    else if (self.iPad_currentStore.remainingDays < 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                        message:@"عدد الأيام المتبقية لديك غير كاف، قم بتجديد اشتراكك لتستطيع تمييز هذا الإعلان."
                                                       delegate:self
                                              cancelButtonTitle:@"موافق"
                                              otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
        return;
    }
    else {
        
        if (self.iPad_currentStore.remainingDays < 7) {
            options = [NSArray arrayWithObjects:@"٣ أيام", nil];

        }
        else if (self.iPad_currentStore.remainingDays < 28) {
            options = [NSArray arrayWithObjects:@"٣ أيام", @"اسبوع", nil];
        }
        else {
            options = [NSArray arrayWithObjects:@"٣ أيام", @"اسبوع", @"شهر", nil];
        }
    }

    
    /*
    [self showLoadingIndicator];
    [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:self.countryAdID withDelegate:self];
     */
}

- (void) showLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"";
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


#pragma mark -featuring store ad delegate methods

- (void) featureAdvDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تمييز الإعلان"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
}

- (void) featureAdvDidSucceed {
    [self hideLoadingIndicator];
    if (self.iPad_currentStore)
    {
        self.iPad_currentStore.remainingFreeFeatureAds--;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم تمييز الإعلان"
                                                    message:@"تم تمييز الإعلان بنجاح."
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    alert.tag = 3;
    [alert show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    /*
    if (alertView.tag == 5) {
//        ChooseActionViewController* vc = [[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:vc animated:YES completion:nil];
        //CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        CarAdDetailsViewController *details;
        if (currentAdHasImages) {   //ad with image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
        }
        else {                            //ad with no image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
        }
        
        details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        details.currentAdID=currentAdID;
        details.checkPage = YES;
        [self presentViewController:details animated:YES completion:nil];

    }
     */
    
    if (alertView.tag == 100) {   //cannot feature the ad due to remaining days
        if (self.isReturn)
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (alertView.tag == 3)
    {
        CarAdDetailsViewController *details;
        
        if (currentAdHasImages){   //ad with image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController_iPad" bundle:nil];
        }
        else {                            //ad with no image
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
            else
                details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController_iPad" bundle:nil];
        }
        
        details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        details.currentAdID=currentAdID;
        details.checkPage = YES;
        [self presentViewController:details animated:YES completion:nil];
        
    }

}


@end
