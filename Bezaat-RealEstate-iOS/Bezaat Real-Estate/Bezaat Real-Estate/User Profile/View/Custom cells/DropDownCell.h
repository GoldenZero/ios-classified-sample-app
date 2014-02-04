//
//  DropDownCell.h
//  Bezaat
//
//  Created by GALMarei on 4/21/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownCell : UITableViewCell{
    
    IBOutlet UILabel *textLabel;
    IBOutlet UIImageView *arrow_up;
    IBOutlet UIImageView *arrow_down;
    IBOutlet UIImageView *flagImg;
    
    BOOL isOpen;
    
}

- (void) setOpen;
- (void) setClosed;

@property (nonatomic) BOOL isOpen;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UIImageView *arrow_up;
@property (nonatomic, retain) IBOutlet UIImageView *arrow_down;
@property (retain, nonatomic) IBOutlet UIImageView *flagImg;


@end
