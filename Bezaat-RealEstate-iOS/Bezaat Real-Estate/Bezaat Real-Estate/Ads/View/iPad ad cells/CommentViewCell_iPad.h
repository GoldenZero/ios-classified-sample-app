//
//  CommentViewCell_iPad.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 12/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell_iPad : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *postedBy;
@property (strong, nonatomic) IBOutlet UILabel *commentText;
@property (strong, nonatomic) IBOutlet UILabel *commentTime;

@end
