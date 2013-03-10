//
//  TableItemsViewController.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 10/27/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "DataDelegate.h"

@interface TableItemsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, DataDelegate> {
@protected
    // List of items to be viewed
    NSMutableArray* _items;
    
    // This is the class of the next view controller that should be created
    // It must be a subclass of ItemDetailsViewController
    Class _nextControllerClass;
    
    // This is the class of the item to be passed to the next controller
    // It must implement ObjectParserProtocol
    Class _nextControllerItemClass;
    
    // This is the name of the NIB to load for the cell
    NSString* _cellNibName;
    
    // These are the message and sub-message that will be shown on the loading indicator
    NSString* _message;
    NSString* _subMessage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblItems;

@end
