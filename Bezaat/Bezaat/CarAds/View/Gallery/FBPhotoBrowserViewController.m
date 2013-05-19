//
//  FBPhotoBrowserViewController.m
//  TryFBBrowser
//
//  Created by Roula Misrabi on 5/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "FBPhotoBrowserViewController.h"
#import "AppDelegate.h"


@interface FBPhotoBrowserViewController ()
{
    CGSize totalSize;
    UITapGestureRecognizer *doubleTap;
    NSMutableArray * allImageViews;
    HJObjManager * asynchImgManager;
}
@end

@implementation FBPhotoBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //...
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init array
    allImageViews = [NSMutableArray new];
    
    //bring the done button to front
    _doneBtn.layer.zPosition = 1;
    
    //send the scroll view to back
    [self.view sendSubviewToBack:_photosScrollView];
    
    //customize properties of scroll view
    self.photosScrollView.contentMode = UIViewContentModeCenter;
    [self.photosScrollView setBounces:NO];
    [self.photosScrollView setBouncesZoom:NO];
    
    doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.photosScrollView addGestureRecognizer:doubleTap];
    
    //init the photo image manager
    asynchImgManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	asynchImgManager.fileCache = fileCache;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneBtnPressed:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setShowingFBBrowser:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    CGFloat singleHeight = 0;
    CGFloat singleWidth = 0;
    CGSize theContentSize  = CGSizeZero;
    
    if (self.photosScrollView.subviews && self.photosScrollView.subviews.count) {
        singleHeight = ((UIImageView *)self.photosScrollView.subviews[0]).frame.size.height;
        singleWidth = ((UIImageView *)self.photosScrollView.subviews[0]).frame.size.width;
        
        theContentSize = CGSizeMake(singleWidth  * self.photosScrollView.subviews.count, self.photosScrollView.frame.size.height);
    }
    
    [self.photosScrollView setContentSize:CGSizeMake(theContentSize.width, theContentSize.height)];
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (void) customizeScrollForPhotos:(NSArray *) photos firstImageID:(NSInteger) index {
    
    totalSize = CGSizeMake(0, self.photosScrollView.frame.size.height);
    
    CGFloat singleHeight = 0;
    CGFloat singleWidth = 0;
    
    for (int i = 0; i < photos.count; i++)
    {
        CGRect frame;
        HJManagedImageV * imgV;
        //UIImageView * imgV;
        
        frame.origin.x = self.photosScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.photosScrollView.frame.size;
        
        
        UIScrollView * scrView = [[UIScrollView alloc] initWithFrame:frame];
        imgV = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        singleHeight = imgV.frame.size.height;
        singleWidth = imgV.frame.size.width;
        
        
        imgV.backgroundColor = [UIColor clearColor];
        imgV.imageView.backgroundColor = [UIColor clearColor];
        
        //set the image
        [imgV clear];
        imgV.url = (NSURL *)[photos objectAtIndex:i];
        [imgV showLoadingWheel];
        imgV.loadingWheel.color = [UIColor whiteColor];
        [asynchImgManager manage:imgV];
        
        
        //[imgV setImageWithURL:(NSURL *)[photos objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"default-car.jpg"]];
        imgV.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight |
                                 UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin);
        
        [imgV setContentMode:UIViewContentModeScaleAspectFit];
        [imgV setClipsToBounds:NO];
        
        scrView.delegate = self;
        scrView.autoresizingMask = self.photosScrollView.autoresizingMask;
        [scrView addSubview:imgV];
        
        scrView.showsHorizontalScrollIndicator = NO;
        scrView.showsVerticalScrollIndicator = NO;
        scrView.contentMode = UIViewContentModeCenter;
        scrView.clipsToBounds = NO;
        scrView.minimumZoomScale = 0.5; //50% minimum
        scrView.maximumZoomScale = 2.5; //250% maximum
        scrView.bounces = NO;
        scrView.bouncesZoom = NO;
        
        [self.photosScrollView addSubview:scrView];
        totalSize.width = totalSize.width + frame.size.width;
        
        [allImageViews addObject:scrView];
    }
    
    totalSize = CGSizeMake(singleWidth  * self.photosScrollView.subviews.count, self.photosScrollView.frame.size.height);
    
    [self.photosScrollView setContentSize:CGSizeMake(totalSize.width, totalSize.height)];
    
    
    CGRect frame = self.photosScrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [self.photosScrollView scrollRectToVisible:frame animated:YES];
}


- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer {
    
    int page = self.photosScrollView.contentOffset.x / self.photosScrollView.frame.size.width;
    
    if (allImageViews && allImageViews.count)
    {
        UIScrollView * aScrollView = allImageViews[page];
        float scale = aScrollView.zoomScale;
        scale += 1.0;
        if(scale > 2.0)
            scale = 1.0;
        [aScrollView setZoomScale:scale animated:YES];
    }
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return scrollView.subviews[0];
    
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)_subview{
    self.photosScrollView.pagingEnabled = NO;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)_subview atScale:(float)scale{
    self.photosScrollView.pagingEnabled = YES;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end
