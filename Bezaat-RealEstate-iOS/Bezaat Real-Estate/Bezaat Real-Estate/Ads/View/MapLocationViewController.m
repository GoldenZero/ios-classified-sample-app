//
//  MapLocationViewController.m
//  Bezaat Real-Estate
//
//  Created by GALMarei on 11/7/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "MapLocationViewController.h"

@interface MapLocationViewController ()
{
    CLLocationManager* locationMgr;
    CLLocation* PropertyLocation;
    NSString* AddLocation;
}
@end

@implementation MapLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GAI sharedInstance].defaultTracker sendView:@"Map location screen"];

    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"mapLaunch"]) { //first launch
            //In your viewDidLoad method of your view controller
            [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideCoachView) userInfo:nil repeats:NO];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mapLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
            [self.hintBtn setHidden:YES];
 
    }
    // Do any additional setup after loading the view from its nib.
    if (self.currentAnnotation) {
        MKCoordinateRegion region;
        CLLocation* estateLocation = [[CLLocation alloc] initWithLatitude:
         self.currentAnnotation.coordinate.latitude longitude:self.currentAnnotation.coordinate.longitude];
        
        region.center = estateLocation.coordinate;
        
        MKCoordinateSpan span = { 0.02, 0.02 };
        region.span = span;
        [self.mapView setRegion:region animated:YES];
        
        [self.mapView addAnnotation:self.currentAnnotation];
        
       
        
    }else{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    locationMgr.distanceFilter = kCLDistanceFilterNone;
    locationMgr.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationMgr startUpdatingLocation];
    }
}

- (void) hideCoachView {
    //[self.coach_view setHidden:YES];
    [UIView transitionWithView:self.hintBtn
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.hintBtn.hidden = YES;
}


-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //[self.mapView removeGestureRecognizer:sender];
    }
    else
    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
       
        // Then all you have to do is create the annotation and add it to the map
        Annotation *dropPin = [[Annotation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
        [self removeAllPinsButUserLocation2];
        [self.mapView addAnnotation:dropPin];
       
        PropertyLocation = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
        [self loadLocationAddress:PropertyLocation];
    }
}

- (void)removeAllPinsButUserLocation2
{
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (userLocation != nil) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.mapView removeAnnotations:pins];
}

-(void)loadLocationAddress:(CLLocation*)myLoc
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=ar",myLoc.coordinate.latitude,myLoc.coordinate.longitude]];
    
    NSArray * parsedArray = [[JSONParser sharedInstance] parseJSONData:[NSData dataWithContentsOfURL:url]];
    NSDictionary* data = (NSDictionary*)[parsedArray objectAtIndex:0];
    NSArray* dataArr = [data objectForKey:@"results"];
    NSDictionary* resultArr = (NSDictionary*)[dataArr objectAtIndex:0];
    NSString* locationAddress = [resultArr objectForKey:@"formatted_address"];

    AddLocation = locationAddress;
    [self.addressLocText setHidden:NO];
    self.addressLocText.text = locationAddress;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [locationMgr stopUpdatingLocation];
    MKCoordinateRegion region;
    region.center = newLocation.coordinate;
    
    MKCoordinateSpan span = { 0.02, 0.02 };
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    //[self.selectedMapDelegate selectedMapLocationIs:newLocation];
}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!pinView) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
       
        if (annotation == mapView.userLocation)
            return nil;
        else
            customPinView.image = [UIImage imageNamed:@"mapIndex.png"];
        
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = NO;
        
        return customPinView;
        
    } else {
        
        pinView.annotation = annotation;
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    CLLocation* temp;
    for (CLLocation* n in views) {
        temp = n;
        NSLog(@"%@",n);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneInvoked:(id)sender {
    
    [self.selectedMapDelegate selectedMapLocationIs:PropertyLocation andAddress:AddLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)demoBtnPressed:(id)sender {
}
@end
