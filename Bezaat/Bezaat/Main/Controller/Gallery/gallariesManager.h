//
//  gallariesManager.h
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
@protocol GallariesManagerDelegate <NSObject>
@required
- (void) didFinishLoadingWithData:(NSArray*) resultArray;
@end
*/

@protocol GalleriesDelegate <NSObject>
@required

- (void) galleriesDidFailLoadingWithError:(NSError *) error;
- (void) galleriesDidFinishLoadingWithData:(NSArray*) resultArray;

@end

@protocol CarsInGalleryDelegate <NSObject>
@required

- (void) carsDidFailLoadingWithError:(NSError *) error;
- (void) carsDidFinishLoadingWithData:(NSArray*) resultArray;

@end


@protocol CommentsDelegate <NSObject>
@required

//post
- (void) commentsDidFailPostingWithError:(NSError *) error;
- (void) commentsDidPostWithData:(NSArray *) resultArray;

//get
- (void) commentsDidFailLoadingWithError:(NSError *) error;
- (void) commentsDidFinishLoadingWithData:(NSArray*) resultArray;
@end


@interface gallariesManager : NSObject <DataDelegate>

#pragma mark - properties
@property (strong, nonatomic) id <GalleriesDelegate> galleriesDel;
@property (strong, nonatomic) id <CarsInGalleryDelegate> carsDel;
@property (strong, nonatomic) id <CommentsDelegate> commentsDel;

#pragma mark - methods

+ (gallariesManager *) sharedInstance;

- (void) getGallariesInCountry:(NSInteger) countryID WithDelegate:(id <GalleriesDelegate>) del;

- (NSArray*) getCarsInGalleryWithDelegateOfPage:(NSUInteger) pageNum forStore:(NSUInteger) storeID Country:(NSInteger) counttryID pageSize:(NSUInteger) pageSize WithDelegate:(id <CarsInGalleryDelegate>) del;

@end
