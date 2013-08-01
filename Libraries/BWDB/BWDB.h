//  BWDB.h
//  updated for ARC by Bill Weinman on 2012-08-10.
//  Copyright (c) 2010-2012 Bill Weinman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

static NSString * const kBWDBVersion = @"1.1.3";

@interface BWDB : NSObject {
	sqlite3 *database;
    sqlite3_stmt *statement;
    NSString *tableName;
    NSString *databaseFileName;
    NSFileManager *filemanager;

    // for "fast enumeration" (iterator/generator pattern)
    __unsafe_unretained NSDictionary * enumRows[1]; // enumerated (iterator) object(s) are passed in a C array
                                // we only ever pass one at a time
}

// object management
- (BWDB *) initWithDBFilename: (NSString *) fn;
- (BWDB *) initWithDBFilename: (NSString *) fn andTableName: (NSString *) tn;
- (void) openDB;
- (void) closeDB;
- (void) dealloc;
- (NSString *) getVersion;
- (NSString *) getDBPath;

// Fast enumeration (iteration) support
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len;

// SQL queries
- (NSNumber *) doQuery:(NSString *) query, ...;
- (BWDB *) getQuery:(NSString *) query, ...;
- (void) prepareQuery:(NSString *) query, ...;
- (id) valueFromQuery:(NSString *) query, ...;

// Raw results
- (void) bindSQL:(const char *) cQuery withVargs:(va_list)vargs;
- (NSDictionary *) getPreparedRow;
- (id) getPreparedValue;

// CRUD methods
- (NSNumber *) insertRow:(NSDictionary *) record;
- (void) updateRow:(NSDictionary *) record: (NSNumber *) rowID;
- (void) deleteRow:(NSNumber *) rowID;
- (NSDictionary *) getRow: (NSNumber *) rowID;
- (NSNumber *) countRows;

// Subscripting methods
- (NSDictionary *) objectForKeyedSubscript: (NSNumber *) rowID;
- (void) setObject:(NSDictionary *) record forKeyedSubscript: (NSNumber *) rowID;

// Utilities
- (id) columnValue:(int) columnIndex;
- (NSNumber *) lastInsertId;

@end
