//
//  labelAdViewController.m
//  Bezaat
//
//  Created by Noor Alssarraj on 4/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "labelAdViewController.h"
#import "labelAdCell.h"
#import "whyLabelAdViewController.h"
#import "BankInfoViewController.h"
#import "CarAdDetailsViewController.h"
@interface labelAdViewController ()
{
    NSArray * productsArr;
    NSString *checkedImageName;
    NSString *unCheckedImageName;
    int choosenCell;
    
    MBProgressHUD2 * loadingHUD;
    NSArray * pricingOptions;
    NSString * currentOrderID;
    NSString * currentProductID;
    PricingOption * chosenPricingOption;
}
@end

@implementation labelAdViewController
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
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //init the productsArr
    productsArr = [NSArray new];
    
    //init the pricingOptions
    pricingOptions = [NSArray new];
    
    //load the options
    [self loadPricingOptions];
    
    currentOrderID = @"";
    currentProductID = @"";
    chosenPricingOption = nil;
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
    if (currentAdHasImages)   //ad with image
        details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
    
    else                            //ad with no image
        details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
    details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    details.currentAdID=currentAdID;
    details.checkPage = YES;
    [self presentViewController:details animated:YES completion:nil];
   
//    ChooseActionViewController* vc = [[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
//    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:vc animated:YES completion:nil];
//    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)labelAdBtnPressed:(id)sender {
    
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
    
}

- (IBAction)explainAdBtnPrss:(id)sender {
    whyLabelAdViewController *vc=[[whyLabelAdViewController alloc] initWithNibName:@"whyLabelAdViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)noServiceBackBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)bankTransferBtnPressed:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Feature Ad bank transfer"
                         withValue:[NSNumber numberWithInt:100]];
    
    [self showLoadingIndicator];
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    
    [[FeaturingManager sharedInstance] createOrderForBankWithAdID:self.currentAdID withShemaName:option.pricingID WithDelegate:self];

}



#pragma mark - handle table

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((pricingOptions) && (pricingOptions.count))
    {
        labelAdCell * cell = (labelAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"labelAdCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.checkButton addTarget:self action:@selector(chosenPeriodPressed) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row==choosenCell) {
            [cell.checkButton setBackgroundImage:[UIImage imageNamed:checkedImageName] forState:UIControlStateNormal];
        }
        else{
            [cell.checkButton setBackgroundImage:[UIImage imageNamed:unCheckedImageName] forState:UIControlStateNormal];
        }
        
        PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:indexPath.row];
        //cell.costLabel.text = [NSString stringWithFormat:@"%@ دولار",[GenericMethods formatPrice:option.price]];
        cell.costLabel.text = [NSString stringWithFormat:@"%@",[GenericMethods formatPrice:option.price]];
        cell.periodLabel.text = option.pricingName;
        cell.detailsLabel.text = @"";
        
        return cell;
    }
    return [UITableViewCell new];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    choosenCell=indexPath.row;
    chosenPricingOption = [pricingOptions objectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

/*
- (void) chosenPeriodPressed{
 
}
*/

#pragma mark - SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
 /*   productsArr = response.products;
    if (productsArr.count != 0)
    {
        SKProduct * prod = productsArr[0];
        SKPayment * payment = [SKPayment paymentWithProduct:prod];
        [[SKPaymentQueue defaultQueue] addPayment:payment];

    }
    else
        [GenericMethods throwAlertWithTitle:@"" message:@"فشل العملية" delegateVC:self];
    */
    [self hideLoadingIndicator];
    productsArr = response.products;
    
    if (productsArr.count != 0)
    {
        for (SKProduct * prod in productsArr)
        {
            NSLog(@"ID: %@, title: %@, desc: %@, ", prod.productIdentifier, prod.localizedTitle, prod.localizedDescription);
            SKPayment * payment = [SKPayment paymentWithProduct:prod];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    } else {
        NSLog(@"No product found");
        [GenericMethods throwAlertWithTitle:@"" message:@"المنتج غير موجود" delegateVC:self];
        return;
    }
    
    NSArray * invalidProducts = response.invalidProductIdentifiers;
    
    for (SKProduct * product in invalidProducts)
    {
        NSLog(@"Product not found: %@", product);
        [GenericMethods throwAlertWithTitle:@"" message:@"المنتج غير موجود" delegateVC:self];
        return;
    }
}


#pragma mark - SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
				break;
                
            case SKPaymentTransactionStatePurchased:
                //NSLog(@"Purchased successfully");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self GAIonPurchaseCompletedFA];
                //confirm order
                [self confirmCurrentOrderWithResponse:transaction.transactionIdentifier];
                
                break;
            
            /*
            case SKPaymentTransactionStateRestored:
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                //confirm order
                [self confirmCurrentOrderWithResponse:transaction.transactionIdentifier];
                
				break;
            */
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                
                if (transaction.error.code != SKErrorPaymentCancelled) // error!
                    [GenericMethods throwAlertWithTitle:@"خطأ" message:transaction.error.localizedDescription delegateVC:self];
                
                //else // this is fine, the user just cancelled
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                //cancel order
                [self cancelCurrentOrder];
                
                break;
                
            default:
                break;
        }
    }
}

