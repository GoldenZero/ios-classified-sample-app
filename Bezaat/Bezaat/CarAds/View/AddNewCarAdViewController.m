//
//  AddNewCarAdViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "AddNewCarAdViewController.h"
#import "ChooseActionViewController.h"

@interface AddNewCarAdViewController (){
    UITextField *carAdTitle;
    UITextField *mobileNum;
    UITextField *phoneNum;
    UITextField *externalColor;
    UITextField *distance;
    UITextField *carPrice;
    UITextView *carDetails;
    UIButton *serviceKind;
    UIButton *adPeriod;
    UIButton *productionYear;
    UIButton *currency;
    UIButton *receiveMail;
    UIButton *kiloMile;
}

@end

@implementation AddNewCarAdViewController

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
    [self addButtonsToXib];
    [self setImagesArray];
    [self setImagesToXib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper methods
- (void) setImagesToXib{
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];

}

- (void) setImagesArray{
    
    [self.horizontalScrollView setContentSize:CGSizeMake(960, 119)];
    [self.horizontalScrollView setScrollEnabled:YES];
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:YES];
    
    for (int i=0; i<8; i++) {
        UIButton *temp=[[UIButton alloc]initWithFrame:CGRectMake(20+(104*i), 20, 77, 70)];
        [temp setImage:[UIImage imageNamed:@"AddCar_Car_logo.png"] forState:UIControlStateNormal];
        
        [temp addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
        [self.horizontalScrollView addSubview:temp];
    }
}

- (void) uploadImage{
    
}

- (void) addButtonsToXib{
    [self.verticalScrollView setContentSize:CGSizeMake(320 , 460)];
    [self.verticalScrollView setScrollEnabled:YES];
    [self.verticalScrollView setShowsHorizontalScrollIndicator:YES];
    
    carAdTitle=[[UITextField alloc] initWithFrame:CGRectMake(30,20 ,260 ,30)];
    [carAdTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [carAdTitle setTextAlignment:NSTextAlignmentRight];
    [carAdTitle setPlaceholder:@"عنوان الإعلان"];
    [self.verticalScrollView addSubview:carAdTitle];
    
    phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(30,96 ,260 ,30)];
    [phoneNum setBorderStyle:UITextBorderStyleRoundedRect];
    [phoneNum setTextAlignment:NSTextAlignmentRight];
    [phoneNum setPlaceholder:@"رقم الهاتف"];
    [self.verticalScrollView addSubview:phoneNum];
    
    mobileNum=[[UITextField alloc] initWithFrame:CGRectMake(30,134 ,260 ,30)];
    [mobileNum setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileNum setTextAlignment:NSTextAlignmentRight];
    [mobileNum setPlaceholder:@"رقم الجوال"];
    [self.verticalScrollView addSubview:mobileNum];
    
    carPrice=[[UITextField alloc] initWithFrame:CGRectMake(170,271 ,120 ,30)];
    [carPrice setBorderStyle:UITextBorderStyleRoundedRect];
    [carPrice setTextAlignment:NSTextAlignmentRight];
    [carPrice setPlaceholder:@"السعر"];
    [self.verticalScrollView addSubview:carPrice];
    
    externalColor=[[UITextField alloc] initWithFrame:CGRectMake(170,348 ,120 ,30)];
    [externalColor setBorderStyle:UITextBorderStyleRoundedRect];
    [externalColor setTextAlignment:NSTextAlignmentRight];
    [externalColor setPlaceholder:@"اللون الخارجي"];
    [self.verticalScrollView addSubview:externalColor];
    
    distance=[[UITextField alloc] initWithFrame:CGRectMake(170,310 ,120 ,30)];
    [distance setBorderStyle:UITextBorderStyleRoundedRect];
    [distance setTextAlignment:NSTextAlignmentRight];
    [distance setPlaceholder:@"المسافة"];
    [self.verticalScrollView addSubview:distance];
    
    serviceKind =[[UIButton alloc] initWithFrame:CGRectMake(170, 58, 120, 30)];
    [serviceKind setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [serviceKind setTitle:@"الخدمة المطلوبة" forState:UIControlStateNormal];
    [serviceKind setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:serviceKind];
    
    adPeriod =[[UIButton alloc] initWithFrame:CGRectMake(30, 58, 120, 30)];
    [adPeriod setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [adPeriod setTitle:@"فترة الإعلان" forState:UIControlStateNormal];
    [adPeriod setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:adPeriod];

    
    productionYear =[[UIButton alloc] initWithFrame:CGRectMake(30, 348, 120, 30)];
    [productionYear setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [productionYear setTitle:@"عام الصنع" forState:UIControlStateNormal];
    [productionYear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:productionYear];

    
    currency =[[UIButton alloc] initWithFrame:CGRectMake(30, 271, 120, 30)];
    [currency setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [currency setTitle:@"العملة" forState:UIControlStateNormal];
    
    [currency setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:currency];

    receiveMail =[[UIButton alloc] initWithFrame:CGRectMake(30, 386, 260, 30)];
    [receiveMail setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [receiveMail setTitle:@"استقبل ايميلات عند التعليق على الاعلان" forState:UIControlStateNormal];
    [receiveMail setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:receiveMail];

    kiloMile =[[UIButton alloc] initWithFrame:CGRectMake(30, 310, 120, 30)];
    [kiloMile setBackgroundImage:[UIImage imageNamed: @"AddCar_text_BG.png"] forState:UIControlStateNormal];
    [kiloMile setTitle:@"كم/ميل" forState:UIControlStateNormal];
    [kiloMile setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.verticalScrollView addSubview:kiloMile];
    
    carDetails=[[UITextView alloc] initWithFrame:CGRectMake(30,178 ,260 ,85 )];
    [carDetails setTextAlignment:NSTextAlignmentRight];
    [self.verticalScrollView addSubview:carDetails];

    
}
#pragma mark - Buttons Actions
- (IBAction)homeBtnPrss:(id)sender {
    ChooseActionViewController *vc=[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)addBtnprss:(id)sender {
    
    // Add current Ad to the user's add
    // CODE HERE
    
    
    ChooseActionViewController *vc=[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
