//
//  CarAdDetailsViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Edited by Noor Alssarraj on 14/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "CarAdDetailsViewController.h"
#import "labelAdViewController.h"
#import "EditCarAdViewController.h"
#import "EditCarAdViewController_iPad.h"
#import "EditStoreAdViewController.h"
#import "EditStoreAdViewController_iPad.h"
#import "StoreDetailsViewController.h"
#import "AppDelegate.h"
#import "SendEmailViewController.h"
#import "labelStoreAdViewController_iPad.h"
#import "AddNewCarAdViewController_iPad.h"
#import <MessageUI/MessageUI.h>

//#define FIXED_V_DISTANCE    17
#define FIXED_V_DISTANCE    0
#define FIXED_H_DISTANCE    20

@interface CarAdDetailsViewController (){
    BOOL pageControlUsed;
    MBProgressHUD2 * loadingHUD;
    CarDetails * currentDetailsObject;
    CGFloat originalScrollViewHeight;
    HJObjManager* asynchImgManager;   //asynchronous image loading manager
    //AURosetteView *shareButton;
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tapForDismissKeyBoard;
    
    //NSMutableDictionary * allImagesDict;    //used in image browser
    UILabel * label;
    StoreManager *advFeatureManager;
    BOOL viewIsShown;
    DFPInterstitial *interstitial_;

    FBPhotoBrowserViewController * galleryView;
    float xForShiftingTinyImg;
    BOOL shareBtnDidMoveUp;
    BOOL shareBtnDidMovedown;
    NSMutableArray * commentsArray;
    
    UIButton * loadMoreCommentsBtn;
    NSString* VideoThumb;
    NSURL* VideoURL;
    BOOL postCommentAfterSignIn;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation CarAdDetailsViewController
@synthesize pageControl,scrollView, phoneNumberButton, favoriteButton, featureBtn, editBtn, topMostToolbar,editAdBtn, currentStore;
@synthesize currentAdID,parentVC, secondParentVC, storeParentVC, userDetailsParentVC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization ...
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    interstitial_ = [[DFPInterstitial alloc] init];
    interstitial_.adUnitID = @"a14e1016f9c2470";//@"/1038459/Argaam..App..ios..320x50..news..listing";
    interstitial_.delegate = self;
    [interstitial_ loadRequest:[GADRequest request]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self setPlacesOfViews];
        
        //customize the comments view positioning
        CGRect commentsViewFrame = self.commentsView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568)
            commentsViewFrame.origin.y = 568 - commentsViewFrame.size.height;
        else
            commentsViewFrame.origin.y = self.view.frame.size.height - commentsViewFrame.size.height;
        
        [self.commentsView setFrame:commentsViewFrame];
        
        //customize the comments textView
        self.commentTextView.textColor = [UIColor lightGrayColor];
        self.commentTextView.returnKeyType = UIReturnKeySend;
        
        commentsArray = [NSMutableArray new];
        loadMoreCommentsBtn = nil;
        
        /*
         // hide share button
         tap = [[UITapGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(dismissShareButton)];
         //[self.scrollView addGestureRecognizer:tap];
         [self.labelsScrollView addGestureRecognizer:tap];
         */
        
        tapForDismissKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self.labelsScrollView addGestureRecognizer:tapForDismissKeyBoard];
        
        shareBtnDidMoveUp = NO;
        shareBtnDidMovedown = NO;
        postCommentAfterSignIn = NO;
        
        [editBtn setEnabled:NO];
        [editAdBtn setEnabled:NO];
        [featureBtn setEnabled:NO];
        
        [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
        
        pageControlUsed=NO;
        
        //set attributes for scrollviews
        self.scrollView.delegate=self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        
        self.labelsScrollView.showsHorizontalScrollIndicator = NO;
        self.labelsScrollView.showsVerticalScrollIndicator = NO;
        self.labelsScrollView.bounces = NO;
        self.labelsScrollView.delegate = self;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        advFeatureManager = [[StoreManager alloc] init];
        advFeatureManager.delegate = self;
        
        //init the image load manager
        asynchImgManager = [[HJObjManager alloc] init];
        NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
        HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
        asynchImgManager.fileCache = fileCache;
        
        //set the original size of scroll view without loading any labels yet
        originalScrollViewHeight = self.labelsScrollView.frame.size.height;
        galleryView = nil;
        xForShiftingTinyImg = 0;
    }
    else {
        
        //remove any false subVeiws in left side scroll view
        for (UIView * subView in self.iPad_commentsScrollView.subviews)
            [subView removeFromSuperview];
        
        //customize the comments textView
        self.commentTextView.textColor = [UIColor lightGrayColor];
        self.commentTextView.returnKeyType = UIReturnKeySend;
        
        commentsArray = [NSMutableArray new];
        loadMoreCommentsBtn = nil;
        
        
        tapForDismissKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        //[self.labelsScrollView addGestureRecognizer:tapForDismissKeyBoard];
        [self.view addGestureRecognizer:tapForDismissKeyBoard];
        
        shareBtnDidMoveUp = NO;
        shareBtnDidMovedown = NO;
        postCommentAfterSignIn = NO;
        
        [self.iPad_deleteAdBtn setEnabled:NO];
        [self.iPad_editAdBtn setEnabled:NO];
        [self.iPad_featureBtn setEnabled:NO];
        
        [self.toolBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
        
        pageControlUsed=NO;
        
        //set attributes for scrollviews
        self.scrollView.delegate=self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        
        self.labelsScrollView.showsHorizontalScrollIndicator = NO;
        self.labelsScrollView.bounces = NO;
        self.labelsScrollView.delegate = self;
        
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        advFeatureManager = [[StoreManager alloc] init];
        advFeatureManager.delegate = self;
        
        //init the image load manager
        asynchImgManager = [[HJObjManager alloc] init];
        NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
        HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
        asynchImgManager.fileCache = fileCache;
        
        //set the original size of scroll view without loading any labels yet
        originalScrollViewHeight = self.labelsScrollView.frame.size.height;
        galleryView = nil;
        xForShiftingTinyImg = 0;
        
    }
    
    //[self prepareShareButton];
    
    [self startLoadingData];
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Ad details screen"];
    [TestFlight passCheckpoint:@"Ad details screen"];

    //end GA
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    viewIsShown = YES;
    
    if (postCommentAfterSignIn)
        [self postCommentForCurrentAd:nil];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    viewIsShown = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Banner Ad handlig

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    
    [interstitial_ presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"fail with error :%@",error);
    //[interstitial_ presentFromRootViewController:self];
}


#pragma mark - scroll actions
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //if (sender == self.labelsScrollView)
        //NSLog(@"The content size when scrolling is width:%f --- height:%f", sender.contentSize.width, sender.contentSize.height);
    
    if (sender == self.scrollView) {
        if (!pageControlUsed) {
            int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
            self.pageControl.currentPage = page;
        }
    }
    /*
     if (sender == self.labelsScrollView) {
     float scrollViewHeight = self.labelsScrollView.frame.size.height;
     float scrollContentSizeHeight = self.labelsScrollView.contentSize.height;
     float scrollOffset = self.labelsScrollView.contentOffset.y;
     
     //if ((scrollOffset >= 0) && (scrollOffset < (scrollContentSizeHeight - 60)))
     if (scrollOffset == 0)
     {
     // we are at the top
     if (!shareBtnDidMovedown) {
     CGRect tempFrame = shareButton.frame;
     tempFrame.origin.y = tempFrame.origin.y + 50;
     
     [UIView animateWithDuration:0.8f animations:^{
     [shareButton setFrame:tempFrame];
     }];
     shareBtnDidMovedown = YES;
     shareBtnDidMoveUp = NO;
     }
     
     }
     else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
     {
     // we are at the end
     if (!shareBtnDidMoveUp) {
     CGRect tempFrame = shareButton.frame;
     tempFrame.origin.y = tempFrame.origin.y - 50;
     
     [UIView animateWithDuration:0.8f animations:^{
     [shareButton setFrame:tempFrame];
     }];
     
     shareBtnDidMoveUp = YES;
     shareBtnDidMovedown = NO;
     }
     
     }
     }
     */
    
}

#pragma mark - custom acions
- (UIView *) prepareImge : (NSURL*) imageURL : (int) i{
    CGRect frame;
    frame.origin.x=self.scrollView.frame.size.width*i + 20;
    frame.origin.y=0;
    frame.size=self.scrollView.frame.size;
    
    //update by roula 18-6-2013:
    frame.size.width = frame.size.width - 40;
    UIView *subView=[[UIView alloc]initWithFrame:frame];
    [subView setBackgroundColor:[UIColor clearColor]];
    
    /*
     UIImageView *imageView=[[UIImageView alloc] init];
     CGRect imageFrame;
     imageFrame.origin.x=10;
     imageFrame.origin.y=10;
     imageFrame.size.width=256;
     imageFrame.size.height=256;
     imageView.frame=imageFrame;
     imageView.image=image;
     */
    
    //HJManagedImageV * imageView = [[HJManagedImageV alloc] init];
    UIImageView * imageView = [[UIImageView alloc] init];
    CGRect imageFrame;
    imageFrame.origin.x=0;
    imageFrame.origin.y=0;
    imageFrame.size.width=frame.size.width;
    imageFrame.size.height=frame.size.height;
    imageView.frame=imageFrame;
    
    //[imageView clear];
    [imageView setBackgroundColor:[UIColor clearColor]];
    
    //UIControl *mask = [[UIControl alloc] initWithFrame:imageView.frame];
    //[mask addTarget:self action:@selector(openImgs:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* temp = [currentDetailsObject.thumbnailURL absoluteString];
    
    if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
        imageView.image = [UIImage imageNamed:@"waitForApprove.png"];
    }else {
        /*
         imageView.url = imageURL;
         [imageView showLoadingWheel];
         [asynchImgManager manage:imageView];
         */
        
        //update by roula 18-6-2013:
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.hidden = NO;
        activityIndicator.center = CGPointMake(imageView.frame.size.width /2, imageView.frame.size.height/2);
        
        [imageView addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
        [imageView setImageWithURL:imageURL
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {  [activityIndicator stopAnimating];
                             [activityIndicator removeFromSuperview];}];
    }
    
    /*
     mask.tag = (i+1) * 10;
     [mask addSubview:imageView];
     [subView setUserInteractionEnabled:YES];
     [subView addSubview:mask];
     */
    //set the tag to observe the image ID
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImgs:)];
    subView.tag = (i+1) * 10;
    [subView addGestureRecognizer:imgTap];
    [subView setUserInteractionEnabled:YES];
    [subView addSubview:imageView];
    return subView;
    
}////


