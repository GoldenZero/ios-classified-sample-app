//
//  ChooseActionViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseActionViewController.h"
#import "BHCollectionViewController.h"

@interface ChooseActionViewController ()

@end

@implementation ChooseActionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)AddNewCarAdBtnPressed:(id)sender {
    
}

- (IBAction)BuyCarBtnPressed:(id)sender {
    BHCollectionViewController *vc=[[BHCollectionViewController alloc] initWithNibName:@"BHCollectionViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
        
}

- (IBAction)AddNewStoreBtnPressed:(id)sender {
}
@end
