//
//  FileManager.h
//  AubadaLibrary
//
//  Created by Aubada Taljo on 8/9/12.
//  Copyright (c) 2012 aubada.com. All rights reserved.
//

@interface FileManager : NSObject 

// Singelton method
+ (FileManager*) sharedInstance;

/*
 * This method returns the documents path for this application
 */
- (NSString*) documentsPath;

// This method returns the path of the given file name in documents directory
- (NSString*) filePathInDocuments:(NSString*)fileName;

// This method returns the path of the given file name in temp directory
- (NSString*) filePathInTemp:(NSString*)fileName;

/*
 * This method returns the caches folder path for this application
 */
- (NSString*) cachesPath;

/*
 * This method checks if the given file exists
 */
- (BOOL) fileExits:(NSString*)path;

/*
 * This method deletes all files in the given path
 */
-(void) deleteFilesInPath: (NSString*)path;

/*
 * This method deletes the file in the given path
 */
-(void) deleteFile: (NSString*)path;

/*
 * This method creates the directory in the given path
 */
- (void) createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates;

/*
 * This method marks the file as non-purgeable and non-backed up
 */
- (void) addSkipBackupAttributeToFile:(NSString *)filePath;

@end
