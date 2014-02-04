//
//  ErrorPageVC.m
//  Argaam
//
//  Created by GALMarei on 7/14/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ErrorPageVC.h"

@interface ErrorPageVC ()

@end

@implementation ErrorPageVC

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
    [self.navigationController setNavigationBarHidden:YES];
    
    //[TestFlight passCheckpoint:@"No Internet screen"];
    [[GAI sharedInstance].defaultTracker sendView:@"No Internet screen"];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    if ([[UIScreen mainScreen] bounds].size.height == 568)
        [self.errorImage setImage:[UIImage imageNamed:@"errorMasIph5.png"]];
    else
        [self.errorImage setImage:[UIImage imageNamed:@"errorMas.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)listInvoked:(id)sender {
    ChooseActionViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    else
        vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
