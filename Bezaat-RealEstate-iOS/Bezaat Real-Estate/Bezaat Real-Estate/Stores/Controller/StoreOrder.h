//
//  StoreOrder.h
//  Bezaat
//
//  Created by GALMarei on 7/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreOrder : NSObject
#pragma mark - properties

@property (nonatomic) NSInteger StoreID;
@property (nonatomic, strong) NSString *StoreName;
@property (nonatomic, strong) NSString *StoreImageURL;
@property (nonatomic) NSInteger OrderID;
@property (nonatomic) NSInteger CountryID;
@property (nonatomic) NSInteger SchemeFee;
@property (nonatomic) NSInteger PaymentMethod;
@property (nonatomic) NSInteger OrderStatus;
@property (nonatomic) NSInteger StorePaymentSchemeID;
@property (nonatomic, strong) NSString *StorePaymentSchemeName;
@property (nonatomic) BOOL IsApproved;
@property (nonatomic) BOOL IsRejected;
@property (nonatomic, strong) NSDate *LastModifiedOn;



#pragma mark - actions

@end