-(void)openImgs:(id) sender {
    
    if (currentDetailsObject && currentDetailsObject.adImages && currentDetailsObject.adImages.count) {
        if (!galleryView)
        {
            //if the image is wait for approval, we don't display the gallery
            NSString* temp = [currentDetailsObject.thumbnailURL absoluteString];
            if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                return;
            }
            
            FBPhotoBrowserViewController * vc = [[FBPhotoBrowserViewController alloc] initWithNibName:@"FBPhotoBrowserViewController" bundle:nil];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] setShowingFBBrowser:YES];
            
            NSMutableArray * imgs = [[NSMutableArray alloc] init];
            
            for (CarDetailsImage * image in currentDetailsObject.adImages) {
                [imgs addObject:image.imageURL];
            }
            
            [vc setPhotosArray:imgs firstImageID:self.pageControl.currentPage];
            galleryView = vc;
            [self presentViewController:galleryView animated:YES completion:nil];
        }
    }
    else if (currentDetailsObject) {
        
        if ( ((!currentDetailsObject.adImages) && (currentDetailsObject.thumbnailURL)) || ((!currentDetailsObject.adImages.count) && (currentDetailsObject.thumbnailURL)) ) {
            
            if (!galleryView)
            {
                //if the image is wait for approval, we don't display the gallery
                NSString* temp = [currentDetailsObject.thumbnailURL absoluteString];
                if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
                    return;
                }
                
                FBPhotoBrowserViewController * vc = [[FBPhotoBrowserViewController alloc] initWithNibName:@"FBPhotoBrowserViewController" bundle:nil];
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] setShowingFBBrowser:YES];
                
                NSMutableArray * imgs = [[NSMutableArray alloc] init];
                
                [imgs addObject:currentDetailsObject.thumbnailURL];
                
                [vc setPhotosArray:imgs firstImageID:self.pageControl.currentPage];
                galleryView = vc;
                [self presentViewController:galleryView animated:YES completion:nil];
            }
        }
    }
}

/*
 // flod share button when touch the screen
 - (void)dismissShareButton{
 if ((shareButton.on)) {
 [shareButton fold];
 }
 
 }
 */

- (void) browsePhotos {
    
}

/*
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
 shareButton= [[AURosetteView alloc] initWithItems: [NSArray arrayWithObjects: twitterItem, facebookItem, mailItem, nil]];
 [shareButton.wheelButton setImage:[UIImage imageNamed:@"Details_button_share.png"] forState:UIControlStateNormal];
 if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
 
 {
 CGSize result = [[UIScreen mainScreen] bounds].size;
 if(result.height == 480)
 
 {
 
 shareButton.frame=CGRectMake(35, 440, shareButton.frame.size.width ,shareButton.frame.size.height );
 [shareButton setCenter:CGPointMake(35.0f, 440.0f)];
 }
 
 else
 
 {
 
 shareButton.frame=CGRectMake(35, 530, shareButton.frame.size.width ,shareButton.frame.size.height );
 [shareButton setCenter:CGPointMake(35.0f, 530.0f)];
 
 }
 }
 
 
 
 CGAffineTransform transform =
 CGAffineTransformMakeRotation(-0.7f);
 
 shareButton.transform = transform;
 
 CGRect temp = shareButton.frame;
 //temp.origin.y = temp.origin.y - self.commentsView.frame.size.height;
 temp.origin.y = temp.origin.y - 50;
 [shareButton setFrame:temp];
 
 [self.view insertSubview:shareButton aboveSubview:self.labelsScrollView];
 
 }
 */

#pragma mark - buttons actions

- (IBAction)changePage:(id)sender{
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

- (IBAction)labelAdBtnPrss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Feature Ad"
                         withValue:[NSNumber numberWithInt:100]];
    
    if (currentDetailsObject)
    {
        if (currentStore && (currentDetailsObject.storeID == currentStore.identifier))
        {
            if (currentDetailsObject.isFeatured)
                [self unfeaturecurrentStoreAd:currentAdID];
            else
                [self featurecurrentStoreAd:currentAdID];
        }
        else
        {
            labelAdViewController *vc;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
            else
                vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
            vc.currentAdID = currentAdID;
            vc.countryAdID = currentDetailsObject.countryID;
            vc.currentAdHasImages = NO;
            if (currentDetailsObject.thumbnailURL)
                vc.currentAdHasImages = YES;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (IBAction)editAdBtnPrss:(id)sender {//this is deletion
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Delete Ad"
                         withValue:[NSNumber numberWithInt:100]];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"معلومة" message:@"هل تريد تأكيد حذف هذا الإعلان ؟" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"إلغاء", nil];
    alert.tag = 2;
    [alert show];
}

- (IBAction)modifyAdBtnPrss:(id)sender {
    
    [self showLoadingIndicator];
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Edit Ad"
                         withValue:[NSNumber numberWithInt:100]];
    
    UserProfile* savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    if (savedProfile.hasStores) {
        [[CarAdsManager sharedInstance] requestToEditStoreAdsOfEditID:currentDetailsObject.EncEditID andStore:[NSString stringWithFormat:@"%i",currentDetailsObject.storeID] WithDelegate:self];
    }else {
        // Request To Edit Ad
        [[CarAdsManager sharedInstance] requestToEditAdsOfEditID:currentDetailsObject.EncEditID WithDelegate:self];
    }
}



- (IBAction)backBtnPrss:(id)sender {
    if (self.checkPage) {
        ChooseActionViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController" bundle:nil];
        else
            vc =[[ChooseActionViewController alloc]initWithNibName:@"ChooseActionViewController_iPad" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMailBtnPrss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Send email to Ad owner"
                         withValue:[NSNumber numberWithInt:100]];
    
    if (![currentDetailsObject.emailAddress isEqualToString:@""])
    {
        SendEmailViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            vc=[[SendEmailViewController alloc] initWithNibName:@"SendEmailViewController" bundle:nil];
            vc.DetailsObject = currentDetailsObject;
            
            [self presentViewController:vc animated:YES completion:nil];
        }
        else {
            vc=[[SendEmailViewController alloc] initWithNibName:@"SendEmailViewController_iPad" bundle:nil];
            vc.DetailsObject = currentDetailsObject;

            vc.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:vc animated:YES completion:nil];
            vc.view.superview.frame = CGRectMake(0, 0, 600, 500);
            vc.view.superview.bounds = CGRectMake(0, 0, 600, 500);
            vc.view.superview.center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 2));
        }
        /*
         if ([MFMailComposeViewController canSendMail])
         {
         MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
         mailer.mailComposeDelegate = self;
         
         [mailer setSubject:currentDetailsObject.title];
         
         NSString * mailBody = currentDetailsObject.description;
         
         //set the recipients to the car ad owner
         [mailer setToRecipients:[NSArray arrayWithObjects:currentDetailsObject.emailAddress, nil]];
         
         [mailer setMessageBody:mailBody isHTML:NO];
         mailer.modalPresentationStyle = UIModalPresentationPageSheet;
         [self presentViewController:mailer animated:YES completion:nil];
         }
         
         else {
         [GenericMethods throwAlertWithTitle:@"خطأ" message:@"تعذر إرسال الرسائل الإلكترونية من هذا الجهاز" delegateVC:self];
         }*/
    }else {
        [GenericMethods throwAlertWithTitle:@"خطأ" message:@"للأسف لا يمكنك مراسلة البائع" delegateVC:self];
    }
}

- (IBAction)favoriteBtnPrss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Add to favorites"
                         withValue:[NSNumber numberWithInt:100]];
    
    if (currentDetailsObject)
    {
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if ((savedProfile) && (!self.favoriteButton.hidden))
        {
            if (!currentDetailsObject.isFavorite)
                //add from fav
                [[ProfileManager sharedInstance] addCarAd:currentDetailsObject.adID toFavoritesWithDelegate:self];
            else
                //remove from fav
                [[ProfileManager sharedInstance] removeCarAd:currentDetailsObject.adID fromFavoritesWithDelegate:self];
        }else if (!savedProfile){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"نعتذر" message:@"لإضافة هذا الإعلان إلى المفضلة يجب ان تسجل الدخول" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (IBAction)callBtnPrss:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Call Ad owner"
                         withValue:[NSNumber numberWithInt:100]];
    
    if (currentDetailsObject)
    {
        if ((currentDetailsObject.mobileNumber) && (![currentDetailsObject.mobileNumber isEqualToString:@""]))
        {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"هل تريد الاتصال بهذا الرقم؟\n%@",currentDetailsObject.mobileNumber] delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 101;
            [alert show];
            return;
        }
    }
}

- (IBAction)smsBtnPrss:(id)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"Hello";
		controller.recipients = [NSArray arrayWithObjects:currentDetailsObject.mobileNumber, nil];
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
}

#pragma mark - SMS delegate handler
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"بيزات" message:@"Unknown Error"
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			break;
        }
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - sharing acions
- (IBAction)twitterAction:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Twitter share"
                         withValue:[NSNumber numberWithInt:100]];
    
    //[shareButton fold];
    if (currentDetailsObject)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        else{
            // no twitter account set in device settings
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }
    
}

- (IBAction)facebookAction:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Facebook Share"
                         withValue:[NSNumber numberWithInt:100]];
    
    //[shareButton fold];
    if (currentDetailsObject)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        else{
            // no facebook account set in device settings
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.adURL)
                [mySLComposerSheet addURL:currentDetailsObject.adURL];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }
    
}

- (IBAction)mailAction:(id)sender {
    
    //Event Tracker
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Mail share"
                         withValue:[NSNumber numberWithInt:100]];
    
    //[shareButton fold];
    if (currentDetailsObject)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            
            [mailer setSubject:currentDetailsObject.title];
            
            NSString * mailBody = currentDetailsObject.description;
            
            [mailer setMessageBody:mailBody isHTML:NO];
            mailer.modalPresentationStyle = UIModalPresentationPageSheet;
            [self presentViewController:mailer animated:YES completion:nil];
        }
        else {
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"تعذر إرسال الرسائل الإلكترونية من هذا الجهاز" delegateVC:self];
        }
    }
}

- (void)globeAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[currentDetailsObject adURL]];
}

- (void) reportbadAdAction:(id)sender {
    NSLog(@"report the ad.");
}

#pragma mark - helper methods

- (void) startLoadingData {
    //set the currentDetailsObject to initial value
    currentDetailsObject = nil;
    
    //show loading indicator
    [self showLoadingIndicator];
    
    //load car details data
    [[CarDetailsManager sharedInstance] loadCarDetailsOfAdID:currentAdID WithDelegate:self];
}

