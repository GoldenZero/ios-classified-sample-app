//
//  CarAdDetailsViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 14/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarAdDetailsViewController.h"
#import "labelAdViewController.h"

#define FIXED_V_DISTANCE    8
#define FIXED_H_DISTANCE    20

@interface CarAdDetailsViewController (){
    BOOL pageControlUsed;
    MBProgressHUD2 * loadingHUD;
    CarDetails * currentDetailsObject;
    CGFloat originalScrollViewHeight;
}
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)twitterAction:(id)sender;
- (void)facebookAction:(id)sender;
- (void)mailAction:(id)sender;

@end

@implementation CarAdDetailsViewController
@synthesize pageControl,scrollView;
@synthesize currentAdID;

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
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Details_navication_bg.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
    pageControlUsed=NO;
    
    //[self resizeScrollView];
    self.scrollView.delegate=self;
    self.labelsScrollView.delegate = self;
    
    //set the original size of scroll view without loading any labels yet
    originalScrollViewHeight = self.labelsScrollView.frame.size.height;
    
    [self prepareShareButton];
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //set the currentDetailsObject to initial value
    currentDetailsObject = nil;
    
    //show loading indicator
    [self showLoadingIndicator];
    
    //load car details data
    [[CarDetailsManager sharedInstance] loadCarDetailsOfAdID:currentAdID WithDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scroll actions
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (!pageControlUsed) {
        int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
        self.pageControl.currentPage = page;
    }
    
}
#pragma mark - custom acions
- (UIView *) prepareImge : (UIImage*) image : (int) i{
    CGRect frame;
    frame.origin.x=self.scrollView.frame.size.width*i;
    frame.origin.y=0;
    frame.size=self.scrollView.frame.size;
    UIView *subView=[[UIView alloc]initWithFrame:frame];
    [subView setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *imageView=[[UIImageView alloc] init];
    CGRect imageFrame;
    imageFrame.origin.x=10;
    imageFrame.origin.y=10;
    imageFrame.size.width=256;
    imageFrame.size.height=256;
    imageView.frame=imageFrame;
    imageView.image=image;
    
    [subView addSubview:imageView];
    return subView;
    
}

- (void) prepareShareButton{
    UIImage* twitterImage = [UIImage imageNamed:@"Details_button_twitter.png"];
    UIImage* facebookImage = [UIImage imageNamed:@"Details_button_facebook.png"];
    UIImage* mailImage = [UIImage imageNamed:@"Details_button_mail.png"];
    
    
    // create rosette items
    AURosetteItem* twitterItem = [[AURosetteItem alloc] initWithNormalImage:twitterImage
                                                           highlightedImage:nil
                                                                     target:self
                                                                     action:@selector(twitterAction:)];
    
    AURosetteItem* facebookItem = [[AURosetteItem alloc] initWithNormalImage:facebookImage
                                                            highlightedImage:nil
                                                                      target:self
                                                                      action:@selector(facebookAction:)];
    
    AURosetteItem* mailItem = [[AURosetteItem alloc] initWithNormalImage:mailImage
                                                        highlightedImage:nil
                                                                  target:self
                                                                  action:@selector(mailAction:)];
    
    // create rosette view
    AURosetteView* rosette = [[AURosetteView alloc] initWithItems: [NSArray arrayWithObjects: twitterItem, facebookItem, mailItem, nil]];
    [rosette.wheelButton setImage:[UIImage imageNamed:@"Details_button_share.png"] forState:UIControlStateNormal];
    [rosette setCenter:CGPointMake(40.0f, 420.0f)];
    
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(-0.7f);
    
    rosette.transform = transform;
    
    [self.view addSubview:rosette];
    
}

#pragma mark - buttpns actions

- (IBAction)changePage:(id)sender{
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

- (IBAction)labelAdBtnPrss:(id)sender {
    labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)editAdBtnPrss:(id)sender {
}

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMailBtnPrss:(id)sender {
}

- (IBAction)favoriteBtnPrss:(id)sender {
}

- (IBAction)callBtnPrss:(id)sender {
}

#pragma mark - sharing acions
- (void)twitterAction:(id)sender{
    
}

- (void)facebookAction:(id)sender{
    
}

- (void)mailAction:(id)sender{
    
}

#pragma mark - helper methods

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"جاري تحميل البيانات";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = YES;
    
}

- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    loadingHUD = nil;
    
}

