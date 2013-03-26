//
//  ChooseLocationViewController.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/3/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

/*
 #import "ChooseLocationViewController.h"
 #import "Configuration.h"
 #import "BaseDataObject.h"
 
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
 NSArray * countriesArray;
 NSArray * citiesArray;
 Country * chosenCountry;
 City * chosenCity;
 BOOL countryChosen;
 BOOL cityChosen;
 CountryLoader * countryLoader;
 MBProgressHUD2 * loadingHUD;
 }
 @end
 
 @implementation ChooseLocationViewController
 @synthesize nextBtn, backgroungImageView;
 
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 countryChosen = NO;
 cityChosen = NO;
 }
 return self;
 }
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 //countryLoader
 countryLoader = [[CountryLoader alloc] initWithDelegate:self];
 [self showLoadingIndicator];
 [countryLoader loadCountries];
 
 //self initialize drop down lists
 //[self initLocationLists];
 
 }
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 #pragma mark - actions
 - (IBAction)nextBtnPressed:(id)sender {
 SignInViewController * signInVC = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
 [self.navigationController pushViewController:signInVC animated:YES];
 }
 
 #pragma mark - DropDownList delegate
 
 - (void) dropDownListItemDidSelected:(DropDownList*) theDropDownList WithNumber:(int) k
 {
 //NSLog(@"item number: %i was selected in dropdownlist with name: %@", k + 1, theDropDownList.name);
 
 if (theDropDownList == countriesLst)
 {
 chosenCountry =  [countriesArray objectAtIndex:k];
 citiesArray = chosenCountry.cities;
 
 citiesLst.name = CITIES_DROPDOWNLIST_NAME;
 
 [self initCitiesListContentOfCurrentCountry];
 
 [citiesLst setUserInteractionEnabled:YES];
 countryChosen = YES;
 
 }
 else if (theDropDownList == citiesLst)
 {
 chosenCity = (City *) [citiesArray objectAtIndex:k];
 if ((chosenCity) && (chosenCity.image))
 [self.backgroungImageView setImage:chosenCity.image];
 
 cityChosen = YES;
 }
 
 if (countryChosen && cityChosen)
 [nextBtn setEnabled:YES];
 
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
 [citiesLst setUserInteractionEnabled:NO];
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
 
 if (countriesArray)
 {
 for (NSUInteger i = 0; i < countriesArray.count; i++)
 {
 BaseItemObject * tempBaseItemObject = [[BaseItemObject alloc] init];
 
 BaseDataObject * tempBaseDataObject = [[BaseDataObject alloc] init];
 tempBaseDataObject.name = [(Country *) [countriesArray objectAtIndex:i] countryName];
 tempBaseDataObject.description = @"";
 tempBaseDataObject.image = nil;
 
 tempBaseItemObject.dataObject = tempBaseDataObject;
 [countriesLstItems addObject:tempBaseItemObject];
 }
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
 [self initCitiesListContentOfCurrentCountry];
 }
 
 - (void) initCitiesListContentOfCurrentCountry {
 
 
 if (!citiesLstItems)
 citiesLstItems = [[NSMutableArray alloc] init];
 [citiesLstItems removeAllObjects];
 
 if (chosenCountry)
 {
 citiesArray = chosenCountry.cities;
 for (NSUInteger i = 0; i < citiesArray.count; i++)
 {
 BaseItemObject * tempBaseItemObject = [[BaseItemObject alloc] init];
 
 BaseDataObject * tempBaseDataObject = [[BaseDataObject alloc] init];
 tempBaseDataObject.name = [(City *)[citiesArray objectAtIndex:i] name];
 
 tempBaseDataObject.description = @"";
 tempBaseDataObject.image = nil;
 
 tempBaseItemObject.dataObject = tempBaseDataObject;
 [citiesLstItems addObject:tempBaseItemObject];
 
 }
 
 citiesLst.objects = citiesLstItems;
 [citiesLst reloadInputViews];
 }
 }
 
 
 - (void) showLoadingIndicator {
 loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.navigationController.view animated:YES];
 
 loadingHUD.mode = MBProgressHUDModeIndeterminate2;
 
 loadingHUD.labelText = @"جاري تحميل البيانات";
 
 loadingHUD.detailsLabelText = @"";
 loadingHUD.dimBackground = YES;
 }
 
 
 - (void) hideLoadingIndicator {
 if (loadingHUD)
 [MBProgressHUD2 hideHUDForView:self.navigationController.view  animated:YES];
 loadingHUD = nil;
 }
 
 
 #pragma mark - CountryLoader Delegate
 
 - (void) countriesDidFailLoadingWithError:(NSError *)error {
 [self hideLoadingIndicator];
 countriesArray = nil;
 [GenericMethods throwAlertWithTitle:@"خطأ" message:@"فشل تحميل بيانات المكان" delegateVC:nil];
 }
 
 - (void) countriesDidSucceedLoadingWithData:(NSArray *)resultArray {
 
 countriesArray = resultArray;
 
 //change loading message
 //loadingHUD.labelText = @"جاري اتحميل بيانات االمدن"
 
 //self initialize drop down lists
 [self initLocationLists];
 
 [self hideLoadingIndicator];
 }
 
 
 @end
 */


