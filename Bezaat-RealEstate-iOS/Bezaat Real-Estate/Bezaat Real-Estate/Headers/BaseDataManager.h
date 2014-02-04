//
//  BaseManager.h
//  MajNews
//
//  Created by Aubada Taljo on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataDelegate.h"

@interface BaseDataManager : NSObject

// This is the delegate that will get the data
@property (strong, nonatomic) id <DataDelegate> delegate;

// This is the request tag
@property (nonatomic) int tag;

@end
