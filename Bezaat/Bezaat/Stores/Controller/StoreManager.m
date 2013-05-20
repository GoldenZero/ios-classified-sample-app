//
//  StoreManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "StoreManager.h"
#import "CarAdsManager.h"

#define LOGIN_STATUS_CODE_JKEY      @"StatusCode"
#define LOGIN_STATUS_MSG_JKEY       @"StatusMessage"
#define LOGIN_DATA_JKEY             @"Data"

#define LOGIN_USER_ID_JKEY          @"UserID"
#define LOGIN_USER_NAME_JKEY        @"UserName"
#define LOGIN_EMAIL_ADDRESS_JKEY    @"EmailAddress"
#define LOGIN_PASSWORD_JKEY         @"Password"
#define LOGIN_DEFAULT_CITY_ID_JKEY  @"DefaultCityID"
#define LOGIN_IS_VERIFIED_JKEY      @"IsVerified"
#define LOGIN_IS_ACTIVE_JKEY        @"IsActive"
#define LOGIN_HAS_STORES_JKEY       @"HasStores"


typedef enum {
    RequestInProgressCreateStore,
    RequestInProgressUploadLOGO,
    RequestInProgressGetUserStores,
    RequestInProgressGetStoreAds,
    RequestInProgressGetStoreStatus,
    RequestInProgressFeatureAdv,
    RequestInProgressUnfeatureAdv
} RequestInProgress;

@interface StoreManager () {
    InternetManager *internetManager;
    RequestInProgress requestInProgress;
    
    Store *storeForStatus;
}
@end

@implementation StoreManager

static NSString *create_store_url = @"/json/create-store";
static NSString *upload_logo_url = @"/json/upload-logo";
static NSString *get_user_stores_url = @"/json/user-stores";
static NSString *my_store_ads_url = @"/json/my-store-ads";
static NSString *store_status_url = @"/json/user-store-status";
static NSString *feature_adv_url = @"/json/make-store-ad-featured";
static NSString *unfeature_adv_url = @"/json/stop-store-ad-featured";
static NSString *create_store_temp_file = @"createStoreTmpFile";
static NSString *upload_logo_temp_file = @"uploadLogoTmpFile";
static NSString *get_user_stores_temp_file = @"getUserStoresTmpFile";
static NSString *my_store_ads_temp_file = @"myStoreAdsTmpFile";
static NSString *store_status_temp_file = @"StoreStatusTmpFile";
static NSString *feature_adv_temp_file = @"FeatureAdvTmpFile";
static NSString *unfeature_adv_temp_file = @"UnfeatureAdvTmpFile";


@synthesize delegate;

+ (StoreManager *) sharedInstance {
    static StoreManager * instance = nil;
    if (instance == nil) {
        instance = [[StoreManager alloc] init];
        create_store_url = [API_MAIN_URL stringByAppendingString:create_store_url];
        upload_logo_url = [API_MAIN_URL stringByAppendingString:upload_logo_url];
        get_user_stores_url = [API_MAIN_URL stringByAppendingString:get_user_stores_url];
        my_store_ads_url = [API_MAIN_URL stringByAppendingString:my_store_ads_url];
        store_status_url = [API_MAIN_URL stringByAppendingString:store_status_url];
        feature_adv_url = [API_MAIN_URL stringByAppendingString:feature_adv_url];
        unfeature_adv_url = [API_MAIN_URL stringByAppendingString:unfeature_adv_url];
    }
    return instance;
}

