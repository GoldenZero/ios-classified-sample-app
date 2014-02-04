//
//  ObjectParserProtocol.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/27/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjectParserProtocol <NSObject>

@required

- (id) initWithDictionary:(NSDictionary*)dataDictionary;

- (void) parse:(NSDictionary*)dataDictionary;

@end
