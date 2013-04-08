//
//  Model.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

#pragma mark - properties
@property (nonatomic) NSInteger modelID;
@property (nonatomic) NSUInteger brandID;
@property (strong, nonatomic) NSString * modelName;

#pragma mark - methods
- (id) initWithModelIDString:(NSString *) aModelIDString
               brandIDString:(NSString *) aBrandIDString
                   modelName:(NSString *) aModelName;
@end