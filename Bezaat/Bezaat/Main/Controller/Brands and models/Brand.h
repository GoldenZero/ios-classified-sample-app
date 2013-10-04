//
//  Brand.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Brand : NSObject

#pragma mark - properties
@property (nonatomic) NSInteger brandID;
@property (strong, nonatomic) NSString * brandNameAr;
@property (strong, nonatomic) NSString * urlName;//EN name
@property (strong, nonatomic) UIImage * brandImage;
@property (strong, nonatomic) UIImage * brandInvertedImage;
@property (strong, nonatomic) NSArray * models;

#pragma mark - methods
- (id) initWithBrandIDString:(NSString *) aBrandIDString
                 brandNameAr:(NSString *) aBrandNameAr
                     urlName:(NSString *) aUrlName
                  brandImage:(UIImage *) aBrandImage
          brandInvertedImage:(UIImage *) aBrandInvertedImage;
@end
