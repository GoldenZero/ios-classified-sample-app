//
//  CountryLoader.h
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"

#define CITY_NAME_PLIST_KEY         @"name"
#define IMAGE_FILE_NAME_PLIST_KEY   @"imageFileName"
#define CITIES_PLIST_KEY            @"cities"

@interface CountryLoader : NSObject

//The plistFileName should relate to a file added to application resources
- (NSArray *) loadCountriesFromPlistFileWithName:(NSString *)plistFileName;

@end
