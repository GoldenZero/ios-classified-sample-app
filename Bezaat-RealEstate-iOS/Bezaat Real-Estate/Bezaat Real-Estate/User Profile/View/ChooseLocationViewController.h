//
//  ChooseLocationViewController.h
//  Bezaat Real-Estate
//
//  Created by Roula Misrabi on 8/1/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownCell.h"
#import "GenericFonts.h"
#import "Country.h"
#import "SignInViewController.h"
#import "CLLocationManager+blocks.h"

@interface ChooseLocationViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,LocationManagerDelegate,CLLocationManagerDelegate>
{
    
    MBProgressHUD2 * loadingHUD;
    
    NSIndexPath* CityIndex;
    NSMutableArray* _countries;
    NSMutableArray* _cities;
    
    NSString *dropDown1;
    NSString *dropDown2;
    
    BOOL dropDown1Open;
    BOOL dropDown2Open;
    BOOL dropDown3Open;
    BOOL dropDown4Open;
    BOOL dropDown5Open;
    BOOL dropDown6Open;
    BOOL dropDown7Open;
    BOOL dropDown8Open;
    BOOL dropDown9Open;
    BOOL dropDown10Open;
    BOOL dropDown11Open;
    BOOL dropDown12Open;
    BOOL dropDown13Open;
    BOOL dropDown14Open;
    BOOL dropDown15Open;
    BOOL dropDown16Open;
    BOOL dropDown17Open;
    BOOL dropDown18Open;
    
    
    NSUInteger defaultIndex;
    NSInteger defaultCityID;
    NSString* defaultCityName;
    
    NSArray * countriesArray;
    NSArray * citiesArray;
    
    Country * chosenCountry;
    City * chosenCity;
    
    BOOL countryChosen;
    BOOL cityChosen;
    
    LocationManager * locationMngr;
    
    CLLocationManager* _locationManager;
    CLLocation* _currentLocation;
    
    NSString* sLatitude;
    NSString* eLatitude;
    NSString* sLongtude;
    NSString* eLongtude;
    
}
@property (weak, nonatomic) IBOutlet UITableView *countriesTable;
@property (nonatomic, strong) CLLocationManager *manager;

@end
