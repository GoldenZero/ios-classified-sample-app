//
//  ProfileManager.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ProfileManager.h"

#pragma mark - login json keys

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
#define LOGIN_USER_TWITTER_ID_JKEY  @"TwitterUserID"
#define LOGIN_USER_FACEBOOK_ID_JKEY @"FacebookID"


#pragma mark - device register json keys

#define DREG_DEVICE_ID              @"DeviceID"
#define DREG_TYPE                   @"Type"
#define DREG_TOKEN                  @"Token"
#define DREG_VERSION                @"Version"
#define DREG_OS_VERSION             @"OSVersion"
#define DREG_IP_ADDRESS             @"IPAddress"
#define DREG_REGISTERED_ON          @"RegisteredOn"


@interface ProfileManager ()
{
    InternetManager * mainMngr;
    InternetManager * updateMngr;
    InternetManager * favoriteAddMngr;
    InternetManager * favoriteRemoveMngr;
    InternetManager * removeAdMngr;
    NSUInteger currentAdIDForFav;
    NSString* twitterChecked;
    @protected
        NSMutableData * dataSoFar;
}
@end

@implementation ProfileManager
@synthesize delegate;
@synthesize deviceDelegate;
@synthesize favDelegate;
@synthesize updateDelegate;

//the login url is a POST url
static NSString * login_url = @"/json/user-login";
static NSString * login_twitter_url = @"/json/user-twitter-login";
static NSString * login_facebook_url = @"/json/user-facebook-login";
static NSString * register_url = @"/json/register-user";
static NSString * device_reg_url = @"/json/register-device?deviceTpe=%@&version=%@&osVersion=%@";
static NSString * add_to_fav_url = @"/json/add-to-favorite";
static NSString * remove_from_fav_url = @"/json/remove-from-favorite";

static NSString * remove_from_ad_url = @"/json/delete-ad";

static NSString * update_user_url = @"/json/modify-user";

static NSString * login_email_post_key = @"EmailAddress";
static NSString * update_user_post_key = @"UserName";
static NSString * update_user_twitter_post_key = @"TwitterUserID";
static NSString * update_user_facebook_post_key = @"FacebookID";
static NSString * login_password_post_key = @"Password";
static NSString * login_key_chain_identifier_iPhone = @"BezaatLogin_iPhone";
static NSString * login_key_chain_identifier_iPad = @"BezaatLogin_iPad";
static NSString * ad_id_post_key = @"AdID";

static NSString * mainMngrTempFileName = @"mngrTmp";
static NSString * favMngrTempFileName = @"favmngrTmp";
static NSString * updateMngrTempFileName = @"updmngrTmp";

- (id) init {
    
    self = [super init];
    
    if (self) {
        self.delegate = nil;
        self.deviceDelegate = nil;
        self.favDelegate = nil;
        self.updateDelegate = nil;
        self.RegisterDelegate = nil;
        dataSoFar = nil;
        currentAdIDForFav= 0;
        
        login_url = [API_MAIN_URL stringByAppendingString:login_url];
        login_twitter_url = [API_MAIN_URL stringByAppendingString:login_twitter_url];
        login_facebook_url = [API_MAIN_URL stringByAppendingString:login_facebook_url];
        register_url = [API_MAIN_URL stringByAppendingString:register_url];
        device_reg_url = [API_MAIN_URL stringByAppendingString:device_reg_url];
        add_to_fav_url = [API_MAIN_URL stringByAppendingString:add_to_fav_url];
        remove_from_fav_url = [API_MAIN_URL stringByAppendingString:remove_from_fav_url];
        remove_from_ad_url = [API_MAIN_URL stringByAppendingString:remove_from_ad_url];
        update_user_url = [API_MAIN_URL stringByAppendingString:update_user_url];
        

    }
    return self;
}

+ (ProfileManager *) sharedInstance {
    static ProfileManager * instance = nil;
    if (instance == nil) {
        instance = [[ProfileManager alloc] init];
    }
    return instance;
}

+ (KeychainItemWrapper *) loginKeyChainItemSharedInstance {
    static KeychainItemWrapper * wrapperInstance = nil;
    if (wrapperInstance == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            wrapperInstance = [[KeychainItemWrapper alloc] initWithIdentifier:login_key_chain_identifier_iPhone accessGroup:nil];
        else
            wrapperInstance = [[KeychainItemWrapper alloc] initWithIdentifier:login_key_chain_identifier_iPad accessGroup:nil];
    }
    
    return wrapperInstance;
}

