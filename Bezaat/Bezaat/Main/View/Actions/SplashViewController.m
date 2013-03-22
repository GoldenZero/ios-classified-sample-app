//
//  SplashViewController.m
//  Bezaat
//
//  Created by Syrisoft on 3/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SplashViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    self.splashView.image=[UIImage imageNamed:@"splash.png"];
    UIImageView *wheelImage=[[UIImageView alloc] initWithFrame:CGRectMake(137, 350, 47, 47)];
    wheelImage.image=[UIImage imageNamed:@"splash_wheel.png"];
    [self.view addSubview:wheelImage];
//    UIImageView *wheelShadowImage=[[UIImageView alloc] initWithFrame:CGRectMake(137, 380, 47, 47)];
//    wheelShadowImage.image=[UIImage imageNamed:@"splash_wheelShadow.png"];
//    [self.view addSubview:wheelShadowImage];
    [self rotationWheel:wheelImage];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) rotationWheel: (UIView*) wheelView{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 /* full rotation*/ * 3 * 3.0];
    rotationAnimation.duration =3.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    rotationAnimation.delegate = self;
    [wheelView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //
    //    CABasicAnimation* translationAnimation;
    //    translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    //    translationAnimation.toValue = [NSNumber numberWithFloat:-700];
    //    translationAnimation.duration = 12;
    //    translationAnimation.cumulative = YES;
    //    translationAnimation.repeatCount = 1.0;
    //    translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //    translationAnimation.removedOnCompletion = NO;
    //    translationAnimation.fillMode = kCAFillModeBackwards;
    //    [wheelView.layer addAnimation:translationAnimation forKey:@"translationAnimation"];
    
    
}
@end
