//
//  Store.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

#pragma mark - properties

@property (nonatomic) NSInteger identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *ownerEmail;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic) NSInteger countryID;
@property (nonatomic, readonly) NSString *countryName;
@property (nonatomic) NSInteger activeAdsCount;
@property (nonatomic) NSInteger status;
@property (nonatomic, strong) NSString *contactNo;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic) NSInteger remainingDays;
@property (nonatomic) NSInteger remainingFreeFeatureAds;


#pragma mark - actions

@end
