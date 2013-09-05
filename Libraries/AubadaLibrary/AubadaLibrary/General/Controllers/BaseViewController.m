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
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

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
    [sender resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    CGRect textFieldRect = [self.view.window convertRect:aTextField.bounds fromView:aTextField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
          ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) ) {
        viewFrame.origin.x -= 352.0f;//352 is the height of onscreen keyboard on iPad - landscape mode
    }
    else //iPhone portrait
        viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
          ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) ) {
             viewFrame.origin.x += 352.0f;//352 is the height of onscreen keyboard on iPad - landscape mode
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

- (void) textViewDidBeginEditing:(UITextView *)atextView {
    CGRect textViewRect = [self.view.window convertRect:atextView.bounds fromView:atextView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
          ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) ) {
        viewFrame.origin.x -= 352.0f;//352 is the height of onscreen keyboard on iPad - landscape mode
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
    CGRect viewFrame = self.view.frame;
    if  ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
         (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
          ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) ) {
        viewFrame.origin.x += 352.0f;//352 is the height of onscreen keyboard on iPad - landscape mode
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
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
