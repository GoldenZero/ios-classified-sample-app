//
//  AdWithImageCell.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "PlainAdCell.h"

#define AD_WITH_IMAGE_CELL_HEIGHT     286

@interface AdWithImageCell : PlainAdCell

@property (strong, nonatomic) IBOutlet UIImageView * adImage;

@end