- (void) showLoadingIndicator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
        loadingHUD.mode = MBProgressHUDModeIndeterminate2;
        loadingHUD.labelText = @"جاري تحميل البيانات";
        loadingHUD.detailsLabelText = @"";
        loadingHUD.dimBackground = YES;
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
            [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
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

- (void) resizeScrollView {
    
    [self.labelsScrollView setUserInteractionEnabled:YES];
    
    //set the labelsScrollview height to fixed small value to avoid enlarging
    //its frame height on iPhone 5, which causes the view not to scroll if it it larger than its content size
    CGRect nibFrame = self.labelsScrollView.frame;
    nibFrame.size.height = self.view.frame.size.height - self.labelsScrollView.frame.origin.y;
    [self.labelsScrollView setFrame:nibFrame];
    
    /*
     CGFloat lastY = self.addTimeLabel.frame.origin.y + self.addTimeLabel.frame.size.height;
     //1- remove all subviews in scroll view, lower than lastY (number is took from nib)
     for (UIView * subview in [self.labelsScrollView subviews]) {
     if (subview.frame.origin.y > lastY) {
     [subview removeFromSuperview];
     }
     }
     */
    
    if (!currentDetailsObject)
        [self.detailsView setHidden:YES];
    
    if (currentDetailsObject)
    {
        //1- set car images
        if ((currentDetailsObject.adImages) && (currentDetailsObject.adImages.count))
        {
            
            self.pageControl.currentPage = 0;
            self.pageControl.numberOfPages = currentDetailsObject.adImages.count;
            
            [self.scrollView setUserInteractionEnabled:YES];
            
            //allImagesDict = [NSMutableDictionary new];
            for (int i=0; i < currentDetailsObject.adImages.count; i++) {
                
                //1- add images in horizontal scroll view
                NSURL * imgThumbURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] thumbnailImageURL];
                [self.scrollView addSubview:[self prepareImge:imgThumbURL :i]];
                
                /*
                 NSURL * imgURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] thumbnailImageURL];
                 //2- init the dictionary for the image browser
                 [allImagesDict setObject:imgURL.absoluteString forKey:[NSString stringWithFormat:@"%i", (i+1)]];
                 */
            }
            
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setShowsVerticalScrollIndicator:YES];
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * currentDetailsObject.adImages.count, self.scrollView.frame.size.height);
            
        }else {
            if (currentDetailsObject && currentDetailsObject.thumbnailURL) {
                
                self.pageControl.currentPage = 0;
                self.pageControl.numberOfPages = 1;
                
                [self.scrollView addSubview:[self prepareImge:currentDetailsObject.thumbnailURL :0]];
            }
        }
        
        //2- set details
        if (![currentDetailsObject.description isEqualToString:@""]) {
            CGSize realTextSize = [currentDetailsObject.description sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((self.detailsView.frame.size.width - (2 * 5)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize expectedLabelSizeNew = realTextSize;
            expectedLabelSizeNew.width = (self.detailsView.frame.size.width - (2 * 5));
            
            /*
             CGSize expectedLabelSizeNew =
             [currentDetailsObject.description sizeWithFont:[UIFont systemFontOfSize:15] forWidth:(self.detailsView.frame.size.width - (2 * 5)) lineBreakMode:NSLineBreakByWordWrapping];
             if (realTextSize.width >= expectedLabelSizeNew.width)
             {
             int factor = (int) (realTextSize.width / expectedLabelSizeNew.width);
             factor ++;
             expectedLabelSizeNew.height = realTextSize.height * factor;
             }
             */
            label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                              self.detailsTextLabel.frame.origin.x,
                                                              self.detailsTextLabel.frame.origin.y + self.detailsTextLabel.frame.size.height + 5,
                                                              expectedLabelSizeNew.width,
                                                              expectedLabelSizeNew.height)];
            
            
            
            label.text = currentDetailsObject.description;
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.textColor = [UIColor blackColor];
            
            //[label setLineBreakMode:NSLineBreakByWordWrapping];
            [self.detailsView addSubview:label];
            [self.detailsView setScrollEnabled:NO];
            [self.detailsView setShowsVerticalScrollIndicator:NO];
            [self.detailsView setContentSize:(CGSizeMake(self.detailsView.frame.size.width,
                                                         self.detailsTextLabel.frame.origin.x + self.detailsTextLabel.frame.size.height + label.frame.size.height + 10))];
            CGRect detailsVieworiginalFrame = self.detailsView.frame;
            
            
            [self.detailsView setFrame:CGRectMake(detailsVieworiginalFrame.origin.x,
                                                  detailsVieworiginalFrame.origin.y,
                                                  detailsVieworiginalFrame.size.width,
                                                  self.detailsView.contentSize.height)];
        }
        else
            [self.detailsView setHidden:YES];
        
        
        //3- set attributes
        if ((currentDetailsObject.attributes) && (currentDetailsObject.attributes.count))
        {
            CGFloat addedHeightValue = self.contentView.frame.origin.y; //initial value, distant from last labels
            
            CGFloat lastY;
            CGFloat totalHeight;
            if (self.detailsView.isHidden)
            {
                lastY = self.addTimeLabel.frame.origin.y + self.addTimeLabel.frame.size.height + addedHeightValue + 30;
                
                totalHeight = lastY;
            }
            else
            {
                lastY = self.detailsView.frame.origin.y + self.detailsView.frame.size.height + addedHeightValue + 30;
                
                totalHeight = lastY + 20;
            }
            
            //add the shareView dynamically
            ShareView * shareV = (ShareView *)[[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] objectAtIndex:0];
            [shareV.mailBtn addTarget:self action:@selector(mailAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareV.twitterBtn addTarget:self action:@selector(twitterAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareV.facebookBtn addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareV.globeBtn addTarget:self action:@selector(globeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect shareVFrame = shareV.frame;
            shareVFrame.origin.x = 13;
            shareVFrame.origin.y = lastY;
            
            [shareV setFrame:shareVFrame];
            
            lastY = lastY + shareVFrame.size.height + 20;
            totalHeight = lastY + 20;
            
            [self.labelsScrollView addSubview:shareV];
            
            UIView* VideoView;
            for (CarDetailsAttribute * attr in currentDetailsObject.attributes)
            {
                if (attr.categoryAttributeID == 10169){
                    if ([attr.attributeValue length] != 0) {
                    VideoThumb = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/1.jpg",attr.attributeValue];
                    VideoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",attr.attributeValue]];
                    
                    VideoView = [self addOpenVideoViewForX:13 andY:lastY];
                    lastY += 74;
                    totalHeight = totalHeight + 20;
                    [self.labelsScrollView addSubview:VideoView];
                    break;
                    }
                }
                
            }
            
            for (CarDetailsAttribute * attr in currentDetailsObject.attributes)
            {
                if (attr.categoryAttributeID != 502 &&
                    attr.categoryAttributeID != 505 &&
                    attr.categoryAttributeID != 508 &&
                    attr.categoryAttributeID != 907 &&
                    attr.categoryAttributeID != 1076 &&
                    attr.categoryAttributeID != 10171 &&
                    attr.categoryAttributeID != 10169) {
                    
                    if (![attr.attributeValue length] == 0) {
                        
                        //attr label
                        NSString * attr_name_text = [NSString stringWithFormat:@"%@ :", attr.displayName];
                        
                        //CGSize realTextSize = [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15]];
                        CGSize realTextSize = [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(((self.labelsScrollView.frame.size.width - (2 * FIXED_H_DISTANCE)) / 2), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        CGSize expectedLabelSize = realTextSize;
                        /*
                         CGSize expectedLabelSize =
                         [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15] forWidth:((self.labelsScrollView.frame.size.width - (2 * FIXED_H_DISTANCE)) / 2) lineBreakMode:NSLineBreakByWordWrapping];
                         if (realTextSize.width >= expectedLabelSize.width)
                         {
                         int factor = (int) (realTextSize.width / expectedLabelSize.width);
                         factor ++;
                         expectedLabelSize.height = realTextSize.height * factor;
                         }
                         expectedLabelSize.width = ((self.labelsScrollView.frame.size.width - (2 * FIXED_H_DISTANCE)) / 2);
                         */
                        expectedLabelSize.width = ((self.labelsScrollView.frame.size.width - (2 * FIXED_H_DISTANCE)) / 2);
                        
                        expectedLabelSize.height = expectedLabelSize.height + 5;
                        CGFloat attr_y = lastY + FIXED_V_DISTANCE;
                        
                        //value label
                        //CGFloat valueLabelWidth = self.labelsScrollView.frame.size.width - (expectedLabelSize.width + (3 * FIXED_H_DISTANCE));
                        CGFloat valueLabelWidth = ((self.labelsScrollView.frame.size.width - (2 * FIXED_H_DISTANCE)) / 2);
                        CGFloat valueLabelHeight = expectedLabelSize.height;
                        
                        
                        CGFloat val_y = attr_y;
                        UIButton* phoneBtn;
                        if ([attr.displayName isEqualToString:@"رقم الجوال"] || [attr.displayName isEqualToString:@"رقم الهاتف"]) {
                            phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            phoneBtn.frame = CGRectMake(30, 1, 128, 24);
                            // CGSize size = [attr.attributeValue sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(valueLabelWidth + 20, valueLabelHeight) lineBreakMode:UILineBreakModeCharacterWrap];
                            //CGRect frame = CGRectMake(20, 1, size.width, 24);
                            //phoneBtn.frame = frame;
                            [phoneBtn setBackgroundImage:[UIImage imageNamed:@"Phonenum_box.png"] forState:UIControlStateNormal];
                            [phoneBtn addTarget:self action:@selector(callBtnPrss:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        UILabel * valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, valueLabelWidth, valueLabelHeight)];
                        
                        valuelabel.text = attr.attributeValue;
                        valuelabel.textAlignment = NSTextAlignmentRight;
                        valuelabel.font = [UIFont systemFontOfSize:15];
                        valuelabel.textColor = [UIColor colorWithRed:56.0/255 green:127.0/255 blue:161.0/255 alpha:1.0f];
                        valuelabel.backgroundColor = [UIColor clearColor];
                        
                        UILabel * attrNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(valuelabel.frame.origin.x + valueLabelWidth + 3, 2, expectedLabelSize.width, expectedLabelSize.height)];
                        
                        attrNameLabel.text = attr_name_text;
                        attrNameLabel.textAlignment = NSTextAlignmentRight;
                        attrNameLabel.font = [UIFont systemFontOfSize:15];
                        attrNameLabel.backgroundColor = [UIColor clearColor];
                        attrNameLabel.numberOfLines = 0;
                        
                        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(13, val_y, valueLabelWidth + expectedLabelSize.width + 15, valueLabelHeight + 4)];
                        
                        
                        [v setBackgroundColor:[UIColor whiteColor]];
                        if ([attr.displayName isEqualToString:@"رقم الجوال"] || [attr.displayName isEqualToString:@"رقم الهاتف"]){
                            valuelabel.textColor = [UIColor whiteColor];
                            valuelabel.font = [UIFont systemFontOfSize:13];
                            [v addSubview:phoneBtn];
                            
                        }
                        
                        [v addSubview:attrNameLabel];
                        [v addSubview:valuelabel];
                        
                        [self.labelsScrollView addSubview:v];
                        
                        lastY = attr_y + valueLabelHeight;
                        
                        addedHeightValue = addedHeightValue + v.frame.size.height + FIXED_V_DISTANCE;
                        
                        
                    }
                }
            }
            
            totalHeight = totalHeight + addedHeightValue;
            
            [self.labelsScrollView setScrollEnabled:YES];
            [self.labelsScrollView setShowsVerticalScrollIndicator:YES];
            [self.labelsScrollView setContentSize:(CGSizeMake(self.labelsScrollView.frame.size.width, totalHeight))];
        }
    }
    
}

- (void) iPad_resizeScrollView {
    
    //set the labelsScrollview height to fixed small value to avoid enlarging
    //its frame height on iPhone 5, which causes the view not to scroll if it it larger than its content size
    CGRect nibFrame = self.labelsScrollView.frame;
    nibFrame.size.height = self.view.frame.size.height - self.labelsScrollView.frame.origin.y;
    [self.labelsScrollView setFrame:nibFrame];
        
    if (!currentDetailsObject)
        [self.iPad_detailsView setHidden:YES];
    
    if (currentDetailsObject)
    {
        //1- set car images
        if ((currentDetailsObject.adImages) && (currentDetailsObject.adImages.count))
        {
            
            self.pageControl.currentPage = 0;
            self.pageControl.numberOfPages = currentDetailsObject.adImages.count;
            
            [self.scrollView setUserInteractionEnabled:YES];
            
            //allImagesDict = [NSMutableDictionary new];
            for (int i=0; i < currentDetailsObject.adImages.count; i++) {
                
                //1- add images in horizontal scroll view
                NSURL * imgThumbURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] thumbnailImageURL];
                [self.scrollView addSubview:[self prepareImge:imgThumbURL :i]];
                
            }
            
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setShowsVerticalScrollIndicator:YES];
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * currentDetailsObject.adImages.count, self.scrollView.frame.size.height);
            
        }else {
            if (currentDetailsObject && currentDetailsObject.thumbnailURL) {
                
                self.pageControl.currentPage = 0;
                self.pageControl.numberOfPages = 1;
                
                [self.scrollView addSubview:[self prepareImge:currentDetailsObject.thumbnailURL :0]];
            }
        }
        
        //2- set details
        if (![currentDetailsObject.description isEqualToString:@""]) {
            CGSize realTextSize = [currentDetailsObject.description sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((self.iPad_detailsView.frame.size.width - (2 * 5)), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize expectedLabelSizeNew = realTextSize;
            expectedLabelSizeNew.width = (self.iPad_detailsView.frame.size.width - (2 * 5));
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                              self.detailsTextLabel.frame.origin.x,
                                                              self.detailsTextLabel.frame.origin.y + self.detailsTextLabel.frame.size.height + 5,
                                                              expectedLabelSizeNew.width,
                                                              expectedLabelSizeNew.height)];
            
            
            
            label.text = currentDetailsObject.description;
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.textColor = [UIColor blackColor];
            
            //[label setLineBreakMode:NSLineBreakByWordWrapping];
            [self.iPad_detailsView addSubview:label];


            CGRect iPad_detailsVieworiginalFrame = self.iPad_detailsView.frame;
            
            [self.iPad_detailsView setFrame:CGRectMake(iPad_detailsVieworiginalFrame.origin.x,
                                                       iPad_detailsVieworiginalFrame.origin.y,
                                                       iPad_detailsVieworiginalFrame.size.width,
                                                       self.detailsTextLabel.frame.origin.y + self.detailsTextLabel.frame.size.height + label.frame.size.height + 5 + 20)];
            
        }
        else
            [self.iPad_detailsView setHidden:YES];
        
        
        //3- set attributes
        if ((currentDetailsObject.attributes) && (currentDetailsObject.attributes.count))
        {
            //CGFloat addedHeightValue = self.contentView.frame.origin.y; //initial value, distant from last labels
            CGFloat addedHeightValue = 10;
            
            CGFloat lastY;
            CGFloat totalHeight;
            lastY = 10;
            totalHeight = lastY + 20;
            
            
            // add video to left side view
            float lastYleftSide = 0;
            float totalCommentsScrollViewHeight = 0;
             UIView* VideoView;
            for (CarDetailsAttribute * attr in currentDetailsObject.attributes)
            {
                if (attr.categoryAttributeID == 10169){
                    if ([attr.attributeValue length] != 0) {
                        VideoThumb = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/1.jpg",attr.attributeValue];
                        VideoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",attr.attributeValue]];
                        
                        VideoView = [self addOpenVideoViewForX:3 andY:lastYleftSide];
                        lastYleftSide += 64;//54 + 10
                        
                        totalCommentsScrollViewHeight = totalCommentsScrollViewHeight + VideoView.frame.size.height + 10;
                        [self.iPad_commentsScrollView setContentSize:CGSizeMake(self.iPad_commentsScrollView.frame.size.width, totalCommentsScrollViewHeight)];
                        [self.iPad_commentsScrollView addSubview:VideoView];
                        break;
                    }
                }
                
            }
            
            //----------------------------------------------------------------------
            //add the view thah contains "browse ad in browser and report ad"
            UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(3, 0, 296, 50)];
            containerView.backgroundColor = [UIColor clearColor];
            
            UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 50)];
            [bgImgV setImage:[UIImage imageNamed:@"tb_car_details_box_5.png"]];
            [containerView addSubview:bgImgV];
            
            UIButton * reportBadAdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [reportBadAdBtn setFrame:CGRectMake(10, 15, 130, 20)];
            [reportBadAdBtn setImage:[UIImage imageNamed:@"tb_car_details_inform_ads_btn.png"] forState:UIControlStateNormal];
            [reportBadAdBtn addTarget:self action:@selector(reportbadAdAction:) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:reportBadAdBtn];
            
            UIButton * globeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [globeBtn setFrame:CGRectMake(156, 15, 130, 20)];
            [globeBtn setImage:[UIImage imageNamed:@"tb_car_details_browse_btn.png"] forState:UIControlStateNormal];
            [globeBtn addTarget:self action:@selector(globeAction:) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:globeBtn];
            
            totalCommentsScrollViewHeight = totalCommentsScrollViewHeight + containerView.frame.size.height + 10;
            [self.iPad_commentsScrollView setContentSize:CGSizeMake(self.iPad_commentsScrollView.frame.size.width, totalCommentsScrollViewHeight)];
            [self.iPad_commentsScrollView addSubview:containerView];
            //----------------------------------------------------------------------
            
            for (CarDetailsAttribute * attr in currentDetailsObject.attributes)
            {
                if (attr.categoryAttributeID != 502 &&
                    attr.categoryAttributeID != 505 &&
                    attr.categoryAttributeID != 508 &&
                    attr.categoryAttributeID != 907 &&
                    attr.categoryAttributeID != 1076 &&
                    attr.categoryAttributeID != 10171 &&
                    attr.categoryAttributeID != 10169) {
                    
                    if (![attr.attributeValue length] == 0) {
                        
                        //attr label
                        NSString * attr_name_text = [NSString stringWithFormat:@"%@ :", attr.displayName];
                        
                        //CGSize realTextSize = [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15]];
                        CGSize realTextSize = [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((( (self.labelsScrollView.frame.size.width /2) - (2 * FIXED_H_DISTANCE)) / 2), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        CGSize expectedLabelSize = realTextSize;
                        
                        expectedLabelSize.width = (((self.labelsScrollView.frame.size.width /2) - (2 * FIXED_H_DISTANCE)) / 2);
                        
                        expectedLabelSize.height = expectedLabelSize.height + 5;
                        CGFloat attr_y = lastY + FIXED_V_DISTANCE;
                        
                        //value label
                        //CGFloat valueLabelWidth = (self.labelsScrollView.frame.size.width /2) - (expectedLabelSize.width + (3 * FIXED_H_DISTANCE));
                        CGFloat valueLabelWidth = (((self.labelsScrollView.frame.size.width /2) - (2 * FIXED_H_DISTANCE)) / 2);
                        CGFloat valueLabelHeight = expectedLabelSize.height;
                        
                        
                        CGFloat val_y = attr_y;
                        UIButton* phoneBtn;
                        if ([attr.displayName isEqualToString:@"رقم الجوال"] || [attr.displayName isEqualToString:@"رقم الهاتف"]) {
                            phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            //phoneBtn.frame = CGRectMake(30, 1, 128, 24);
                            phoneBtn.frame = CGRectMake(10, 1, valueLabelWidth, 24);
                            // CGSize size = [attr.attributeValue sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(valueLabelWidth + 20, valueLabelHeight) lineBreakMode:UILineBreakModeCharacterWrap];
                            //CGRect frame = CGRectMake(20, 1, size.width, 24);
                            //phoneBtn.frame = frame;
                            [phoneBtn setBackgroundImage:[UIImage imageNamed:@"Phonenum_box.png"] forState:UIControlStateNormal];
                            [phoneBtn addTarget:self action:@selector(callBtnPrss:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        UILabel * valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, valueLabelWidth, valueLabelHeight)];
                        
                        valuelabel.text = attr.attributeValue;
                        valuelabel.textAlignment = NSTextAlignmentRight;
                        valuelabel.font = [UIFont systemFontOfSize:14];
                        valuelabel.textColor = [UIColor colorWithRed:56.0/255 green:127.0/255 blue:161.0/255 alpha:1.0f];
                        valuelabel.backgroundColor = [UIColor clearColor];
                        
                        UILabel * attrNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(valuelabel.frame.origin.x + valueLabelWidth + 3, 2, expectedLabelSize.width, expectedLabelSize.height)];
                        
                        attrNameLabel.text = attr_name_text;
                        attrNameLabel.textAlignment = NSTextAlignmentRight;
                        attrNameLabel.font = [UIFont systemFontOfSize:15];
                        attrNameLabel.backgroundColor = [UIColor clearColor];
                        attrNameLabel.numberOfLines = 0;
                        
                        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(13 + (self.labelsScrollView.frame.size.width /2), val_y, valueLabelWidth + expectedLabelSize.width + 15, valueLabelHeight + 4)];
                        
                        v.backgroundColor = [UIColor clearColor];
                        [v setBackgroundColor:[UIColor whiteColor]];
                        if ([attr.displayName isEqualToString:@"رقم الجوال"] || [attr.displayName isEqualToString:@"رقم الهاتف"]){
                            valuelabel.textColor = [UIColor whiteColor];
                            valuelabel.font = [UIFont systemFontOfSize:13];
                            [v addSubview:phoneBtn];
                            
                        }
                        
                        [v addSubview:attrNameLabel];
                        [v addSubview:valuelabel];
                        
                        
                        lastY = attr_y + valueLabelHeight;
                        
                        addedHeightValue = addedHeightValue + v.frame.size.height + FIXED_V_DISTANCE;
                        
                        [self.labelsScrollView setContentSize:
                         (CGSizeMake(self.labelsScrollView.frame.size.width, ((addedHeightValue > self.iPad_detailsView.frame.size.height + 40) ? addedHeightValue : self.iPad_detailsView.frame.size.height + 40)))];
                        
                        [self.labelsScrollView addSubview:v];
                    }
                }
            }
            
            totalHeight = totalHeight + addedHeightValue;
            
            [self.labelsScrollView setScrollEnabled:YES];
            [self.labelsScrollView setShowsVerticalScrollIndicator:YES];
            [self.labelsScrollView setUserInteractionEnabled:YES];
            /*
            [self.labelsScrollView setContentSize:
             (CGSizeMake(self.labelsScrollView.frame.size.width, ((totalHeight > self.iPad_detailsView.frame.size.height + 40) ? totalHeight : self.iPad_detailsView.frame.size.height + 40)))];
             */
            //NSLog(@"%f", self.labelsScrollView.contentSize.height);
        }
    }
    
    
}

