//
//  ChooseLocationViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "Configuration.h"
#import "BaseDataObject.h"
#import "Countries.h"

#pragma mark - drop down lists parameters

//position
#define COUNTRIES_DROPDOWNLIST_ORIGIN					CGPointMake(30.0,40.0)
#define CITIES_DROPDOWNLIST_ORIGIN                      CGPointMake(30.0,175.0)

//name
#define COUNTRIES_DROPDOWNLIST_NAME						@"اختر البلد"
#define CITIES_DROPDOWNLIST_NAME						@"اختر االمدينة"

//type
#define DROPDOWNLIST_TYPE							@"DEFAULT_TYPE"

//Instruction label frame in button
//#define BUTTON_INSTRUCTION_LABEL_FRAME					CGRectMake(14.0,30.0,200.0,12.0)

//table view parameters
static const CGFloat X_TABLE_MARGIN						= 4.0;
static const CGFloat Y_TABLE_MARGIN						= 45.0;

//backgroud parameters
static const CGFloat X_BAKCGROUND_MARGIN				= -13.0;
static const CGFloat Y_BACKGROUND_MARGIN				= 0.0;
static const CGFloat BG_UNDER_TABLE_HEIGHT				= 20.0;


@interface ChooseLocationViewController ()
{
    DropDownList * countriesLst;
    DropDownList * citiesLst;
    NSMutableArray * countriesLstItems;
    NSMutableArray * citiesLstItems;
    enum Country chosenCountry;
    enum City chosenCity;
    
}
@end

@implementation ChooseLocationViewController

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
    
    //self initialize drop down lists
    [self initLocationLists];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DropDownList delegate

- (void) dropDownListItemDidSelected:(DropDownList*) theDropDownList WithNumber:(int) k
{
	//NSLog(@"item number: %i was selected in dropdownlist with name: %@", k + 1, theDropDownList.name);
    
    if (theDropDownList == countriesLst)
    {
        chosenCountry = k;
        NSLog(@"k = %i, chosen country = %@", k, [GenericMethods countryName:k]);
        [self initCitiesListContentOfCountry:k];
    }
}

- (void) dropDownListDidShown:(DropDownList*) theDropDownList
{
	//NSLog(@"dropdownlist is shown");
}

#pragma mark - helper methods

- (void) initLocationLists {
    //1- init countries DropDownList
	[self initCountriesDropDownList];
	
	//2- set countries DropDownList delegate
	countriesLst.delegate = self;
    
	
    //1- init cities DropDownList
	[self initCitiesDropDownList];
	
	//2- set countries DropDownList delegate
	citiesLst.delegate = self;
    
	//3- add to MainViewController
	[self.view addSubview:countriesLst];
	[self.view addSubview:citiesLst];
	
	// Paste data to myDropdownList
	//myDropDownList.objects = dropDownListItems;
	
	//4- make active (because it's inactive by default)
	[countriesLst setUserInteractionEnabled:YES];
    [citiesLst setUserInteractionEnabled:YES];
}

- (void) initCountriesDropDownList {
    
    // Create configuration object
	Configuration *config = [[Configuration alloc] init];
	
	countriesLst = [[DropDownList alloc] initWithOrigin:COUNTRIES_DROPDOWNLIST_ORIGIN
                                            ActiveImage:config.buttonActiveBG
                                      WithInactiveImage:config.buttonNoActiveBG];
	
	countriesLst.name = COUNTRIES_DROPDOWNLIST_NAME;
	countriesLst.type = DROPDOWNLIST_TYPE;
	countriesLst.buttonInstructionLabelFrame = BUTTON_INSTRUCTION_LABEL_FRAME;
	
	[countriesLst setTopMainBG:config.openBGTop setMiddleBG:config.openBGMiddle setBottom:config.openBGBottom];
	
	[countriesLst setCellBGImage:config.itemBG setCellBGHoverImage:config.itemBGHoved];
	
	[countriesLst setBGXMargin:X_BAKCGROUND_MARGIN
                     BGYMargin:Y_BACKGROUND_MARGIN
            BGUnderTableHeight:BG_UNDER_TABLE_HEIGHT];
	
	[countriesLst setTableXMargin:X_TABLE_MARGIN TableYMargin:Y_TABLE_MARGIN];
	
	countriesLst.cellDispAmount = 4;
	
	// Make myDropDownList inactive by default
	[countriesLst setUserInteractionEnabled:NO];
	
    
	// Set parent view controller
	countriesLst.parentViewController = self;
    
    //2- create the content
    [self initCountriesListContent];
}

- (void) initCountriesListContent {
    
	countriesLstItems = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i <= COUNTRY_COUNT; i++)
	{
		BaseItemObject * tempBaseItemObject = [[BaseItemObject alloc] init];
		
        BaseDataObject * tempBaseDataObject = [[BaseDataObject alloc] init];
		tempBaseDataObject.name = [GenericMethods countryName:i];
		tempBaseDataObject.description = @"";
		tempBaseDataObject.image = nil;
        
		tempBaseItemObject.dataObject = tempBaseDataObject;
		[countriesLstItems addObject:tempBaseItemObject];
	}
    countriesLst.objects = countriesLstItems;
}

