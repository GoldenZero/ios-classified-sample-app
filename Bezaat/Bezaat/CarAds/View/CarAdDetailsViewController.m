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

@interface CarAdDetailsViewController (){
    BOOL pageControlUsed;
    NSUInteger photosNumber;
}
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)twitterAction:(id)sender;
- (void)facebookAction:(id)sender;
- (void)mailAction:(id)sender;

@end

@implementation CarAdDetailsViewController
@synthesize pageControl,scrollView,carPhotos;

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
    photosNumber=carPhotos.count;
    pageControlUsed=NO;
    self.scrollView.delegate=self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * photosNumber, self.scrollView.frame.size.height);
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = photosNumber;
    for (int i=0; i<photosNumber; i++) {
        [self.scrollView addSubview:[self prepareImge:[carPhotos objectAtIndex:i] :i]];
    }
    [self prepareShareButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scroll acions
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


@end
