//
//  FBPhotoBrowserViewController.m
//  TryFBBrowser
//
//  Created by Roula Misrabi on 5/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "FBPhotoBrowserViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD2.h"


@interface FBPhotoBrowserViewController ()
{
    CGSize totalSize;
    HJObjManager * asynchImgManager;
    BOOL zoomingOn;
    int currentZoomingPage;
    int currentPageForRotation;
    
    int firstImageID;
    NSArray *photosArray;
    
    MBProgressHUD2 * loadingHUD;
    UIScrollView * currentZoomView;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}
@end

@implementation FBPhotoBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        firstImageID = -1;
        photosArray = [NSArray new];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //bring the done button to front
    _doneBtn.layer.zPosition = 1;
    
    //send the scroll view to back
    [self.view sendSubviewToBack:_photosScrollView];
    
    //customize properties of scroll view
    self.photosScrollView.contentMode = UIViewContentModeCenter;
    [self.photosScrollView setBounces:NO];
    [self.photosScrollView setBouncesZoom:NO];
    [self.photosScrollView setClipsToBounds:YES];
    
    
    //init the photo image manager
    asynchImgManager = [[HJObjManager alloc] init];
	//NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
    NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/gallery/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	asynchImgManager.fileCache = fileCache;
    
    zoomingOn = NO;
    currentZoomingPage = -1;
    currentPageForRotation = -1;
    
    //initially, set the scrollView to hidden until we have at least one image size cached
    [self.photosScrollView setHidden:YES];
    [self showLoadingIndicator];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self customizeScrollForPhotos];
    
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
    
    if (self.photosScrollView.isHidden) {
        [self.photosScrollView setHidden:NO];
        [self hideLoadingIndicator];
        [self.activityView setHidden:YES];
        
    }
    
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setShowingFBBrowser:NO];
    if ([self.presentingViewController respondsToSelector:@selector(resetGalleryViewToNil)])
        [self.presentingViewController performSelector:@selector(resetGalleryViewToNil) withObject:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    int page = self.photosScrollView.contentOffset.x / self.photosScrollView.frame.size.width;
    currentPageForRotation = page;
    
    if (self.photosScrollView.subviews && self.photosScrollView.subviews.count) {
        
        for (int i = 0; i < self.photosScrollView.subviews.count; i++) {
            UIScrollView * scroll = (UIScrollView *)self.photosScrollView.subviews[i];
            if (scroll.zoomScale != 1.0) {
                [scroll setZoomScale:1.0];
            }
        }
    }
    
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    CGFloat totalWidth = 0;
    CGSize theContentSize  = CGSizeZero;
    
    CGRect frameToScroll = CGRectZero;
    CGPoint offsetToScroll = CGPointZero;
    
    
    if (self.photosScrollView.subviews && self.photosScrollView.subviews.count) {
        
        for (int i = 0; i < self.photosScrollView.subviews.count; i++) {
            UIScrollView * scroll = (UIScrollView *)self.photosScrollView.subviews[i];
            
            CGRect frame = scroll.frame;
            
            //update the size if image is set
            
            //try to get sizes from cache
            NSString * correctURLstring = [[(NSURL *)[(HJManagedImageV *)scroll.subviews[0] url] absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
            
            NSString * imageFileName = [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
            NSString * imageFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], imageFileName];
            
            
            CGSize imageSize;
            NSData *archiveData = [NSData dataWithContentsOfFile:imageFilePath];
            if (archiveData)
            {
                NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
                
                if (!dataDict)
                {
                    
                    imageSize = CGSizeZero;
                    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                        
                        dispatch_async( dispatch_get_main_queue(), ^(void){
                            UIImage *theImage = [UIImage imageWithData:imageData];
                            CGSize theImageSize = theImage.size;
                            [self customizeScrollForPhotoAtIndex:i withImageSize:theImageSize];
                        });
                    });
                }
                else
                {
                    float w = [(NSNumber *)[dataDict objectForKey:@"width"] floatValue];
                    float h = [(NSNumber *)[dataDict objectForKey:@"height"] floatValue];
                    imageSize = CGSizeMake(w, h);
                }
                
            }
            else {
                
                imageSize = CGSizeZero;
                dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                    
                    dispatch_async( dispatch_get_main_queue(), ^(void){
                        UIImage *theImage = [UIImage imageWithData:imageData];
                        CGSize theImageSize = theImage.size;
                        [self customizeScrollForPhotoAtIndex:i withImageSize:theImageSize];
                    });
                });
            }
            

            frame.size = [GenericMethods size:imageSize constrainedToSize:(CGSizeMake(self.photosScrollView.frame.size.width - 20, self.photosScrollView.frame.size.height))];

            
            
            frame.origin.x = totalWidth + ( 0.5 * (self.photosScrollView.frame.size.width - frame.size.width));
            //frame.origin.x = totalWidth + 10;
            frame.origin.y = 0.5 * (self.photosScrollView.frame.size.height - frame.size.height);
            
            [UIView animateWithDuration:0.5f animations:^{
                
                [scroll setFrame:frame];
                [scroll setContentSize:scroll.frame.size];
            }];
            
            
            totalWidth = totalWidth + scroll.frame.size.width + (self.photosScrollView.frame.size.width - frame.size.width) ;
            
            if (i == currentPageForRotation) {
                frameToScroll = frame;
                offsetToScroll.x = frame.origin.x - ( 0.5 * (self.photosScrollView.frame.size.width - frame.size.width));;
                offsetToScroll.y = 0;
            }
        }
        
        theContentSize = CGSizeMake(totalWidth, self.photosScrollView.frame.size.height);
        
        [self.photosScrollView setContentSize:CGSizeMake(theContentSize.width, theContentSize.height)];
        
       
        [self.photosScrollView setContentOffset:offsetToScroll animated:YES];
    }
    
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (void) setPhotosArray:(NSArray *) photos firstImageID:(NSInteger) index {
    photosArray = [NSArray arrayWithArray:photos];
    firstImageID = index;
}

