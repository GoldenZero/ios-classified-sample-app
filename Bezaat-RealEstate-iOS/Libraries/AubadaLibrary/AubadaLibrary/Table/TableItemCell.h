//
//  TableItemCell.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/27/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ObjectParserProtocol.h"

@interface TableItemCell : UITableViewCell

- (void) reloadViewWithData:(NSObject<ObjectParserProtocol>*)item;

@end
