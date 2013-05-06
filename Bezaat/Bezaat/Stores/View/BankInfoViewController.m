//
//  BankInfoViewController.m
//  Bezaat
//
//  Created by GALMarei on 5/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "BankInfoViewController.h"
#import "ChooseActionViewController.h"

@interface BankInfoViewController ()

@end

@implementation BankInfoViewController

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
     [self.bankWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"contact_us" ofType:@"html"] isDirectory:NO]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeBtnPressed:(id)sender {
    ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];

}
@end
