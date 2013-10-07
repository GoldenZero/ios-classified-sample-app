//
//  UIImagePickerController+NonRotating.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "UIImagePickerController+NonRotating.h"

@implementation UIImagePickerController (NonRotating)

- (BOOL)shouldAutorotate {
    //return NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return NO;
    else
        return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    //return UIInterfaceOrientationPortrait;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationPortrait;
    else {
        //return (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        return orientation;
    }
}

@end
