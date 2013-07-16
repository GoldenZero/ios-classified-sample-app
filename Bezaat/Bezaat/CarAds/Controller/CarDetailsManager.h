//
//  CarDetailsManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarDetails.h"
#import "CommentOnAd.h"

@protocol CarDetailsManagerDelegate <NSObject>
@required
- (void) detailsDidFailLoadingWithError:(NSError *) error;
- (void) detailsDidFinishLoadingWithData:(CarDetails *) resultObject;
@end

@protocol CommentsDelegate <NSObject>
@required

//post
- (void) commentsDidFailPostingWithError:(NSError *) error;
- (void) commentsDidPostWithData:(CommentOnAd *) resultComment;

//get
- (void) commentsDidFailLoadingWithError:(NSError *) error;
- (void) commentsDidFinishLoadingWithData:(NSArray*) resultArray;
@end

@interface CarDetailsManager : NSObject <DataDelegate>

#pragma mark - prperties
@property (strong, nonatomic) id <CarDetailsManagerDelegate> delegate;
@property (strong, nonatomic) id <CommentsDelegate> commentsDel;

#pragma mark - methods

+ (CarDetailsManager *) sharedInstance;

- (void) loadCarDetailsOfAdID:(NSUInteger) adID WithDelegate:(id <CarDetailsManagerDelegate>) del;

- (NSString *) getDateDifferenceStringFromDate:(NSDate *) input;

- (void) postCommentForAd:(NSUInteger) adID WithText:(NSString *) commentText WithDelegate:(id <CommentsDelegate>) del;
@end