- (void) customizeScrollForPhotos {
    
    totalSize = CGSizeMake(0, self.photosScrollView.frame.size.height);
    
    CGFloat singleHeight = 0;
    CGFloat singleWidth = 0;
    
    for (int i = 0; i < photosArray.count; i++)
    {
        CGRect frame;
        HJManagedImageV * imgV;
        
        
        //try to get sizes from cache
        NSString * correctURLstring = [[(NSURL *)[photosArray objectAtIndex:i] absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
        
        NSString * imageFileName = [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
        NSString * imageFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], imageFileName];
        
        
        CGSize imageSize;
        NSData *archiveData = [NSData dataWithContentsOfFile:imageFilePath];
        if (archiveData)
        {
            NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
            
            if (!dataDict)
            {
                
                imageSize = CGSizeZero;
                dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:(NSURL *)[photosArray objectAtIndex:i]];
                    
                    dispatch_async( dispatch_get_main_queue(), ^(void){
                        UIImage *theImage = [UIImage imageWithData:imageData];
                        CGSize theImageSize = theImage.size;
                        [self customizeScrollForPhotoAtIndex:i withImageSize:theImageSize];
                    });
                });
            }
            else
            {
                if (self.photosScrollView.isHidden)
                {
                    [self.photosScrollView setHidden:NO];
                    [self hideLoadingIndicator];
                    [self.activityView setHidden:YES];
                    
                }
                
                float w = [(NSNumber *)[dataDict objectForKey:@"width"] floatValue];
                float h = [(NSNumber *)[dataDict objectForKey:@"height"] floatValue];
                imageSize = CGSizeMake(w, h);
            }
            
        }
        else {
            
            imageSize = CGSizeZero;
            dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
                
                NSData *imageData = [NSData dataWithContentsOfURL:(NSURL *)[photosArray objectAtIndex:i]];
                
                dispatch_async( dispatch_get_main_queue(), ^(void){
                    UIImage *theImage = [UIImage imageWithData:imageData];
                    CGSize theImageSize = theImage.size;
                    [self customizeScrollForPhotoAtIndex:i withImageSize:theImageSize];
                });
            });
            
        }
        
        CGSize constraintSize = self.photosScrollView.frame.size;
        constraintSize.width = constraintSize.width - 20;
        
        
        frame.size = [GenericMethods size:imageSize constrainedToSize:constraintSize];
        
        frame.origin.x = totalSize.width + ( 0.5 * (self.photosScrollView.frame.size.width - frame.size.width));
        frame.origin.y = 0.5 * (self.photosScrollView.frame.size.height - frame.size.height);
        
        UIScrollView * scrView = [[UIScrollView alloc] initWithFrame:frame];
        imgV = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        singleHeight = imgV.frame.size.height;
        singleWidth = imgV.frame.size.width;
        
        
        imgV.backgroundColor = [UIColor blackColor];
        imgV.imageView.backgroundColor = [UIColor blackColor];
        
        //set the image
        [imgV clear];
        imgV.url = (NSURL *)[photosArray objectAtIndex:i];
        [imgV showLoadingWheel];
        imgV.loadingWheel.color = [UIColor whiteColor];
        [asynchImgManager manage:imgV];
        
        imgV.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight);
        
        [imgV setContentMode:UIViewContentModeScaleAspectFit];
        [imgV setClipsToBounds:NO];
        
        scrView.delegate = self;
        scrView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight |
                                    UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleBottomMargin);
        
        [scrView addSubview:imgV];
        
        scrView.showsHorizontalScrollIndicator = NO;
        scrView.showsVerticalScrollIndicator = NO;
        scrView.backgroundColor = [UIColor blackColor];
        scrView.contentMode = UIViewContentModeCenter;
        scrView.clipsToBounds = NO;
        scrView.minimumZoomScale = 0.5; //50% minimum
        scrView.maximumZoomScale = 2.5; //250% maximum
        scrView.bounces = NO;
        scrView.bouncesZoom = NO;
        
        
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        [scrView setUserInteractionEnabled:YES];
        [scrView addGestureRecognizer:doubleTap];
        
        
        self.photosScrollView.contentMode = UIViewContentModeCenter;
        
        [self.photosScrollView addSubview:scrView];
        
        //totalSize.width = totalSize.width + scrView.frame.size.width + 20;
        totalSize.width = totalSize.width + scrView.frame.size.width + (self.photosScrollView.frame.size.width - frame.size.width) ;
    }
    
    if (self.photosScrollView.isHidden)
    {
        [self.photosScrollView setHidden:NO];
        [self hideLoadingIndicator];
        [self.activityView setHidden:YES];
    }
    
    totalSize.height = self.photosScrollView.frame.size.height;
    
    [self.photosScrollView setContentSize:CGSizeMake(totalSize.width, totalSize.height)];
    
    
    CGRect frame = self.photosScrollView.frame;
    frame.origin.x = frame.size.width * firstImageID + ((self.photosScrollView.frame.size.width - frame.size.width) * 0.5);
    frame.origin.y = 0;
    currentPageForRotation = firstImageID;
    [self.photosScrollView scrollRectToVisible:frame animated:NO];
}

