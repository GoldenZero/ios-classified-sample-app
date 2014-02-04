//
//  ManagerDelegate.h
//  Akary
//
//  Created by Alaa Al-Zaibak on ٢٨‏/٤‏/٢٠١١.
//  Copyright ٢٠١١ __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseDataManager;

@protocol DataDelegate <NSObject>

@required

- (void) manager:(BaseDataManager*)manager connectionDidFailWithError:(NSError*) error;

- (void) manager:(BaseDataManager*)manager connectionDidSucceedWithObjects:(NSData*)result;

@end
