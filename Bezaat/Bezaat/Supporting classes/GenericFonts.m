//
//  GenericFonts.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/13/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GenericFonts.h"

@implementation GenericFonts

static SFFontRef WinsoftBItalFont22;    //Bold Italic 22
static SFFontRef WinsoftBoldFont22;     //Bold 22
static SFFontRef WinsoftMItalFont22;    //Medium Italic 22
static SFFontRef WinsoftMedFont22;      //Medium 22

+(SFFontRef) getWinsoftBItalFont22 {
    
    if (!WinsoftBItalFont22)
        WinsoftBItalFont22 = SFFontCreateWithFileName((CFStringRef)@"WinSoftPro-BItal", (CFStringRef)@"otf", 22);
    
    return WinsoftBItalFont22;
}

+(SFFontRef) getWinsoftBoldFont22 {
    
    if (!WinsoftBoldFont22)
        WinsoftBoldFont22 = SFFontCreateWithFileName((CFStringRef)@"WinSoftPro-Bold", (CFStringRef)@"otf", 22);
    
    return WinsoftBoldFont22;
}

+(SFFontRef) getWinsoftMItalFont22 {
    
    if (!WinsoftMItalFont22)
        WinsoftMItalFont22 = SFFontCreateWithFileName((CFStringRef)@"WinSoftPro-MItal", (CFStringRef)@"otf", 22);
    
    return WinsoftMItalFont22;
}

+(SFFontRef) getWinsoftMedFont22 {
    
    if (!WinsoftMedFont22)
        WinsoftMedFont22 = SFFontCreateWithFileName((CFStringRef)@"WinSoftPro-Med", (CFStringRef)@"otf", 22);

    return WinsoftMedFont22;
}

@end