//This method gets called only after image data gets loaded
- (void) customizeScrollForPhotoAtIndex:(int) index withImageSize:(CGSize) imageSize {
    
    totalSize = CGSizeMake(self.photosScrollView.contentSize.width, self.photosScrollView.frame.size.height);
    
    CGFloat singleHeight = 0;
    CGFloat singleWidth = 0;
    
    for (int i = 0; i < photosArray.count; i++)
    {
        if (i == index) {
            CGRect frame;
            HJManagedImageV * imgV;
            
            if (self.photosScrollView.isHidden)
            {
                [self.photosScrollView setHidden:NO];
                [self hideLoadingIndicator];
                [self.activityView setHidden:YES];
                
            }
            
            CGSize constraintSize = self.photosScrollView.frame.size;
            constraintSize.width = constraintSize.width - 20;
            
            frame.size = [GenericMethods size:imageSize constrainedToSize:constraintSize];
            
            frame.origin.x = totalSize.width + ( 0.5 * (self.photosScrollView.frame.size.width - frame.size.width));
            frame.origin.y = 0.5 * (self.photosScrollView.frame.size.height - frame.size.height);
            
            UIScrollView * scrView = [[UIScrollView alloc] initWithFrame:frame];
            imgV = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            
            singleHeight = imgV.frame.size.height;
            singleWidth = imgV.frame.size.width;
            
            
            imgV.backgroundColor = [UIColor blackColor];
            imgV.imageView.backgroundColor = [UIColor blackColor];
            
            //set the image
            [imgV clear];
            imgV.url = (NSURL *)[photosArray objectAtIndex:i];
            [imgV showLoadingWheel];
            imgV.loadingWheel.color = [UIColor whiteColor];
            [asynchImgManager manage:imgV];
            
            imgV.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight);
            
            
            [imgV setContentMode:UIViewContentModeScaleAspectFit];
            [imgV setClipsToBounds:NO];
            
            scrView.delegate = self;
            scrView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleHeight |
                                        UIViewAutoresizingFlexibleLeftMargin |
                                        UIViewAutoresizingFlexibleRightMargin |
                                        UIViewAutoresizingFlexibleTopMargin |
                                        UIViewAutoresizingFlexibleBottomMargin);
            
            [scrView addSubview:imgV];
            
            scrView.showsHorizontalScrollIndicator = NO;
            scrView.showsVerticalScrollIndicator = NO;
            scrView.backgroundColor = [UIColor blackColor];
            scrView.contentMode = UIViewContentModeCenter;
            scrView.clipsToBounds = NO;
            scrView.minimumZoomScale = 0.5; //50% minimum
            scrView.maximumZoomScale = 2.5; //250% maximum
            scrView.bounces = NO;
            scrView.bouncesZoom = NO;
            
            
            UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
            [doubleTap setNumberOfTapsRequired:2];
            
            [scrView setUserInteractionEnabled:YES];
            [scrView addGestureRecognizer:doubleTap];
            
            
            self.photosScrollView.contentMode = UIViewContentModeCenter;
            
            [self.photosScrollView addSubview:scrView];
            
            //totalSize.width = totalSize.width + scrView.frame.size.width + 20;
            totalSize.width = totalSize.width + scrView.frame.size.width + (self.photosScrollView.frame.size.width - frame.size.width) ;
        }
    }
    
    if (self.photosScrollView.isHidden)
    {
        [self.photosScrollView setHidden:NO];
        [self hideLoadingIndicator];
        [self.activityView setHidden:YES];
    }
    
    totalSize.height = self.photosScrollView.frame.size.height;
    
    [self.photosScrollView setContentSize:CGSizeMake(totalSize.width, totalSize.height)];
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer {
    
    int page = self.photosScrollView.contentOffset.x / self.photosScrollView.frame.size.width;
    
    if (self.photosScrollView.subviews && self.photosScrollView.subviews.count)
    {
        //UIScrollView * aScrollView = (UIScrollView *) self.photosScrollView.subviews[page];
        UIScrollView * aScrollView = (UIScrollView *) recognizer.view;
        float scale = aScrollView.zoomScale;
        
        zoomingOn = YES;
        scale += 1.0;
        
        if (scale > 2.0) {
            scale = 1.0;
            zoomingOn = NO;
        }
        
        if (zoomingOn)
            currentZoomingPage = page;
        
        [aScrollView setZoomScale:scale animated:YES];
        
    }
    
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return scrollView.subviews[0];
    
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)_subview{
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.photosScrollView) {
        
        for (int i = 0; i < self.photosScrollView.subviews.count; i++) {
            UIScrollView * scroll = (UIScrollView *)self.photosScrollView.subviews[i];
            
            if (scroll.zoomScale != 1.0) {
                [scroll setZoomScale:1.0];
            }
        }
    }
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)_subview atScale:(float)scale {
    
    currentZoomView = scrollView;
    if (scrollView.zoomScale == 1.0) {
        zoomingOn = NO;
        
        
        CGFloat totalWidth = 0;
        CGSize theContentSize  = CGSizeZero;
        
        CGRect frameToScroll = CGRectZero;
        CGPoint offsetToScroll = CGPointZero;
        
        if (self.photosScrollView.subviews && self.photosScrollView.subviews.count) {
            for (int i = 0; i < self.photosScrollView.subviews.count; i++) {
                UIScrollView * scroll = (UIScrollView *)self.photosScrollView.subviews[i];
                
                CGRect frame = scroll.frame;
                //try to get sizes from cache
                NSString * correctURLstring = [[(NSURL *)[(HJManagedImageV *)scroll.subviews[0] url] absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
                
                NSString * imageFileName = [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
                NSString * imageFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], imageFileName];
                
                
                CGSize imageSize;
                NSData *archiveData = [NSData dataWithContentsOfFile:imageFilePath];
                if (archiveData)
                {
                    NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
                    
                    if (!dataDict)
                    {
                        
                        imageSize = CGSizeZero;
                        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
                            
                            NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                            
                            dispatch_async( dispatch_get_main_queue(), ^(void){
                                UIImage *theImage = [UIImage imageWithData:imageData];
                                CGSize theImageSize = theImage.size;
                                [self customizeScrollForPhotoAtIndex:i withImageSize:theImageSize];
                            });
                        });
                    }
                    else
                    {
                        float w = [(NSNumber *)[dataDict objectForKey:@"width"] floatValue];
                        float h = [(NSNumber *)[dataDict objectForKey:@"height"] floatValue];
                        imageSize = CGSizeMake(w, h);
                    }
                    
                }
                else {
                    
                    imageSize = CGSizeZero;
                    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                        
                        dispatch_async( dispatch_get_main_queue(), ^(void){
                            UIImage *theImage = [UIImage imageWithData:imageData];
                            CGSize theImageSize = theImage.size;
                            [self customizeScrollForPhotoAtIndex:i withImageSize:theImageSize];
                        });
                    });
                }
                
                frame.size = [GenericMethods size:imageSize constrainedToSize:(CGSizeMake(self.photosScrollView.frame.size.width - 20, self.photosScrollView.frame.size.height))];
                
                frame.origin.x = totalWidth + ( 0.5 * (self.photosScrollView.frame.size.width - frame.size.width) );
                
                frame.origin.y = 0.5 * (self.photosScrollView.frame.size.height - frame.size.height);
                
                //[UIView animateWithDuration:0.5f animations:^{
                [scroll setFrame:frame];
                [scroll setContentSize:scroll.frame.size];
                //}];
                
                
                totalWidth = totalWidth + scroll.frame.size.width + (self.photosScrollView.frame.size.width - scroll.frame.size.width) ;
                
                if (scroll == scrollView) {
                    frameToScroll = frame;
                    offsetToScroll.x = frame.origin.x - ( 0.5 * (self.photosScrollView.frame.size.width - frame.size.width));;
                    offsetToScroll.y = 0;
                }
                
            }
            
            float extra = 0.5 * (self.photosScrollView.frame.size.width - [(UIScrollView *)[self.photosScrollView.subviews lastObject] frame].size.width);
            theContentSize = CGSizeMake(totalWidth + extra, self.photosScrollView.frame.size.height);
        }
        
        [self.photosScrollView setContentSize:CGSizeMake(theContentSize.width, theContentSize.height)];
        
        [self.photosScrollView setContentOffset:offsetToScroll animated:NO];
        
    }
    
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