- (void) customizeButtonsByData {
    
    if (currentDetailsObject)
    {
        if ((currentDetailsObject.mobileNumber) && (![currentDetailsObject.mobileNumber isEqualToString:@""]))
            [self.phoneNumberButton setEnabled:YES];
        else
            [self.phoneNumberButton setEnabled:NO];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (currentDetailsObject.isFeatured)
            {
                if (currentStore && (currentDetailsObject.storeID == currentStore.identifier))
                {
                    //set the design to deleted $;
                    [self.featureBtn setEnabled:YES];
                    [self.featureBtn setImage:[UIImage imageNamed:@"buttons_dollar_deleted.png"]];
                }
                else
                    [self.featureBtn setEnabled:NO];
            }
            else
            {
                [self.featureBtn setImage:[UIImage imageNamed:@"buttons_ok.png"]];
                [self.featureBtn setEnabled:YES];
            }
        }
        else {
            if (currentDetailsObject.isFeatured)
            {
                [self.iPad_featureBtn setEnabled:NO];
                [self.iPad_isFeaturedTinyImg setHidden:NO];
            }
            else
            {
                [self.iPad_featureBtn setEnabled:YES];
                [self.iPad_isFeaturedTinyImg setHidden:YES];
            }
        }
        
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if(savedProfile){
            [self.favoriteButton setEnabled:YES];
            
            // Check favorite
            if (currentDetailsObject.isFavorite) {
                [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
            }
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                // check if he own the Ad
                if (savedProfile.userID == currentDetailsObject.ownerID){
                    [self.editBtn setEnabled:YES];
                    [self.editAdBtn setEnabled:YES];
                } else {
                    [self.editBtn setEnabled:NO];
                    [self.editAdBtn setEnabled:NO];
                }
            }
            else {
                
                // check if he own the Ad
                if (savedProfile.userID == currentDetailsObject.ownerID){
                    [self.iPad_deleteAdBtn setEnabled:YES];
                    [self.iPad_editAdBtn setEnabled:YES];
                } else {
                    [self.iPad_featureBtn setHidden:YES];
                    [self.iPad_deleteAdBtn setHidden:YES];
                    [self.iPad_editAdBtn setHidden:YES];
                }
                
            }
        }else {
            [self.favoriteButton setEnabled:YES];
        }
        
        if ((!savedProfile) || ((savedProfile) && (savedProfile.userID != currentDetailsObject.ownerID)))
        {
            NSMutableArray * newItems = [NSMutableArray new];
            for (UIBarButtonItem * item in self.topMostToolbar.items)
            {
                // the edit button is marked by tag = 1
                if ((item.tag != 1)&&(item.tag!=2))
                    [newItems addObject:item];
            }
            [self.topMostToolbar setItems:newItems];
        }

        // Check labeld ad
        if (currentDetailsObject.isFeatured) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self.distinguishingImage setHidden:NO];
                //NSLog(@"%c",currentDetailsObject.isFeatured);
                [self.backgroundImage setImage:[UIImage imageNamed:@"Details_bg_Sp.png"]];
                // [self.priceLabel setTextColor:[UIColor colorWithRed:56.0/255 green:127.0/255 blue:161.0/255 alpha:1.0f]];
                [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
                [self.bgStoreView setImage:[UIImage imageNamed:@"Details_bar_Sp.png"]];
            }
            else {
                [self.distinguishingImage setHidden:NO];
                //NSLog(@"%c",currentDetailsObject.isFeatured);
                [self.backgroundImage setImage:[UIImage imageNamed:@"tb_car_details_background.png"]];
                // [self.priceLabel setTextColor:[UIColor colorWithRed:56.0/255 green:127.0/255 blue:161.0/255 alpha:1.0f]];
                [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
                [self.bgStoreView setImage:[UIImage imageNamed:@"tb_car_details_boxes_orange1.png"]];
            }
            
        }
        
        else
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                //[self.distinguishingImage setHidden:YES];
                
                [self.backgroundImage setImage:[UIImage imageNamed:@"Details_bg.png"]];
                
                [self.pageControl setCurrentPageIndicatorTintColor:[UIColor lightGrayColor]];
                [self.bgStoreView setImage:[UIImage imageNamed:@"Details_bar.png"]];
            }
            else {
                [self.backgroundImage setImage:[UIImage imageNamed:@"tb_car_details_blue_background.png"]];
                
                [self.pageControl setCurrentPageIndicatorTintColor:[UIColor lightGrayColor]];
                [self.bgStoreView setImage:[UIImage imageNamed:@"tb_car_details_boxes_blue1.png"]];
            }
        }
        
        // Check store
        if (currentDetailsObject.storeID!=0) {
            if (currentDetailsObject.isFeatured)
                [self.backgroundImage setImage:[UIImage imageNamed:@"Details_bg_Sp.png"]];
            else
                [self.backgroundImage setImage:[UIImage imageNamed:@"Details_bg_blue.png"]];
            
            [self.storeView setHidden:NO];
            self.contentView.frame=CGRectMake(0,124 ,self.contentView.frame.size.width , self.contentView.frame.size.height);
            
            [self.nameStoreLabel setBackgroundColor:[UIColor clearColor]];
            [self.nameStoreLabel setText:currentDetailsObject.storeName];
            [self.nameStoreLabel setTextAlignment:SSTextAlignmentRight];
            [self.nameStoreLabel setTextColor:[UIColor grayColor]];
            [self.nameStoreLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:16.0] ];
            
            [self.viewInStoreLabel setBackgroundColor:[UIColor clearColor]];
            [self.viewInStoreLabel setText:@"معروض في متجر"];
            [self.viewInStoreLabel setTextAlignment:SSTextAlignmentRight];
            [self.viewInStoreLabel setTextColor:[UIColor grayColor]];
            [self.viewInStoreLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:16.0] ];
            
            NSURL* aURL = currentDetailsObject.storeLogoURL;
            //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
            if (aURL)
                [self.brandStoreImg setImageWithURL:aURL];
            
        }
        if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if ( (!savedProfile) || ((savedProfile) && (savedProfile.userID != currentDetailsObject.ownerID)) ) {
                
                //move the bottomLeftView up and hide the buttons of editing teh ad
                float newY = self.iPad_topLeftSideView.frame.origin.y + (self.iPad_topLeftSideView.frame.size.height /2);
                
                CGRect newBottomLeftFrame = self.iPad_bottomLeftSideView.frame;
                float yDiff = newBottomLeftFrame.origin.y - newY;
                newBottomLeftFrame.origin.y = newY;
                newBottomLeftFrame.size.height = newBottomLeftFrame.size.height + yDiff;
                
                //CGRect newCommentsViewFrame = self.commentsView.frame;
                //newCommentsViewFrame.origin.y = newCommentsViewFrame.origin.y + yDiff;
                
                CGRect newCommentsScrollViewFrame = self.iPad_commentsScrollView.frame;
                newCommentsScrollViewFrame.origin.y = 0;
                newCommentsScrollViewFrame.size.height = newCommentsScrollViewFrame.size.height + yDiff;
                [UIView animateWithDuration:0.1f animations:^{
                    [self.iPad_bottomLeftSideView setFrame:newBottomLeftFrame];
                    //[self.commentsView setFrame:newCommentsViewFrame];
                    [self.iPad_commentsScrollView setFrame:newCommentsScrollViewFrame];
                }];
                

            }
        }
    }

}

