//
//  MapLocationViewController.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKAnnotation.h>
#import "Annotation.h"

@protocol MapsDelegate
@optional
-(void)selectedMapLocationIs:(CLLocation *)pinLocation andAddress:(NSString*)Address;
@end

@interface MapLocationViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *hintBtn;
@property (nonatomic, assign) id<MapsDelegate> selectedMapDelegate;
@property (strong, nonatomic) IBOutlet UITextField *addressLocText;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Annotation* currentAnnotation;
- (IBAction)backInvoked:(id)sender;
- (IBAction)doneInvoked:(id)sender;
- (IBAction)demoBtnPressed:(id)sender;

@end
