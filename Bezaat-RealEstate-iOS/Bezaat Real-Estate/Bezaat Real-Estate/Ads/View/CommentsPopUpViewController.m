//
//  CommentsPopUpViewController.m
//  Bezaat Real-Estate
//
//  Created by GALMarei on 12/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CommentsPopUpViewController.h"

@interface CommentsPopUpViewController ()
{
    NSMutableArray * commentsArray;
    
}
@end

@implementation CommentsPopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    commentsArray = [NSMutableArray new];
    
    
    [[AdDetailsManager sharedInstance] setCommentsPageSizeToDefault];
    [[AdDetailsManager sharedInstance] setCommentsPageNumber:0];
    [self loadPageOfComments];
    // Do any additional setup after loading the view from its nib.
}

- (void) loadPageOfComments {
    int page = [[AdDetailsManager sharedInstance] nextPage];
    [[AdDetailsManager sharedInstance] getAdCommentsForAd:self.AdID OfPage:page WithDelegate:self];
    
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (commentsArray && commentsArray.count)
        return commentsArray.count;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    
    CommentOnAd* myComment = [commentsArray objectAtIndex:indexPath.row];
    
    CommentViewCell_iPad * cell = [self.commentTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = (CommentViewCell_iPad *)[[[NSBundle mainBundle] loadNibNamed:@"CommentViewCell_iPad" owner:self options:nil] objectAtIndex:0];
    
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    cell.postedBy.text = myComment.userName;
    cell.commentText.text = myComment.commentText;
    cell.commentTime.text = [df stringFromDate:myComment.postedOnDate];
    
    return cell;
}

- (IBAction)postCommentInvoked:(id)sender {
    
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (savedProfile) {
        if ([self.commentText.text isEqualToString:@"أضف تعليقك"]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"الرجاء تعبئة الحقل" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if (self.commentText.text.length > 0) {
            if ([self.commentText.text length] < 10) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"اكتب ما لا يقل عن 10 احرف ولا يزيد عن 500 حرف" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
                //alert.tag = 4;
                [alert show];
                return;
            }
            [self.commentText resignFirstResponder];
            
            [[AdDetailsManager sharedInstance] postCommentForAd:self.AdID WithText:self.commentText.text WithDelegate:self];
        }
        
    }
    else {
        
        [self.commentText resignFirstResponder];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"نعتذر" message:@"يجب أن تسجل الدخول حتى تتمكن من إضافة تعليق" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:@"إلغاء", nil];
        alert.delegate = self;
        alert.tag = 11;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11){
        if (buttonIndex == 0) {
            // sign in
            SignInViewController *vc;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            else
                vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
            
        }else if (buttonIndex == 1)
        {
            // ignore
            alertView.hidden = YES;
        }
        
        
    }
    
}


#pragma mark - Comments Delegate methods

- (void) commentsDidFailLoadingWithError:(NSError *)error {
    // [self hideLoadingIndicator];
}

- (void) commentsDidFinishLoadingWithData:(NSArray *)resultArray {
    if (resultArray && resultArray.count) {
        [commentsArray addObjectsFromArray:resultArray];
        
    }
    
    [self.commentTable reloadData];
    
}

- (void) commentsDidFailPostingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
}

- (void) commentsDidPostWithData:(CommentOnAd *)resultComment {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"تم إضافة تعليقك بنجاح" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
    [alert show];
    self.commentText.text = @"";
}


@end
