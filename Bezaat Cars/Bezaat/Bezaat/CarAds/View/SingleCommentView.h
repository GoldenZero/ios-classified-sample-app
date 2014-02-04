//
//  CommentCell.h
//  Bezaat
//
//  Created by Roula Misrabi on 7/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//This cell is 85 px height without adding the comment text.
//This cell has dynamic height

@interface SingleCommentView : UIView

@property (strong, nonatomic) UILabel * usernameLabel;
@property (strong, nonatomic) UILabel * dateLabel;
@property (strong, nonatomic) UIImageView * clockImgV;
@property (strong, nonatomic) UILabel * commentTextLabel;

@property (nonatomic) float commentTextHeight;

+ (float) initialHeight;

- (id) initWithCommentText:(NSString *) cText;

@end
