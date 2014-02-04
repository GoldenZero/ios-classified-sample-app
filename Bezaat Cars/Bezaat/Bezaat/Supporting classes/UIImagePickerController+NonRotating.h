//
//  UIImagePickerController+NonRotating.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/22/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (NonRotating)

- (BOOL)shouldAutorotate;

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation;

- (NSUInteger) supportedInterfaceOrientations;

@end
