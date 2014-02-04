//
//  StoreOrderCell.h
//  Bezaat
//
//  Created by GALMarei on 7/17/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *storeImage;
@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *paymentMethod;

@property (strong, nonatomic) IBOutlet UILabel *orderStatus;
@property (strong, nonatomic) IBOutlet UILabel *orderDate;
@property (strong, nonatomic) IBOutlet UILabel *orderBundle;
@property (strong, nonatomic) IBOutlet UIButton *proceedBtn;
@property (strong, nonatomic) IBOutlet UIButton *bankTransferBtn;
@property (strong, nonatomic) IBOutlet UILabel *orderId;
@end
