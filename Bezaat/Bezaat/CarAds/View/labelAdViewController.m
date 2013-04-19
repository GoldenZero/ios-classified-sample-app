//
//  labelAdViewController.m
//  Bezaat
//
//  Created by Noor Alssarraj on 4/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "labelAdViewController.h"
#import "labelAdCell.h"

@interface labelAdViewController ()
{
    NSArray * productsArr;
}
@end

@implementation labelAdViewController

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
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

    //register the current class as transaction observer
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:self];
    
    //init the productsArr
    productsArr = [NSArray new];
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
}

- (IBAction)labelAdBtnPressed:(id)sender {
}

- (IBAction)explainAdBtnPrss:(id)sender {
}



#pragma mark - handle table

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    labelAdCell * cell = (labelAdCell *)[[[NSBundle mainBundle] loadNibNamed:@"labelAdCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.checkButton addTarget:self action:@selector(chosenPeriodPressed) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (productsArr && productsArr.count)
    {
        SKProduct *product = [productsArr objectAtIndex:indexPath.row];
        [self purchaseProductWithIdentifier:product.productIdentifier];
    }
}

- (void) chosenPeriodPressed{
    //
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

@end
