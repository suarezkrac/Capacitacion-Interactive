//
//  IOSDB.h
//  SQLLite
//
//  Created by Equipo Desarrollo 2 on 30/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>



@interface IOSDB : NSObject{
    sqlite3 * database;
    sqlite3_stmt *statement;
    NSString *tableName;
    NSString *databaseFileName;
    NSFileManager *filemanager;
    
    __unsafe_unretained NSDictionary * enumRows[1]; 
    
}

//MANIPULACION OBJETO
-(IOSDB *) initWithDBFilename : (NSString *) fn;
-(IOSDB *) initWithDBFilename:(NSString *)fn andTableName: (NSString *) tn;
-(void) openBD;
-(void) closeBD;
-(void) dealloc;
-(NSString *) getVersion;
-(NSString *) getDBPath;

//ENUMERACION O ITERACIONES
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len;

//QUERIES SQL
-(NSNumber *) doQuery:(NSString *)query, ...;
-(IOSDB *) getQuery:(NSString *)query, ...;
-(void) prepareQuery:(NSString *)query, ...;
-(id) valueFromQuery:(NSString *)query, ...;

//RESULTS
-(void) bindSQL:(const char*) cQuery withVargs:(va_list)vargs;
-(NSDictionary *) getPrepareRow;
-(id) getPreparedValue;

//METODOS CRUD
-(NSNumber *) insertRow:(NSDictionary *) record;
-(void) updateRow:(NSDictionary *) record: (NSNumber *) rowID;
-(void) deleteRow:(NSNumber *) rowID;
-(NSDictionary *) getRow:(NSNumber *) rowID;
-(NSNumber *)countRows;

//METODOS ADICIONALES
-(NSDictionary *) objectForKeyedSubscript: (NSNumber *) rowID;
-(void) setObject: (NSDictionary *) record ForKeyedSubscript: (NSNumber *) rowID;

//UTILIDES
-(id) columnValue:(int) columnIndex;
-(NSNumber *) lastInsertId;

@end
