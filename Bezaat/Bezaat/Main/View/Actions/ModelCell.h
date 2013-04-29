//
//  ModelCell.h
//  Bezaat
//
//  Created by Aubada Taljo on 3/25/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface ModelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SSLabel *lblModel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

- (void) reloadInformation:(Model*)model;

@end