- (void) initCitiesDropDownList {
    // Create configuration object
	Configuration *config = [[Configuration alloc] init];
	
	citiesLst = [[DropDownList alloc] initWithOrigin:CITIES_DROPDOWNLIST_ORIGIN
                                         ActiveImage:config.buttonActiveBG
                                   WithInactiveImage:config.buttonNoActiveBG];
	
	citiesLst.name = CITIES_DROPDOWNLIST_NAME;
	citiesLst.type = DROPDOWNLIST_TYPE;
	citiesLst.buttonInstructionLabelFrame = BUTTON_INSTRUCTION_LABEL_FRAME;
	
	[citiesLst setTopMainBG:config.openBGTop setMiddleBG:config.openBGMiddle setBottom:config.openBGBottom];
	
	[citiesLst setCellBGImage:config.itemBG setCellBGHoverImage:config.itemBGHoved];
	
	[citiesLst setBGXMargin:X_BAKCGROUND_MARGIN
                  BGYMargin:Y_BACKGROUND_MARGIN
         BGUnderTableHeight:BG_UNDER_TABLE_HEIGHT];
	
	[citiesLst setTableXMargin:X_TABLE_MARGIN TableYMargin:Y_TABLE_MARGIN];
	
	citiesLst.cellDispAmount = 4;
	
	// Make myDropDownList inactive by default
	[citiesLst setUserInteractionEnabled:NO];
	
    
	// Set parent view controller
	citiesLst.parentViewController = self;
    
    //2- create the content
    [self initCitiesListContentOfCountry:-1];
}

- (void) initCitiesListContentOfCountry:(int) theCountry {//if theCountry == -1 --> empty list!
    
    citiesLstItems = [[NSMutableArray alloc] init];
    int numOfCities = -1;
    
    switch (theCountry) {
        case SaudiArabia: numOfCities = SAUDI_ARABIA_CITY_COUNT;
            break;
            
        case Emirates: numOfCities = EMIRATES_CITY_COUNT;
            break;
            
        case Kuwait: numOfCities = KUWAIT_CITY_COUNT;
            break;
            
        case Qatar: numOfCities = QATAR_CITY_COUNT;
            break;
            
        case Bahrain: numOfCities = BAHRAIN_CITY_COUNT;
            break;
            
        case Yemen: numOfCities = YEMEN_CITY_COUNT;
            break;
            
        case Iraq: numOfCities = IRAQ_CITY_COUNT;
            break;
            
        case Syria: numOfCities = SYRIA_CITY_COUNT;
            break;
            
        case Jordan: numOfCities = JORDAN_CITY_COUNT;
            break;
            
        case Lebanon: numOfCities = LEBANON_CITY_COUNT;
            break;
            
        case Egypt: numOfCities = EGYPT_CITY_COUNT;
            break;
            
        case Algeria: numOfCities = ALGERIA_CITY_COUNT;
            break;
            
        case Tunisia: numOfCities = TUNISIA_CITY_COUNT;
            break;
            
        case Sudan: numOfCities = SUDAN_CITY_COUNT;
            break;
            
        case Morocco: numOfCities = MOROCCO_CITY_COUNT;
            break;
            
        case Libya: numOfCities = LIBYA_CITY_COUNT;
            break;
            
        case Somalia: numOfCities = SOMALIA_CITY_COUNT;
            break;
            
        case Mauritania: numOfCities = MAURITANIA_CITY_COUNT;
            break;
            
        case Djibouti: numOfCities = DJIBOUTI_CITY_COUNT;
            break;
            
        case Comoros: numOfCities = COMOROS_CITY_COUNT;
            break;
            
        case Oman: numOfCities = OMAN_CITY_COUNT;
            break;
            
        case Palestine: numOfCities = PALESTINE_CITY_COUNT;
            break;
    }
    if (numOfCities == -1)
    {
        for (NSUInteger i = 0; i < 2; i++)//fake 2 lines if country not set yet
        {
            BaseItemObject * tempBaseItemObject = [[BaseItemObject alloc] init];
            
            BaseDataObject * tempBaseDataObject = [[BaseDataObject alloc] init];
            tempBaseDataObject.name = @"...";
            tempBaseDataObject.description = @"";
            tempBaseDataObject.image = nil;
            
            tempBaseItemObject.dataObject = tempBaseDataObject;
            [citiesLstItems addObject:tempBaseItemObject];
        }
    }
    else
    {
        for (NSUInteger i = 0; i <= numOfCities; i++)
        {
            BaseItemObject * tempBaseItemObject = [[BaseItemObject alloc] init];
            
            BaseDataObject * tempBaseDataObject = [[BaseDataObject alloc] init];
            
            switch (theCountry) {
                case SaudiArabia:
                    tempBaseDataObject.name = [GenericMethods SaudiArabiaCityName:i];
                    break;
                    
                case Emirates: tempBaseDataObject.name = [GenericMethods EmiratesCityName:i];
                    break;
                    
                case Kuwait: tempBaseDataObject.name = [GenericMethods KuwaitCityName:i];
                    break;
                /*
                case Qatar:
                     break;
                     
                case Bahrain:
                     break;
                     
                case Yemen:
                     break;
                     
                case Iraq:
                     break;
                     
                case Syria:
                     break;
                     
                case Jordan:
                     break;
                     
                case Lebanon:
                     break;
                     
                case Egypt:
                     break;
                     
                case Algeria:
                     break;
                     
                case Tunisia:
                     break;
                     
                case Sudan:
                     break;
                     
                case Morocco:
                     break;
                     
                case Libya:
                     break;
                     
                case Somalia:
                     break;
                     
                case Mauritania:
                     break;
                     
                case Djibouti:
                     break;
                     
                case Comoros:
                     break;
                     
                case Oman:
                     break;
                     
                case Palestine:
                     break;
                */
                
                default: tempBaseDataObject.name = @"";
                    break;
            }
            tempBaseDataObject.description = @"";
            tempBaseDataObject.image = nil;
            
            tempBaseItemObject.dataObject = tempBaseDataObject;
            [citiesLstItems addObject:tempBaseItemObject];
            
        }
    }
    citiesLst.objects = citiesLstItems;
    
}
@end
