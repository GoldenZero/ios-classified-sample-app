//
//  BaseDatabaseManager.m
//  ClassifiedAds
//
//  Created by Aubada Taljo on 9/28/12.
//  Copyright (c) 2012 SyriSoft. All rights reserved.
//

#import "BaseDatabaseManager.h"

#import "DBManager.h"
#import "FMDatabase.h"

#pragma mark -
#pragma mark Private

@implementation BaseDatabaseManager

- (id) initWithDatabaseName:(NSString*)database TableName:(NSString*)table {
    if (self = [self init]) {
        self.tableName = table;
        self.databaseName = database;
        
        timeout = 2;
    }
    
    return self;
}

#pragma mark -
#pragma mark Methods

- (FMResultSet*) query:(NSString*)query {
    // Try to open a connection to the database
    FMDatabase* connection = [[DBManager sharedInstance] openDBConnection:self.databaseName timeout:timeout];
    if (connection == nil) {
        [self.delegate manager:self connectionDidFailWithError:[NSError errorWithDomain:@"DatabaseError"
                                                                                   code:-1
                                                                               userInfo:nil]];
        return nil;
    }
    
    // Execute the query on the database
    FMResultSet* result = [connection executeQuery:query];
    
    // Close the database
    //[connection close];
    
    return result;
}

- (FMResultSet*) queryTable:(NSString*)table withCriteria:(NSDictionary*)criteria sortCriteria:(NSDictionary*)sortCriteria {
    if (table == nil) {
        table = self.tableName;
    }

    // Build the query
    NSString* query = [[DBManager sharedInstance] buildQueryToTable:table usingCriteria:criteria sortCriteria:sortCriteria];

    // Try to execute it
    return [self query:query];
}

- (int) executeNoneQuerySQL:(NSString*)sql {
    // Try to open a connection to the database
    FMDatabase* connection = [[DBManager sharedInstance] openDBConnection:self.databaseName timeout:timeout];
    if (connection == nil) {
        [self.delegate manager:self connectionDidFailWithError:[NSError errorWithDomain:@"DatabaseError"
                                                                                   code:-1
                                                                               userInfo:nil]];
        return -1;
    }

    return [connection executeUpdate:sql];
}

@end