- (void)uploadLOGO:(UIImage *)image {
    requestInProgress = RequestInProgressUploadLOGO;
    
    //1- check connectivity
    if (![self checkConnectivity]) {
        return ;
    }
    
    //2- start the request
    /////////////////////////////////
    /*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
     */
    
	NSData *imageData = UIImageJPEGRepresentation(image, 90);
	
	// setting up the request object now
   // NSMutableURLRequest *request = [self request];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    /// set user credentials in HTTP header
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    //passing user id as a http header request
    NSString * userIDString = @"";
    if (savedProfile) { //if user is logged and not a visitor --> set the ID
        userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
    }
    else {
        userIDString = nil;
    }
    
    [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
    
    //passing password as a http header request
    NSString * passwordMD5String = savedProfile.passwordMD5;
    
    [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
/*
    if (request == nil) {
        [self manager:internetManager connectionDidFailWithError:[[NSError alloc] initWithDomain:@"user is not logged in!" code:0 userInfo:nil]];
        return;
    }
 */
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"StoreLOGO\"; filename=\"StoreLOGO.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    

    // setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    [request setURL:[NSURL URLWithString:upload_logo_url]];
	
    internetManager = [[InternetManager alloc] initWithTempFileName:upload_logo_temp_file
                                                         urlRequest:request
                                                           delegate:self
                                                   startImmediately:YES
                                                       responseType:@"JSON"
                       ];

}

- (void)createStore:(Store *)store {
    requestInProgress = RequestInProgressCreateStore;

    //1- check connectivity
    if (![self checkConnectivity]) {
        return;
    }
    UserProfile *s = [[SharedUser sharedInstance] getUserProfileData];
    NSMutableURLRequest *request;
    //2- start the request
    //NSMutableURLRequest *request = [self request];
    /*
    if (request == nil) {
        [self manager:internetManager connectionDidFailWithError:[[NSError alloc] initWithDomain:@"user is not logged in!" code:0 userInfo:nil]];
        return;
    }*/
    if (!s) {
    request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    /// set user credentials in HTTP header
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    //passing user id as a http header request
    NSString * userIDString = @"";
    if (savedProfile) { //if user is logged and not a visitor --> set the ID
        userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
    }
    else {
        userIDString = nil;
    }
    
    [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
    
    //passing password as a http header request
    NSString * passwordMD5String = savedProfile.passwordMD5;
    
    [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
    }else {
        request = [self request];
    }
    [request setURL:[NSURL URLWithString:create_store_url]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSString * post =[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%d&%@=%@&%@=%@"
                      ,@"StoreName", store.name
                      ,@"Description", store.desc
                      ,@"EmailAddress", store.ownerEmail
                      ,@"CountryID", store.countryID
                      ,@"MobileNumber", store.phone
                      ,@"Password",store.storePassword
                      ];
    if (store.imageURL != nil) {
        post = [post stringByAppendingFormat:@"&%@=%@",@"LogoURL", store.imageURL];
    }
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // start the request
    [request setHTTPBody:postData];
    
    internetManager = [[InternetManager alloc] initWithTempFileName:create_store_temp_file
                                                         urlRequest:request
                                                           delegate:self
                                                   startImmediately:YES
                                                       responseType:@"JSON"
                       ];
}

- (void)getUserStores {
    requestInProgress = RequestInProgressGetUserStores;
    
    //1- check connectivity
    if (![self checkConnectivity]) {
        return;
    }
    
    //2- start the request
    NSMutableURLRequest *request = [self request];
    
    if (request == nil) {
        [self manager:internetManager connectionDidFailWithError:[[NSError alloc] initWithDomain:@"user is not logged in!" code:0 userInfo:nil]];
        return;
    }
    [request setURL:[NSURL URLWithString:get_user_stores_url]];
    
    internetManager = [[InternetManager alloc] initWithTempFileName:get_user_stores_temp_file
                                                         urlRequest:request
                                                           delegate:self
                                                   startImmediately:YES
                                                       responseType:@"JSON"
                       ];
}

- (void)getStoreAds:(NSInteger)storeID page:(NSInteger)pageNumber status:(NSString *)status {
    requestInProgress = RequestInProgressGetStoreAds;
    
    //1- check connectivity
    if (![self checkConnectivity]) {
        return;
    }
    
    //2- start the request
    NSMutableURLRequest *request = [self request];
    
    if (request == nil) {
        [self manager:internetManager connectionDidFailWithError:[[NSError alloc] initWithDomain:@"user is not logged in!" code:0 userInfo:nil]];
        return;
    }
    NSString *urlString  = [NSString stringWithFormat:@"%@?pageno=%d&pagesize=10&status=%@&storeid=%d",my_store_ads_url,pageNumber,status,storeID];
    [request setURL:[NSURL URLWithString:urlString]];
    
    // start the request
    internetManager = [[InternetManager alloc] initWithTempFileName:my_store_ads_temp_file
                                                         urlRequest:request
                                                           delegate:self
                                                   startImmediately:YES
                                                       responseType:@"JSON"
                       ];
}

- (void) getStoreStatus:(Store *)store {
    requestInProgress = RequestInProgressGetStoreStatus;
    storeForStatus = store;
    
    //1- check connectivity
    if (![self checkConnectivity]) {
        return;
    }
    
    //2- start the request
    NSMutableURLRequest *request = [self request];
    
    if (request == nil) {
        [self manager:internetManager connectionDidFailWithError:[[NSError alloc] initWithDomain:@"user is not logged in!" code:0 userInfo:nil]];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?storeid=%d",store_status_url,store.identifier];
    [request setURL:[NSURL URLWithString:urlString]];
    
    // start the request
    internetManager = [[InternetManager alloc] initWithTempFileName:store_status_temp_file
                                                         urlRequest:request
                                                           delegate:self
                                                   startImmediately:YES
                                                       responseType:@"JSON"
                       ];
}

- (void)unfeatureAdv:(NSInteger)advID inStore:(NSInteger)storeID {
    requestInProgress = RequestInProgressUnfeatureAdv;
    
    //1- check connectivity
    if (![self checkConnectivity]) {
        return;
    }
    
    //2- start the request
    NSMutableURLRequest *request = [self request];
    
    if (request == nil) {
        [self manager:internetManager connectionDidFailWithError:[[NSError alloc] initWithDomain:@"user is not logged in!" code:0 userInfo:nil]];
        return;
    }
    [request setURL:[NSURL URLWithString:unfeature_adv_url]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString * post =[NSString stringWithFormat:@"%@=%d&%@=%d"
                      ,@"StoreID",storeID
                      ,@"AdID", advID
                      ];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // start the request
    [request setHTTPBody:postData];
    
    internetManager = [[InternetManager alloc] initWithTempFileName:unfeature_adv_temp_file
                                                         urlRequest:request
                                                           delegate:self
                                                   startImmediately:YES
                                                       responseType:@"JSON"
                       ];
}

- (void)featureAdv:(NSInteger)advID inStore:(NSInteger)storeID featureDays:(NSInteger)featureDays {
    requestInProgress = RequestInProgressFeatureAdv;
    
    //1- check connectivity
    if (![self checkConnectivity]) {
        return;
    }
    
    //2- start the request
    NSMutableURLRequest *request = [self request];
    
    
    if (request == nil) {
        [self manager:internetManager connectionDidFailWithError:[[NSError alloc] initWithDomain:@"user is not logged in!" code:0 userInfo:nil]];
        return;
    }
    [request setURL:[NSURL URLWithString:feature_adv_url]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString * post =[NSString stringWithFormat:@"%@=%d&%@=%d&%@=%d"
                      ,@"StoreID",storeID
                      ,@"AdID", advID
                      ,@"NoOfFeaturedDays", featureDays
                      ];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // start the request
    [request setHTTPBody:postData];
    
    internetManager = [[InternetManager alloc] initWithTempFileName:feature_adv_temp_file
                                                         urlRequest:request
                                                           delegate:self
                                                   startImmediately:YES
                                                       responseType:@"JSON"
                       ];
}

#pragma mark - Private Methods

- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    return [self addUserCredentialsToRequest:request];
}

- (NSMutableURLRequest *)addUserCredentialsToRequest:(NSMutableURLRequest *)request {
    /// set user credentials in HTTP header
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    //passing user id as a http header request
    NSString * userIDString = @"";
    if (savedProfile) { //if user is logged and not a visitor --> set the ID
        userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
    }
    else {
        return nil;
    }
    
    [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
    
    //passing password as a http header request
    NSString * passwordMD5String = savedProfile.passwordMD5;
    
    [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
    
    return request;
}

- (BOOL) checkConnectivity {
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate storeCreationDidFailWithError:error];
        return NO;
    }
    return YES;
}

#pragma mark - DataDelegate Methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    if (manager != internetManager) {
        return;
    }
    
    if (requestInProgress == RequestInProgressUploadLOGO) {
        if ([delegate respondsToSelector:@selector(storeLOGOUploadDidFailWithError:)]) {
            [delegate storeLOGOUploadDidFailWithError:error];
        }
    }
    else if (requestInProgress == RequestInProgressCreateStore) {
        if ([delegate respondsToSelector:@selector(storeCreationDidFailWithError:)]) {
            [delegate storeCreationDidFailWithError:error];
        }
    }
    else if (requestInProgress == RequestInProgressGetUserStores) {
        if ([delegate respondsToSelector:@selector(userStoresRetrieveDidFailWithError:)]) {
            [delegate userStoresRetrieveDidFailWithError:error];
        }
    }
    else if (requestInProgress == RequestInProgressGetStoreAds) {
        if ([delegate respondsToSelector:@selector(storeAdsRetrieveDidFailWithError:)]) {
            [delegate storeAdsRetrieveDidFailWithError:error];
        }
    }
    else if (requestInProgress == RequestInProgressGetStoreStatus) {
        if ([delegate respondsToSelector:@selector(storeStatusRetrieveDidFailWithError:)]) {
            [delegate storeStatusRetrieveDidFailWithError:error];
        }
    }
    else if (requestInProgress == RequestInProgressFeatureAdv) {
        if ([delegate respondsToSelector:@selector(featureAdvDidFailWithError:)]) {
            [delegate featureAdvDidFailWithError:error];
        }
    }
    else if (requestInProgress == RequestInProgressUnfeatureAdv) {
        if ([delegate respondsToSelector:@selector(unfeatureAdvDidFailWithError:)]) {
            [delegate unfeatureAdvDidFailWithError:error];
        }
    }

}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*)result {
    if (manager != internetManager) {
        return;
    }
    if (requestInProgress == RequestInProgressUploadLOGO) {
        NSDictionary *data = ((NSArray *)result)[0][@"Data"];
        NSString *imageURL = [data objectForKey:@"LogoURL"];
        if ([delegate respondsToSelector:@selector(storeLOGOUploadDidSucceedWithImageURL:)]) {
            [delegate storeLOGOUploadDidSucceedWithImageURL:imageURL];
        }
    }
    else if (requestInProgress == RequestInProgressCreateStore) {
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        if (!savedProfile.hasStores) {
            //[[ProfileManager sharedInstance] updateStoreStateForCurrentUser:YES];
        }
        if ([delegate respondsToSelector:@selector(storeCreationDidSucceedWithStoreID: andUser:)]) {
            NSLog(@"%@",((NSArray *)result)[0][@"Data"]);
            NSDictionary *s = ((NSArray *)result)[0][@"Data"];
            NSString * statusCodeString = [NSString stringWithFormat:@"%@", ((NSArray *)result)[0][LOGIN_STATUS_CODE_JKEY]] ;
            NSInteger statusCode = statusCodeString.integerValue;
            NSString * message = ((NSArray *)result)[0][LOGIN_STATUS_MSG_JKEY];
            if (statusCode == 320) {
                CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                [error setDescMessage:message];
                [delegate storeCreationDidFailWithError:error];
            }else {
            NSDictionary* storeDict = [s objectForKey:@"Store"];
                NSDictionary* userDict = [[NSDictionary alloc]init];
                NSString* ID;
                if (!storeDict.count == 0) {
                    if ([[[s objectForKey:@"User"] description] isEqualToString:@""]) {
                        //[userDict setValue:@"0" forKey:@"0"];
                        //[userDict set]
                    }else {
                        userDict = [s objectForKey:@"User"];}
            ID = [storeDict objectForKey:@"StoreID"];
                }else {
                    CustomError * error = [CustomError errorWithDomain:@"" code:statusCode userInfo:nil];
                    [error setDescMessage:message];
                    [delegate storeCreationDidFailWithError:error];
                }
                UserProfile* newUser;
                if (userDict.count > 0) {
                    newUser = [self getUserData:userDict];
                }else{
                    newUser = [[SharedUser sharedInstance] getUserProfileData];
                }
             [delegate storeCreationDidSucceedWithStoreID:[ID integerValue] andUser:newUser];
            
            }
            
           
        }
    }
    else if (requestInProgress == RequestInProgressGetUserStores) {
        NSArray *storesDics = ((NSArray *)result)[0][@"Data"];
        NSMutableArray *stores = [[NSMutableArray alloc] initWithCapacity:[storesDics count]];
        for (NSDictionary *storeDic in storesDics) {
            Store *store = [[Store alloc] init];
            store.identifier = [storeDic[@"StoreID"] integerValue];
            store.name = storeDic[@"StoreName"];
            store.activeAdsCount = [storeDic[@"ActiveAdsCount"] integerValue];
            store.countryID = [storeDic[@"CountryID"] integerValue];
            store.contactNo = storeDic[@"StoreContactNo"];
            store.imageURL = storeDic[@"StoreImageURL"];
            store.ownerEmail = storeDic[@"StoreOwnerEmail"];
            store.status = [storeDic[@"StoreStatus"] integerValue];
            store.remainingFreeFeatureAds = [storeDic[@"RemainingFreeFeatureAds"] integerValue];
            store.remainingDays = [storeDic[@"RemainingDays"] integerValue];
            [stores addObject:store];
        }
        if ([delegate respondsToSelector:@selector(userStoresRetrieveDidSucceedWithStores:)]) {
            [delegate userStoresRetrieveDidSucceedWithStores:stores];
        }
    }
    else if (requestInProgress == RequestInProgressGetStoreAds) {
        NSArray *ads = [[CarAdsManager sharedInstance] createCarAdsArrayWithData:(NSArray *)result];
        if ([delegate respondsToSelector:@selector(storeAdsRetrieveDidSucceedWithAds:)]) {
            [delegate storeAdsRetrieveDidSucceedWithAds:ads];
        }
    }
    else if (requestInProgress == RequestInProgressGetStoreStatus) {
        NSDictionary *dataDic = ((NSArray *)result)[0][@"Data"];
        storeForStatus.remainingDays = [dataDic[@"RemainingDays"] integerValue];
        storeForStatus.remainingFreeFeatureAds = [dataDic[@"RemainingFreeFeatureAds"] integerValue];
        
        NSLog(@"%@",storeForStatus);
        if ([delegate respondsToSelector:@selector(storeStatusRetrieveDidFailWithError:)]) {
            [delegate storeStatusRetrieveDidSucceedWithStatus:storeForStatus];
        }
    }
    else if (requestInProgress == RequestInProgressFeatureAdv) {
        if ([delegate respondsToSelector:@selector(featureAdvDidSucceed)]) {
            [delegate featureAdvDidSucceed];
        }
    }
    else if (requestInProgress == RequestInProgressUnfeatureAdv) {
        if ([delegate respondsToSelector:@selector(unfeatureAdvDidSucceed)]) {
            [delegate unfeatureAdvDidSucceed];
        }
    }

}

- (UserProfile *) getUserData: (NSDictionary *) responseDataArray {
    
    if ((responseDataArray) && (responseDataArray.count > 0))
    {
        //NSDictionary * totalDict = [responseDataArray objectAtIndex:0];
        //NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
       // NSInteger statusCode = statusCodeString.integerValue;
       // if (statusCode == 200)
        //{
           // NSDictionary * dataDict = [totalDict objectForKey:LOGIN_DATA_JKEY];
            if (responseDataArray)
            {
                UserProfile * p = [[UserProfile alloc]
                                   initWithUserIDString:[responseDataArray objectForKey:LOGIN_USER_ID_JKEY]
                                   userName:[responseDataArray objectForKey:LOGIN_USER_NAME_JKEY]
                                   emailAddress:[responseDataArray objectForKey:LOGIN_EMAIL_ADDRESS_JKEY]
                                   passwordMD5:[responseDataArray objectForKey:LOGIN_PASSWORD_JKEY]
                                   defaultCityIDString:[responseDataArray objectForKey:LOGIN_DEFAULT_CITY_ID_JKEY]
                                   isVerifiedString:[responseDataArray objectForKey:LOGIN_IS_VERIFIED_JKEY]
                                   isActiveString:[responseDataArray objectForKey:LOGIN_IS_ACTIVE_JKEY]
                                   hasStoresString:[responseDataArray objectForKey:LOGIN_HAS_STORES_JKEY]
                                   ];
                return p;
            }
        //}
    }
    return nil;
    
}


@end
