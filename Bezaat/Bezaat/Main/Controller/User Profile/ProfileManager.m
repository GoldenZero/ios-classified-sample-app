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
    InternetManager * favoriteMngr;
    @protected
        NSMutableData * dataSoFar;
}
@end

@implementation ProfileManager
@synthesize delegate;
@synthesize deviceDelegate;

//the login url is a POST url
static NSString * login_url = @"http://gfctest.edanat.com/v1.0/json/user-login";
static NSString * device_reg_url = @"http://gfctest.edanat.com/v1.0/json/register-device?deviceTpe=%@&version=%@&osVersion=%@";
static NSString * ad_to_fav_url = @"";
static NSString * login_email_post_key = @"EmailAddress";
static NSString * login_password_post_key = @"Password";
static NSString * login_key_chain_identifier = @"BezaatLogin";

static NSString * mainMngrTempFileName = @"mngrTmp";

- (id) init {
    
    self = [super init];
    
    if (self) {
        self.delegate = nil;
        self.deviceDelegate = nil;
        self.favDelegate = nil;
        dataSoFar = nil;
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
        wrapperInstance = [[KeychainItemWrapper alloc] initWithIdentifier:login_key_chain_identifier accessGroup:nil];
    }
    
    return wrapperInstance;
}

- (void) loginWithDelegate:(id <ProfileManagerDelegate>) del email:(NSString *) emailAdress password:(NSString *) plainPassword {
    
    //1- set the delegate
    self.delegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.delegate)
            [self.delegate userFailLoginWithError:error];
        return ;
    }
    
    //3- start the request
    NSString * post =[NSString stringWithFormat:@"%@=%@&%@=%@",login_email_post_key, emailAdress, login_password_post_key, [plainPassword MD5]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:20];
    
    [request setURL:[NSURL URLWithString:login_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
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
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.deviceDelegate)
            [self.deviceDelegate deviceFailRegisterWithError:error];
        return ;
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
    //1- set the delegate
    self.favDelegate = del;
    
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل الاتصال بالإنترنت"];
        
        if (self.favDelegate)
            [self.favDelegate FavoriteFailAddingWithError:error];
        return ;
    }
    //3- set the url string
    NSString * fullURLString = [NSString stringWithFormat:details_url, adID];
    
    NSString * correctURLstring = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", correctURLstring);
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    NSURL * correctURL = [NSURL URLWithString:correctURLstring];
    
    if (correctURL)
    {
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
        [request setURL:correctURL];
        internetMngr = [[InternetManager alloc] initWithTempFileName:internetMngrTempFileName urlRequest:request delegate:self startImmediately:YES responseType:@"JSON"];
    }
    else
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.delegate)
            [self.delegate detailsDidFailLoadingWithError:error];
        return ;
    }
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
    
    if (self.delegate)
        [self.delegate userFailLoginWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //handle the response of login that is received totally here
    if (dataSoFar)
    {
        NSString * responseStr = [[NSString alloc] initWithData:dataSoFar encoding:NSUTF8StringEncoding];
        
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
                        [delegate userDidLoginWithData:userData];
                    else
                    {
                        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                        [error setDescMessage:@"تعذر تسجيل الدخول"];
                        
                        [self.delegate userFailLoginWithError:error];
                    }
                }
            }
            else    //data is nil for some reason
            {
                if (self.delegate)
                {
                    CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
                    [error setDescMessage:@"خطأ في تحميل االبيانات"];
                    
                    [self.delegate userFailLoginWithError:error];
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
                
                [self.delegate userFailLoginWithError:error];
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
        NSString * statusCodeString = [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY];
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
        NSString * statusCodeString = [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY];
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
        NSString * statusCodeString = [totalDict objectForKey:LOGIN_STATUS_CODE_JKEY];
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
    [formatter setDateFormat:@"yyyy-mm-dd 'at' HH:mm:ss"];
    
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
    
    if (self.deviceDelegate)
        [deviceDelegate deviceFailRegisterWithError:error];
}

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*) result {
    
    if (!result)
    {
        CustomError * error = [CustomError errorWithDomain:@"" code:-1 userInfo:nil];
        [error setDescMessage:@"فشل تحميل البيانات"];
        
        if (self.deviceDelegate)
            [self.deviceDelegate deviceFailRegisterWithError:error];
    }
    else
    {
        DeviceRegistration * deviceRegObject = [self parseRegistrationData:(NSArray *)result];
        if (deviceRegObject)
            [self storeDeviceRegistrationData:deviceRegObject];
    }
}
@end
