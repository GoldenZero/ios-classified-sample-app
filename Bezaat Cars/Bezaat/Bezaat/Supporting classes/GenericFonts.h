//
//  GenericFonts.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/13/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "SSLabel.h"
//#import "SSFont.h"

@interface GenericFonts : NSObject {
    // This dictionary contains the caching of the loaded fonts with their sizes
    // The key is the fontName|fontSize and the value is the font object SSFont*
    NSMutableDictionary* cache;
}

- (SSFont*)loadFont:(NSString*)fontName withSize:(int)fontSize;
//- (SSLabel*)applyFont:(SSFont*)font toLabel:(SSLabel*)label;

+ (GenericFonts*)sharedInstance;

@end
