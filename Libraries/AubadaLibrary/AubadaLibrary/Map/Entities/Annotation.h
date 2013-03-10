//
//  Annotation.h
//  ClassifiedAds
//
//  Created by Aubada Taljo on 10/4/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subtitle;

- (id) initWithLatitude:(double)latitude longitude:(double)longitude;

@end
