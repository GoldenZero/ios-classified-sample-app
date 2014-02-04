//
//  FileManager.m
//  AubadaLibrary
//
//  Created by Aubada Taljo on 8/9/12.
//  Copyright (c) 2012 aubada.com. All rights reserved.
//

#import "FileManager.h"

#include <sys/xattr.h>

@implementation FileManager

+ (FileManager*) sharedInstance {
	static FileManager* instance = nil;
	if (instance == nil) {
		instance = [[FileManager alloc] init];
	}
	
	return instance;
}

/*
 * This method returns the documents path for this application (with / at the end)
 */
- (NSString*) documentsPath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Build the documents path with /
	NSString* documentsPath = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]];
	
	return documentsPath;
}

// This method returns the path of the given file name in documents
- (NSString*) filePathInDocuments:(NSString*)fileName {
    NSString* documentsPath = [self documentsPath];
    return [documentsPath stringByAppendingString:fileName];
}

// This method returns the path of the given file name in temp directory
- (NSString*) filePathInTemp:(NSString*)fileName {
    NSString* tempDirectory = NSTemporaryDirectory();
    return [tempDirectory stringByAppendingPathComponent:fileName];
}

/*
 * This method returns the caches folder path for this application (with / at the end)
 */
- (NSString*) cachesPath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	
	NSString* cachesPath = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]];
	
	return cachesPath;
}

/*
 * This method checks if the given file exists
 */
- (BOOL) fileExits:(NSString*)path {
	BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path];
	return result;
}

-(void) deleteFilesInPath: (NSString*)path {
    NSArray* directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (int i = 0; i < [directoryContent count]; i++) {
        NSString* filePath = [path stringByAppendingPathComponent:[directoryContent objectAtIndex:i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        }
    }
}

-(void) deleteFile: (NSString*)path {
    if ( ([self fileExits:path]) && ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO]) ) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
}

- (void) createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates {
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:createIntermediates
                                               attributes:nil
                                                    error:nil];
}

/*
 * This method marks the file as non-purgeable and non-backed up
 */
- (void) addSkipBackupAttributeToFile:(NSString *)filePath {
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	
	u_int8_t attributeValue = 1;
	setxattr([[fileURL path] fileSystemRepresentation], "com.apple.MobileBackup", &attributeValue, 1, 0, 0);
}

@end
