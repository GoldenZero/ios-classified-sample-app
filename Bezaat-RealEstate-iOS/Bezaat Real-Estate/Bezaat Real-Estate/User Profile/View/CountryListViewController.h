//
//  CountryListViewController.h
//  Bezaat Real-Estate
//
//  Created by GALMarei on 9/11/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownCell.h"
#import "GenericFonts.h"
#import "Country.h"

@interface CountryListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LocationManagerDelegate>
{
    
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
    
}
@property (weak, nonatomic) IBOutlet UITableView *countriesTable;
@property (weak, nonatomic) IBOutlet UIViewController * iPad_parentViewOfPopOver;
- (IBAction)backInvoked:(id)sender;

@end
