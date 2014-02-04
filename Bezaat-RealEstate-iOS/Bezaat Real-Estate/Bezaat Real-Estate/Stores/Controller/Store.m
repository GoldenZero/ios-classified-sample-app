//
//  Store.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "Store.h"

@implementation Store

@synthesize  identifier;
@synthesize  name;
@synthesize  ownerEmail;
@synthesize  imageURL;
@synthesize  countryID;
@synthesize  activeAdsCount;
@synthesize  status;
@synthesize  contactNo;

@synthesize desc;
@synthesize storePassword;
@synthesize remainingDays;
@synthesize remainingFreeFeatureAds;

- (NSString *)countryName {
    Country * ctr = [[LocationManager sharedInstance] getCountryByID:self.countryID];
    return ctr.countryName;
}

@end