#import "ChooseLocationViewController.h"
#import "Configuration.h"
#import "BaseDataObject.h"
#import "GenericFonts.h"
#import "Country.h"
#pragma mark - drop down lists parameters

//position
//#define COUNTRIES_DROPDOWNLIST_ORIGIN CGPointMake(30.0,40.0)
//#define CITIES_DROPDOWNLIST_ORIGIN CGPointMake(30.0,175.0)


//name
#define COUNTRIES_DROPDOWNLIST_NAME @"اختر البلد"
#define CITIES_DROPDOWNLIST_NAME @"اختر االمدينة"

//type
#define DROPDOWNLIST_TYPE @"DEFAULT_TYPE"

//Instruction label frame in button
//#define BUTTON_INSTRUCTION_LABEL_FRAME CGRectMake(14.0,30.0,200.0,12.0)

//table view parameters
static const CGFloat X_TABLE_MARGIN	= 0.0;
static const CGFloat Y_TABLE_MARGIN	= 34.5;

//backgroud parameters
static const CGFloat X_BAKCGROUND_MARGIN	= 0.0;
static const CGFloat Y_BACKGROUND_MARGIN	= 0.0;
static const CGFloat BG_UNDER_TABLE_HEIGHT	= 20.0;


@interface ChooseLocationViewController ()
{
    DropDownList * countriesLst;
    DropDownList * citiesLst;
    NSMutableArray * countriesLstItems;
    NSMutableArray * citiesLstItems;
    NSArray * countriesArray;
    NSArray * citiesArray;
    Country * chosenCountry;
    City * chosenCity;
    BOOL countryChosen;
    BOOL cityChosen;
    LocationManager * locationMngr;
    UIImageView *mapImageView;
    MBProgressHUD2 * loadingHUD;
    UIImageView *countryImage;
    CGPoint COUNTRIES_DROPDOWNLIST_ORIGIN;//
    CGPoint CITIES_DROPDOWNLIST_ORIGIN;//
    
}
@end

@implementation ChooseLocationViewController
@synthesize nextBtn, backgroungImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        countryChosen = NO;
        cityChosen = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
            
        {
            COUNTRIES_DROPDOWNLIST_ORIGIN.x= 30.0;
            COUNTRIES_DROPDOWNLIST_ORIGIN.y= 280.0;
            CITIES_DROPDOWNLIST_ORIGIN.x=30.0;
            CITIES_DROPDOWNLIST_ORIGIN.y=330.0;
        }
        
        if(result.height == 568)
            
        {
            COUNTRIES_DROPDOWNLIST_ORIGIN.x= 30.0;
            COUNTRIES_DROPDOWNLIST_ORIGIN.y= 340.0;
            CITIES_DROPDOWNLIST_ORIGIN.x=30.0;
            CITIES_DROPDOWNLIST_ORIGIN.y=400.0;
        }
    }
    [nextBtn setEnabled:YES];
    [self setBackgroundImages];
    locationMngr = [[LocationManager alloc] initWithDelegate:self];
    [self showLoadingIndicator];
    [locationMngr loadCountriesAndCities];
    //self initialize drop down lists
    [self initLocationLists];
    
    // set images
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)nextBtnPressed:(id)sender {
    SignInViewController * signInVC = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [self presentViewController:signInVC animated:YES completion:nil];
}

