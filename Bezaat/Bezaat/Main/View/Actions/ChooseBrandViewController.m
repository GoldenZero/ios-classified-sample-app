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
@synthesize collectionView, okBtn;

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
    
    //okBtn
    self.okBtn = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(okBtnPressed)];
    [self.okBtn setTitle:@"OK"];
    self.navigationItem.rightBarButtonItem = okBtn;
    [self.okBtn setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView handling

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {    
    return BRANDS_COUNT;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"BrandCell" forIndexPath:indexPath];
    
    cell.brandImageView.image = [UIImage imageNamed:@"Toyota.png"];
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BRAND_THUMB_SIZE, BRAND_THUMB_SIZE);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.okBtn setEnabled:YES];
    MJSecondDetailViewController *secondDetailViewController = [[MJSecondDetailViewController alloc] initWithNibName:@"MJSecondDetailViewController" bundle:nil];
    secondDetailViewController.delegate = self;
    [self presentPopupViewController:secondDetailViewController animationType:MJPopupViewAnimationFade];
}


//- (void)didSelectsubBrandOfNumber:(int) subBrandNumber {

#pragma mark - MJSecondPopup delegate
- (void) cancelButtonClicked:(MJSecondDetailViewController *)aSecondDetailViewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - actions
- (void) okBtnPressed {
    
    BrowseCarAdsViewController * browseCarAdsVC = [[BrowseCarAdsViewController alloc] initWithNibName:@"BrowseCarAdsViewController" bundle:nil];
    
    [self.navigationController pushViewController:browseCarAdsVC animated:YES];
}

@end
