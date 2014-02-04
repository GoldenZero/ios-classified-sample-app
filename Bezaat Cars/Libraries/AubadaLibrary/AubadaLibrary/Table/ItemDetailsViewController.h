//
//  ItemDetailsViewController.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/27/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "ObjectParserProtocol.h"

@interface ItemDetailsViewController : BaseViewController

@property (strong, nonatomic) NSObject<ObjectParserProtocol>* item;

@end
