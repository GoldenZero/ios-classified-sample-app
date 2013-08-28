//
//  StoreOrdersViewController.m
//  Bezaat
//
//  Created by GALMarei on 7/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreOrdersViewController.h"

@interface StoreOrdersViewController ()
{
    
    float lastContentOffset;
    UITapGestureRecognizer *tap;
    MBProgressHUD2 * loadingHUD;
    NSMutableArray * storeOrdersArray;
    HJObjManager* asynchImgManager;   //asynchronous image loading manager
    BOOL dataLoadedFromCache;
    BOOL isRefreshing;
    
    StoreOrder * myOrderObject;
    float xForShiftingTinyImg;
    BOOL isSecondPage;
    
    UIActivityIndicatorView * iPad_activityIndicator;
    UIView * iPad_loadingView;
    UILabel *iPad_loadingLabel;
}

@end

@implementation StoreOrdersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        lastContentOffset=0;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.adsTable setSeparatorColor:[UIColor clearColor]];
    [self.adsTable setBackgroundColor:[UIColor clearColor]];
[self.noAdsImage setHidden:YES];
    isSecondPage = NO;
    //initialize the user to get info
    CurrentUser = [[UserProfile alloc]init];
    locationMngr = [LocationManager sharedInstance];
    locationMngr = [LocationManager sharedInstance];
    CurrentUser = [[ProfileManager sharedInstance] getSavedUserProfile];
    defaultCityID =  [[SharedUser sharedInstance] getUserCityID];
    
    //init the array if it is still nullable
    if (!storeOrdersArray)
        storeOrdersArray = [NSMutableArray new];
    
    //init the image load manager
    asynchImgManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	asynchImgManager.fileCache = fileCache;
    
    //hide the scrolling indicator
    [self.adsTable setShowsVerticalScrollIndicator:NO];
    //[self.tableView setScrollEnabled:NO];
    
    dataLoadedFromCache = NO;
    isRefreshing = NO;
    currentStatus = @"active";
    //load the first page of data
    [self loadFirstDataOfOrdersWithPage:1];
    
    // Do any additional setup after loading the view from its nib.
    
    //GA
    [[GAI sharedInstance].defaultTracker sendView:@"User my ads screen"];
    //end GA
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.adsTable setNeedsDisplay];
    [self.adsTable reloadData];
    self.adsTable.contentSize=CGSizeMake(320, self.adsTable.contentSize.height);
}

- (void) loadFirstDataOfOrdersWithPage:(NSInteger)pageNumb {
    
    //refresh table data
    [self.adsTable reloadData];
    [self.adsTable setContentOffset:CGPointZero animated:YES];
    dataLoadedFromCache = NO;
    [[CarAdsManager sharedInstance] setCurrentPageNum:1];
    [[CarAdsManager sharedInstance] setPageSizeToDefault];
    [self loadPageOfAdsOfOrderWithPage:pageNumb];
    
}
- (void) loadPageOfAdsOfOrderWithPage:(NSInteger)pageNum {
    dataLoadedFromCache = NO;
    
    //show loading indicator
    [self showLoadingIndicator];
    NSInteger page;
    if (!pageNum) {
        //load a page of data
        page = [[CarAdsManager sharedInstance] nextPage];
    }else{
        page = pageNum;
    }
    
    //NSInteger size = [[CarAdsManager sharedInstance] pageSize];
    
//[[CarAdsManager sharedInstance] loadUserAdsOfStatus:status forPage:page andSize:[[CarAdsManager sharedInstance] getCurrentPageSize] WithDelegate:self];
    [StoreManager sharedInstance].delegate = self;
    [[StoreManager sharedInstance] getStoreOrdersForPage:page andSize:[[CarAdsManager sharedInstance] getCurrentPageSize]];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //4- cache the data
    
    //   [[CarAdsManager sharedInstance] loadUserAdsOfStatus:@"all" forPage:[[CarAdsManager sharedInstance] getCurrentPageNum] andSize:[[CarAdsManager sharedInstance] getCurrentPageSize] WithDelegate:self];
    
}


