//
//  CommentCell.m
//  Bezaat
//
//  Created by Roula Misrabi on 7/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "SingleCommentView.h"

@implementation SingleCommentView

static float initial_height = 85;

+ (float) initialHeight {
    return initial_height;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // usernameLabel
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 275, 20)];
        self.usernameLabel.textColor = [UIColor blackColor];
        self.usernameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.usernameLabel.textAlignment = NSTextAlignmentRight;
        self.usernameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.usernameLabel.numberOfLines = 1;
        
        // datelabel
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, 265, 20)];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.font = [UIFont systemFontOfSize:11.0f];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.dateLabel.numberOfLines = 1;
        
        // clockImgV
        self.clockImgV = [[UIImageView alloc] initWithFrame:CGRectMake(277, 46, 12, 12)];
        self.clockImgV.image = [UIImage imageNamed:@"ClockIcon.png"];
        
        // commentTextLabel
        self.commentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 275, self.commentTextHeight)];
        self.commentTextLabel.textColor = [UIColor blackColor];
        self.commentTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.commentTextLabel.textAlignment = NSTextAlignmentRight;
        self.commentTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.commentTextLabel.numberOfLines = 0;
        
        
        [self addSubview:self.usernameLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.clockImgV];
        [self addSubview:self.commentTextLabel];
        
        
        UIImageView * separator = [[UIImageView alloc] initWithFrame:CGRectMake(7, self.frame.size.height - 4, 280, 4)];
        
        //separator.image = [UIImage imageNamed:@"Details_Line.png"];
        separator.image = [UIImage imageNamed:@"black_skipLine.png"];
        
        [self addSubview:separator];
    }
    return self;
    
}

- (id) initWithCommentText:(NSString *) cText {

    CGSize textSize = [cText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.commentTextHeight = textSize.height;
    
    CGRect cellFrame = CGRectMake(0, 0, 295, initial_height + 5 + self.commentTextHeight + 5);
    return [self initWithFrame:cellFrame];

}

@end
