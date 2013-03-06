//
//  ModelBrand.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBrand : NSObject

#pragma mark - properties
@property (strong, nonatomic) NSString * name;

#pragma mark - methods
- (id) initWithName:(NSString *) aName;
@end