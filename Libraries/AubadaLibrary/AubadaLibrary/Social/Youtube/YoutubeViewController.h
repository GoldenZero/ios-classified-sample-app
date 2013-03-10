//
//  YoutubeViewController.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/29/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ItemDetailsViewController.h"

@interface YoutubeViewController : ItemDetailsViewController

@property (strong, nonatomic) IBOutlet UIButton* btnClose;
@property (strong, nonatomic) IBOutlet UIWebView* youtubeContainer;

@property (strong, nonatomic) NSString* youtubeLink;
@property (nonatomic) BOOL showCloseButton;

@end
