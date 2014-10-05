//
//  EnhancedKeyboard.m
//  CustomKeyboardForm
//
//  Created by Krzysztof Satola on 10.12.2012.
//  Copyright (c) 2012 API-SOFT. All rights reserved.
//

#import "EnhancedKeyboard.h"

// ====================================================================
@implementation EnhancedKeyboard

// --------------------------------------------------------------------
- (UIToolbar *)getToolbarWithDoneEnabled:(BOOL)doneEnabled
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbarItems addObject:flexSpace];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(doneDidClick:)];
   // UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButton target:self action:@selector(doneDidClick:)];
    doneButton.title=@"تم";


    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    return toolbar;
}



// --------------------------------------------------------------------
- (void)doneDidClick:(id)sender
{
    if (!self.delegate) return;
    
    //NSLog(@"Done");
    [self.delegate doneDidTouchDown];
}

@end