#pragma mark - custom methods

- (void) setBackgroundImages{
    

    // set map view
   if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        mapImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 2844, 1983)];
    }
   else {
        mapImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 1427, 993)];

   }
    mapImageView.image=[UIImage imageNamed:@"location_map.png"];
    [self.backgroungImageView addSubview:mapImageView ];


}
#pragma mark - DropDownList delegate

- (void) dropDownListItemDidSelected:(DropDownList*) theDropDownList WithNumber:(int) k
{
    //NSLog(@"item number: %i was selected in dropdownlist with name: %@", k + 1, theDropDownList.name);
    
    if (theDropDownList == countriesLst)
    {
        chosenCountry = [countriesArray objectAtIndex:k];
        citiesArray = chosenCountry.cities;
       

        countriesLst.name = [chosenCountry countryName];
        CGAffineTransform translate = CGAffineTransformMakeTranslation((-[chosenCountry xCoord]+160), (-[chosenCountry yCoord]+140));
        [mapImageView setTransform:translate];
        int countryid=[chosenCountry countryID];
        countryImage.image=nil;
        UIImage *temp;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
            && [[UIScreen mainScreen] scale] == 2.0) {
            NSString *imagePath=[NSString stringWithFormat:@"%d_country@2x.png",countryid];
            temp =[UIImage imageNamed:imagePath];
            if (temp) {
                if ([chosenCountry xCoord]!=-1) {
                     countryImage=[[UIImageView alloc] initWithFrame:CGRectMake([chosenCountry xCoord], [chosenCountry yCoord],temp.size.width, temp.size.height)];
                }
            }
          countryImage.image=temp;
        }
        else
        {
            NSString *imagePath=[NSString stringWithFormat:@"%d_country.png",countryid];
            temp =[UIImage imageNamed:imagePath];
            if (temp) {
                if ([chosenCountry xCoord]!=-1) {
                   countryImage=[[UIImageView alloc] initWithFrame:CGRectMake([chosenCountry xCoord]+5, [chosenCountry yCoord]+1,temp.size.width, temp.size.height)];
                }
            }
            countryImage.image=temp;

        }

        
        [mapImageView addSubview:countryImage];
        [mapImageView insertSubview:countryImage aboveSubview:mapImageView];

        
        citiesLst.name =[[citiesArray objectAtIndex:0] cityName];
        
        [self initCitiesListContentOfCurrentCountry];
        
        [citiesLst setUserInteractionEnabled:YES];
        countryChosen = YES;
        
    }
    else if (theDropDownList == citiesLst)
    {
        chosenCity = (City *) [citiesArray objectAtIndex:k];
        /*
         if ((chosenCity) && (chosenCity.image))
         [self.backgroungImageView setImage:chosenCity.image];
         */
        cityChosen = YES;
    }
    
//    if (countryChosen && cityChosen)
//        [nextBtn setEnabled:YES];
    
}

- (void) dropDownListDidShown:(DropDownList*) theDropDownList
{
    //NSLog(@"dropdownlist is shown");
}

- (void) didFinishLoadingWithData:(NSArray*) resultArray{
    countriesArray=resultArray;
    [self hideLoadingIndicator];
    
}
#pragma mark - handler show indecator delegate
- (void) showLoadingIndicator {
    
    loadingHUD = [MBProgressHUD2 showHUDAddedTo:self.view animated:YES];
    
    loadingHUD.mode = MBProgressHUDModeIndeterminate2;
    
    loadingHUD.labelText = @"جاري تحميل البيانات";
    
    loadingHUD.detailsLabelText = @"";
    
    loadingHUD.dimBackground = YES;
    
}


- (void) hideLoadingIndicator {
    
    if (loadingHUD)
        
        [MBProgressHUD2 hideHUDForView:self.view  animated:YES];
    
    loadingHUD = nil;
    
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
    [citiesLst setUserInteractionEnabled:NO];
}

