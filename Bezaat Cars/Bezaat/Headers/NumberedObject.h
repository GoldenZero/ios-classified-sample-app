//
//  NumberedObject.h
//  ClassifiedAds
//
//  Created by Aubada Taljo on 9/29/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberedObject : NSObject

@property (nonatomic) int ID;

- (id) initWithID:(int)objectID;

@end
