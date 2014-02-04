//
//  CommentsPopUpViewController.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 12/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewCell_iPad.h"
#import "CommentOnAd.h"
#import "AdDetailsManager.h"

@interface CommentsPopUpViewController : UIViewController<CommentsDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSInteger AdID;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property (strong, nonatomic) IBOutlet UITableView *commentTable;

- (IBAction)backInvoked:(id)sender;
- (IBAction)postCommentInvoked:(id)sender;
@end