#pragma mark - helper methods

- (void) showLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.activityView animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"";
        loadingHUD.detailsLabelText = @"";
        loadingHUD.dimBackground = NO;
    }
    else {
        iPad_loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
        
        iPad_loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        iPad_loadingView.clipsToBounds = YES;
        iPad_loadingView.layer.cornerRadius = 10.0;
        iPad_loadingView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        
        iPad_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        iPad_activityIndicator.frame = CGRectMake(65, 40, iPad_activityIndicator.bounds.size.width, iPad_activityIndicator.bounds.size.height);
        [iPad_loadingView addSubview:iPad_activityIndicator];
        
        iPad_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        iPad_loadingLabel.backgroundColor = [UIColor clearColor];
        iPad_loadingLabel.textColor = [UIColor whiteColor];
        iPad_loadingLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        iPad_loadingLabel.adjustsFontSizeToFitWidth = YES;
        iPad_loadingLabel.textAlignment = NSTextAlignmentCenter;
        iPad_loadingLabel.text = @"جاري تحميل البيانات";
        [iPad_loadingView addSubview:iPad_loadingLabel];
        
        [self.view addSubview:iPad_loadingView];
        [iPad_activityIndicator startAnimating];
    }
}

- (void) hideLoadingIndicator {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (loadingHUD)
            [MBProgressHUD2 hideHUDForView:self.activityView  animated:YES];
        loadingHUD = nil;
    }
    else {
        if ((iPad_activityIndicator) && (iPad_loadingView)) {
            [iPad_activityIndicator stopAnimating];
            [iPad_loadingView removeFromSuperview];
        }
        iPad_activityIndicator = nil;
        iPad_loadingView = nil;
        iPad_loadingLabel = nil;
    }
    
}

@end
