//
//  DBManager.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 8/9/12.
//  Copyright (c) 2012 aubada.com. All rights reserved.
//

@class FMDatabase;

@interface DBManager : NSObject {

}

// Signleton Instance
+ (DBManager*) sharedInstance;

#pragma mark -
#pragma mark Database Managment

/* 
 * This method copied the given database from app resources to app documents and returns:
 * 0 if the database wasn't found in the documents and was successfully copied.
 * 1 if the database was found in the documents so it wasn't copied.
 * -1 if the database wasn;t found and couldn't be copied.
 */
- (int) copyDatabase:(NSString*)databaseName withOverwrite:(BOOL)overwrite;

#pragma mark -
#pragma mark Connection Methods

// This method tries to open a database connection to the given database name (from app documents)
- (FMDatabase*) openDBConnection:(NSString*)databaseName timeout:(int)timeout;

// This method tried to close the given database connection
- (void) closeDBConnection:(FMDatabase*)connection;

#pragma mark -
#pragma mark SQL Methods

- (NSString*) buildQueryToTable:(NSString*)tableName usingCriteria:(NSDictionary*)criteria sortCriteria:(NSDictionary*)sortCriteria;

@end
