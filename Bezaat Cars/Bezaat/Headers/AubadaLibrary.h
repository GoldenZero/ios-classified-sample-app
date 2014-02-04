//
//  AubadaLibrary.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 7/28/12.
//  Copyright (c) 2012 aubada.com. All rights reserved.
//

#ifndef AubadaLibrary_AubadaLibrary_h
#define AubadaLibrary_AubadaLibrary_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#pragma mark -
#pragma mark Ad Classes

//#import "AdMobViewController.h"
#import "AdBannerPosition.h"
//#import "AdMobManager.h"

#pragma mark -
#pragma mark Data Classes

#import "BaseDatabaseManager.h"
#import "BaseDataManager.h"
#import "DBManager.h"
#import "DataDelegate.h"
#import "FileManager.h"
#import "InternetManager.h"

#pragma mark -
#pragma mark DB Classes

#import "FMDatabase.h"
#import "FMResultSet.h"

#pragma mark -
#pragma mark General Classes

#import "BaseViewController.h"
#import "NumberedObject.h"
#import "NamedObject.h"
#import "DescribedObject.h"
#import "DetailedObject.h"
#import "ObjectParserProtocol.h"

#pragma mark -
#pragma mark Map Classes

#import "Annotation.h"

#pragma mark -
#pragma mark Social Classes

#import "YoutubeViewController.h"

#pragma mark -
#pragma mark Table Methods

#import "TableItemsViewController.h"
#import "ItemDetailsViewController.h"
#import "TableItemCell.h"

#pragma mark -
#pragma mark Utils Classes

#import "URLUtils.h"
#import "UIUtils.h"
#import "ViewUtils.h"
#import "StringUtils.h"

#pragma mark -
#pragma mark Parsers

#import "JSONParser.h"
#import "PListParser.h"

#pragma mark -
#pragma mark Third Party
#import "HJManagedImageV.h"
#import "HJObjManager.h"
#import "EGOPhotoGlobal.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"
#import "MBProgressHUD2.h"
#endif
