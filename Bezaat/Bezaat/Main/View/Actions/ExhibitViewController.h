//
//  ExhibitViewController.h
//  Bezaat
//
//  Created by Syrisoft on 7/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gallariesManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ExhibitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GalleriesDelegate, UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *viewTitle;
//@property int countryID;

@property (strong, nonatomic) IBOutlet SSLabel * iPad_titleLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *iPad_collectionView;

#pragma mark - Actions
- (IBAction)homeBtnPrss:(id)sender;

@end
