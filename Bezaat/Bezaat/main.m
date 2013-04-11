//
//  main.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "CarDetalisManager.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [[CarDetalisManager sharedInstance] loadCarDetailsOfAdID:4373270 WithDelegate:nil];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
