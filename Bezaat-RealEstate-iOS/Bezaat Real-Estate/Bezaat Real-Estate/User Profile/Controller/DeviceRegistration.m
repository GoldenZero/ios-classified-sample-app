//
//  DeviceRegistration.m
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "DeviceRegistration.h"

@implementation DeviceRegistration

@synthesize deviceID;
@synthesize type;
@synthesize token;
@synthesize version;
@synthesize osVersion;
@synthesize ipAddress;
@synthesize registeredOn;

- (id) initWithDeviceIDString:(NSString *) aDeviceIDString
                         type:(NSString *) aType
                        token:(NSString *) aToken
                      version:(NSString *) aVersion
                    osVersion:(NSString *) aOsVersion
                    ipAddress:(NSString *) aIpAddress
           registeredOnString:(NSString *) aRegisteredOnString {
    
    self = [super init];
    
    if (self) {
        // deviceID
        self.deviceID = aDeviceIDString.integerValue;
        
        // type
        self.type = aType;
        
        // token
        self.token = aToken;
        
        // version
        self.version = aVersion;
        
        // osVersion
        self.osVersion = aOsVersion;
        
        // ipAddress
        self.ipAddress = aIpAddress;
        
        // registeredOn
        self.registeredOn = [GenericMethods NSDateFromDotNetJSONString:aRegisteredOnString];
    }
    return self;
}
@end
