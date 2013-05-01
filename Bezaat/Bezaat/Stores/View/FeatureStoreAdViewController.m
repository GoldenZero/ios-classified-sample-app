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

@interface FeatureStoreAdViewController (){
    NSArray * productsArr;
    NSString *checkedImageName;
    NSString *unCheckedImageName;
    int choosenCell;
    
    MBProgressHUD2 * loadingHUD;
    NSArray * pricingOptions;
    NSString* OrderID;
    NSString* transactionID;
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
    
    //init the productsArr
    productsArr = [NSArray new];
    
    //init the pricingOptions
    pricingOptions = [NSArray new];
    
    //load the options
    [self loadPricingOptions];
    
    //[self purchaseProductWithIdentifier:@"com.bezaat.uae.25"];
    //[self purchaseProductWithIdentifier:@"com.bezaat.uae.test"];
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
   // [self dismissViewControllerAnimated:YES completion:nil];
    ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)labelAdBtnPressed:(id)sender {
    [self showLoadingIndicator];
    PricingOption * option = (PricingOption *)[pricingOptions objectAtIndex:choosenCell];
    
    [[FeaturingManager sharedInstance] createStoreOrderForStoreID:self.storeID.identifier withcountryID:[[SharedUser sharedInstance] getUserCountryID] withShemaName:option.pricingID WithDelegate:self];
}

- (IBAction)explainAdBtnPrss:(id)sender {
    WhyFeatureStoreAdViewController *vc=[[WhyFeatureStoreAdViewController alloc] initWithNibName:@"WhyFeatureStoreAdViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
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
        cell.costLabel.text = [NSString stringWithFormat:@"%@ دولار",[GenericMethods formatPrice:option.price]];
        cell.periodLabel.text = option.pricingName;
        cell.detailsLabel.text = @"";
        
        return cell;
    }
    return [UITableViewCell new];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    choosenCell=indexPath.row;
    if (productsArr && productsArr.count)
    {
        SKProduct *product = [productsArr objectAtIndex:indexPath.row];
        [self purchaseProductWithIdentifier:product.productIdentifier];
    }
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
    [[FeaturingManager sharedInstance] confirmStoreOrderID:OrderID withAppName:@"AppStore" gatewayResponse:[notification description] withDelegate:self];
    
}

#pragma mark - helper methods
- (void) loadPricingOptions {
    
    [self showLoadingIndicator];
    [[FeaturingManager sharedInstance] loadStorePricingOptionsForCountry:[[SharedUser sharedInstance] getUserCountryID] withDelegate:self];
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

#pragma mark - PricingOptions Delegate

- (void) optionsDidFailLoadingWithError:(NSError *)error {
    
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

- (void) optionsDidFinishLoadingWithData:(NSArray *)resultArray {
    [self hideLoadingIndicator];
    
    pricingOptions = [NSArray arrayWithArray:resultArray];
    [self.tableView reloadData];
}

-(void)storeOptionsDidFailLoadingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)storeOptionsDidFinishLoadingWithData:(NSArray *)resultArray
{
    [self hideLoadingIndicator];
    
    pricingOptions = [NSArray arrayWithArray:resultArray];
    [self.tableView reloadData];
}

-(void)StoreOrderDidFailCreationWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)StoreOrderDidFinishCreationWithID:(NSString *)orderID
{
    OrderID = orderID;
    NSLog(@"%@",OrderID);
    
    [self purchaseProductWithIdentifier:@"com.bezaat.S.13"];
}

-(void)StoreOrderDidFailConfirmingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)StoreOrderDidFinishConfirmingWithStatus:(BOOL)status
{
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (!savedProfile.hasStores) {
        [[ProfileManager sharedInstance] updateStoreStateForCurrentUser:YES];
    }
   
    
    if (status) {
        [GenericMethods throwAlertWithTitle:@"شكرا" message:@"لقد تمت العملية بنجاح" delegateVC:self];
    }else{
       [GenericMethods throwAlertWithTitle:@"خطأ" message:@"لم تتم العملية يرجى اعادة المحاولة" delegateVC:self];
    }
}

@end
