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
@synthesize currentAdID;
@synthesize laterBtn, nowBtn, parentNewCarVC;

static NSString * product_id_form = @"com.bezaat.cars.%i.%i";

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)labelAdBtnPressed:(id)sender {
    
    if (chosenPricingOption)
    {
        //1- extract product ID from pricing option
        //Form is: com.bezaat.cars.[country_id].[pricing_id]
        currentProductID = [NSString stringWithFormat:product_id_form,
                            [[SharedUser sharedInstance] getUserCountryID],
                            chosenPricingOption.pricingID
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
        cell.costLabel.text = [NSString stringWithFormat:@"%@ دولار",[GenericMethods formatPrice:1000]];
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
    productsArr = response.products;
    if (productsArr.count != 0)
    {
        SKProduct * prod = productsArr[0];
        SKPayment * payment = [SKPayment paymentWithProduct:prod];
        [[SKPaymentQueue defaultQueue] addPayment:payment];

    }
    else
        [GenericMethods throwAlertWithTitle:@"" message:@"فشل العملية" delegateVC:self];
    
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

#pragma mark - helper methods

- (void) loadPricingOptions {
    
    [self showLoadingIndicator];
    [[FeaturingManager sharedInstance] loadPricingOptionsForCountry:[[SharedUser sharedInstance] getUserCountryID] withDelegate:self];
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
        [self.laterBtn setEnabled:YES];
        [self.nowBtn setEnabled:YES];
        [self.tableView reloadData];
    }
    else
    {
        //NOOR: set the background of sad face
    }
}

#pragma mark -  FeaturingOrder Delegate

//creation
- (void) orderDidFailCreationWithError:(NSError *) error {
    [self hideLoadingIndicator];
    
    //COME BACK HERE LATER TO ADD A RETRY BUTTON
}

- (void) orderDidFinishCreationWithID:(NSString *) orderID {
    
    //1- store the ID
    currentOrderID = orderID;
    
    //2- in app purchase
    if (![currentProductID isEqualToString:@""])
        [self purchaseProductWithIdentifier:currentProductID];
}
//-----------------------------------------------------------
//confirmation
- (void) orderDidFailConfirmingWithError:(NSError *) error {
    
    [self hideLoadingIndicator];
    
    //COME BACK HERE LATER TO ADD A RETRY BUTTON
}

- (void) orderDidFinishConfirmingWithStatus:(BOOL) status {
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.parentNewCarVC)
            [(AddNewCarAdViewController *)parentNewCarVC dismissSelfAfterFeaturing];
    }];*/
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-----------------------------------------------------------

//cancellation
- (void) orderDidFailCancellingWithError:(NSError *) error {
    [self hideLoadingIndicator];
}

- (void) orderDidFinishCancellingWithStatus:(BOOL) status {
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.parentNewCarVC)
            [(AddNewCarAdViewController *)parentNewCarVC dismissSelfAfterFeaturing];
    }];*/
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
