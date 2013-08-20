//
//  ChooseModelView_iPad.m
//  Bezaat
//
//  Created by Roula Misrabi on 8/18/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseModelView_iPad.h"
#import "ModelCell.h"

@interface ChooseModelView_iPad () {
    NSMutableArray * modelsArray;
}
@end

@implementation ChooseModelView_iPad

- (id) init {
    self = [super init];
    if (self) {
        modelsArray = [NSMutableArray new];
        self.modelCellsArray = [NSMutableArray new];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    modelsArray = [NSMutableArray new];
    self.modelCellsArray = [NSMutableArray new];
    
}

- (void) drawModels:(NSArray *) models {
    [modelsArray removeAllObjects];
    [modelsArray addObjectsFromArray:models];
    
    [self.modelCellsArray removeAllObjects];
    
    float currentX = 0;
    float currentY = 0;
    float totalHeight = 0;
    
    int rowCounter = 0;
    int colCounter = 0;
    
    CGRect modelFrame = CGRectMake(-1, -1, 135, 41);//these are the dimensions of the model cell
    
    for (int i = 0; i < models.count; i++) {
        Model * currentItem = models[i];
        
        // Update the cell information
        ModelCell* modelCell = (ModelCell*)[[NSBundle mainBundle] loadNibNamed:@"ModelCell_iPad" owner:self options:nil][0];;
        [modelCell reloadInformation:currentItem];
        
        if (i == 0)
            [modelCell setSelected:YES];
        
        if (i != 0) {
            if (i % 4 == 0) {
                rowCounter ++;
                colCounter = 0;
            }
            else
                colCounter ++;
        }
        else
            [modelCell setSelected:YES];
        
        currentX = (colCounter * modelFrame.size.width) + ((colCounter + 1) * 10);

        currentY = (rowCounter * modelFrame.size.height) + 5;
        
        
        modelFrame.origin.x = currentX;
        modelFrame.origin.y = currentY;
        
        modelCell.frame = modelFrame;
        
        [self.modelsScrollView addSubview:modelCell];
        [self.modelCellsArray addObject:modelCell];
        
    }
    totalHeight = 20 + modelFrame.size.height + currentY;
    [self.modelsScrollView setContentSize:CGSizeMake(self.modelsScrollView.contentSize.width, totalHeight)];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
