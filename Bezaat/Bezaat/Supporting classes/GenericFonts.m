//
//  GenericFonts.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/13/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GenericFonts.h"

@implementation GenericFonts

+ (GenericFonts*)sharedInstance {
    static GenericFonts* instance = nil;
    if (instance == nil) {
        instance = [[GenericFonts alloc] init];
    }
    
    return instance;
}

- (id)init {
    if (self = [super init]) {
        cache = [[NSMutableDictionary alloc] initWithCapacity:50];
    }
    
    return self;
}

//- (SSLabel*)applyFont:(SSFont*)font toLabel:(SSLabel*)label {
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor blackColor];
//    label.textAlignment = NSTextAlignmentRight;
//    label.font = font;
//    
//    return label;
//}
//
//// The font for Bezaat is @"ge_ss_two_medium"
//- (SSFont*)loadFont:(NSString*)fontName withSize:(int)fontSize {
//    NSString * path = [[NSBundle mainBundle] pathForResource:fontName ofType:@"ttf"];
//    return [SSFont fontWithPath:path size:fontSize];
//}

@end
