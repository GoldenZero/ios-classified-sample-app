//
//  CategoriesPopOver_iPad.m
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/28/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "CategoriesPopOver_iPad.h"

@interface CategoriesPopOver_iPad ()
{
    NSMutableArray * categoriesArray;

}
@end

@implementation CategoriesPopOver_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    categoriesArray = [NSMutableArray arrayWithArray:
                       [[AdsManager sharedInstance] getCategoriesForstatus:self.browsingForSale]];

    [self prepareCategories];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)prepareCategories
{
    int categories_x = 242;
    int categories_y = 0;
    for (int i = 0; i < [categoriesArray count]; i++) {
        Category1* categ = [categoriesArray objectAtIndex:i];
        
        UIView* CatContainer = [[UIView alloc] initWithFrame:CGRectMake(categories_x, categories_y, 241, 48)];
        CatContainer.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0f];

        
        UIImageView* CatImg = [[UIImageView alloc] initWithFrame:CGRectMake(206, 14, 20, 20)];
        CatImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"small_default-Cat-%i",categ.categoryID]];
        UILabel* CatLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200, 48)];
        CatLbl.text = categ.categoryName;
        CatLbl.textAlignment = NSTextAlignmentRight;
        CatLbl.backgroundColor = [UIColor clearColor];
        CatLbl.textColor = [UIColor blackColor];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 241, 48);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(iPad_userDidEndChoosingCategoryFromPopOver:) forControlEvents:UIControlEventTouchUpInside];
        
        [CatContainer addSubview:CatImg];
        [CatContainer addSubview:CatLbl];
        [CatContainer addSubview:btn];
        
        categories_y+=49;
        if (categories_y == 637) {
            categories_x -= 242;
            categories_y = 0;
        }
        [self.view addSubview:CatContainer];
        
        
    }

}

-(void)iPad_userDidEndChoosingCategoryFromPopOver:(UIButton*)sender
{
    Category1* cat = [categoriesArray objectAtIndex:sender.tag];
    [self.choosingDelegate didChooseCategory:cat];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
