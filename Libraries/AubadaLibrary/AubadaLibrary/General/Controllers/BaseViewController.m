//
//  BaseViewController.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 11/2/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat IPHONE_PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat IPHONE_LANDSCAPE_KEYBOARD_HEIGHT = 140;

static const CGFloat IPAD_PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat IPAD_LANDSCAPE_KEYBOARD_HEIGHT = 352;

CGFloat animatedDistance;

@implementation UINavigationController (RotationIn_IOS6)

- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject]  preferredInterfaceOrientationForPresentation];
}

@end

@implementation BaseViewController

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField*)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [sender resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGRect textFieldRect = [self.view.window convertRect:aTextField.bounds fromView:aTextField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    NSLog(@"height = %f", textFieldRect.size.height);
    NSLog(@"width = %f", textFieldRect.size.width);
    NSLog(@"x = %f", textFieldRect.origin.x);
    NSLog(@"y = %f", textFieldRect.origin.y);
    
    CGFloat midline;
    CGFloat numerator;
    CGFloat denominator;
    CGFloat heightFraction;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
        denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
        heightFraction = numerator / denominator;
    
        if (heightFraction < 0.0) {
            heightFraction = 0.0;
        }
        else if (heightFraction > 1.0) {
            heightFraction = 1.0;
        }
    }
    else /////// PLEASE NOTICE THAT this code is written only for the IPad Landscape Views 
    {
        midline = textFieldRect.origin.x + 0.5 * textFieldRect.size.width;
        numerator = midline - viewRect.origin.x - MINIMUM_SCROLL_FRACTION * viewRect.size.width;
        denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.width;
        heightFraction = numerator / denominator;
        
        if (heightFraction < 0.0)
        {
            heightFraction = 0.0;
        }
        else if (heightFraction > 1.0)
        {
            heightFraction = 1.0;
        }
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            animatedDistance = floor(IPHONE_PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            animatedDistance = floor(IPAD_PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            animatedDistance = floor(IPHONE_LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            animatedDistance = floor(IPAD_LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    NSLog(@"%f",animatedDistance);
    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         ((orientation == UIInterfaceOrientationLandscapeLeft) ||
          (orientation == UIInterfaceOrientationLandscapeRight)) )
    {
        viewFrame.origin.x -= animatedDistance;
    }
    else //iPhone portrait
        viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
          ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) )
    {
        viewFrame.origin.x += animatedDistance;
    }
    else //iPhone portrait
        viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}



#pragma mark -
#pragma mark UITextView Delegate

- (void) textViewDidBeginEditing:(UITextView *)atextView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGRect textViewRect = [self.view.window convertRect:atextView.bounds fromView:atextView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            animatedDistance = floor(IPHONE_PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            animatedDistance = floor(IPAD_PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            animatedDistance = floor(IPHONE_LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            animatedDistance = floor(IPAD_LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         ((orientation == UIInterfaceOrientationLandscapeLeft) ||
          (orientation == UIInterfaceOrientationLandscapeRight)) ) {
        viewFrame.origin.x -= animatedDistance;
    }
    else //iPhone portrait
        viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)atextView {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
          ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) ) {
        viewFrame.origin.x += animatedDistance;
    }
    else //iPhone portrait
        viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIViewController Methods

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return NO;
    else
        return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskPortrait;
    else
        //return (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
        return (UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationPortrait;
    else {
        //return (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        return orientation;
    }
    
}


@end
