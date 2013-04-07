//
//  main.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "CarAdsManager.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        [[CarAdsManager sharedInstance] loadCarAdsOfPage:1 forBrand:363 Model:208 InCity:13 WithDelegate:nil];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
