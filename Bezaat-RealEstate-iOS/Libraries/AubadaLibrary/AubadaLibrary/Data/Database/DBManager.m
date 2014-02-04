//
//  DBManager.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 8/9/12.
//  Copyright (c) 2012 aubada.com. All rights reserved.
//

#import "DBManager.h"

#import "FileManager.h"
#import "FMDatabase.h"

@implementation DBManager

- (id) init {
	if (self = [super init]) {
	}
	
	return self;
}

// Signleton Instance
+ (DBManager*) sharedInstance {
	static DBManager* instance = nil;
	if (instance == nil) {
		instance = [[DBManager alloc] init];
	}
	
	return instance;
}

#pragma mark -
#pragma mark Database Managment

/*
 * This method copied the given database from app resources to app documents and returns:
 * 0 if the database wasn't found in the documents and was successfully copied.
 * 1 if the database was found in the documents so it wasn't copied.
 * -1 if the database wasn;t found and couldn't be copied.
 */
- (int) copyDatabase:(NSString*)databaseName withOverwrite:(BOOL)overwrite {
	// Get the database path in the bundle
	NSString* databasePathInBundle = [[NSBundle mainBundle] pathForResource:[databaseName stringByDeletingPathExtension] ofType:[databaseName pathExtension]];
	
	// The supposed database path
	NSString* databasePathInDocuments = [[FileManager sharedInstance] filePathInDocuments:databaseName];
	
	// Check if the database is already in the documents directory
	BOOL dbExists = [[NSFileManager defaultManager] fileExistsAtPath:databasePathInDocuments];
	
	// Copy it if necessary
	if ((dbExists == NO) || ((dbExists == YES) && (overwrite == YES))) {
		// Try to delete the file if it already exists
		if (dbExists == YES) {
			NSError* deleteError;
			[[NSFileManager defaultManager] removeItemAtPath:databasePathInDocuments error:&deleteError];
		}
		
		NSError* copyError;
		BOOL copied = [[NSFileManager defaultManager] copyItemAtPath:databasePathInBundle toPath:databasePathInDocuments error:&copyError];
		if (copied == YES) {
			return 0;
		}
		else {
			return -1;
		}
	}
	
	return 1;
}

#pragma mark -
#pragma mark Connection Methods

// This method tries to open a database connection to the given database name (from app documents)
- (FMDatabase*) openDBConnection:(NSString*)databaseName timeout:(int)timeout {
	// Get the database path in documents
	NSString* databasePath = [[FileManager sharedInstance] filePathInDocuments:databaseName];

    // Check if database exists and try to open a connection
	FMDatabase* database = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        database = [FMDatabase databaseWithPath:databasePath];
    }
    else {
        return nil;
    }
    
	if (![database open]) {
		return nil;
	}
	
    [database setBusyRetryTimeout:timeout];
    
	return database;
}

// This method tried to close the given database connection
- (void) closeDBConnection:(FMDatabase*)connection {
    [connection close];
}

#pragma mark -
#pragma mark SQL Methods

- (NSString*) buildQueryToTable:(NSString*)tableName usingCriteria:(NSDictionary*)criteria sortCriteria:(NSDictionary*)sortCriteria {
    // Build the query
    NSMutableString* query = [NSMutableString stringWithFormat:@"SELECT * FROM %@", tableName];
    
    if (criteria != nil) {
        // Add the WHERE part
        [query appendString:@" WHERE "];
        
        // Add the arguments to the query
        NSArray* keys = [criteria allKeys];
        for (int i = 0; i < keys.count; i++) {
            NSString* name = [keys objectAtIndex:i];
            NSString* value = [criteria objectForKey:name];
            [query appendFormat:@"[%@]=%@", name, value];
            
            if (i != keys.count - 1) {
                [query appendString:@" AND "];
            }
        }
    }
    
    if (sortCriteria != nil) {
        // Add the SORT part
        [query appendString:@" ORDER BY "];
        
        // Add the sort fields to the query
        NSArray* keys = [sortCriteria allKeys];
        for (int i = 0; i < keys.count; i++) {
            NSString* name = [keys objectAtIndex:i];
            NSString* value = [sortCriteria objectForKey:name];
            [query appendFormat:@"[%@] %@", name, value];
            
            if (i != keys.count - 1) {
                [query appendString:@" , "];
            }
        }
    }
    
    return query;
}

@end