#pragma mark - carDetailsManager delegate methods

- (void) detailsDidFailLoadingWithError:(NSError *) error {
    
    //[GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
    
}

- (void) detailsDidFinishLoadingWithData:(CarDetails *) resultObject {
    
    //1- hide the loading indicator
    //[self hideLoadingIndicator];
    
    //2- append the newly loaded ads
    currentDetailsObject = resultObject;
    
    //3- display data
    if (currentDetailsObject)
    {
        NSMutableArray * URLsToPrefetch = [NSMutableArray new];
        for (int i=0; i < currentDetailsObject.adImages.count; i++) {
            //1- add images in horizontal scroll view
            NSURL * imgThumbURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] thumbnailImageURL];
            
            if (imgThumbURL)
                [URLsToPrefetch addObject:[NSURL URLWithString:imgThumbURL.absoluteString]];
        }
        SDWebImagePrefetcher * prefetcher = [[SDWebImagePrefetcher alloc] init];
        [prefetcher prefetchURLs:URLsToPrefetch];
        
        
        
        [self.detailsLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailsLabel setText:currentDetailsObject.title];
        [self.detailsLabel setTextAlignment:SSTextAlignmentRight];
        [self.detailsLabel setTextColor:[UIColor blackColor]];
        [self.detailsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 14.0 : 20.0f)] ];
        
        
        [self.priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.priceLabel setTextAlignment:((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? SSTextAlignmentLeft : SSTextAlignmentCenter)];
        [self.priceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
        [self.priceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 13.0 : 26.0f)] ];
        
        NSString * priceStr = [GenericMethods formatPrice:currentDetailsObject.price];
        if ([priceStr isEqualToString:@""])
            self.priceLabel.text = priceStr;
        else
            self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, currentDetailsObject.currencyString];
        
        self.addTimeLabel.text = [[CarDetailsManager sharedInstance] getDateDifferenceStringFromDate:currentDetailsObject.postedOnDate];
        
        if (currentDetailsObject.modelYear > 0)
            self.yearMiniLabel.text = [NSString stringWithFormat:@"%i", currentDetailsObject.modelYear];
        else {
            xForShiftingTinyImg = self.yearMiniImg.frame.origin.x;
            
            self.yearMiniLabel.hidden = YES;
            self.yearMiniImg.hidden = YES;
        }
        
        
        if (xForShiftingTinyImg > 0) {
            CGRect tempLabelFrame = self.kiloMiniLabel.frame;
            CGRect tempImgFrame = self.kiloMiniImg.frame;
            
            
            tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
            tempImgFrame.origin.x = xForShiftingTinyImg;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                [self.kiloMiniImg setFrame:tempImgFrame];
                [self.kiloMiniLabel setFrame:tempLabelFrame];
            }];
            
            xForShiftingTinyImg = tempLabelFrame.origin.x - 5 - self.countOfViewsTinyImg.frame.size.width;
        }
        
        
        if (currentDetailsObject.distanceRangeInKm != -1)
            self.kiloMiniLabel.text = [NSString stringWithFormat:@"%i KM", currentDetailsObject.distanceRangeInKm];
        else {
            xForShiftingTinyImg = self.kiloMiniImg.frame.origin.x;
            
            self.kiloMiniLabel.hidden = YES;
            self.kiloMiniImg.hidden = YES;
        }
        
        if (xForShiftingTinyImg > 0) {
            CGRect tempLabelFrame = self.watchingCountLabel.frame;
            CGRect tempImgFrame = self.countOfViewsTinyImg.frame;
            
            
            tempLabelFrame.origin.x = xForShiftingTinyImg - 3 - tempLabelFrame.size.width;
            tempImgFrame.origin.x = xForShiftingTinyImg;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                [self.countOfViewsTinyImg setFrame:tempImgFrame];
                [self.watchingCountLabel setFrame:tempLabelFrame];
            }];
        }
        
        if (currentDetailsObject.viewCount > 0)
            self.watchingCountLabel.text = [NSString stringWithFormat:@"%i", currentDetailsObject.viewCount];
        else {
            self.watchingCountLabel.text = @"";
            [self.countOfViewsTinyImg setHidden:YES];
        }
        
        [[CarDetailsManager sharedInstance] setCommentsPageSizeToDefault];
        [[CarDetailsManager sharedInstance] setCommentsPageNumber:0];
        [self loadPageOfComments];
        
    }
    else
        [self hideLoadingIndicator];
    
    [self customizeButtonsByData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self resizeScrollView];
    else
        [self iPad_resizeScrollView];
    
    //4- cache the resultArray data
    //... (COME BACK HERE LATER) ...
}

