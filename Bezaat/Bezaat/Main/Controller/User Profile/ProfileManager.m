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
    @protected
        NSMutableData * dataSoFar;
}
@end

@implementation ProfileManager
@synthesize delegate;

//the login url is a POST url
static NSString * login_url = @"http://gfctest.edanat.com/v1.0/json/user-login";
static NSString * login_email_post_key = @"EmailAddress";
static NSString * login_password_post_key = @"Password";
static NSString * login_key_chain_identifier = @"BezaatLogin";

- (id) init {
    
    self = [super init];
    
    if (self) {
        self.delegate = nil;
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
@end
