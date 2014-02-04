//
//  AdDetailsManager.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdDetails.h"
#import "CommentOnAd.h"

@protocol AdDetailsManagerDelegate <NSObject>
@required
- (void) detailsDidFailLoadingWithError:(NSError *) error;
- (void) detailsDidFinishLoadingWithData:(AdDetails *) resultObject;
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


@protocol AbuseAdDelegate <NSObject>
@required

- (void) abuseDidFailLoadingWithError:(NSError *) error;
- (void) abuseDidFinishLoadingWithData:(BOOL) result;
@end

@interface AdDetailsManager : NSObject <DataDelegate>

#pragma mark - prperties
@property (strong, nonatomic) id <AdDetailsManagerDelegate> delegate;
@property (strong, nonatomic) id <CommentsDelegate> commentsDel;
@property (strong, nonatomic) id <AbuseAdDelegate> abuseAdDelegate;

@property (nonatomic) NSUInteger commentsPageNumber;
@property (nonatomic) NSUInteger commentsPageSize;

#pragma mark - methods

+ (AdDetailsManager *) sharedInstance;

- (NSUInteger) nextPage;

- (NSUInteger) getCurrentCommentsPageNum;
- (NSUInteger) getCurrentCommentsPageSize;

- (void) setCurrentCommentsPageNum:(NSUInteger) pNum;
- (void) setCurrentCommentsPageSize:(NSUInteger) pSize;
- (void) setCommentsPageSizeToDefault;

- (void) loadCarDetailsOfAdID:(NSUInteger) adID WithDelegate:(id <AdDetailsManagerDelegate>) del;

- (NSString *) getDateDifferenceStringFromDate:(NSDate *) input;

- (void) postCommentForAd:(NSUInteger) adID WithText:(NSString *) commentText WithDelegate:(id <CommentsDelegate>) del;

- (void) getAdCommentsForAd:(NSUInteger) adID OfPage:(NSUInteger) pageNum WithDelegate:(id <CommentsDelegate>) del;

- (void) abuseForAd:(NSUInteger) adID WithReason:(NSInteger) reasonID WithDelegate:(id <AbuseAdDelegate>) del;

@end
