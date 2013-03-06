//
//  CarModel.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This class assumes that a model image is provided inside the app resources.

#import <Foundation/Foundation.h>
#import "ModelBrand.h"

@interface CarModel : NSObject

#pragma mark - properties
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * imageFileName;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) NSArray * brandsArray;

#pragma mark - methods

- (id) initWithName:(NSString *) aName imageFileName:(NSString *) aImageFileName brandsArray:(NSArray *)aBrandsArray;

@end
