//
//  FeatureStoreAdViewController.m
//  Bezaat
//
//  Created by GALMarei on 4/30/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "FeatureStoreAdViewController.h"
#import "FeatureAdCell.h"
#import "WhyFeatureStoreAdViewController.h"
#import "ChooseActionViewController.h"
#import "BankInfoViewController.h"
#import "StoreDetailsViewController.h"

@interface FeatureStoreAdViewController (){
    NSArray * productsArr;
    NSString *checkedImageName;
    NSString *unCheckedImageName;
    int choosenCell;
    
    MBProgressHUD2 * loadingHUD;
    NSArray * pricingOptions;
    NSString* OrderID;
    NSString* transactionID;
    
    NSString* theGatwayID;
}

@end

@implementation FeatureStoreAdViewController
@synthesize currentAdID;
NSString *const MyStorePurchasedNotification = @"MyProductPurchasedNotification";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        checkedImageName=@"storebackegeOn.png";
        unCheckedImageName=@"storebackegeOff.png";
        choosenCell=0;
        // Custom initialization
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
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:self];
    
    if (self.currentOrder) {
        self.storeID = [[Store alloc] init];
        self.storeID.identifier = self.currentOrder.StoreID;
        self.storeID.name = self.currentOrder.StoreName;
        self.storeID.imageURL = self.currentOrder.StoreImageURL;
        self.storeID.countryID = self.currentOrder.CountryID;
    }
    //init the productsArr
    productsArr = [NSArray new];
    
    //init the pricingOptions
    pricingOptions = [NSArray new];
    
    //load the options
    [self loadPricingOptions];
    
    //[self purchaseProductWithIdentifier:@"com.bezaat.uae.25"];
    //[self purchaseProductWithIdentifier:@"com.bezaat.uae.test"];
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Store subscriptions screen"];
    //end GA
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:MyStorePurchasedNotification object:nil];
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
    
    StoreDetailsViewController *vc = [[StoreDetailsViewController alloc] initWithNibName:@"StoreDetailsViewController" bundle:nil];
    vc.currentStore = self.storeID;
    vc.fromSubscribtion = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)labelAdBtnPressed:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Store feature Ad"
                         withValue:[NSNumber numberWithInt:100]];
    
    [self showLoadingIndicator];
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    
    [[FeaturingManager sharedInstance] createStoreOrderForStoreID:self.storeID.identifier withcountryID:self.storeID.countryID withShemaName:option.pricingID WithDelegate:self];
}

- (IBAction)explainAdBtnPrss:(id)sender {
    WhyFeatureStoreAdViewController *vc=[[WhyFeatureStoreAdViewController alloc] initWithNibName:@"WhyFeatureStoreAdViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)noServiceBackBtnPrss:(id)sender
{
    ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)bankTransferBtnPrss:(id)sender {
    //TODO - make the create and confirm API
    [self showLoadingIndicator];
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    [[FeaturingManager sharedInstance] createOrderForBankWithStoreID:self.storeID.identifier withcountryID:self.storeID.countryID withShemaName:option.pricingID WithDelegate:self];
    //[[FeaturingManager sharedInstance] createOrderForBankWithAdID:self.storeID.identifier withShemaName:option.pricingID WithDelegate:self];
}


#pragma mark - handle table

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pricingOptions count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if ((pricingOptions) && (pricingOptions.count))
    {
        
        FeatureAdCell * cell = (FeatureAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"FeatureAdCell" owner:self options:nil] objectAtIndex:0];
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
        if (!option.pricingTierID || option.pricingTierID == 0){
            [cell.itunesImg setHidden:YES];
           // [self.nowBtn setEnabled:NO];
        }else{
            [cell.itunesImg setHidden:NO];
           // [self.nowBtn setEnabled:YES];
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    choosenCell=indexPath.row;
   PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    if (!option.pricingTierID || option.pricingTierID == 0)
        [self.nowBtn setEnabled:NO];
    else
        [self.nowBtn setEnabled:YES];
    
    [self.tableView reloadData];
}

- (void) chosenPeriodPressed{
    
   
    
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
    else{
        NSLog(@"Please enable In App Purchase in Settings");
    [GenericMethods throwAlertWithTitle:@"" message:@"Please enable In App Purchase in Settings" delegateVC:self];
    return;
    }
}

#pragma mark - SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
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
    [self hideLoadingIndicator];
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Purchased successfully");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                [[NSNotificationCenter defaultCenter] postNotificationName:MyStorePurchasedNotification object:transaction.payment.productIdentifier userInfo:nil];
               transactionID = transaction.transactionIdentifier;
                [self GAIonPurchaseCompletedFA];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                [GenericMethods throwAlertWithTitle:@"" message:@"فشلت العملية يرجى إعادة المحاولة" delegateVC:self];
                
                break;
                
            default:
                break;
        }
    }
}

- (void)productPurchased:(NSNotification *)notification {
    [self hideLoadingIndicator];
    NSString * productIdentifier = notification.object;
    NSLog(@"product is purchased: %@", productIdentifier);
    
    [[FeaturingManager sharedInstance] confirmStoreOrderID:(NSString*)OrderID withAppName:@"AppStore" gatewayResponse:transactionID withDelegate:self];
    
}

-(void) GAIonPurchaseCompletedFA
{
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    
    GAITransaction *transaction =
    [GAITransaction transactionWithId:(NSString*)OrderID
                      withAffiliation:@"In-App Store"];
    transaction.shippingMicros = (int64_t)(0);
    transaction.revenueMicros = (int64_t)(option.price * 1000000);
    
    [transaction addItemWithCode:[NSString stringWithFormat:@"%i_%i",self.storeID.countryID,option.pricingID]
                            name:option.pricingName
                        category:@"Store Subscribtion"
                     priceMicros:(int64_t)(option.price * 1000000)
                        quantity:1];
    
    
    [[GAI sharedInstance].defaultTracker sendTransaction:transaction];
}

