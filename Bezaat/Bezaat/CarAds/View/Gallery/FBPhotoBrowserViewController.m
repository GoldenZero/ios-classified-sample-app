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
    /*
     int i = 0;
     BOOL someDataMissed = YES;
     
     while ((someDataMissed) && (i < photosArray.count))
     {
     
     //try to get sizes from cache
     NSString * correctURLstring = [[(NSURL *)[photosArray objectAtIndex:i] absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
     
     NSString * imageFileName = [[correctURLstring componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
     NSString * imageFilePath = [NSString stringWithFormat:@"%@/%@", [GenericMethods getDocumentsDirectoryPath], imageFileName];
     
     
     NSData *archiveData = [NSData dataWithContentsOfFile:imageFilePath];
     if (archiveData)
     {
     NSDictionary * dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
     
     if (!dataDict)
     {
     someDataMissed = YES;
     continue;
     }
     else
     {
     i++;
     if (i == photosArray.count)
     someDataMissed = NO;
     }
     
     }
     else {
     someDataMissed = YES;
     continue;
     }
     }
     
     if (!someDataMissed)
     [self customizeScrollForPhotos];
     */
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
    
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGFloat totalWidth = 0;
    CGSize theContentSize  = CGSizeZero;
    
    CGRect frameToScroll = CGRectZero;
    //NSLog(@"%f",  self.photosScrollView.frame.size.height);
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
                    /*
                    if ([GenericMethods connectedToInternet]) {
                        NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                        UIImage *theImage = [UIImage imageWithData:imageData];
                        imageSize = theImage.size;
                    }
                    else
                        imageSize = CGSizeZero;
                     */
                    
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
                /*
                if ([GenericMethods connectedToInternet]) {
                    NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                    UIImage *theImage = [UIImage imageWithData:imageData];
                    imageSize = theImage.size;
                }
                else
                    imageSize = CGSizeZero;
                 */
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
            }];
            
            
            totalWidth = totalWidth + scroll.frame.size.width + (self.photosScrollView.frame.size.width - frame.size.width) ;
            
            if (i == currentPageForRotation)
                frameToScroll = frame;
        }
        
        theContentSize = CGSizeMake(totalWidth, self.photosScrollView.frame.size.height);
        
        [self.photosScrollView setContentSize:CGSizeMake(theContentSize.width, theContentSize.height)];
        [self.photosScrollView scrollRectToVisible:frameToScroll animated:YES];
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
                /*
                if ([GenericMethods connectedToInternet]) {
                    NSData *imageData = [NSData dataWithContentsOfURL:(NSURL *)[photosArray objectAtIndex:i]];
                    UIImage *theImage = [UIImage imageWithData:imageData];
                    imageSize = theImage.size;
                }
                else
                    imageSize = CGSizeZero;
                 */
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
            /*
            if ([GenericMethods connectedToInternet]) {
                NSData *imageData = [NSData dataWithContentsOfURL:(NSURL *)[photosArray objectAtIndex:i]];
                UIImage *theImage = [UIImage imageWithData:imageData];
                imageSize = theImage.size;
            }
            else
                imageSize = CGSizeZero;
             */
            
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
        
        
        //frame.size = self.photosScrollView.frame.size;
        frame.size = [GenericMethods size:imageSize constrainedToSize:constraintSize];
        //frame.origin.x = (self.photosScrollView.frame.size.width * i) + 10;
        //frame.origin.y = 0.5 * (self.photosScrollView.frame.size.height - frame.size.height);
        //frame.origin.y = 0;
        
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
        
        //imgV.imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
        //UIViewAutoresizingFlexibleHeight);
        
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
            
            
            //frame.size = self.photosScrollView.frame.size;
            frame.size = [GenericMethods size:imageSize constrainedToSize:constraintSize];
            //frame.origin.x = (self.photosScrollView.frame.size.width * i) + 10;
            //frame.origin.y = 0.5 * (self.photosScrollView.frame.size.height - frame.size.height);
            //frame.origin.y = 0;
            
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
            
            //imgV.imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
            //UIViewAutoresizingFlexibleHeight);
            
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
        scale += 1.0;
        if(scale > 2.0)
            scale = 1.0;
        
        zoomingOn = !zoomingOn;
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

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)_subview atScale:(float)scale {
    
    CGFloat totalWidth = 0;
    CGSize theContentSize  = CGSizeZero;
    
    
    if (self.photosScrollView.subviews && self.photosScrollView.subviews.count) {
        for (int i = 0; i < self.photosScrollView.subviews.count; i++) {
            UIScrollView * scroll = (UIScrollView *)self.photosScrollView.subviews[i];
            
            if (!zoomingOn)
            {
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
                        /*
                        if ([GenericMethods connectedToInternet]) {
                            NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                            UIImage *theImage = [UIImage imageWithData:imageData];
                            imageSize = theImage.size;
                        }
                        else
                            imageSize = CGSizeZero;
                         */
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
                    /*
                    if ([GenericMethods connectedToInternet]) {
                        NSData *imageData = [NSData dataWithContentsOfURL:[(HJManagedImageV *)scroll.subviews[0] url]];
                        UIImage *theImage = [UIImage imageWithData:imageData];
                        imageSize = theImage.size;
                    }
                    else
                        imageSize = CGSizeZero;
                     */
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
                
                [UIView animateWithDuration:0.5f animations:^{
                    [scroll setFrame:frame];
                    [scroll setContentSize:scroll.frame.size];
                }];
                
            }
            
            totalWidth = totalWidth + scroll.frame.size.width + (self.photosScrollView.frame.size.width - scroll.frame.size.width) ;
            
        }
        
        float extra = 0.5 * (self.photosScrollView.frame.size.width - [(UIScrollView *)[self.photosScrollView.subviews lastObject] frame].size.width);
        theContentSize = CGSizeMake(totalWidth + extra, self.photosScrollView.frame.size.height);
    }
    
    [self.photosScrollView setContentSize:CGSizeMake(theContentSize.width, theContentSize.height)];
    
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

- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.activityView animated:YES];
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    loadingHUD.labelText = @"";
    loadingHUD.detailsLabelText = @"";
    loadingHUD.dimBackground = NO;
    
}

- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        [MBProgressHUD2 hideHUDForView:self.activityView  animated:YES];
    loadingHUD = nil;
    
}

@end
