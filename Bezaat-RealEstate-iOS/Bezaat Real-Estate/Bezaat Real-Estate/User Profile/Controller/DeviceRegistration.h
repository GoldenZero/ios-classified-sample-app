//
//  DeviceRegistration.h
//  Bezaat
//
//  Created by Roula Misrabi on 4/10/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceRegistration : NSObject

@property (nonatomic) NSUInteger deviceID;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * token;
@property (strong, nonatomic) NSString * version;
@property (strong, nonatomic) NSString * osVersion;
@property (strong, nonatomic) NSString * ipAddress;
@property (strong, nonatomic) NSDate * registeredOn;

- (id) initWithDeviceIDString:(NSString *) aDeviceIDString
                         type:(NSString *) aType
                        token:(NSString *) aToken
                      version:(NSString *) aVersion
                    osVersion:(NSString *) aOsVersion
                    ipAddress:(NSString *) aIpAddress
           registeredOnString:(NSString *) aRegisteredOnString;


@end
