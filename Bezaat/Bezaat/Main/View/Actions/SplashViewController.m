//
//  SplashViewController.m
//  Bezaat
//
//  Created by Syrisoft on 3/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SplashViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "BrandsManager.h"

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
    
    [self rotationWheel:self.wheelView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) loadBrands {
    
    [[BrandsManager sharedInstance] getBrandsAndModelsWithDelegate:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(stopAnimatingWheel) userInfo:nil repeats:NO];
}

- (void) stopAnimatingWheel {
    [self.wheelView.layer removeAllAnimations];
}

- (void) rotationWheel: (UIView*) wheelView{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 /* full rotation*/ * 10 * 15.0];
    rotationAnimation.duration = 15.0;
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

- (void) animationDidStart:(CAAnimation *)anim {
    [self performSelectorOnMainThread:@selector(loadBrands) withObject:nil waitUntilDone:YES];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] onSplashScreenDone];
}


@end
