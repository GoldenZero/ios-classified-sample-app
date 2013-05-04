//
//  BaseDatabaseManager.h
//  ClassifiedAds
//
//  Created by Aubada Taljo on 9/28/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "BaseDataManager.h"

@class FMResultSet;

@interface BaseDatabaseManager : BaseDataManager {
@private
    // The timeout to wait the database
    int timeout;
}

#pragma mark -
#pragma mark Properties

@property (strong, nonatomic) NSString* databaseName;
@property (strong, nonatomic) NSString* tableName;

#pragma mark -
#pragma mark Methods

- (id) initWithDatabaseName:(NSString*)database TableName:(NSString*)table;

- (int) executeNoneQuerySQL:(NSString*)sql;
- (FMResultSet*) query:(NSString*)query;
- (FMResultSet*) queryTable:(NSString*)table withCriteria:(NSDictionary*)criteria sortCriteria:(NSDictionary*)sortCriteria;

@end
