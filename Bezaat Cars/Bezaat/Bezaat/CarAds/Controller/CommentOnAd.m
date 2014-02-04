//
//  CommentOnAd.m
//  Bezaat
//
//  Created by Roula Misrabi on 7/16/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CommentOnAd.h"

@implementation CommentOnAd

@synthesize adID;
@synthesize commentID;
@synthesize commentText;
@synthesize postedByID;
@synthesize postedOnDate;
@synthesize userName;

- (id) initWithAdIDString:(NSString *) aAdIDString
          commentIDString:(NSString *) aCommentIDString
        commentTextString:(NSString *) aCommentTextString
         postedByIDString:(NSString *) aPostedByIDString
           postedOnDateString:(NSString *) aPostedOnDateString
           userNameString:(NSString *) aUserNameString {
    
    self = [super init];
    if (self) {
        
        // adID
        self.adID = aAdIDString.integerValue;
        
        // commentID
        self.commentID = aCommentIDString.integerValue;
        
        // commentText
        self.commentText = aCommentTextString;
        
        // postedByID
        self.postedByID = aPostedByIDString.integerValue;
        
        // postedOnDate
        // the JSON date has the style of "\/Date(1356658797343)\/", so it needs custom parsing
        self.postedOnDate = [GenericMethods NSDateFromDotNetJSONString:aPostedOnDateString];
        
        // userName
        self.userName = aUserNameString;
    }
    return self;
}

@end
