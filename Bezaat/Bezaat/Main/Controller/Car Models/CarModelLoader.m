//
//  CarModelLoader.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/6/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CarModelLoader.h"

@implementation CarModelLoader

- (NSArray *) loadCarModelsFromPlistFileWithName:(NSString *)plistFileName {

    //The array that will contain all CarModel objects loaded from plist file
    NSMutableArray * resultArray = [NSMutableArray new];
    
    //Plist file path
    NSString * plistFilePath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];
    
    //The dictionary holding all plist file
    NSDictionary * allModelsDic = [[NSDictionary alloc] initWithContentsOfFile:plistFilePath];
    
    //loop
    for (int index = 0; index < allModelsDic.count ; index ++)
    {
        //keys array
        NSArray * modelNamesArray = [allModelsDic allKeys];
        
        //1- model name from keys array
        NSString * currentModelName = [modelNamesArray objectAtIndex:index];
        
        //the distionary of current model
        NSDictionary * carModelDic = [allModelsDic objectForKey:currentModelName];
        
        //get image file name
        NSString * currentImageFileName = [carModelDic objectForKey:IMAGE_FILE_NAME_PLIST_KEY];
        
        //create array of ModelBrand objects
        NSMutableArray * currentBrands = [NSMutableArray new];
        for (NSString * aModelBrandName in [carModelDic objectForKey:BRANDS_PLIST_KEY])
            [currentBrands addObject:[[ModelBrand alloc] initWithName:aModelBrandName]];
        
        //create the CarModel object
        CarModel * aCarModel = [[CarModel alloc] initWithName:currentModelName imageFileName:currentImageFileName brandsArray:currentBrands];
        
        //add CarModel object to result array
        [resultArray addObject:aCarModel];
    }
    
    return resultArray;
}

@end
