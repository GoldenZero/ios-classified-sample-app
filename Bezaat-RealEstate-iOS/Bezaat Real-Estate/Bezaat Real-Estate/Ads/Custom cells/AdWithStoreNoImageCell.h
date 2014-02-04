//
//  AdWithStoreNoImageCell.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/5/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "PlainAdCell.h"

#define AD_WITH_STORE_NO_IMAGE_CELL_HEIGHT     195

@interface AdWithStoreNoImageCell : PlainAdCell

@property (strong, nonatomic) IBOutlet UIImageView * storeImage;
@property (strong, nonatomic) IBOutlet SSLabel * storeNameLabel;

@end