- (void) resizeScrollView {
    
    //1- remove all subviews in scroll view, lower than 335 (number is took from nib)
    for (UIView * subview in [self.labelsScrollView subviews]) {
        if (subview.frame.origin.y > 335) {
            [subview removeFromSuperview];
        }
    }
    [self.labelsScrollView setContentSize:(CGSizeMake(self.labelsScrollView.frame.size.width, originalScrollViewHeight))];
    
    
    if (self.currentAdID)
    {
         if ((currentDetailsObject.attributes) && (currentDetailsObject.attributes.count))
         {
             CGFloat addedHeightValue = 20;//initial value, distant from last labels
             
             CGFloat lastY = self.addTimeLabel.frame.origin.y + self.addTimeLabel.frame.size.height;
             
             for (CarDetailsAttribute * attr in currentDetailsObject.attributes)
             {
                 //attr label
                 NSString * attr_name_text = [NSString stringWithFormat:@"%@ :", attr.displayName];
                 CGSize expectedLabelSize =
                 [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15]];
                 
                 CGFloat attr_x = self.labelsScrollView.frame.size.height - (expectedLabelSize.width + FIXED_H_DISTANCE);
                 
                 CGFloat attr_y  = lastY + FIXED_V_DISTANCE;
                 
                 UILabel * attrNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(attr_x, attr_y, expectedLabelSize.width, expectedLabelSize.height)];
                                            
                 attrNameLabel.text = attr_name_text;
                 attrNameLabel.textAlignment = NSTextAlignmentRight;
                 attrNameLabel.font = [UIFont systemFontOfSize:15];
                 
                 //value label
                 CGFloat valueLabelWidth = self.labelsScrollView.frame.size.height - (expectedLabelSize.width + (3 * FIXED_H_DISTANCE));
                 CGFloat valueLabelHeight = expectedLabelSize.height;
                 
                 CGFloat val_x = self.labelsScrollView.frame.size.height - FIXED_H_DISTANCE;
                 CGFloat val_y  = attr_y;
                 
                 UILabel * valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(val_x, val_y, valueLabelWidth, valueLabelHeight)];
                 
                 valuelabel.text = attr.attributeValue;
                 valuelabel.textAlignment = NSTextAlignmentRight;
                 valuelabel.font = [UIFont systemFontOfSize:15];
                 
                 [self.labelsScrollView addSubview:attrNameLabel];
                 [self.labelsScrollView addSubview:valuelabel];
                 
                 lastY = attr_y + valueLabelHeight;
                 addedHeightValue = addedHeightValue + valueLabelHeight;
             }
             
             addedHeightValue = addedHeightValue + FIXED_V_DISTANCE;
             
             self.labelsScrollView.showsHorizontalScrollIndicator = NO;
             self.labelsScrollView.showsVerticalScrollIndicator = NO;
             
             CGFloat totalHeight = self.labelsScrollView.frame.size.height + addedHeightValue;
             
             [self.labelsScrollView setContentSize:(CGSizeMake(self.labelsScrollView.frame.size.width, totalHeight))];
         }
    }
    

    
    /*
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * photosNumber, self.scrollView.frame.size.height);
    self.pageControl.currentPage = 0;
    
    //self.pageControl.numberOfPages = photosNumber;
    
     for (int i=0; i<photosNumber; i++) {
     [self.scrollView addSubview:[self prepareImge:[carPhotos objectAtIndex:i] :i]];
     }*/
}


#pragma mark - carDetailsManager delegate methods

- (void) detailsDidFailLoadingWithError:(NSError *) error {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
    
}

- (void) detailsDidFinishLoadingWithData:(CarDetails *) resultObject {
    
    //1- hide the loading indicator
    [self hideLoadingIndicator];
    
    //2- append the newly loaded ads
    currentDetailsObject = resultObject;
    
    //3- display data
    [self resizeScrollView];
    
    //4- cache the resultArray data
    //... (COME BACK HERE LATER) ...
}
@end