- (void) initCountriesDropDownList {
    
    // Create configuration object
    Configuration *config = [[Configuration alloc] init];
    
    countriesLst = [[DropDownList alloc] initWithOrigin:COUNTRIES_DROPDOWNLIST_ORIGIN
                                            ActiveImage:config.buttonActiveBG
                                      WithInactiveImage:config.buttonNoActiveBG];
    // Setting default country
    NSUInteger defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    Country *defaultCountry=[countriesArray objectAtIndex:defaultIndex];
    countriesLst.name = [defaultCountry countryName];
    CGAffineTransform translate = CGAffineTransformMakeTranslation((-[defaultCountry xCoord]+160), (-[defaultCountry yCoord]+140));
    [mapImageView setTransform:translate];
    int countryid=[defaultCountry countryID];
    
    UIImage *temp;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        NSString *imagePath=[NSString stringWithFormat:@"%d_country@2x.png",countryid];
        temp =[UIImage imageNamed:imagePath];
        if (temp) {
            if ([chosenCountry xCoord]!=-1) {
                countryImage=[[UIImageView alloc] initWithFrame:CGRectMake([defaultCountry xCoord], [defaultCountry yCoord],temp.size.width, temp.size.height)];
            }
        }
        countryImage.image=temp;
    }
    else
    {
        NSString *imagePath=[NSString stringWithFormat:@"%d_country.png",countryid];
        temp =[UIImage imageNamed:imagePath];
        if (temp) {
            if ([chosenCountry xCoord]!=-1) {
                countryImage=[[UIImageView alloc] initWithFrame:CGRectMake([defaultCountry xCoord]+5, [defaultCountry yCoord]+1,temp.size.width, temp.size.height)];
            }
        }
        countryImage.image=temp;
        
    }
 
    [mapImageView addSubview:countryImage];
    [mapImageView insertSubview:countryImage aboveSubview:mapImageView];
    
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
    
    if (countriesArray)
    {
        for (NSUInteger i = 0; i < countriesArray.count; i++)
        {
            BaseItemObject * tempBaseItemObject = [[BaseItemObject alloc] init];
            
            BaseDataObject * tempBaseDataObject = [[BaseDataObject alloc] init];
            tempBaseDataObject.name = [(Country *) [countriesArray objectAtIndex:i] countryName];
            tempBaseDataObject.description = @"";
            tempBaseDataObject.image = nil;
            
            tempBaseItemObject.dataObject = tempBaseDataObject;
            [countriesLstItems addObject:tempBaseItemObject];
        }
    }
    countriesLst.objects = countriesLstItems;
}

- (void) initCitiesDropDownList {
    // Create configuration object
    Configuration *config = [[Configuration alloc] init];
    
    citiesLst = [[DropDownList alloc] initWithOrigin:CITIES_DROPDOWNLIST_ORIGIN
                                         ActiveImage:config.buttonActiveBG
                                   WithInactiveImage:config.buttonNoActiveBG];
    NSUInteger defaultIndex= [locationMngr getDefaultSelectedCountryIndex];
    citiesArray= [[countriesArray objectAtIndex:defaultIndex] cities];
    citiesLst.name = [[citiesArray objectAtIndex:0]cityName];
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
    [self initCitiesListContentOfCurrentCountry];
}

- (void) initCitiesListContentOfCurrentCountry {
    
    
    if (!citiesLstItems)
        citiesLstItems = [[NSMutableArray alloc] init];
    [citiesLstItems removeAllObjects];
    
    if (chosenCountry)
    {
        citiesArray = chosenCountry.cities;
        for (NSUInteger i = 0; i < citiesArray.count; i++)
        {
            BaseItemObject * tempBaseItemObject = [[BaseItemObject alloc] init];
            
            BaseDataObject * tempBaseDataObject = [[BaseDataObject alloc] init];
            tempBaseDataObject.name = [(City *)[citiesArray objectAtIndex:i] cityName];
            
            tempBaseDataObject.description = @"";
            tempBaseDataObject.image = nil;
            
            tempBaseItemObject.dataObject = tempBaseDataObject;
            [citiesLstItems addObject:tempBaseItemObject];
            
        }
        
        citiesLst.objects = citiesLstItems;
        [citiesLst reloadInputViews];
    }
}

@end