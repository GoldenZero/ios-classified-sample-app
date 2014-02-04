//
//  Category1.m
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/14/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "Category1.h"

@implementation Category1
- (id) initWithcategoryIDString:(NSString *)aCategoryIDString
                   categoryName:(NSString *)aCategoryName
                 categoryNameEn:(NSString *)aCategoryNameEn {
    self = [super init];
    if (self) {
        // categoryID
        self.categoryID = aCategoryIDString.integerValue;
        
        // categoryName
        self.categoryName = aCategoryName;
        
        // categoryNameEn
        self.categoryNameEn = aCategoryNameEn;
    }
    return self;
}
@end
