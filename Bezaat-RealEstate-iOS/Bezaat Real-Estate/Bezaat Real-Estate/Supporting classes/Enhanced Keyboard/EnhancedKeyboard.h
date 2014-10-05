//
//  KSEnhancedKeyboard.h
//  CustomKeyboardForm
//
//  Created by Krzysztof Satola on 10.12.2012.
//  Copyright (c) 2012 API-SOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

// ====================================================================
@protocol EnhancedKeyboardDelegate


- (void)doneDidTouchDown;

@end

// ====================================================================
@interface EnhancedKeyboard : NSObject

@property (nonatomic, strong) id <EnhancedKeyboardDelegate> delegate;

- (UIToolbar *)getToolbarWithDoneEnabled:(BOOL)doneEnabled;

@end
