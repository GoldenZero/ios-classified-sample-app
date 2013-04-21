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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic) NSInteger countryID;

#pragma mark - actions

@end
