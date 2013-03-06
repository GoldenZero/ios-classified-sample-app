//
//  CarModelLoader.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//
// This class is supposed to load models and brands from a local plist file

#import <Foundation/Foundation.h>
#import "CarModel.h"

#define IMAGE_FILE_NAME_PLIST_KEY @"imageFileName"
#define BRANDS_PLIST_KEY          @"brands"

@interface CarModelLoader : NSObject

//The plistFileName should relate to a file added to application resources
- (NSDictionary *) loadCarModelsFromPlistFileWithName:(NSString *)plistFileName;

@end