- (void) loadPageOfComments {
    if (currentDetailsObject) {
        int page = [[CarDetailsManager sharedInstance] nextPage];
        [[CarDetailsManager sharedInstance] getAdCommentsForAd:currentDetailsObject.adID OfPage:page WithDelegate:self];
    }
}

#pragma mark - MFMailComposeViewController delegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    // Remove the mail view
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - favorites Delegate methods
- (void) FavoriteFailAddingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [self.favoriteButton setImage:[UIImage imageNamed:@"Details_gray_heart.png"] forState:UIControlStateNormal];
}

- (void) FavoriteDidAddWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    if (resultStatus)//added successfully
    {
        [currentDetailsObject setIsFavorite:YES];
        if (self.parentVC)
            [self.parentVC updateFavStateForAdID:currentAdID withState:YES];
        
        if (self.secondParentVC)
            [self.secondParentVC updateFavStateForAdID:currentAdID withState:YES];
        
        if (self.storeParentVC)
            [self.storeParentVC updateFavStateForAdID:currentAdID withState:YES];
        
        if (self.userDetailsParentVC)
            [self.userDetailsParentVC updateFavStateForAdID:currentAdID withState:YES];
        
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [currentDetailsObject setIsFavorite:NO];
        if (self.parentVC)
            [self.parentVC updateFavStateForAdID:currentAdID withState:NO];
        
        if (self.secondParentVC)
            [self.secondParentVC updateFavStateForAdID:currentAdID withState:NO];
        
        if (self.storeParentVC)
            [self.storeParentVC updateFavStateForAdID:currentAdID withState:NO];
        
        if (self.userDetailsParentVC)
            [self.userDetailsParentVC updateFavStateForAdID:currentAdID withState:NO];
        
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_gray_heart.png"] forState:UIControlStateNormal];
        
    }
}

- (void) FavoriteFailRemovingWithError:(NSError*) error forAdID:(NSUInteger)adID {
    
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
    
}

- (void) FavoriteDidRemoveWithStatus:(BOOL) resultStatus forAdID:(NSUInteger)adID {
    
    if (resultStatus)//removed successfully
    {
        [currentDetailsObject setIsFavorite:NO];
        if (self.parentVC)
            [self.parentVC updateFavStateForAdID:currentAdID withState:NO];
        
        if (self.secondParentVC)
            [self.secondParentVC updateFavStateForAdID:currentAdID withState:NO];
        
        if (self.storeParentVC)
            [self.storeParentVC updateFavStateForAdID:currentAdID withState:NO];
        
        if (self.userDetailsParentVC)
            [self.userDetailsParentVC updateFavStateForAdID:currentAdID withState:NO];
        
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_gray_heart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [currentDetailsObject setIsFavorite:YES];
        if (self.parentVC)
            [self.parentVC updateFavStateForAdID:currentAdID withState:YES];
        
        if (self.secondParentVC)
            [self.secondParentVC updateFavStateForAdID:currentAdID withState:YES];
        
        if (self.storeParentVC)
            [self.storeParentVC updateFavStateForAdID:currentAdID withState:YES];
        
        if (self.userDetailsParentVC)
            [self.userDetailsParentVC updateFavStateForAdID:currentAdID withState:YES];
        
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
    }
    
}

-(void)AdFailRemovingWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)AdDidRemoveWithStatus:(NSString*)resultStatus{
    
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"تم حذف الإعلان بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 3;
    
    [alert show];
    
}

-(void)RequestToEditFailWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)RequestToEditFinishWithData:(NSArray *)resultArray imagesArray:(NSArray *)resultIDs
{
    
    //TODO fill down the array and then move to next page "Edit Ad"
    NSLog(@"loading result Array : %@",resultArray);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        EditCarAdViewController *homeVC=[[EditCarAdViewController alloc] initWithNibName:@"EditCarAdViewController" bundle:nil];
        homeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        homeVC.myAdArray = resultArray;
        homeVC.myImageIDArray = resultIDs;
        homeVC.myDetails = currentDetailsObject;
        [self hideLoadingIndicator];
        
        [self presentViewController:homeVC animated:YES completion:nil];
    }
    else {
        EditCarAdViewController_iPad *homeVC=[[EditCarAdViewController_iPad alloc] initWithNibName:@"EditCarAdViewController_iPad" bundle:nil];
        homeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        homeVC.myAdArray = resultArray;
        homeVC.myImageIDArray = resultIDs;
        homeVC.myDetails = currentDetailsObject;
        [self hideLoadingIndicator];
        
        [self presentViewController:homeVC animated:YES completion:nil];

    }
        
    
}

-(void)RequestToEditStoreFailWithError:(NSError *)error{
    [self hideLoadingIndicator];
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
}

-(void)RequestToEditStoreFinishWithData:(NSArray *)resultArray imagesArray:(NSArray *)resultIDs{
    //TODO fill down the array and then move to next page "Edit Ad"
    NSLog(@"loading result Array : %@",resultArray);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        EditStoreAdViewController *homeVC=[[EditStoreAdViewController alloc] initWithNibName:@"EditStoreAdViewController" bundle:nil];
        homeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        homeVC.myAdArray = resultArray;
        homeVC.myImageIDArray = resultIDs;
        homeVC.myDetails = currentDetailsObject;
        [self hideLoadingIndicator];
        
        [self presentViewController:homeVC animated:YES completion:nil];
    }
    else {
        EditStoreAdViewController_iPad *homeVC=[[EditStoreAdViewController_iPad alloc] initWithNibName:@"EditStoreAdViewController_iPad" bundle:nil];
        homeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        homeVC.myAdArray = resultArray;
        homeVC.myImageIDArray = resultIDs;
        homeVC.myDetails = currentDetailsObject;
        [self hideLoadingIndicator];
        
        [self presentViewController:homeVC animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 3) {
        if (self.parentVC) //BrowseCarAdsViewController
            [self.parentVC removeAdWithAdID:currentDetailsObject.adID];
        
        if (self.secondParentVC) //CarsInGalleryViewController
            [self.secondParentVC removeAdWithAdID:currentDetailsObject.adID];
        
        if (self.storeParentVC) //StoreDetailsViewController
            [self.storeParentVC removeAdWithAdID:currentDetailsObject.adID];
        
        if (self.userDetailsParentVC) //StoreDetailsViewController
            [self.userDetailsParentVC removeAdWithAdID:currentDetailsObject.adID];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        /*BrowseCarAdsViewController *homeVC=[[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController" bundle:nil];
         homeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [self presentViewController:homeVC animated:YES completion:nil];*/
    }
    else if (alertView.tag == 2){
        if (buttonIndex == 0) {
            // delete Ad
            [self showLoadingIndicator];
            [[ProfileManager sharedInstance] removeAd:currentDetailsObject.adID fromAdsWithDelegate:self];
        }else if (buttonIndex == 1)
        {
            alertView.hidden = YES;
        }
    }
    else if (alertView.tag == 100) {
        labelAdViewController *vc;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
        else
            vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController_iPad" bundle:nil];
        vc.currentAdID = currentAdID;
        vc.countryAdID = currentStore.countryID;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (alertView.tag == 101){
        if (buttonIndex == 0) {
            // call
            NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",currentDetailsObject.mobileNumber];
            NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
            [[UIApplication sharedApplication] openURL:phoneURL];
            
        }else if (buttonIndex == 1)
        {
            // ignore
            alertView.hidden = YES;
        }
    }
    else if (alertView.tag == 11){
        if (buttonIndex == 0) {
            // sign in
            //SignInViewController *vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            SignInViewController *vc;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            else
                vc=[[SignInViewController alloc] initWithNibName:@"SignInViewController_iPad" bundle:nil];
            vc.returnPage = YES;
            [self presentViewController:vc animated:YES completion:nil];
            
        }else if (buttonIndex == 1)
        {
            // ignore
            alertView.hidden = YES;
        }
        
        
    }
    
}
- (void) setPlacesOfViews{
    self.toolBar.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    self.labelsScrollView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    self.callBarImgBg.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    self.toolBar.frame=CGRectMake(0, 0, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
            
        {
            self.labelsScrollView.frame=CGRectMake(0, self.toolBar.frame.size.height, self.labelsScrollView.frame.size.width ,self.labelsScrollView.frame.size.height );
            //shareButton.frame=CGRectMake(35, 430, shareButton.frame.size.width ,shareButton.frame.size.height );
        }
        
        else
            
        {
            self.labelsScrollView.frame=CGRectMake(0, self.toolBar.frame.size.height, self.labelsScrollView.frame.size.width ,960- self.toolBar.frame.size.height);
            //shareButton.frame=CGRectMake(35, 520, shareButton.frame.size.width ,shareButton.frame.size.height );
            
        }
    }
    
}

#pragma mark - featuring an ad related to a store

- (void)featurecurrentStoreAd:(NSInteger)advID {
    if (currentStore)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (currentStore.remainingFreeFeatureAds <= 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                                message:@"لقد تجاوزت عدد الإعلانات المحجوزة، بإمكانك إلغاء إعلان آخر ثم تمييز هذا الإعلان."
                                                               delegate:self
                                                      cancelButtonTitle:@"موافق"
                                                      otherButtonTitles:nil];
                alert.tag = 100;
                [alert show];
            }
            else if (currentStore.remainingDays < 3) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"لايمكن تمييز هذ االاعلان"
                                                                message:@"عدد الأيام المتبقية لديك غير كاف، قم بتجديد اشتراكك لتستطيع تمييز هذا الإعلان."
                                                               delegate:self
                                                      cancelButtonTitle:@"موافق"
                                                      otherButtonTitles:nil];
                alert.tag = 100;
                [alert show];
            }
            else {
                UIActionSheet *actionSheet = nil;
                
                if (currentStore.remainingDays < 7) {
                    actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                              delegate:self
                                                     cancelButtonTitle:@"إلغاء"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"٣ أيام", nil];
                }
                else if (currentStore.remainingDays < 28) {
                    actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                              delegate:self
                                                     cancelButtonTitle:@"إلغاء"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"٣ أيام", @"اسبوع", nil];
                }
                else {
                    actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختر مدة التمييز"
                                                              delegate:self
                                                     cancelButtonTitle:@"إلغاء"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"٣ أيام", @"اسبوع", @"شهر", nil];
                }
                [actionSheet showInView:self.view];
            }
        }
        else { //iPad
            labelStoreAdViewController_iPad *vc=[[labelStoreAdViewController_iPad alloc] initWithNibName:@"labelStoreAdViewController_iPad" bundle:nil];
            vc.currentAdID = currentAdID;
            vc.countryAdID = currentStore.countryID;
            vc.iPad_currentStore = currentStore;
            vc.currentAdHasImages = NO;
            if (currentDetailsObject.adImages && currentDetailsObject.adImages.count)
                vc.currentAdHasImages = YES;
            
            [self presentViewController:vc animated:YES completion:nil];
        }
    }

}

