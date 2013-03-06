//
//  Country.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface Country : NSObject

#pragma mark - properties
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSArray * citiesArray;

#pragma mark - methods
- (id) initWithName:(NSString *) aName citiesArray:(NSArray *)aCitiesArray;
@end
