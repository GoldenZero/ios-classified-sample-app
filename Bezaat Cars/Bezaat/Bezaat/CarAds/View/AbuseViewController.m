//
//  AbuseViewController.m
//  Bezaat
//
//  Created by GALMarei on 10/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AbuseViewController.h"

@interface AbuseViewController ()
{
    int ReasonID;
    BOOL isReasonChoosen;
}
@end

@implementation AbuseViewController

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
    isReasonChoosen = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAbuse:(id)sender {
    if (!isReasonChoosen) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"الرجاء اخيار احد الاسباب" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }else{
    [[CarDetailsManager sharedInstance] abuseForAd:self.AdID WithReason:ReasonID WithDelegate:self];
    
    [self.abuseDelegate abuseFinishsubmit];
    }
}

-(void)abuseDidFailLoadingWithError:(NSError *)error
{
    [self.abuseDelegate abuseFinishsubmit];
}

-(void)abuseDidFinishLoadingWithData:(BOOL)result
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"شكرا" message:@"لقد تم التبليغ عن هذا الاعلان" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];

    [alert show];
    return;
    [self.abuseDelegate abuseFinishsubmit];
   
}

- (IBAction)Btn1Invoked:(id)sender {
    isReasonChoosen = YES;
    UIButton* btn = (UIButton*)sender;
    switch (btn.tag) {
        case 1:
            [self.Btn1 setSelected:YES];
            [self.Btn2 setSelected:NO];
            [self.Btn3 setSelected:NO];
            [self.Btn4 setSelected:NO];
            ReasonID = 1;

            break;
            
        case 2:
            [self.Btn1 setSelected:NO];
            [self.Btn2 setSelected:YES];
            [self.Btn3 setSelected:NO];
            [self.Btn4 setSelected:NO];
            ReasonID = 2;
            
            break;
            
            case 3:
            [self.Btn1 setSelected:NO];
            [self.Btn2 setSelected:NO];
            [self.Btn3 setSelected:YES];
            [self.Btn4 setSelected:NO];
            ReasonID = 3;

            break;
            
        case 4:
            [self.Btn1 setSelected:NO];
            [self.Btn2 setSelected:NO];
            [self.Btn3 setSelected:NO];
            [self.Btn4 setSelected:YES];
            ReasonID = 4;

            break;
            
        default:
            break;
    }
}
@end
