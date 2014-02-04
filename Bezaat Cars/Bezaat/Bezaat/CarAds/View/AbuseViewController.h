//
//  AbuseViewController.h
//  Bezaat
//
//  Created by GALMarei on 10/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarDetailsManager.h"

@protocol AbuseDelegate <NSObject>
@required
-(void)abuseFinishsubmit;

@end

@interface AbuseViewController : UIViewController<AbuseAdDelegate>

@property (strong, nonatomic) id <AbuseDelegate> abuseDelegate;
@property (nonatomic) NSInteger AdID;

@property (strong, nonatomic) IBOutlet UIButton *Btn1;
@property (strong, nonatomic) IBOutlet UIButton *Btn2;
@property (strong, nonatomic) IBOutlet UIButton *Btn3;
@property (strong, nonatomic) IBOutlet UIButton *Btn4;

- (IBAction)submitAbuse:(id)sender;
- (IBAction)Btn1Invoked:(id)sender;

@end
