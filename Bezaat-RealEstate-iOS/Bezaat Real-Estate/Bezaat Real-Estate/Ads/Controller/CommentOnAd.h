//
//  CommentOnAd.h
//  Bezaat
//
//  Created by Roula Misrabi on 7/16/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentOnAd : NSObject

#pragma mark - properties

@property (nonatomic) NSUInteger adID;
@property (nonatomic) NSUInteger commentID;
@property (strong, nonatomic) NSString * commentText;
@property (nonatomic) NSUInteger postedByID;
@property (nonatomic) NSDate * postedOnDate;
@property (strong, nonatomic) NSString * userName;

#pragma mark - methods

- (id) initWithAdIDString:(NSString *) aAdIDString
          commentIDString:(NSString *) aCommentIDString
        commentTextString:(NSString *) aCommentTextString
         postedByIDString:(NSString *) aPostedByIDString
       postedOnDateString:(NSString *) aPostedOnDateString
           userNameString:(NSString *) aUserNameString;
@end