#pragma mark - StoreManager Delegate methods

-(void)storeOrdersLoadDidFailLoadingWithError:(NSError *)error
{
    [GenericMethods throwAlertWithTitle:@"خطأ" message:[error description] delegateVC:self];
    [self.noAdsImage setHidden:NO];
    [self hideLoadingIndicator];

}

-(void)storeOrdersLoadDidFinishLoadingWithOrders:(NSArray *)orders
{
    if ([orders count] == 0) {
        dataLoadedFromCache = YES;
        if (!isSecondPage)
        [self.noAdsImage setHidden:NO];
    }
     //2- append the newly loaded ads
    else if (orders && [orders count]!=0)
    {
        for (StoreOrder* obj in orders) {
            [storeOrdersArray addObject:obj];
        }
        //3- refresh table data
        [self.adsTable reloadData];
        
    }
    
    //1- hide the loading indicator
    [self hideLoadingIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollToTheBottom
{
    if (self.adsTable.contentSize.height > self.adsTable.frame.size.height)
    {
        CGPoint offset = CGPointMake(0,self.adsTable.contentSize.height-self.adsTable.frame.size.height);
        [self.adsTable setContentOffset:offset animated:YES];
    }
}

#pragma mark - tableView handlig
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([storeOrdersArray count] == 0) {
        return 130;
    }
    


    //store order - with image
    return 130 ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (storeOrdersArray)
    {
        //[self scrollToTheBottom];
        return storeOrdersArray.count;
    }
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NCellId";
    xForShiftingTinyImg = 0;
    StoreOrder * orderObject;
    if ((storeOrdersArray) && (storeOrdersArray.count)){
        orderObject = (StoreOrder *)[storeOrdersArray objectAtIndex:indexPath.row];
        myOrderObject = (StoreOrder *)[storeOrdersArray objectAtIndex:indexPath.row];
    }
    else
        return [UITableViewCell new];
    
     //store ad - with image
    
    StoreOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[StoreOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StoreOrderCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    NSString * newThumbUrl = [orderObject.StoreImageURL stringByReplacingOccurrencesOfString:@"http://content.bezaat.com" withString:@"http://content.bezaat.com.s3-external-3.amazonaws.com"];
    
    [cell.storeImage setImageWithURL:[NSURL URLWithString:newThumbUrl] placeholderImage:[UIImage imageNamed:@"default-car.jpg"]];
    
    [cell.storeImage setContentMode:UIViewContentModeScaleAspectFill];
    [cell.storeImage setClipsToBounds:YES];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yy"];
    [cell.storeName setText:orderObject.StoreName];
    [cell.paymentMethod setText:[self getPaymentMethod:orderObject.PaymentMethod]];
    [cell.orderStatus setText:[self getOrderStatus:orderObject.OrderStatus]];
    [cell.orderBundle setText:orderObject.StorePaymentSchemeName];
    
    [cell.orderDate setText:[df stringFromDate:orderObject.LastModifiedOn]];
    [cell.orderId setText:[NSString stringWithFormat:@"%i", orderObject.OrderID]];

    if (orderObject.OrderStatus != 1) {
        [cell.bankTransferBtn setHidden:YES];
    }
    cell.bankTransferBtn.tag = indexPath.row;
    cell.proceedBtn.tag = indexPath.row;
    
    [cell.bankTransferBtn addTarget:self action:@selector(bankPayment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.proceedBtn addTarget:self action:@selector(ProceedInvoked:) forControlEvents:UIControlEventTouchUpInside];
    
    //customize the carAdCell with actual data
            /* // just comment
            cell.carTitle.text = carAdObject.title;
            NSString * priceStr = [GenericMethods formatPrice:carAdObject.price];
            if ([priceStr isEqualToString:@""])
                cell.carPrice.text = priceStr;
            else
                cell.carPrice.text = [NSString stringWithFormat:@"%@ %@", priceStr, carAdObject.currencyString];
            if (carAdObject.price < 1.0) {
                cell.carPrice.text = @"";
            }
            cell.adTime.text = [[CarAdsManager sharedInstance] getDateDifferenceStringFromDate:carAdObject.postedOnDate];*/
            
            /*
             cell.carModel.text = [NSString stringWithFormat:@"%i", carAdObject.modelYear];
             
             if (carAdObject.viewCount > 0)
             cell.adViews.text = [NSString stringWithFormat:@"%i", carAdObject.viewCount];
             else
             {
             cell.adViews.text = @"";
             //[cell.countOfViewsTinyImg setHidden:YES];
             }
             
             cell.carDistance.text = [NSString stringWithFormat:@"%i KM", carAdObject.distanceRangeInKm];
             */
                     
            return cell;
        
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    
    
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == ([self.adsTable numberOfRowsInSection:0] - 1))
    {
        isSecondPage = YES;
        if (!dataLoadedFromCache)
            [self loadPageOfAdsOfOrderWithPage:nil];
    }
}

-(NSString*)getPaymentMethod:(NSInteger)payment
{
    switch (payment) {
        case 5:
            return @"اندرويد بايبال";
            break;
            
        case 4:
            return @"أبل ستور";
            break;
            
        case 2:
            return @"تحويل بنكي";
            break;
            
        default:
            return @"بطاقة إئتمانية";
            break;
    }
}

-(NSString*)getOrderStatus:(NSInteger)status
{
    switch (status) {
        case 0:
            return @"قيد الإنشاء";
            break;
            
        case 1:
            return @"بانتظار التحويل البنكي";
            break;
            
        case 2:
            return @"تم الطلب";
            break;
        
        case 3:
            return @"فشل العملية";
            break;
            
        case 4:
            return @"تم التفعيل";
            break;
            
        case 5:
            return @"مرفوض";
            break;
            
        case 6:
            return @"تم التأكيد";
            break;
            
        case 7:
            return @"ملغي";
            break;

        default:
            return @"";
            break;
    }
}

-(void)bankPayment:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    StoreOrder * orderObject = (StoreOrder *)[storeOrdersArray objectAtIndex:btn.tag];
   
    BankTransferPaymentVC *vc=[[BankTransferPaymentVC alloc] initWithNibName:@"BankTransferPaymentVC" bundle:nil];
    vc.currentOrder = orderObject;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

-(void)ProceedInvoked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    StoreOrder * orderObject = (StoreOrder *)[storeOrdersArray objectAtIndex:btn.tag];
    
    FeatureStoreAdViewController *vc=[[FeatureStoreAdViewController alloc] initWithNibName:@"FeatureStoreAdViewController" bundle:nil];
    vc.currentOrder = orderObject;
    [self presentViewController:vc animated:YES completion:nil];
    
}


/*
 #pragma mark - Table view data source
 
 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 10;
 }
 
 
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 100;
 }
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 // Return the number of sections.
 return 4;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 // Return the number of rows in the section.
 return 1;
 }
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 static NSString *DropDownCellIdentifier = @"profileCell";
 
 
 StoreAdsCell *cell = (StoreAdsCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
 
 if (cell == nil){
 NSLog(@"New Cell Made");
 
 NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StoreAdsCell" owner:nil options:nil];
 
 for(id currentObject in topLevelObjects)
 {
 if([currentObject isKindOfClass:[StoreAdsCell class]])
 {
 cell = (StoreAdsCell *)currentObject;
 break;
 }
 }
 }
 
 //[cell.carImage setImage:[UIImage imageNamed:@"setting_user.png"]];
 //cell.carTitle.text = @"إسم المستخدم";
 
 return cell;
 
 
 }
 
 #pragma mark - Table view delegate
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 BrowseStoresViewController* vc = [[BrowseStoresViewController alloc]initWithNibName:@"BrowseStoresViewController" bundle:nil];
 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 [self presentViewController:vc animated:YES completion:nil];
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 }
 */
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

@end
