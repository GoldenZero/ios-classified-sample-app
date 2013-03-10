//
//  Annotation.m
//  ClassifiedAds
//
//  Created by Aubada Taljo on 10/4/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (id) initWithLatitude:(double)latitude longitude:(double)longitude {
    if (self = [super init]) {
        self.coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)latitude, (CLLocationDegrees)longitude);        
    }
    
    return self;
}

@end
