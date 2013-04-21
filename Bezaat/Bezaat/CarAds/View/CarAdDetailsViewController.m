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
    HJObjManager* asynchImgManager;   //asynchronous image loading manager
    AURosetteView *shareButton;
    UITapGestureRecognizer *tap;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)twitterAction:(id)sender;
- (void)facebookAction:(id)sender;
- (void)mailAction:(id)sender;

@end

@implementation CarAdDetailsViewController
@synthesize pageControl,scrollView, phoneNumberButton, favoriteButton, featureBtn, editBtn, topMostToolbar;
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
    // hide share button
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissShareButton)];
    [self.scrollView addGestureRecognizer:tap];
    [self.labelsScrollView addGestureRecognizer:tap];

    
    
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
    //self.labelsScrollView.delegate = self;
    
    //init the image load manager
    asynchImgManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	asynchImgManager.fileCache = fileCache;
    
    //set the original size of scroll view without loading any labels yet
    originalScrollViewHeight = self.labelsScrollView.frame.size.height;
    
    [self prepareShareButton];
    
    [self startLoadingData];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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
    imageView.url = imageURL;
    
    [imageView showLoadingWheel];
    [asynchImgManager manage:imageView];
    
    [subView addSubview:imageView];
    return subView;
    
}

// flod share button when touch the screen
-(void)dismissShareButton{
    if ((shareButton.on)) {
        [shareButton fold];
    }

    
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
    [shareButton setCenter:CGPointMake(35.0f, 430.0f)];
    
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
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)editAdBtnPrss:(id)sender {
}

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMailBtnPrss:(id)sender {
    
    if (currentDetailsObject)
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:currentDetailsObject.title];
        
        NSString * mailBody = currentDetailsObject.description;
        
        //set the recipients to the car ad owner
        //mailer setToRecipients:
        
        [mailer setMessageBody:mailBody isHTML:NO];
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
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
    
    if (currentDetailsObject)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.thumbnailURL)
                [mySLComposerSheet addURL:currentDetailsObject.thumbnailURL];
            
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
        /*
        else
            // no twitter account set in device settings
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"تعذر الحصول على بيانات تويتر في إعدادات جهازك" delegateVC:self];
         */
    }
    
}

- (void)facebookAction:(id)sender{
    
    if (currentDetailsObject)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [mySLComposerSheet setInitialText:currentDetailsObject.title];
            
            //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            if (currentDetailsObject.thumbnailURL)
                [mySLComposerSheet addURL:currentDetailsObject.thumbnailURL];
            
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
        /*
        else
            // no facebook account set in device settings
            [GenericMethods throwAlertWithTitle:@"خطأ" message:@"تعذر الحصول على بيانات تويتر في إعدادات جهازك" delegateVC:self];
         */
    }
    
}

- (void)mailAction:(id)sender {
    if (currentDetailsObject)
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:currentDetailsObject.title];
        
        NSString * mailBody = currentDetailsObject.description;
        
        [mailer setMessageBody:mailBody isHTML:NO];
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
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
    
    CGFloat lastY = self.addTimeLabel.frame.origin.y + self.addTimeLabel.frame.size.height;
    
    //1- remove all subviews in scroll view, lower than lastY (number is took from nib)
    for (UIView * subview in [self.labelsScrollView subviews]) {
        if (subview.frame.origin.y > lastY) {
            [subview removeFromSuperview];
        }
    }
    
    
    
    if (currentDetailsObject)
    {
        //1- set car images
        if ((currentDetailsObject.adImages) && (currentDetailsObject.adImages.count))
        {
            self.pageControl.currentPage = 0;
            self.pageControl.numberOfPages = currentDetailsObject.adImages.count;
            for (int i=0; i < currentDetailsObject.adImages.count; i++) {
                NSURL * imgURL = [(CarDetailsImage *)[currentDetailsObject.adImages objectAtIndex:i] thumbnailImageURL];
                [self.scrollView addSubview:[self prepareImge:imgURL :i]];
            }
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
                
                UILabel * attrNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(attr_x, attr_y, expectedLabelSize.width, expectedLabelSize.height)];
                
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
                
                UILabel * valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(val_x, val_y, valueLabelWidth, valueLabelHeight)];
                
                valuelabel.text = attr.attributeValue;
                valuelabel.textAlignment = NSTextAlignmentRight;
                valuelabel.font = [UIFont systemFontOfSize:15];
                valuelabel.backgroundColor = [UIColor clearColor];
                
                [self.labelsScrollView addSubview:attrNameLabel];
                [self.labelsScrollView addSubview:valuelabel];
                
                lastY = attr_y + valueLabelHeight;
                addedHeightValue = addedHeightValue + valueLabelHeight + FIXED_V_DISTANCE;
            }
            
            addedHeightValue = addedHeightValue + FIXED_V_DISTANCE;
            
            CGFloat totalHeight = self.labelsScrollView.frame.size.height + addedHeightValue;
            
            [self.labelsScrollView setScrollEnabled:YES];
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
        
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        if(savedProfile){
            [self.favoriteButton setHidden:NO];
            
            // Check favorite
            if (currentDetailsObject.isFavorite) {
                [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
            }
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
            [self.backgroundImage setImage:[UIImage imageNamed:@"Details_bg_Sp.png"]];
            [self.priceLabel setTextColor:[UIColor orangeColor]];
            [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
            [self.bgStoreView setImage:[UIImage imageNamed:@"Details_bar_Sp.png"]];
            
        }
        
        // Check store
        if (currentDetailsObject.storeID!=0) {
            [self.storeView setHidden:NO];
            self.contentView.frame=CGRectMake(0,124 ,self.contentView.frame.size.width , self.contentView.frame.size.height);
            [self.nameStoreLabel setText:currentDetailsObject.storeName];
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
        self.detailsLabel.text = currentDetailsObject.title;
        
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
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [currentDetailsObject setIsFavorite:NO];
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
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_gray_heart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [currentDetailsObject setIsFavorite:YES];
        [self.favoriteButton setImage:[UIImage imageNamed:@"Details_navication_2_hart.png"] forState:UIControlStateNormal];
    }
    
}


@end
