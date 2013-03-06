//
//  ChooseBrandViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseBrandViewController.h"

@interface ChooseBrandViewController ()
{
    CarModelLoader * carModelLoader;
    NSArray * modelsArray;
}
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
    [self.collectionView registerClass:[ModelCell class] forCellWithReuseIdentifier:@"ModelCell"];
    [self.collectionView reloadData];
    
    //okBtn
    self.okBtn = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(okBtnPressed)];
    [self.okBtn setTitle:@"OK"];
    self.navigationItem.rightBarButtonItem = okBtn;
    [self.okBtn setEnabled:NO];
    
    //carModelLoader
    carModelLoader = [[CarModelLoader alloc] init];
    modelsArray = [carModelLoader loadCarModelsFromPlistFileWithName:CAR_MODELS_PLIST_FILE_NAME];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView handling

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (modelsArray)
        return modelsArray.count;
    return 0;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (modelsArray)
    {
        ModelCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ModelCell" forIndexPath:indexPath];
        
        CarModel * aCarModel = [modelsArray objectAtIndex:indexPath.row];
        cell.brandImageView.image = [UIImage imageNamed:aCarModel.imageFileName];
        return cell;
    }
    return [UICollectionViewCell new];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BRAND_THUMB_SIZE, BRAND_THUMB_SIZE);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (modelsArray)
    {
        CarModel * aCarModel = [modelsArray objectAtIndex:indexPath.row];
        NSMutableArray * brandNames = [NSMutableArray new];
        for (ModelBrand * brand in aCarModel.brandsArray)
            [brandNames addObject:brand.name];
        
        //add an entry for "all brands"
        [brandNames addObject:@"جميع الأنواع"];
        
        [self.okBtn setEnabled:YES];
        MJSecondDetailViewController *secondDetailViewController = [[MJSecondDetailViewController alloc] initWithNibName:@"MJSecondDetailViewController" bundle:nil];
        secondDetailViewController.delegate = self;
        secondDetailViewController.sourceArray = brandNames;
        [self presentPopupViewController:secondDetailViewController animationType:MJPopupViewAnimationFade];
    }
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