-(void) GAIonPurchaseCompletedFA
{
    GAITransaction *transaction =
    [GAITransaction transactionWithId:currentOrderID
                      withAffiliation:@"In-App Store"];
    transaction.shippingMicros = (int64_t)(0);
    transaction.revenueMicros = (int64_t)(chosenPricingOption.price * 1000000);
    
    [transaction addItemWithCode:[NSString stringWithFormat:@"%i_%i",self.countryAdID,chosenPricingOption.pricingID]
                            name:chosenPricingOption.pricingName
                        category:@"Featured Ads"
                     priceMicros:(int64_t)(chosenPricingOption.price * 1000000)
                        quantity:1];
    
    
    [[GAI sharedInstance].defaultTracker sendTransaction:transaction];
}

-(void) GAIonPurchaseCompletedBT
{
    GAITransaction *transaction =
    [GAITransaction transactionWithId:currentOrderID
                      withAffiliation:@"Bank Transfer"];
    transaction.shippingMicros = (int64_t)(0);
    transaction.revenueMicros = (int64_t)(chosenPricingOption.price * 1000000);
    
    [transaction addItemWithCode:[NSString stringWithFormat:@"%i_%i",self.countryAdID,chosenPricingOption.pricingID]
                            name:chosenPricingOption.pricingName
                        category:@"Featured Ads"
                     priceMicros:(int64_t)(chosenPricingOption.price * 1000000)
                        quantity:1];
    
    
    [[GAI sharedInstance].defaultTracker sendTransaction:transaction];
}

#pragma mark - helper methods

- (void) loadPricingOptions {
    
    [self showLoadingIndicator];
    [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:self.countryAdID withDelegate:self];
}

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
    
}

- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
}

- (void) purchaseProductWithIdentifier:(NSString *) identifier {
    
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *request = [[SKProductsRequest alloc]
                                      initWithProductIdentifiers:
                                      [NSArray arrayWithObjects:identifier, nil]];
        request.delegate = self;
        [request start];
    }
    else
    {
        [GenericMethods throwAlertWithTitle:@"" message:@"الرجاء تفعيل إعدادات الشراء في الجهاز" delegateVC:self];
    }
}

- (void) confirmCurrentOrderWithResponse:(NSString *) responseString {
    if (![currentOrderID isEqualToString:@""])
    {
        [self showLoadingIndicator];
        
        [[FeaturingManager sharedInstance] confirmOrderID:currentOrderID
                                          gatewayResponse:responseString
                                             withDelegate:self];
    }
}

- (void) cancelCurrentOrder {
    if (![currentOrderID isEqualToString:@""])
    {
        [self showLoadingIndicator];
        [[FeaturingManager sharedInstance] cancelOrderID:currentOrderID
                                            withDelegate:self];
    }
}


#pragma mark - PricingOptions Delegate