- (void)unfeaturecurrentStoreAd:(NSInteger)advID {
    [advFeatureManager unfeatureAdv:advID inStore:currentStore.identifier];
    [self showLoadingIndicator];
}

#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
        return;
    }
    if (currentDetailsObject)
    {
        if ((currentAdID == 0) || (currentAdID == -1)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                            message:@"لم يتم تحديد إعلان."
                                                           delegate:self
                                                  cancelButtonTitle:@"موافق"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSInteger featureDays = 3;
        if ([@"٣ أيام" isEqualToString:buttonTitle]) {
            featureDays = 3;
        }
        else if ([@"اسبوع" isEqualToString:buttonTitle]) {
            featureDays = 7;
        }
        else if ([@"شهر" isEqualToString:buttonTitle]) {
            featureDays = 28;
        }
        if (currentStore)
        {
            [advFeatureManager featureAdv:currentAdID
                                  inStore:currentStore.identifier
                              featureDays:featureDays];
            [self showLoadingIndicator];
        }
    }
}

#pragma mark -featuring store ad delegate methods

- (void) featureAdvDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في تمييز الإعلان"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
    [self customizeButtonsByData];
}

- (void) featureAdvDidSucceed {
    if (currentDetailsObject && currentStore)
    {
        currentStore.remainingFreeFeatureAds--;
        currentDetailsObject.isFeatured = YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم تمييز الإعلان"
                                                    message:@"تم تمييز الإعلان بنجاح."
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
    [self customizeButtonsByData];
    if (self.parentStoreDetailsView)
    {
        [(StoreDetailsViewController *)self.parentStoreDetailsView updateAd:currentAdID WithFeaturedStatus:YES];
    }
}

- (void) unfeatureAdvDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ"
                                                    message:@"حدث خطأ في إلغاء تمييز الإعلان"
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
    [self customizeButtonsByData];
}

- (void) unfeatureAdvDidSucceed {
    
    if (currentDetailsObject && currentStore)
    {
        currentStore.remainingFreeFeatureAds++;
        currentDetailsObject.isFeatured = NO;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تم إلغاء تمييز الإعلان"
                                                    message:@"تم إلغاء تمييز الإعلان بنجاح."
                                                   delegate:self
                                          cancelButtonTitle:@"موافق"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self hideLoadingIndicator];
    [self customizeButtonsByData];
    if (self.parentStoreDetailsView)
    {
        [(StoreDetailsViewController *)self.parentStoreDetailsView updateAd:currentAdID WithFeaturedStatus:NO];
    }
}

- (void) didRotate:(NSNotification *)notification
{
    if (viewIsShown)
    {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        
        if ( (orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight) ) {
            [self openImgs:nil];
        }
    }
}


- (void) resetGalleryViewToNil {
    galleryView = nil;
}

- (void) dismissKeyboard {
    
    [self.commentTextView resignFirstResponder];
    if(self.commentTextView.text.length == 0){
        self.commentTextView.textColor = [UIColor lightGrayColor];
        self.commentTextView.text = @"أضف تعليقك";
        self.commentTextView.textAlignment = NSTextAlignmentRight;
    }
    
    CGRect textViewFrame = self.commentTextView.frame;
    textViewFrame.size.width = 233.0f; //nib size
    
    CGRect commentsViewFrame = self.commentsView.frame;
    commentsViewFrame.size.width = 290.0f;
    
    UIImageView * innerImgV;
    for (UIView * subview in self.commentsView.subviews) {
        if ([subview class] == [UIImageView class]) {
            innerImgV = (UIImageView *) subview;
            break;
        }
    }
    CGRect innerImgVFrame = innerImgV.frame;
    innerImgVFrame.size.width = 290.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.commentTextView setFrame:textViewFrame];
        [self.commentsView setFrame:commentsViewFrame];
        [innerImgV setFrame:innerImgVFrame];
    }];
}


#pragma mark -  open browser
- (void) openInBrowser{
    [[UIApplication sharedApplication] openURL:[currentDetailsObject adURL]];
    
}

- (void) openVideo{
    //[[UIApplication sharedApplication] openURL:[currentDetailsObject adURL]];
    [[UIApplication sharedApplication] openURL:VideoURL];
    
    
}
- (void) addOpenBoweseViewForX:(float) x andY:(float)y{
    
    
    UIButton * openBrowserBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 295, 30)];
    [openBrowserBtn setTitle:@"" forState:UIControlStateNormal];
    [openBrowserBtn setImage:[UIImage imageNamed:@"OpenInBrowser.png"] forState:UIControlStateNormal];
    [openBrowserBtn addTarget:self action:@selector(openInBrowser) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.labelsScrollView addSubview:openBrowserBtn];
    
}

- (UIView*) addOpenVideoViewForX:(float) x andY:(float)y{
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(x, y, 296, 54)];
    view.backgroundColor=[UIColor clearColor];
    
    UIButton *buttn= [UIButton buttonWithType:UIButtonTypeCustom];
    buttn.frame = CGRectMake(0, 0, 296, 54);
    [buttn setImage:[UIImage imageNamed:@"seeVideo.png"] forState:UIControlStateNormal];
    [buttn addTarget:self action:@selector(openVideo) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* VideoImg = [[UIImageView alloc] initWithFrame:CGRectMake(232, 4, 60, 46)];
    [VideoImg setImageWithURL:[NSURL URLWithString:VideoThumb]];
    [view addSubview:buttn];
    [view addSubview:VideoImg];
    
    return view;
    
}


#pragma mark - UITextView delegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (self.commentTextView.textColor == [UIColor lightGrayColor]) {
        self.commentTextView.text = @"";
        self.commentTextView.textColor = [UIColor blackColor];
        self.commentTextView.textAlignment = NSTextAlignmentLeft;
        CGRect textViewFrame = self.commentTextView.frame;
        textViewFrame.size.width = 946.0f; //wider size
        
        CGRect commentsViewFrame = self.commentsView.frame;
        commentsViewFrame.size.width = 1002.0f;
        
        UIImageView * innerImgV;
        for (UIView * subview in self.commentsView.subviews) {
            if ([subview class] == [UIImageView class]) {
                innerImgV = (UIImageView *) subview;
                break;
            }
        }
        CGRect innerImgVFrame = innerImgV.frame;
        innerImgVFrame.size.width = 1002.0f;
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.commentTextView setFrame:textViewFrame];
            [self.commentsView setFrame:commentsViewFrame];
            [innerImgV setFrame:innerImgVFrame];
        }];
        
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self.commentTextView resignFirstResponder];
        
        if(self.commentTextView.text.length == 0){
            self.commentTextView.textColor = [UIColor lightGrayColor];
            self.commentTextView.text = @"أضف تعليقك";
            self.commentTextView.textAlignment = NSTextAlignmentRight;
            
        }
        else
            [self postCommentForCurrentAd:nil];
        return NO;
    }
    
    return YES;
    
}

#pragma mark - comments methods

- (IBAction) postCommentForCurrentAd:(id)sender {
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (savedProfile) {
        
        postCommentAfterSignIn = NO;
        
        if (self.commentTextView.text.length > 0) {
            [self.commentTextView resignFirstResponder];
            
            if (loadMoreCommentsBtn)
                [loadMoreCommentsBtn removeFromSuperview];
            loadMoreCommentsBtn = nil;
            
            [self showLoadingIndicator];
            
            [[CarDetailsManager sharedInstance] postCommentForAd:currentDetailsObject.adID WithText:self.commentTextView.text WithDelegate:self];
        }
        
    }
    else {
        postCommentAfterSignIn = YES;
        
        [self.commentTextView resignFirstResponder];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"نعتذر" message:@"يجب أن تسجل الدخول حتى تتمكن من إضافة تعليق" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:@"إلغاء", nil];
        alert.delegate = self;
        alert.tag = 11;
        [alert show];
    }
    
}

