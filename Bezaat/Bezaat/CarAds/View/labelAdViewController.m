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
}
@end

@implementation labelAdViewController

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
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:self];
    
    //init the productsArr
    productsArr = [NSArray new];
    
    //init the pricingOptions
    pricingOptions = [NSArray new];
    
    //load the options
    [self loadPricingOptions];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)labelAdBtnPressed:(id)sender {
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
                                      [NSSet setWithObject:identifier]];
        request.delegate = self;
        [request start];
    }
    else
        NSLog(@"Please enable In App Purchase in Settings");

}

#pragma mark - SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    productsArr = response.products;
    
    if (productsArr.count != 0)
    {
        for (SKProduct * prod in productsArr)
        {
            NSLog(@"ID: %@, title: %@, desc: %@, ", prod.productIdentifier, prod.localizedTitle, prod.localizedDescription);
        }
    } else {
        NSLog(@"No product found");
    }
    
    NSArray * invalidProducts = response.invalidProductIdentifiers;
    
    for (SKProduct * product in invalidProducts)
    {
        NSLog(@"Product not found: %@", product);
    }
}

#pragma mark - SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Purchased successfully");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
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
@end