- (void) loginWithDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress password:(NSString *) plainPassword {
    
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- start the request
    NSString * post =[NSString stringWithFormat:@"%@=%@&%@=%@",login_email_post_key, emailAdress, login_password_post_key, [plainPassword MD5]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    
    [request setURL:[NSURL URLWithString:login_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

- (void) loginWithTwitterDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress AndUserName:(NSString *) userName andTwitterid:(NSString*)twitterID
{
    twitterChecked = @"twitter";
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- start the request
    NSString * post =[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",login_email_post_key, emailAdress, update_user_post_key, userName,update_user_twitter_post_key,twitterID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    
    [request setURL:[NSURL URLWithString:login_twitter_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

}

- (void) loginWithFacebookDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress AndUserName:(NSString *) userName andFacebookid:(NSString*)facebookID
{
    twitterChecked = @"facebook";
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- start the request
    NSString * post =[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",login_email_post_key, emailAdress, update_user_post_key, userName,update_user_facebook_post_key,facebookID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    
    [request setURL:[NSURL URLWithString:login_facebook_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}


- (void) registerWithDelegate:(id <ProfileRegisterDelegate>) del UserName:(NSString *) userName AndEmail:(NSString *) emailAdress andPassword:(NSString*)PWD
{
    twitterChecked = @"twitter";
    //1- set the delegate
    self.RegisterDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //3- start the request
    NSString * post =[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",update_user_post_key, userName,login_email_post_key, emailAdress,login_password_post_key,PWD];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    
    [request setURL:[NSURL URLWithString:register_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //passing device token as a http header request
    NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
    [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
    
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

- (void) registerDeviceWithDelegate:(id <DeviceRegisterDelegate>) del {
    
    //1- set the delegate
    self.deviceDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    //4- detect device data
    //temp string for simulator
    NSString * machineNameWithVersion = [@"iPhone1,1" lowercaseString];
    
    //NSString * machineNameWithVersion = [[[GenericMethods machineName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];

    NSString * str1 = [machineNameWithVersion stringByReplacingOccurrencesOfString:@"iphone" withString:@""];
    
    NSString * str2 = [str1 stringByReplacingOccurrencesOfString:@"ipad" withString:@""];
    NSString * version = [str2 stringByReplacingOccurrencesOfString:@"ipod" withString:@""];

    // 4-1- device generation number
    NSString * deviceVersion = [version stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    
    // 4-2- device type
    NSString * deviceType = [machineNameWithVersion stringByReplacingOccurrencesOfString:version withString:@""];
    
    // 4-3- iOS version
    NSString * osVersion = [[UIDevice currentDevice] systemVersion];
    
    //5- set the url string
    NSString * fullURLString = [NSString stringWithFormat:device_reg_url, deviceType, deviceVersion, osVersion];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        //5- send the request
        mainMngr = [[InternetManager alloc] initWithTempFileName:mainMngrTempFileName url:correctURLstring delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"خطأ غير معروق"];
        
        if (self.deviceDelegate)
            [self.deviceDelegate deviceFailRegisterWithError:error];
        
        return ;
    }
}

- (void) addCarAd:(NSUInteger ) adID toFavoritesWithDelegate:(id <FavoritesDelegate>) del {
    
    currentAdIDForFav = adID;
    
    //1- set the delegate
    self.favDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    NSString * fullURLString = add_to_fav_url;
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        NSString * post =[NSString stringWithFormat:@"%@=%@",ad_id_post_key, [NSString stringWithFormat:@"%i",adID]];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData
                                                                  length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:60];
        
        [request setURL:correctURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //4- set user credentials in HTTP header
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        //passing device token as a http header request
        NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
        [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
        
        //passing user id as a http header request
        NSString * userIDString = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the ID
            userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
        
        [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
        
        //passing password as a http header request
        NSString * passwordMD5String = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the password
            passwordMD5String = savedProfile.passwordMD5;
        
        [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
        
        
        [request setHTTPBody:postData];
        
        
        favoriteAddMngr = [[InternetManager alloc] initWithTempFileName:favMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.favDelegate)
            [self.favDelegate FavoriteFailAddingWithError:error forAdID:adID];
        return ;
    }
    
}

- (void) removeCarAd:(NSUInteger ) adID fromFavoritesWithDelegate:(id <FavoritesDelegate>) del {
    
    currentAdIDForFav = adID;
    
    //1- set the delegate
    self.favDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    //3- set the url string
    NSString * fullURLString = remove_from_fav_url;
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        NSString * post =[NSString stringWithFormat:@"%@=%@",ad_id_post_key, [NSString stringWithFormat:@"%i",adID]];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:60];
        
        [request setURL:correctURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //4- set user credentials in HTTP header
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        //passing device token as a http header request
        NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
        [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
        
        //passing user id as a http header request
        NSString * userIDString = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the ID
            userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
        
        [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
        
        //passing password as a http header request
        NSString * passwordMD5String = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the password
            passwordMD5String = savedProfile.passwordMD5;
        
        [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
        
        //5- send the request
        [request setHTTPBody:postData];
        
        
        favoriteRemoveMngr = [[InternetManager alloc] initWithTempFileName:favMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.favDelegate)
            [self.favDelegate FavoriteFailRemovingWithError:error forAdID:adID];
        return ;
    }
    
}

- (void) removeAd:(NSUInteger ) adID fromAdsWithDelegate:(id <FavoritesDelegate>) del {
    
    currentAdIDForFav = adID;
    
    //1- set the delegate
    self.favDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    //3- set the url string
    NSString * fullURLString = remove_from_ad_url;
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        NSString * post =[NSString stringWithFormat:@"%@=%@",ad_id_post_key, [NSString stringWithFormat:@"%i",adID]];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:60];
        
        [request setURL:correctURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //4- set user credentials in HTTP header
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        //passing device token as a http header request
        NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
        [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
        
        //passing user id as a http header request
        NSString * userIDString = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the ID
            userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
        
        [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
        
        //passing password as a http header request
        NSString * passwordMD5String = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the password
            passwordMD5String = savedProfile.passwordMD5;
        
        [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
        
        //5- send the request
        [request setHTTPBody:postData];
        
        
        removeAdMngr = [[InternetManager alloc] initWithTempFileName:favMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.favDelegate)
            [self.favDelegate AdFailRemovingWithError:error];
        return ;
    }
    
}

- (BOOL) updateStoreStateForCurrentUser:(BOOL) storeState {
    UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
    if (savedProfile)
    {
        savedProfile.hasStores = storeState;
        [self storeUserProfile:savedProfile];
        return YES;
    }
    else
        return NO;
}

- (void) storeUserProfile:(UserProfile * ) up {
    
    NSMutableDictionary * userDict = [NSMutableDictionary new];
    
    [userDict setObject:[NSNumber numberWithUnsignedInteger:up.userID] forKey:LOGIN_USER_ID_JKEY];
    [userDict setObject:up.userName forKey:LOGIN_USER_NAME_JKEY];
    [userDict setObject:up.emailAddress forKey:LOGIN_EMAIL_ADDRESS_JKEY];
    [userDict setObject:up.passwordMD5 forKey:LOGIN_PASSWORD_JKEY];
    [userDict setObject:[NSNumber numberWithUnsignedInteger:up.defaultCityID] forKey:LOGIN_DEFAULT_CITY_ID_JKEY];
    [userDict setObject:[NSNumber numberWithBool:up.isVerified] forKey:LOGIN_IS_VERIFIED_JKEY];
    [userDict setObject:[NSNumber numberWithBool:up.isActive] forKey:LOGIN_IS_ACTIVE_JKEY];
    [userDict setObject:[NSNumber numberWithBool:up.hasStores] forKey:LOGIN_HAS_STORES_JKEY];
    
    [[ProfileManager loginKeyChainItemSharedInstance] setObject:userDict.description forKey:(__bridge id)(kSecAttrAccount)];
}

- (UserProfile *) getSavedUserProfile {
    
    NSString * str = [[ProfileManager loginKeyChainItemSharedInstance] objectForKey:(__bridge id)(kSecAttrAccount)];
    
    if ([str isEqualToString:@""])
         return nil;
    
    NSDictionary * userDict = [str propertyList];
    
    if (!userDict)
        return nil;
    
    UserProfile * result= [[UserProfile alloc] init] ;
    
    result.userID = ((NSNumber *)[userDict objectForKey:LOGIN_USER_ID_JKEY]).integerValue;
    result.userName = [userDict objectForKey:LOGIN_USER_NAME_JKEY];
    result.emailAddress = [userDict objectForKey:LOGIN_EMAIL_ADDRESS_JKEY];
    result.passwordMD5 = [userDict objectForKey:LOGIN_PASSWORD_JKEY];
    result.defaultCityID = ((NSNumber *)[userDict objectForKey:LOGIN_DEFAULT_CITY_ID_JKEY]).integerValue;
    result.isVerified = ((NSNumber *)[userDict objectForKey:LOGIN_IS_VERIFIED_JKEY]).boolValue;
    result.isActive = ((NSNumber *)[userDict objectForKey:LOGIN_IS_ACTIVE_JKEY]).boolValue;
    result.hasStores = ((NSNumber *)[userDict objectForKey:LOGIN_HAS_STORES_JKEY]).boolValue;
    
    return result;
}

- (NSString *) getSavedDeviceToken {
    
    NSString * str = [[ProfileManager loginKeyChainItemSharedInstance] objectForKey:(__bridge id)(kSecValueData)];
    if ([str isEqualToString:@""])
        return @"";
    
    NSDictionary * dataDict = [str propertyList];
    
    if (!dataDict)
        return @"";
    
    return [dataDict objectForKey:DREG_TOKEN];
}


- (void) updateUserWithDelegate:(id <ProfileUpdateDelegate> )del userName:(NSString *)Name andPassword:(NSString*)pwd{
   
    //1- set the delegate
    self.updateDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    NSString * fullURLString = update_user_url;
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
        //[NSString s]
        NSString * post =[NSString  stringWithFormat:@"%@=%@&%@=%@",update_user_post_key, Name,login_password_post_key,pwd];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding  allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData
                                                                  length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:60];
        
        [request setURL:correctURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //4- set user credentials in HTTP header
        UserProfile * savedProfile = [[SharedUser sharedInstance] getUserProfileData];
        
        //passing device token as a http header request
        NSString * deviceTokenString = [[ProfileManager sharedInstance] getSavedDeviceToken];
        [request addValue:deviceTokenString forHTTPHeaderField:DEVICE_TOKEN_HTTP_HEADER_KEY];
        
        //passing user id as a http header request
        NSString * userIDString = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the ID
            userIDString = [NSString stringWithFormat:@"%i", savedProfile.userID];
        
        [request addValue:userIDString forHTTPHeaderField:USER_ID_HTTP_HEADER_KEY];
        
        //passing password as a http header request
        NSString * passwordMD5String = @"";
        if (savedProfile) //if user is logged and not a visitor --> set the password
            passwordMD5String = savedProfile.passwordMD5;
        
        [request addValue:passwordMD5String forHTTPHeaderField:PASSWORD_HTTP_HEADER_KEY];
        
        
        [request setHTTPBody:postData];
        
        
        updateMngr = [[InternetManager alloc] initWithTempFileName:updateMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.updateDelegate)
            [self.updateDelegate userFailUpdateWithError:error];
        return ;
    }

}


#pragma mark - NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    if (dataSoFar == nil) {
        dataSoFar = [[NSMutableData alloc] initWithData:data];
    }
    else {
        [dataSoFar appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // Prepare the data object for the next request
    dataSoFar = nil;
    
    if (self.delegate){
        if ([twitterChecked isEqualToString:@"twitter"])
            [self.delegate userFailLoginWithTwitterError:error];
        else if ([twitterChecked isEqualToString:@"facebook"])
            [self.delegate userFailLoginWithFacebookError:error];
        else
            [self.delegate userFailLoginWithError:error];
    }
    else if (self.updateDelegate) {
        [self.updateDelegate userFailUpdateWithError:error];
    }
    else if (self.RegisterDelegate) {
        [self.RegisterDelegate userFailRegisterWithError:error];
    }
    else if (self.RegisterDelegate) {
        [self.RegisterDelegate userFailRegisterWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //handle the response of login that is received totally here
    if (dataSoFar)
    {
        NSString * responseStr = [[NSString alloc] initWithData:dataSoFar encoding:NSUTF8StringEncoding];
        NSLog(@"data is : %@",responseStr);
        NSString * nullReplacedInStr = [responseStr stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
        
        NSData * dataWithNullReplaced = [nullReplacedInStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray * dataArray = [[JSONParser sharedInstance] parseJSONData:dataWithNullReplaced];
        
        BOOL logged = [self parseAndAuthorize:dataArray];
        
        if (logged)
        {
            UserProfile * userData = [self getUserData:dataArray];
            if (userData)
            {
                if (self.delegate)
                {
                    if (userData.isActive && userData.isVerified)
                        if ([twitterChecked isEqualToString:@"twitter"])
                            [delegate userDidLoginWithTwitterData:userData];
                        else if ([twitterChecked isEqualToString:@"facebook"])
                            [delegate userDidLoginWithFacebookData:userData];
                        else
                            [delegate userDidLoginWithData:userData];
                    
                        else
                        {
                            CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                            [error setDescMessage:@"تعذر تسجيل الدخول"];
                            if ([twitterChecked isEqualToString:@"twitter"])
                                [self.delegate userFailLoginWithTwitterError:error];
                            else if ([twitterChecked isEqualToString:@"facebook"])
                                [self.delegate userFailLoginWithFacebookError:error];
                            else
                                [self.delegate userFailLoginWithError:error];
                        }
                }
                else if (self.updateDelegate) {
                    if (userData.isActive && userData.isVerified)
                        [updateDelegate userUpdateWithData:userData];
                }
                else if (self.RegisterDelegate) {
                    if (userData.isActive && userData.isVerified)
                        [self.RegisterDelegate userDidRegisterWithData:userData];
                }else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:@"تعذر تسجيل الدخول"];
                    
                    [self.RegisterDelegate userFailRegisterWithError:error];
                }
            }
            else    //data is nil for some reason
            {
                if (self.delegate)
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:@"خطأ في تحميل االبيانات"];
                    if ([twitterChecked isEqualToString:@"twitter"])
                        [self.delegate userFailLoginWithTwitterError:error];
                    else if ([twitterChecked isEqualToString:@"facebook"])
                        [self.delegate userFailLoginWithFacebookError:error];
                    else
                        [self.delegate userFailLoginWithError:error];
                }
                else if (self.updateDelegate)
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:@"خطأ في تحميل االبيانات"];
                    
                    [self.updateDelegate userFailUpdateWithError:error];
                }
            }
        }
        
        
        else
        {
            NSString * statusMessage = [self getStatusMessage:dataArray];
            if (self.delegate)
            {
                CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                [error setDescMessage:statusMessage];
                if ([twitterChecked isEqualToString:@"twitter"])
                    [self.delegate userFailLoginWithTwitterError:error];
                else if ([twitterChecked isEqualToString:@"facebook"])
                    [self.delegate userFailLoginWithFacebookError:error];
                else
                    [self.delegate userFailLoginWithError:error];
            }
            if (self.updateDelegate)
            {
                CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                [error setDescMessage:statusMessage];
                
                [self.updateDelegate userFailUpdateWithError:error];
            }
            if (self.RegisterDelegate)
            {
                CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                [error setDescMessage:statusMessage];
                
                [self.RegisterDelegate userFailRegisterWithError:error];
            }
        }
    }
    
    // Prepare the data object for the next request
    dataSoFar = nil;
}

- (BOOL) parseAndAuthorize: (NSArray *) responseDataArray {
    
    if ((responseDataArray) && (responseDataArray.count > 0))
    {
        NSDictionary * totalDict = [responseDataArray objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        if (statusCode != 200)
            return NO;
        else
            return YES;
    }
    return NO;
    
}

- (UserProfile *) getUserData: (NSArray *) responseDataArray {
    
    if ((responseDataArray) && (responseDataArray.count > 0))
    {
        NSDictionary * totalDict = [responseDataArray objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        if (statusCode == 200)
        {
            NSDictionary * dataDict = [totalDict objectForKey:LOGIN_DATA_JKEY];
            if (dataDict)
            {
                UserProfile * p = [[UserProfile alloc]
                                   initWithUserIDString:[dataDict objectForKey:LOGIN_USER_ID_JKEY]
                                    userName:[dataDict objectForKey:LOGIN_USER_NAME_JKEY]
                                    emailAddress:[dataDict objectForKey:LOGIN_EMAIL_ADDRESS_JKEY]
                                    passwordMD5:[dataDict objectForKey:LOGIN_PASSWORD_JKEY]
                                    defaultCityIDString:[dataDict objectForKey:LOGIN_DEFAULT_CITY_ID_JKEY]
                                    isVerifiedString:[dataDict objectForKey:LOGIN_IS_VERIFIED_JKEY]
                                    isActiveString:[dataDict objectForKey:LOGIN_IS_ACTIVE_JKEY]
                                   hasStoresString:[dataDict objectForKey:LOGIN_HAS_STORES_JKEY]
                                   ];
                return p;
            }
        }
    }
    return nil;
    
}


- (NSString * ) getStatusMessage: (NSArray *) responseDataArray {
    if ((responseDataArray) && (responseDataArray.count > 0))
    {
        NSDictionary * totalDict = [responseDataArray objectAtIndex:0];
        
        NSString * message = [totalDict objectForKey:LOGIN_STATUS_MSG_JKEY];
        return message;

    }
    return @"";
}

- (DeviceRegistration *) parseRegistrationData:(NSArray *) data {
    
    if ((data) && (data.count > 0))
    {
        NSDictionary * totalDict = [data objectAtIndex:0];
        NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
        NSInteger statusCode = statusCodeString.integerValue;
        
        if (statusCode == 200)
        {
            NSDictionary * dataDict = [totalDict objectForKey:LOGIN_DATA_JKEY];
            if (dataDict)
            {
                DeviceRegistration * devRegObject = [[DeviceRegistration alloc]
                                   initWithDeviceIDString:[dataDict objectForKey:DREG_DEVICE_ID]
                                        type:[dataDict objectForKey:DREG_TYPE]
                                        token:[dataDict objectForKey:DREG_TOKEN]
                                        version:[dataDict objectForKey:DREG_VERSION]
                                        osVersion:[dataDict objectForKey:DREG_OS_VERSION]
                                        ipAddress:[dataDict objectForKey:DREG_IP_ADDRESS]
                                        registeredOnString:[dataDict objectForKey:DREG_REGISTERED_ON]
                                   ];
                return devRegObject;
            }
        }
    }
    return nil;
}

//store device data and token in keychain
- (void) storeDeviceRegistrationData:(DeviceRegistration *) devRegObject {
    
    NSMutableDictionary * dataDict = [NSMutableDictionary new];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    
    NSString * dateString = [formatter stringFromDate:devRegObject.registeredOn];

    [dataDict setObject:[NSString stringWithFormat:@"%i", devRegObject.deviceID] forKey:DREG_DEVICE_ID];
    [dataDict setObject:devRegObject.type forKey:DREG_TYPE];
    [dataDict setObject:devRegObject.token forKey:DREG_TOKEN];
    [dataDict setObject:devRegObject.version forKey:DREG_VERSION];
    [dataDict setObject:devRegObject.osVersion forKey:DREG_OS_VERSION];
    [dataDict setObject:devRegObject.ipAddress forKey:DREG_IP_ADDRESS];
    [dataDict setObject:dateString forKey:DREG_REGISTERED_ON];
    
    [[ProfileManager loginKeyChainItemSharedInstance] setObject:dataDict.description forKey:(__bridge id)(kSecValueData)];
}


#pragma mark - Data delegate methods

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error {
    
    if (manager == mainMngr)
    {   //Device registeration
        if (self.deviceDelegate)
            [deviceDelegate deviceFailRegisterWithError:error];
    }
    else if (manager == favoriteAddMngr)
    {   // add to favorites
        if (self.favDelegate)
            [favDelegate FavoriteFailAddingWithError:error forAdID:currentAdIDForFav];
    }
    else if (manager == favoriteRemoveMngr)
    {   // remove from favorites
        if (self.favDelegate)
            [favDelegate FavoriteFailRemovingWithError:error forAdID:currentAdIDForFav];
    }
    else if (manager == updateMngr)
    {   // remove from favorites
        if (self.updateDelegate)
            [updateDelegate userFailUpdateWithError:error];
    }
    else if (manager == removeAdMngr)
    {   // remove from favorites
        if (self.favDelegate)
            [favDelegate AdFailRemovingWithError:error];
    }
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
    
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل العملية"];
        
        if (manager == mainMngr)
        {   //Device registeration
            if (self.deviceDelegate)
                [self.deviceDelegate deviceFailRegisterWithError:error];
        }
        else if (manager == favoriteAddMngr)
        {   // add to favorites
            if (self.favDelegate)
                [favDelegate FavoriteFailAddingWithError:error forAdID:currentAdIDForFav];
        }
        else if (manager == favoriteRemoveMngr)
        {   // add to favorites
            if (self.favDelegate)
                [favDelegate FavoriteFailRemovingWithError:error forAdID:currentAdIDForFav];
        }
        else if (manager == updateMngr)
        {   // remove from favorites
            if (self.updateDelegate)
                [updateDelegate userFailUpdateWithError:error];
        }
        else if (manager == removeAdMngr)
        {   // remove from favorites
            if (self.favDelegate)
                [favDelegate AdFailRemovingWithError:error];
        }
        
    }
    else
    {
        if (manager == mainMngr)
        {   //Device registeration
            DeviceRegistration * deviceRegObject = [self parseRegistrationData:(NSArray *)result];
            if (deviceRegObject)
                [self storeDeviceRegistrationData:deviceRegObject];
        }
        else if (manager == favoriteAddMngr)
        {   // add to favorites
            NSArray * data = (NSArray *) result;
            if ((data) && (data.count > 0))
            {
                NSDictionary * totalDict = [data objectAtIndex:0];
                NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
                NSInteger statusCode = statusCodeString.integerValue;
                
                NSString * statusMessageProcessed = [[[totalDict objectForKey:LOGIN_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                
                if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                {
                    if (self.favDelegate)
                        [favDelegate FavoriteDidAddWithStatus:YES forAdID:currentAdIDForFav];
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    if (self.favDelegate)
                        [favDelegate FavoriteFailAddingWithError:error forAdID:currentAdIDForFav];
                }
            }
        }
        else if (manager == favoriteRemoveMngr)
        {   // add to favorites
            NSArray * data = (NSArray *) result;
            if ((data) && (data.count > 0))
            {
                NSDictionary * totalDict = [data objectAtIndex:0];
                NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
                NSInteger statusCode = statusCodeString.integerValue;
                
                NSString * statusMessageProcessed = [[[totalDict objectForKey:LOGIN_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                
                if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                {
                    if (self.favDelegate)
                        [favDelegate FavoriteDidRemoveWithStatus:YES forAdID:currentAdIDForFav];
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    if (self.favDelegate)
                        [favDelegate FavoriteFailRemovingWithError:error forAdID:currentAdIDForFav];
                }
            }
        }
        else if (manager == removeAdMngr)
        {   // add to favorites
            NSArray * data = (NSArray *) result;
            if ((data) && (data.count > 0))
            {
                NSDictionary * totalDict = [data objectAtIndex:0];
                NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
                NSInteger statusCode = statusCodeString.integerValue;
                
                NSString * statusMessageProcessed = [[[totalDict objectForKey:LOGIN_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                
                if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                {
                    if (self.favDelegate)
                        [favDelegate AdDidRemoveWithStatus:statusMessageProcessed];
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    if (self.favDelegate)
                        [favDelegate AdFailRemovingWithError:error];
                }
            }
        }
        else if (manager == updateMngr)
        {
            NSArray * data = (NSArray *) result;
            if ((data) && (data.count > 0))
            {
                NSDictionary * totalDict = [data objectAtIndex:0];
                NSString * statusCodeString = [NSString stringWithFormat:@"%@", [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY]];
                NSInteger statusCode = statusCodeString.integerValue;
                
                NSString * statusMessageProcessed = [[[totalDict objectForKey:LOGIN_STATUS_MSG_JKEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
                
                if ((statusCode == 200) && ([statusMessageProcessed isEqualToString:@"ok"]))
                {
                    if (self.updateDelegate)
                        [updateDelegate userUpdateWithData:[self getUserData:data]];
                }
                else
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:statusMessageProcessed];
                    if (self.updateDelegate)
                        [updateDelegate userFailUpdateWithError:error];
                }
            }
        }
    }
}

@end
