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
#import "EditCarAdViewController.h"
#import "KRImageViewer.h"

//#define FIXED_V_DISTANCE    17
#define FIXED_V_DISTANCE    0
#define FIXED_H_DISTANCE    20

@interface CarAdDetailsViewController (){
    BOOL pageControlUsed;
    MBProgressHUD2 * loadingHUD;
    CarDetails * currentDetailsObject;
    CGFloat originalScrollViewHeight;
    HJObjManager* asynchImgManager;   //asynchronous image loading manager
    AURosetteView *shareButton;
    UITapGestureRecognizer *tap;
    NSMutableDictionary * allImagesDict;    //used in image browser
    KRImageViewer *krImageViewer;
    UILabel * label;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)twitterAction:(id)sender;
- (void)facebookAction:(id)sender;
- (void)mailAction:(id)sender;

@end

@implementation CarAdDetailsViewController
@synthesize pageControl,scrollView, phoneNumberButton, favoriteButton, featureBtn, editBtn, topMostToolbar,editAdBtn;
@synthesize currentAdID,parentVC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/*
- (void) resizeScrollView {
    
    CGFloat lastY = self.addTimeLabel.frame.origin.y + self.addTimeLabel.frame.size.height;
    
    //1- remove all subviews in scroll view, lower than lastY (number is took from nib)
    for (UIView * subview in [self.labelsScrollView subviews]) {
        if (subview.frame.origin.y > lastY) {
            [subview removeFromSuperview];
        }
    }
    
    
    
    if (currentDetailsObject)
    {
        self.detailLbl.text =  currentDetailsObject.description;
        //1- set car images
        if ((currentDetailsObject.adImages) && (currentDetailsObject.adImages.count))
        {
            self.pageControl.currentPage = 0;
            self.pageControl.numberOfPages = currentDetailsObject.adImages.count;
            for (int i=0; i < currentDetailsObject.adImages.count; i++) {
                NSURL * imgURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] thumbnailImageURL];
                [self.scrollView addSubview:[self prepareImge:imgURL :i]];
            }
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setShowsVerticalScrollIndicator:YES];
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * currentDetailsObject.adImages.count, self.scrollView.frame.size.height);
            
        }
        
        //2- set attributes
        if ((currentDetailsObject.attributes) && (currentDetailsObject.attributes.count))
        {
            CGFloat addedHeightValue;   //initial value, distant from last labels
            if (currentDetailsObject.storeID > 0)   //isStore
                addedHeightValue = 80 + 30;
            else
                addedHeightValue = 35 + 30;
            
            lastY = self.addTimeLabel.frame.origin.y + self.addTimeLabel.frame.size.height + addedHeightValue;
            
            for (CarDetailsAttribute * attr in currentDetailsObject.attributes)
            {
                if (attr.categoryAttributeID != 502 &&
                    attr.categoryAttributeID != 505 &&
                    attr.categoryAttributeID != 508 &&
                    attr.categoryAttributeID != 907 &&
                    attr.categoryAttributeID != 1076) {
                    
                    if (![attr.attributeValue length] == 0) {
                        
                        
                        //attr label
                        NSString * attr_name_text = [NSString stringWithFormat:@"%@ :", attr.displayName];
                        
                        CGSize realTextSize = [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15]];
                        
                        CGSize expectedLabelSize =
                        [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15] forWidth:((self.labelsScrollView.frame.size.width - (2 * FIXED_H_DISTANCE)) / 2) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        if (realTextSize.width > expectedLabelSize.width)
                        {
                            int factor = (int) (realTextSize.width / expectedLabelSize.width);
                            factor ++;
                            
                            expectedLabelSize.height = expectedLabelSize.height * factor;
                        }
                        
                        CGFloat attr_x = self.labelsScrollView.frame.size.width - (expectedLabelSize.width + FIXED_H_DISTANCE);
                        
                        CGFloat attr_y  = lastY + FIXED_V_DISTANCE;
                        
                        UILabel * attrNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(260 - expectedLabelSize.width, 8, expectedLabelSize.width, expectedLabelSize.height)];
                        
                        attrNameLabel.text = attr_name_text;
                        attrNameLabel.textAlignment = NSTextAlignmentRight;
                        attrNameLabel.font = [UIFont systemFontOfSize:15];
                        attrNameLabel.backgroundColor = [UIColor clearColor];
                        attrNameLabel.numberOfLines = 0;
                        
                        //value label
                        CGFloat valueLabelWidth = self.labelsScrollView.frame.size.width - (expectedLabelSize.width + (3 * FIXED_H_DISTANCE));
                        CGFloat valueLabelHeight = expectedLabelSize.height;
                        
                        //CGFloat val_x = self.labelsScrollView.frame.size.width - FIXED_H_DISTANCE;
                        CGFloat val_x = FIXED_H_DISTANCE;
                        CGFloat val_y  = attr_y;
                        
                        UILabel * valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 120, valueLabelHeight)];
                        
                        valuelabel.text = attr.attributeValue;
                        valuelabel.textAlignment = NSTextAlignmentRight;
                        valuelabel.font = [UIFont systemFontOfSize:15];
                        valuelabel.textColor = [UIColor colorWithRed:56.0/255 green:127.0/255 blue:161.0/255 alpha:1.0f];
                        valuelabel.backgroundColor = [UIColor clearColor];
                        
                         // UITextField* backgroundText = [[UITextField alloc]initWithFrame:CGRectMake(attr_x, attr_y, 100,valueLabelHeight)];
                         //UITableViewCell* myCell = [[UITableViewCell alloc]initWithFrame:CGRectMake(attr_x, attr_y, 100,valueLabelHeight)];
                         //myCell.accessoryType = UITableViewCellAccessoryNone;
                         //myCell.backgroundColor = [UIColor whiteColor];
                         //myCell.textLabel.text = attrNameLabel.text;
                         //myCell.detailTextLabel.text = valuelabel.text;
                         
                         
                        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(23, val_y + 50, valueLabelWidth + expectedLabelSize.width + 13, 35)];
                        [v setBackgroundColor:[UIColor whiteColor]];
                        [v addSubview:attrNameLabel];
                        [v addSubview:valuelabel];
                        
                        //[self.labelsScrollView addSubview:attrNameLabel];
                        //[self.labelsScrollView addSubview:valuelabel];
                        [self.labelsScrollView addSubview:v];
                        
                        
                        lastY = attr_y + valueLabelHeight;
                        addedHeightValue = addedHeightValue + valueLabelHeight + FIXED_V_DISTANCE;
                    }
                }
            }
            
            addedHeightValue = addedHeightValue + FIXED_V_DISTANCE;
            
            CGFloat totalHeight = self.labelsScrollView.frame.size.height + addedHeightValue;
            
            [self.labelsScrollView setScrollEnabled:YES];
            [self.labelsScrollView setShowsVerticalScrollIndicator:YES];
            [self.labelsScrollView setContentSize:(CGSizeMake(self.labelsScrollView.frame.size.width, totalHeight))];
        }
    }
    
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPlacesOfViews];
    // hide share button
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissShareButton)];
    //[self.scrollView addGestureRecognizer:tap];
    [self.labelsScrollView addGestureRecognizer:tap];
    
    
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
    
    
    
    //init the image load manager
    asynchImgManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	asynchImgManager.fileCache = fileCache;
    
    //set the original size of scroll view without loading any labels yet
    originalScrollViewHeight = self.labelsScrollView.frame.size.height;
    
    //init the image browser
    krImageViewer = [[KRImageViewer alloc] initWithDragMode:krImageViewerModeOfTopToBottom];
    krImageViewer.maxConcurrentOperationCount = 1;
    krImageViewer.dragDisapperMode            = krImageViewerDisapperAfterMiddle;
    krImageViewer.allowOperationCaching       = NO;
    krImageViewer.timeout                     = 30.0f;
    
    [self prepareShareButton];
    
    [self startLoadingData];
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"Ad details screen"];
    //end GA
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [krImageViewer resetView:self.view.window];
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
- (UIView *) prepareImge : (NSURL*) imageURL : (int) i{
    CGRect frame;
    frame.origin.x=self.scrollView.frame.size.width*i;
    frame.origin.y=0;
    frame.size=self.scrollView.frame.size;
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
    
    HJManagedImageV * imageView = [[HJManagedImageV alloc] init];
    CGRect imageFrame;
    imageFrame.origin.x=0;
    imageFrame.origin.y=0;
    imageFrame.size.width=frame.size.width;
    imageFrame.size.height=frame.size.height;
    imageView.frame=imageFrame;
    
    [imageView clear];
    
    UIControl *mask = [[UIControl alloc] initWithFrame:imageView.frame];
    [mask addTarget:self action:@selector(openImgs:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* temp = [currentDetailsObject.thumbnailURL absoluteString];
    
    if ([temp isEqualToString:@"UseAwaitingApprovalImage"]) {
        imageView.image = [UIImage imageNamed:@"waitForApprove.png"];
    }else{
       imageView.url = imageURL;
        [imageView showLoadingWheel];
        [asynchImgManager manage:imageView];
        
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
   
    //NSLog(@"test img");
    
    NSInteger imageIDForDict = [(UITapGestureRecognizer *) sender view].tag/ 10;
    NSString * dictionaryKey = [NSString stringWithFormat:@"%i", imageIDForDict];
    
    if (allImagesDict && allImagesDict.count)
        [krImageViewer browsePageByPageImageURLs:allImagesDict firstShowImageId:dictionaryKey];
    
}

// flod share button when touch the screen
- (void)dismissShareButton{
    if ((shareButton.on)) {
        [shareButton fold];
    }
    
    
}

- (void) browsePhotos {
    
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
    
    
    [self.view insertSubview:shareButton aboveSubview:self.labelsScrollView];
    
}

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
    labelAdViewController *vc=[[labelAdViewController alloc] initWithNibName:@"labelAdViewController" bundle:nil];
    vc.currentAdID = currentAdID;
    vc.countryAdID = currentDetailsObject.countryID;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)editAdBtnPrss:(id)sender {
   
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"معلومة" message:@"هل تريد تأكيد حذف هذا الإعلان ؟" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"إلغاء", nil];
    alert.tag = 2;
    [alert show];
}

- (IBAction)modifyAdBtnPrss:(id)sender {
    
    [self showLoadingIndicator];
    // Request To Edit Ad
    [[CarAdsManager sharedInstance] requestToEditAdsOfEditID:currentDetailsObject.EncEditID WithDelegate:self];
}



- (IBAction)backBtnPrss:(id)sender {
    if (self.checkPage) {
        ChooseActionViewController *vc=[[ChooseActionViewController alloc] initWithNibName:@"ChooseActionViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMailBtnPrss:(id)sender {
    
    if (currentDetailsObject)
    {
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
        }
    }
}

- (IBAction)favoriteBtnPrss:(id)sender {
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
    if (currentDetailsObject)
    {
        if ((currentDetailsObject.mobileNumber) && (![currentDetailsObject.mobileNumber isEqualToString:@""]))
        {
            NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",currentDetailsObject.mobileNumber];
            NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}


#pragma mark - sharing acions
- (void)twitterAction:(id)sender{
    [shareButton fold];
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

- (void)facebookAction:(id)sender{
    [shareButton fold];
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

- (void)mailAction:(id)sender {
    [shareButton fold];
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
            
            allImagesDict = [NSMutableDictionary new];
            for (int i=0; i < currentDetailsObject.adImages.count; i++) {
                //1- add images in horizontal scroll view
                NSURL * imgThumbURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] thumbnailImageURL];
                [self.scrollView addSubview:[self prepareImge:imgThumbURL :i]];
                
                NSURL * imgURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] imageURL];
                //2- init the dictionary for the image browser
                [allImagesDict setObject:imgURL.absoluteString forKey:[NSString stringWithFormat:@"%i", (i+1)]];
            }
            
              

          
            
            //preload the images in the browser
            [krImageViewer preloadImageURLs:allImagesDict];
            
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setShowsVerticalScrollIndicator:YES];
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * currentDetailsObject.adImages.count, self.scrollView.frame.size.height);
            
        }else {
              [self.scrollView addSubview:[self prepareImge:currentDetailsObject.thumbnailURL :0]];
        }
        
        //2- set details
        if (![currentDetailsObject.description isEqualToString:@""]) {
            CGSize realTextSize = [currentDetailsObject.description sizeWithFont:[UIFont systemFontOfSize:15]];
            CGSize expectedLabelSizeNew =
            [currentDetailsObject.description sizeWithFont:[UIFont systemFontOfSize:15] forWidth:(self.detailsView.frame.size.width - (2 * 5)) lineBreakMode:NSLineBreakByWordWrapping];
            
            if (realTextSize.width >= expectedLabelSizeNew.width)
            {
                int factor = (int) (realTextSize.width / expectedLabelSizeNew.width);
                factor ++;
                
                expectedLabelSizeNew.height = expectedLabelSizeNew.height * factor;
            }
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(
                                self.detailsTextLabel.frame.origin.x,
                                self.detailsTextLabel.frame.origin.y + self.detailsTextLabel.frame.size.height + 5,
                                self.detailsView.frame.size.width - (2 * 5),
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
            CGFloat addedHeightValue = self.contentView.frame.origin.y;   //initial value, distant from last labels
            
            CGFloat lastY;
            CGFloat totalHeight;
            if (self.detailsView.isHidden)
            {
                lastY = self.addTimeLabel.frame.origin.y + self.addTimeLabel.frame.size.height +  addedHeightValue + 30;
                totalHeight = lastY;
            }
            else
            {
                lastY = self.detailsView.frame.origin.y + self.detailsView.frame.size.height +  addedHeightValue + 30;
                totalHeight = lastY + 20;
            }
            
            
            for (CarDetailsAttribute * attr in currentDetailsObject.attributes)
            {
                if (attr.categoryAttributeID != 502 &&
                    attr.categoryAttributeID != 505 &&
                    attr.categoryAttributeID != 508 &&
                    attr.categoryAttributeID != 907 &&
                    attr.categoryAttributeID != 1076 &&
                    attr.categoryAttributeID != 10171) {
                    
                    if (![attr.attributeValue length] == 0) {
                        
                        //attr label
                        NSString * attr_name_text = [NSString stringWithFormat:@"%@ :", attr.displayName];
                        
                        CGSize realTextSize = [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15]];
                        
                        CGSize expectedLabelSize =
                        [attr_name_text sizeWithFont:[UIFont systemFontOfSize:15] forWidth:((self.labelsScrollView.frame.size.width - (2 * FIXED_H_DISTANCE)) / 2) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        if (realTextSize.width >= expectedLabelSize.width)
                        {
                            int factor = (int) (realTextSize.width / expectedLabelSize.width);
                            factor ++;
                            
                            expectedLabelSize.height = expectedLabelSize.height * factor;
                        }

                        CGFloat attr_y  = lastY + FIXED_V_DISTANCE;
                        
                        
                        UILabel * attrNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(260 - expectedLabelSize.width, 2, expectedLabelSize.width, expectedLabelSize.height)];
                        
                        attrNameLabel.text = attr_name_text;
                        attrNameLabel.textAlignment = NSTextAlignmentRight;
                        attrNameLabel.font = [UIFont systemFontOfSize:15];
                        attrNameLabel.backgroundColor = [UIColor clearColor];
                        attrNameLabel.numberOfLines = 0;
                        
                        //value label
                        CGFloat valueLabelWidth = self.labelsScrollView.frame.size.width - (expectedLabelSize.width + (3 * FIXED_H_DISTANCE));
                        CGFloat valueLabelHeight = expectedLabelSize.height;
                        

                        CGFloat val_y  = attr_y;
                        
                        UILabel * valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 130, valueLabelHeight)];
                        
                        valuelabel.text = attr.attributeValue;
                        valuelabel.textAlignment = NSTextAlignmentRight;
                        valuelabel.font = [UIFont systemFontOfSize:15];
                        valuelabel.textColor = [UIColor colorWithRed:56.0/255 green:127.0/255 blue:161.0/255 alpha:1.0f];
                        valuelabel.backgroundColor = [UIColor clearColor];
                        
                        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(23, val_y, valueLabelWidth + expectedLabelSize.width + 13, valueLabelHeight + 4)];
                        [v setBackgroundColor:[UIColor whiteColor]];
                        [v addSubview:attrNameLabel];
                        [v addSubview:valuelabel];
                        
                        [self.labelsScrollView addSubview:v];
                        
                        
                        lastY = attr_y + valueLabelHeight;
                        
                        addedHeightValue = addedHeightValue + v.frame.size.height + FIXED_V_DISTANCE;
                        
                    }
                }
            }
            
            addedHeightValue = addedHeightValue + FIXED_V_DISTANCE;
            
            
            totalHeight = totalHeight + addedHeightValue + 30;

            
            [self.labelsScrollView setScrollEnabled:YES];
            [self.labelsScrollView setShowsVerticalScrollIndicator:YES];
            [self.labelsScrollView setContentSize:(CGSizeMake(self.labelsScrollView.frame.size.width, totalHeight))];
            
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
        
        if (currentDetailsObject.isFeatured)
            [self.featureBtn setEnabled:NO];
        else
            [self.featureBtn setEnabled:YES];
        
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if(savedProfile){
            [self.favoriteButton setEnabled:YES];
            
            // Check favorite
            if (currentDetailsObject.isFavorite) {
                [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
            }
            
            // check if he own the Ad
            if (savedProfile.userID == currentDetailsObject.ownerID){
                [self.editBtn setEnabled:YES];
            [self.editAdBtn setEnabled:YES];
            } else{
                [self.editBtn setEnabled:NO];
                [self.editAdBtn setEnabled:NO];
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
            [self.distinguishingImage setHidden:NO];
            NSLog(@"%c",currentDetailsObject.isFeatured);
            [self.backgroundImage setImage:[UIImage imageNamed:@"Details_bg_Sp.png"]];
            // [self.priceLabel setTextColor:[UIColor colorWithRed:56.0/255 green:127.0/255 blue:161.0/255 alpha:1.0f]];
            [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
            [self.bgStoreView setImage:[UIImage imageNamed:@"Details_bar_Sp.png"]];
            
        }
        
        // Check store
        if (currentDetailsObject.storeID!=0) {
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
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
            [self.brandStoreImg setImage:image];
            
        }
    }
    
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
    if (currentDetailsObject)
    {
        [self.detailsLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailsLabel setText:currentDetailsObject.title];
        [self.detailsLabel setTextAlignment:SSTextAlignmentRight];
        [self.detailsLabel setTextColor:[UIColor blackColor]];
        [self.detailsLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:14.0] ];
        
        
        [self.priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.priceLabel setTextAlignment:SSTextAlignmentLeft];
        [self.priceLabel setTextColor:[UIColor colorWithRed:52.0f/255.0f green:165.0f/255.0f blue:206.0f/255.0f alpha:1.0f]];
        [self.priceLabel setFont:[[GenericFonts sharedInstance] loadFont:@"HelveticaNeueLTArabic-Roman" withSize:13.0] ];
        
        NSString * priceStr = [GenericMethods formatPrice:currentDetailsObject.price];
        if ([priceStr isEqualToString:@""])
            self.priceLabel.text = priceStr;
        else
            self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", priceStr, currentDetailsObject.currencyString];
        
        self.addTimeLabel.text = [[CarDetailsManager sharedInstance] getDateDifferenceStringFromDate:currentDetailsObject.postedOnDate];
        self.yearMiniLabel.text = [NSString stringWithFormat:@"%i", currentDetailsObject.modelYear];
        self.kiloMiniLabel.text = [NSString stringWithFormat:@"%i KM", currentDetailsObject.distanceRangeInKm];
        if (currentDetailsObject.viewCount > 0)
            self.watchingCountLabel.text = [NSString stringWithFormat:@"%i", currentDetailsObject.viewCount];
        else
        {
            self.watchingCountLabel.text = @"";
            [self.countOfViewsTinyImg setHidden:YES];
        }
        
    }
    [self customizeButtonsByData];
    [self resizeScrollView];
    
    //4- cache the resultArray data
    //... (COME BACK HERE LATER) ...
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
        
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [currentDetailsObject setIsFavorite:NO];
        if (self.parentVC)
            [self.parentVC updateFavStateForAdID:currentAdID withState:NO];
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
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_gray_heart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [currentDetailsObject setIsFavorite:YES];
        if (self.parentVC)
            [self.parentVC updateFavStateForAdID:currentAdID withState:YES];
        
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
    
    EditCarAdViewController *homeVC=[[EditCarAdViewController alloc] initWithNibName:@"EditCarAdViewController" bundle:nil];
    homeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    homeVC.myAdArray = resultArray;
    homeVC.myImageIDArray = resultIDs;
    homeVC.myDetails = currentDetailsObject;
    [self hideLoadingIndicator];
    
    [self presentViewController:homeVC animated:YES completion:nil];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 3) {
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
            shareButton.frame=CGRectMake(35, 430, shareButton.frame.size.width ,shareButton.frame.size.height );
        }
        
        else
            
        {
            self.labelsScrollView.frame=CGRectMake(0, self.toolBar.frame.size.height, self.labelsScrollView.frame.size.width ,960- self.toolBar.frame.size.height);
            shareButton.frame=CGRectMake(35, 520, shareButton.frame.size.width ,shareButton.frame.size.height );
            
        }
    }
    
    
    
}

@end