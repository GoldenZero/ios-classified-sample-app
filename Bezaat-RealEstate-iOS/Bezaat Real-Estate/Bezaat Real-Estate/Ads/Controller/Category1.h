//
//  Category1.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/14/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category1 : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger categoryID;
@property (strong, nonatomic) NSString * categoryName;
@property (strong, nonatomic) NSString * categoryNameEn;
@property (nonatomic) NSUInteger ActiveAdsCount;

#pragma mark - methods
- (id) initWithcategoryIDString:(NSString *) aCategoryIDString
                   categoryName:(NSString *) aCategoryName
                 categoryNameEn:(NSString *) aCategoryNameEn;
@end
