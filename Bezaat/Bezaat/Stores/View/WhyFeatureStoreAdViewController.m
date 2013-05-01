//
//  WhyFeatureStoreAdViewController.m
//  Bezaat
//
//  Created by GALMarei on 5/1/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "WhyFeatureStoreAdViewController.h"

@interface WhyFeatureStoreAdViewController (){
    BOOL pageControlUsed;
}

@end

@implementation WhyFeatureStoreAdViewController

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
    pageControlUsed=NO;
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    [self.scrollView setContentSize:CGSizeMake(result.width*3, result.height-self.toolBar.frame.size.height - 33)];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [self.scrollView addSubview:[self prepareImge:@"feature.png" :0]];
    [self.scrollView addSubview:[self prepareImge:@"logo.png" :1]];
    [self.scrollView addSubview:[self prepareImge:@"manage.png" :2]];
    
    [super viewDidLoad];
    
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
- (UIView *) prepareImge : (NSString*) imageNAme : (int) i{
    CGRect frame;
    frame.origin.x=self.scrollView.frame.size.width*i;
    frame.origin.y=0;
    frame.size=self.scrollView.frame.size;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image=[UIImage  imageNamed:imageNAme];
    return imageView;
}



#pragma mark - button actions
- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changePage:(id)sender{
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}


@end