- (void) optionsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    currentOrderID = @"";
    currentProductID = @"";
    chosenPricingOption = nil;
    
    [self.laterBtn setEnabled:NO];
    [self.nowBtn setEnabled:NO];
    
   

}

- (void) optionsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    [self hideLoadingIndicator];
    
    pricingOptions = [NSArray arrayWithArray:resultArray];
    
    if (resultArray && resultArray.count)
    {
        chosenPricingOption = [resultArray objectAtIndex:0];
        [self.laterBtn setHidden:NO];
        [self.nowBtn setHidden:NO];
        [self.tableView reloadData];
    }
    else
    {
        [self.noServiceView setHidden:NO];
        [self.laterBtn setHidden:YES];
        [self.nowBtn setHidden:YES];
        [self.bankTransBtn setHidden:YES];
        [self.whiteRectImg setHidden:YES];
    }
}

#pragma mark -  FeaturingOrder Delegate

//creation
- (void) orderDidFailCreationWithError:(NSError *) error {
    [self hideLoadingIndicator];
    
    //COME BACK HERE LATER TO ADD A RETRY BUTTON
    if ([[error description] isEqualToString:@"input string was not in a correct format."]) {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"لا يمكنك تمييز اعلانك لأنك زائر ،يرجى تسجيل الدخول لتمييز إعلانك" delegateVC:self];
    }else
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

- (void) orderDidFinishCreationWithID:(NSString *) orderID {
    
    //1- store the ID
    currentOrderID = orderID;
    
    //2- in app purchase
    if (![currentProductID isEqualToString:@""])
        [self purchaseProductWithIdentifier:currentProductID];
}

-(void)BankOrderDidFailCreationWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    if ([[error description] isEqualToString:@"input string was not in a correct format."]) {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"لا يمكنك تمييز اعلانك لأنك زائر ،يرجى تسجيل الدخول لتمييز إعلانك" delegateVC:self];
    }else
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)BankOrderDidFinishCreationWithID:(NSString *)orderID
{
    [self hideLoadingIndicator];
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    [self GAIonPurchaseCompletedBT];
    
    BankInfoViewController *vc=[[BankInfoViewController alloc] initWithNibName:@"BankInfoViewController" bundle:nil];
    vc.Order = orderID;
    vc.AdID = self.currentAdID;
    vc.ProductName = option.pricingName;
    vc.type = 1;
    [self presentViewController:vc animated:YES completion:nil];
    
}

//-----------------------------------------------------------
//confirmation
- (void) orderDidFailConfirmingWithError:(NSError *) error {
    
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];

    //COME BACK HERE LATER TO ADD A RETRY BUTTON
}

- (void) orderDidFinishConfirmingWithStatus:(BOOL) status {
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.parentNewCarVC)
            [(AddNewCarAdViewController *)parentNewCarVC dismissSelfAfterFeaturing];
    }];*/
    UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد تم تمييز إعلانك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    
    alert.tag = 5;
    [alert show];
    return;
    

}
//-----------------------------------------------------------

//cancellation
- (void) orderDidFailCancellingWithError:(NSError *) error {
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];

}

- (void) orderDidFinishCancellingWithStatus:(BOOL) status {
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.parentNewCarVC)
            [(AddNewCarAdViewController *)parentNewCarVC dismissSelfAfterFeaturing];
    }];*/
    if (status) {
        UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"شكرا" message:@"لقد تم إلغاء طلبك" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        
        alert.tag = 5;
        [alert show];
        return;
    }
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 5) {
//        ChooseActionViewController* vc = [[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:vc animated:YES completion:nil];
        //CarAdDetailsViewController *details=[[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        CarAdDetailsViewController *details;
        if (currentAdHasImages)   //ad with image
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdDetailsViewController" bundle:nil];
        
        else                            //ad with no image
            details = [[CarAdDetailsViewController alloc]initWithNibName:@"CarAdNoPhotoDetailsViewController" bundle:nil];
        
        details.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        details.currentAdID=currentAdID;
        details.checkPage = YES;
        [self presentViewController:details animated:YES completion:nil];

    }
    
    
}


@end
