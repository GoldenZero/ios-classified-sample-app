//
//  ChooseBrandViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseBrandViewController.h"

@interface ChooseBrandViewController ()

@end

@implementation ChooseBrandViewController
@synthesize collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //collection view
    [self.collectionView registerClass:[BrandCell class] forCellWithReuseIdentifier:@"BrandCell"];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView handling

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return BRANDS_COUNT;
}

- (PSUICollectionViewCell *) collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"BrandCell" forIndexPath:indexPath];
    
    cell.brandImageView.image = [UIImage imageNamed:@"Toyota.png"];
    return cell;
    
    
    return [PSUICollectionViewCell new];
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BRAND_THUMB_SIZE, BRAND_THUMB_SIZE);
}

- (void) collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
