//
//  City.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

#pragma mark - properties
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * imageFileName;
@property (strong, nonatomic) UIImage * image;

#pragma mark - methods
- (id) initWithName:(NSString *) aName imageFileName:(NSString *) aImageFileName;

@end
