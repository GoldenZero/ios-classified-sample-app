//
//  gallariesManager.h
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GallariesManagerDelegate <NSObject>
@required
- (void) didFinishLoadingWithData:(NSArray*) resultArray;
@end

@interface gallariesManager : NSObject

#pragma mark - properties
@property (strong, nonatomic) id <GallariesManagerDelegate> delegate;
@property  NSInteger *countryID;
#pragma mark - methods
+ (gallariesManager *) sharedInstance;

- (NSArray*) getGallariesWithDelegate:(id <GallariesManagerDelegate>) del;

- (NSArray*) getCarsInGalleryWithDelegateOfPage:(NSUInteger) pageNum forStore:(NSUInteger) storeID Country:(NSInteger) counttryID pageSize:(NSUInteger) pageSize WithDelegate:(id <GallariesManagerDelegate>) del;

@end
