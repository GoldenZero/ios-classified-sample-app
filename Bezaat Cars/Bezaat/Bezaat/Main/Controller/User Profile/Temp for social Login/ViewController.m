//
//  ViewController.m
//  TrySignInWithFBTW
//
//  Created by Roula Misrabi on 3/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountCredential.h>


@interface ViewController ()
{
     NSDictionary *fbDataList;
    NSArray *twAccounts;
}
@end

@implementation ViewController
@synthesize accountStore, facebookAccount, twitterAccount;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanged:) name:ACAccountStoreDidChangeNotification object:nil];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:ACAccountStoreDidChangeNotification];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signInFBPressed:(id)sender {
    
    self.accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"000000000000000";
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"email"],ACFacebookPermissionsKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
             //it will always be the last object with single sign on
             self.facebookAccount = [accounts lastObject];
             NSLog(@"facebook account =%@",self.facebookAccount);
             [self get];
         } else {
             //Fail gracefully...
             
             if(e.code == 6)
                 [self throwAlertWithTitle:@"Error" message:@"Account not found. Please setup your account in settings app."];
             else
                 [self throwAlertWithTitle:@"Error" message:@"Account access denied."];

            
            /*
             if (e.code == 6)
                 NSLog(@"You're not signed in settings app.");
             NSLog(@"error getting permission %@",e);
             */
             
         }
     }];
}

- (void) get {
    
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:nil];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error) {
        
        if(!error)
        {
            fbDataList =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            NSLog(@"Dictionary contains: %@", fbDataList );
            if([fbDataList objectForKey:@"error"]!=nil)
            {
                [self attemptRenewCredentials];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                //nameLabel.text = [fbDataList objectForKey:@"username"];
                [self throwAlertWithTitle:@"sign in successful" message:[NSString stringWithFormat:@"username: %@", [fbDataList objectForKey:@"username"]]];
            });
        }
        else{
            //handle error gracefully
            NSLog(@"error from get%@",error);
            //attempt to revalidate credentials
        }
        
    }];
    
    self.accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"270430619733847";
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"friends_videos"],ACFacebookPermissionsKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {}];
    
}

-(void)accountChanged:(NSNotification *)notif {//no user info associated with this notif 
    [self attemptRenewCredentials];
}

-(void)attemptRenewCredentials{
    //renew facebook if not null
    if (self.accountStore)
    {
        if (self.facebookAccount)
        {
            [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
                if(!error)
                {
                    switch (renewResult) {
                        case ACAccountCredentialRenewResultRenewed:
                            NSLog(@"Good to go");
                            [self get];
                            break;
                        case ACAccountCredentialRenewResultRejected:
                            NSLog(@"User declined permission");
                            break;
                        case ACAccountCredentialRenewResultFailed:
                            NSLog(@"non-user-initiated cancel, you may attempt to retry");
                            break;
                        default:
                            break;
                    }
                    
                }
                else{
                    //handle error gracefully
                    NSLog(@"error from renew credentials%@",error);
                }
            }];
        }
        
        //renew twitter if not null
        if (self.twitterAccount)
        {
            [self.accountStore renewCredentialsForAccount:(ACAccount *)self.twitterAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
                if(!error)
                {
                    switch (renewResult) {
                        case ACAccountCredentialRenewResultRenewed:
                            NSLog(@"Good to go");
                            [self getForTwitter];
                            break;
                        case ACAccountCredentialRenewResultRejected:
                            NSLog(@"User declined permission");
                            break;
                        case ACAccountCredentialRenewResultFailed:
                            NSLog(@"non-user-initiated cancel, you may attempt to retry");
                            break;
                        default:
                            break;
                    }
                    
                }
                else{
                    //handle error gracefully
                    NSLog(@"error from renew credentials%@",error);
                }
            }];
        }
    }
    
}

- (IBAction)signInTWPressed:(id)sender {
    
    if (!self.accountStore)
        self.accountStore = [[ACAccountStore alloc]init];
    
    ACAccountType *TWaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    [self.accountStore requestAccessToAccountsWithType:TWaccountType options:nil completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             twAccounts = [self.accountStore accountsWithAccountType:TWaccountType];
             if ((twAccounts) && (twAccounts.count == 1))
             {
                 self.twitterAccount = [twAccounts lastObject];
                 NSLog(@"twitter account =%@",self.twitterAccount);
                 [self getForTwitter];
             }
             else
             {
                 TWAccountsViewController * TWAccountsVC = [[TWAccountsViewController alloc] initWithNibName:@"TWAccountsViewController" bundle:nil];
                 
                 TWAccountsVC.accountsArray = twAccounts;
                 TWAccountsVC.delegate = self;
                 
                 UINavigationController * container = [[UINavigationController alloc] initWithRootViewController:TWAccountsVC];
                 [self presentViewController:container animated:YES completion:nil];
             }
             
         } else {
             //Fail gracefully...
             
              if(e.code == 6)
              [self throwAlertWithTitle:@"Error" message:@"Account not found. Please setup your account in settings app."];
              else
              [self throwAlertWithTitle:@"Error" message:@"Account access denied."];
              
              
             /*
             if (e.code == 6)
                 NSLog(@"You're not signed in settings app.");
             NSLog(@"error getting permission %@",e);
              */
             
             
         }
     }];
    
}


- (void) getForTwitter {

    // Creating a request to get the info about a user on Twitter
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    
    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:requestURL
                                                          parameters:[NSDictionary dictionaryWithObject:self.twitterAccount.username forKey:@"screen_name"]];
    twitterInfoRequest.account = self.twitterAccount;
    
    // Making the request
    
    [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Check if we reached the reate limit
            if ([urlResponse statusCode] == 429) {
                NSLog(@"Rate limit reached");
                return;
            }
            
            // Check if there was an error
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            
            // Check if there is some response data
            if (responseData) {
                
                NSError *error = nil;
                NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                
                
                // Filter the preferred data
                
                NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                
                
                NSLog(@"screen name = %@", screen_name);
                NSLog(@"name = %@", name);
                /*
                 int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                 int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                 int tweets = [[(NSDictionary *)TWData objectForKey:@"statuses_count"] integerValue];
                 
                 NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                 NSString *bannerImageStringURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                 
                 
                 */
            }
        });
    }];
    
}

// This method shows a simple alert view with ok button as a cancel button
- (void) throwAlertWithTitle:(NSString *) aTitle message:(NSString *) aMessage {

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:aTitle
                                                    message:aMessage
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil ];
    //[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

#pragma mark - ChooseTWAccount Delegate
- (void) didChooseAccountWithIndex:(NSUInteger)accountIndex {
    
    self.twitterAccount = [twAccounts objectAtIndex:accountIndex];
    NSLog(@"twitter account =%@",self.twitterAccount);
    [self getForTwitter];
    
}
@end