- (void) AddNewComment:(CommentOnAd *) comment animated:(BOOL) animated {
    
    float minCommentViewY = CGFLOAT_MAX;
    
    UIScrollView * containerScrollView;
    float totalHeight = containerScrollView.contentSize.height;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    	containerScrollView = self.labelsScrollView;
    else
    	containerScrollView = self.iPad_commentsScrollView;
    if (commentsArray && commentsArray.count) {
        for (UIView * subView in containerScrollView.subviews) {
            if ([subView class] == [SingleCommentView class]) {
                if (subView.frame.origin.y < minCommentViewY) {
                    minCommentViewY = subView.frame.origin.y;
                }
            }
            
        }
    }
    else {
        
        float maxY = 0;
        float bottomViewHeight = 0;
        for (UIView * subView in containerScrollView.subviews) {
            if (subView.frame.origin.y > maxY) {
                maxY = subView.frame.origin.y;
                bottomViewHeight = subView.frame.size.height;
                
            }
        }
        
        float x;
        x = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 13 : 3);
        
        maxY = maxY + bottomViewHeight;
        
        UILabel* titleImgV = [[UILabel alloc] initWithFrame:CGRectMake(x, maxY + 10, 295, 35)];
        [titleImgV setText:@" تعليقات المستخدمين"];
        [titleImgV setTextAlignment:NSTextAlignmentRight];
        [titleImgV setTextColor:[UIColor colorWithRed:0.0/255 green:127.0/255 blue:175.0/255 alpha:1.0f]];
        [titleImgV setBackgroundColor:[UIColor whiteColor]];
        [titleImgV setFont:[UIFont systemFontOfSize:22]];
        
        maxY = maxY + titleImgV.frame.size.height + 10;
        
        totalHeight = totalHeight + titleImgV.frame.size.height;
        [containerScrollView addSubview:titleImgV];
        
        minCommentViewY = maxY;
    }
    
    [commentsArray insertObject:comment atIndex:0];
    
    float x;
    x = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 13 : 3);
    
    SingleCommentView * cView = [[SingleCommentView alloc] initWithCommentText:comment.commentText];
    
    //username
    cView.usernameLabel.text = comment.userName;
    
    //posted on date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm a"];
    
    NSString * postedOnDateFormatted = [formatter stringFromDate:comment.postedOnDate];
    
    cView.dateLabel.text = postedOnDateFormatted;
    
    //comment text
    cView.commentTextLabel.text = comment.commentText;
    
    
    CGRect cViewFrame = cView.frame;
    cViewFrame.origin.x = x;
    cViewFrame.origin.y = minCommentViewY;
    
    [cView setFrame:cViewFrame];
    
    //lastY = lastY + cView.frame.size.height + FIXED_V_DISTANCE;
    
    totalHeight = totalHeight + cView.frame.size.height + FIXED_V_DISTANCE;
    
    
    if (animated) {
        
        [UIView transitionWithView:containerScrollView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                        animations:^ {
                            for (UIView * subView in containerScrollView.subviews) {
                                if ([subView class] == [SingleCommentView class]) {
                                    CGRect viewFrame = subView.frame;
                                    viewFrame.origin.y = viewFrame.origin.y + cView.frame.size.height;
                                    [subView setFrame:viewFrame];
                                    
                                }
                                
                                [containerScrollView addSubview:cView];
                            }
                        }
                        completion:nil];
    }
    else  {
        for (UIView * subView in containerScrollView.subviews) {
            if ([subView class] == [SingleCommentView class]) {
                CGRect viewFrame = subView.frame;
                viewFrame.origin.y = viewFrame.origin.y + cView.frame.size.height;
                [subView setFrame:viewFrame];
            }
            
            [containerScrollView addSubview:cView];
        }
    }
    
    float lastY = 0;
    
    float bottomViewHeight = 0;
    for (UIView * subView in containerScrollView.subviews) {
        if (subView.frame.origin.y > lastY) {
            
            if (subView.class == [SingleCommentView class]) {
                lastY = subView.frame.origin.y;
                bottomViewHeight = subView.frame.size.height;
            }
            
        }
    }

    lastY = lastY + cView.frame.size.height + 10;
    loadMoreCommentsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loadMoreCommentsBtn setFrame:CGRectMake(x, lastY, 295, 30)];
    [loadMoreCommentsBtn setTitle:@"إظهار المزيد ..." forState:UIControlStateNormal];
    [loadMoreCommentsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [loadMoreCommentsBtn addTarget:self action:@selector(loadMoreCommentsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [containerScrollView addSubview:loadMoreCommentsBtn];
    
    if ([commentsArray count] >= 50) {
        [loadMoreCommentsBtn setHidden:NO];
    }else
        [loadMoreCommentsBtn setHidden:YES];
    
    totalHeight = totalHeight + loadMoreCommentsBtn.frame.size.height;
    
    
    [containerScrollView setContentSize:CGSizeMake(containerScrollView.frame.size.width, totalHeight)];
    
}

- (NSArray *) sortCommentsArray:(NSArray *) input {
    
    NSArray * sortedArray;
    sortedArray = [input sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate * first = [(CommentOnAd *)a postedOnDate];
        NSDate * second = [(CommentOnAd *)b postedOnDate];
        return ([first compare:second]);
    }];
    
    return sortedArray;
}

- (void) loadMoreCommentsBtnPressed:(id) sender {
    
    [self showLoadingIndicator];
    [self loadPageOfComments];
    
}

#pragma mark - Comments Delegate methods

//get
- (void) commentsDidFailLoadingWithError:(NSError *)error {
    [self hideLoadingIndicator];
}

- (void) commentsDidFinishLoadingWithData:(NSArray *)resultArray {
    
    
    if (resultArray && resultArray.count) {
        
        [commentsArray addObjectsFromArray:resultArray];
        
        if (commentsArray.count > resultArray.count) {
            if (loadMoreCommentsBtn)
                [loadMoreCommentsBtn removeFromSuperview];
            loadMoreCommentsBtn = nil;
        }
        
        //NSMutableArray * sorted = [NSMutableArray new];
        //[sorted addObjectsFromArray:[self sortCommentsArray:commentsArray]];
        //commentsArray = sorted;
        
        float maxY = -1;
        float bottomViewHeight = 0;
        UIScrollView * containerScrollView;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            containerScrollView = self.labelsScrollView;
        else
            containerScrollView = self.iPad_commentsScrollView;
        
        for (UIView * subView in containerScrollView.subviews) {
            if (subView.frame.origin.y > maxY) {
                
                if (commentsArray.count > resultArray.count) {  // second time comment loading
                    if (subView.class == [SingleCommentView class]) {
                        maxY = subView.frame.origin.y;
                        bottomViewHeight = subView.frame.size.height;
                    }
                }
                else {
                    maxY = subView.frame.origin.y;
                    bottomViewHeight = subView.frame.size.height;
                }
            }
        }
        
        maxY = maxY + bottomViewHeight;
        float totalHeight = containerScrollView.contentSize.height;
        float lastY = maxY;
        
        if (commentsArray.count == resultArray.count) {
            float x;
            x = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 13 : 3);
            UIImageView * titleImgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, lastY + 10, 295, 35)];
            titleImgV1.image = [UIImage imageNamed:@"Comments_title.png"];
            
            UILabel* titleImgV = [[UILabel alloc] initWithFrame:CGRectMake(x, lastY + 10, 295, 35)];
            [titleImgV setText:@" تعليقات المستخدمين"];
            [titleImgV setTextAlignment:NSTextAlignmentRight];
            [titleImgV setTextColor:[UIColor colorWithRed:0.0/255 green:127.0/255 blue:175.0/255 alpha:1.0f]];
            [titleImgV setBackgroundColor:[UIColor whiteColor]];
            [titleImgV setFont:[UIFont systemFontOfSize:22]];
            
            lastY = lastY + titleImgV.frame.size.height;
            
            totalHeight = totalHeight + titleImgV.frame.size.height;
            [containerScrollView addSubview:titleImgV];
        }
        
        for (CommentOnAd * comment in resultArray) {
            float x;
            x = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 13 : 3);
            
            SingleCommentView * cView = [[SingleCommentView alloc] initWithCommentText:comment.commentText];
            
            //username
            cView.usernameLabel.text = comment.userName;
            
            //posted on date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy HH:mm a"];
            
            NSString * postedOnDateFormatted = [formatter stringFromDate:comment.postedOnDate];
            
            cView.dateLabel.text = postedOnDateFormatted;
            
            //comment text
            cView.commentTextLabel.text = comment.commentText;
            
            
            CGRect cViewFrame = cView.frame;
            cViewFrame.origin.x = x;
            cViewFrame.origin.y = lastY + 10 ;
            
            [cView setFrame:cViewFrame];
            
            lastY = lastY + cView.frame.size.height + FIXED_V_DISTANCE;
            
            totalHeight = totalHeight + cView.frame.size.height + FIXED_V_DISTANCE;
            
            [containerScrollView addSubview:cView];
        }
        
        float x;
        x = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 13 : 3);
        lastY = lastY + 10;
        loadMoreCommentsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [loadMoreCommentsBtn setFrame:CGRectMake(x, lastY, 295, 30)];
        [loadMoreCommentsBtn setTitle:@"إظهار المزيد ..." forState:UIControlStateNormal];
        [loadMoreCommentsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [loadMoreCommentsBtn addTarget:self action:@selector(loadMoreCommentsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        if ([resultArray count] >= 50) {
            [loadMoreCommentsBtn setHidden:NO];
        }else
            [loadMoreCommentsBtn setHidden:YES];
        [containerScrollView addSubview:loadMoreCommentsBtn];
        
        totalHeight = totalHeight + loadMoreCommentsBtn.frame.size.height;
        
        [containerScrollView setContentSize:CGSizeMake(containerScrollView.frame.size.width, totalHeight)];
    }
    
    [self hideLoadingIndicator];
}


//post
- (void) commentsDidFailPostingWithError:(NSError *)error {
    
    [GenericMethods throwAlertWithCode:error.code andMessageStatus:[error description] delegateVC:self];
    
    [self hideLoadingIndicator];
}

- (void) commentsDidPostWithData:(CommentOnAd *)resultComment {
    [self hideLoadingIndicator];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"تم إضافة تعليقك بنجاح" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
    [alert show];
    
    if (resultComment) {
        self.commentTextView.textColor = [UIColor lightGrayColor];
        self.commentTextView.text = @"أضف تعليقك";
        self.commentTextView.textAlignment = NSTextAlignmentRight;
        
        [self AddNewComment:resultComment animated:YES];
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
            (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
            [self dismissKeyboard];
    }
}

@end