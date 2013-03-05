//
//  MJSecondDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJSecondDetailViewController.h"
#define BLOCK_PIXELS_WIDTH  50
#define BLOCK_PIXELS_HEIGHT  50

@interface MJSecondDetailViewController ()
{
    NSArray * brandsArray;
}
@end

@implementation MJSecondDetailViewController

@synthesize delegate, collectionView;

- (void)viewDidLoad {
 
    brandsArray = [[NSArray alloc] initWithObjects: @"كامري",
                                                    @"كروان",
                                                    @"سليسيا",
                                                    @"كوستر",
                                                    @"كورولا",
                                                    @"كريسيدا",
                                                    @"ايكو",
                                                    @"اف جيه كروزر",
                                                    @"هايس",
                                                    @"هايلوكس",
                                                    @"جراند لوكس",
                                                    @"جميع الأنواع",                   
                                                    nil];
    [self.collectionView registerClass:[SubBrandCell class] forCellWithReuseIdentifier:@"SubBrandCell"];
    
    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(BLOCK_PIXELS_WIDTH, BLOCK_PIXELS_HEIGHT);
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return brandsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SubBrandCell * subBrandCell = [cv dequeueReusableCellWithReuseIdentifier:@"SubBrandCell" forIndexPath:indexPath];
    //brand button title
    NSString * brandName = [brandsArray objectAtIndex:indexPath.row];
    [subBrandCell.brandBtn setTitle:brandName forState:UIControlStateNormal ];
    
    //brand button title font
    if ([brandName isEqualToString:@"جميع الأنواع"] )
        [subBrandCell.brandBtn.titleLabel setFont:BRAND_NAME_FONT_BOLD];
    else
        [subBrandCell.brandBtn.titleLabel setFont:BRAND_NAME_FONT];
        
    //brand button action
    [subBrandCell.brandBtn addTarget:self action:@selector(selectBrand) forControlEvents:UIControlEventTouchUpInside];

    return subBrandCell;
}

#pragma mark – RFQuiltLayoutDelegate

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //calculate the desired cell size according to brand name text length
    NSString * brandName = [brandsArray objectAtIndex:indexPath.row];
    CGSize expectedLabelSize = [brandName sizeWithFont:BRAND_NAME_FONT];
    
    int div = expectedLabelSize.width / BLOCK_PIXELS_WIDTH;
    
    if (div < 6)
        return CGSizeMake(div + 1, 1);
    return CGSizeMake(6, 1);    
    
}

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


#pragma mark - actions

- (void) selectBrand {
    [self closePopup];
}

- (void)closePopup {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

@end
