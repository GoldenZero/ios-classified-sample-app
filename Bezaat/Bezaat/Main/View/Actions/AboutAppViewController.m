//
//  AboutAppViewController.m
//  Bezaat
//
//  Created by danat on 4/27/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController

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
    self.trackedViewName = @"About app Screen";
    self.imageScroll.contentSize = CGSizeMake(320, 534);

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