-(void) GAIonPurchaseCompletedBT
{
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    
    GAITransaction *transaction =
    [GAITransaction transactionWithId:(NSString*)OrderID
                      withAffiliation:@"Bank Transfer"];
    transaction.shippingMicros = (int64_t)(0);
    transaction.revenueMicros = (int64_t)(option.price * 1000000);
    
    [transaction addItemWithCode:[NSString stringWithFormat:@"%i_%i",self.storeID.countryID,option.pricingID]
                            name:option.pricingName
                        category:@"Store Subscribtion"
                     priceMicros:(int64_t)(option.price * 1000000)
                        quantity:1];
    
    
    [[GAI sharedInstance].defaultTracker sendTransaction:transaction];
}


#pragma mark - helper methods
- (void) loadPricingOptions {
    
    [self showLoadingIndicator];
    [[FeaturingManager sharedInstance] loadStorePricingOptionsForCountry:self.storeID.countryID withDelegate:self];
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

- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
}

#pragma mark - PricingOptions Delegate

- (void) optionsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self.noServiceView setHidden:NO];
    [self.laterBtn setHidden:YES];
    [self.nowBtn setHidden:YES];
    [self.bankBtn setHidden:YES];
    [self.bgBtns setHidden:YES];

}

- (void) optionsDidFinishLoadingWithData:(NSArray *)resultArray {
    [self hideLoadingIndicator];
    
    pricingOptions = [NSArray arrayWithArray:resultArray];

    if (resultArray && resultArray.count)
    {
        //chosenPricingOption = [resultArray objectAtIndex:0];
        [self.laterBtn setEnabled:YES];
        [self.nowBtn setEnabled:YES];
        [self.bankBtn setEnabled:YES];
        [self.tableView reloadData];
    }
    else
    {
        [self.noServiceView setHidden:NO];
        [self.laterBtn setHidden:YES];
        [self.nowBtn setHidden:YES];
        [self.bankBtn setHidden:YES];
        [self.bgBtns setHidden:YES];
    }

    
   // [self.tableView reloadData];
}

-(void)storeOptionsDidFailLoadingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self.noServiceView setHidden:NO];
    [self.laterBtn setHidden:YES];
    [self.nowBtn setHidden:YES];
    [self.bankBtn setHidden:YES];
    [self.bgBtns setHidden:YES];
}

-(void)storeOptionsDidFinishLoadingWithData:(NSArray *)resultArray
{
    [self hideLoadingIndicator];
    
    pricingOptions = [NSArray arrayWithArray:resultArray];
    
    if (resultArray && resultArray.count)
    {
        //chosenPricingOption = [resultArray objectAtIndex:0];
        [self.laterBtn setEnabled:YES];
        [self.nowBtn setEnabled:YES];
        [self.tableView reloadData];
    }
    else
    {
        [self.noServiceView setHidden:NO];
        [self.laterBtn setHidden:YES];
        [self.nowBtn setHidden:YES];
        [self.bankBtn setHidden:YES];
        [self.bgBtns setHidden:YES];
    }
}

-(void)StoreOrderDidFailCreationWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)StoreOrderDidFinishCreationWithID:(NSString *)orderID
{
    //OrderID = orderID;
    NSDictionary* temp = (NSDictionary*)orderID;
    if (temp) {
        OrderID = [temp objectForKey:@"OrderID"];
    }else{
        OrderID = orderID;
    }
    NSLog(@"%@",OrderID);
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    
    [self purchaseProductWithIdentifier:[NSString stringWithFormat:@"com.bezaat.cars.ns.%i",option.pricingTierID]];
}

-(void)BankStoreOrderDidFailCreationWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)BankStoreOrderDidFinishCreationWithID:(NSString *)orderID
{
    [self hideLoadingIndicator];
    
    OrderID = orderID;
    NSLog(@"%@",OrderID);
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    [self GAIonPurchaseCompletedBT];
    
    BankInfoViewController *vc=[[BankInfoViewController alloc] initWithNibName:@"BankInfoViewController" bundle:nil];
    vc.Order = orderID;
    vc.StoreName = self.storeID.name;
    vc.ProductName = option.pricingName;
    vc.type = 2;
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(void)StoreOrderDidFailConfirmingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)StoreOrderDidFinishConfirmingWithStatus:(BOOL)status
{
    [self hideLoadingIndicator];
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedProfile.hasStores) {
        [[ProfileManager sharedInstance] updateStoreStateForCurrentUser:YES];
    }
   
    
    if (status) {
       // [GenericMethods throwAlertWithTitle:@"شكرا" message:@"لقد تمت العملية بنجاح" delegateVC:self];
        UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"شكرا" message:[NSString stringWithFormat:@"تم الدفع بنجاح وتفعيل المتجر\n\nرقم الطلب : %@",OrderID] delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        
        alert.tag = 5;
        [alert show];
        return;
    }else{
       [GenericMethods throwAlertWithTitle:@"خطأ" message:@"لم تتم العملية يرجى اعادة المحاولة" delegateVC:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 5) {
        StoreDetailsViewController *vc = [[StoreDetailsViewController alloc] initWithNibName:@"StoreDetailsViewController" bundle:nil];
        vc.currentStore = self.storeID;
        vc.fromSubscribtion = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    
}


@end
