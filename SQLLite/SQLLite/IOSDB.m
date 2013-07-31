//
//  IOSDB.m
//  SQLLite
//
//  Created by Equipo Desarrollo 2 on 30/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "IOSDB.h"




@implementation IOSDB
-(IOSDB *) initWithDBFilename : (NSString *) fn{

}
-(IOSDB *) initWithDBFilename:(NSString *)fn andTableName: (NSString *) tn{

}
-(void) openBD{

}
-(void) closeBD{

}
-(void) dealloc{

}

-(NSNumber *) insertRow:(NSDictionary *) record{
    int dictSize = [record count];
    
    NSMutableData *dKeys = [NSMutableData dataWithLength: sizeof(id) * dictSize ];
    NSMutableData *dValues = [NSMutableData dataWithLength: sizeof(id) * dictSize ];
    
    [record getObjects:(__unsafe_unretained id *)dValues.mutableBytes andKeys:(__unsafe_unretained id *)dKeys.mutableBytes];
    
    //Construir Query
    NSMutableArray * placeHoldersArray = [NSMutableArray arrayWithCapacity:dictSize];
    for (int i = 0; i<dictSize; i++) {
        [placeHoldersArray addObject:@"?"];
    }
    
    NSString * query = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName,[[record allKeys]componentsJoinedByString:@","], [placeHoldersArray componentsJoinedByString:@","]];
    [self bindSQL:[query UTF8String] withVargs:(va_list)dValues.mutableBytes];
    sqlite3_step(statement);
    if (sqlite3_finalize(statement)== SQLITE_OK) {
        return [self lastInsertId];
    }else{
        NSLog(@" SQL LITE FALLO POR : %s", sqlite3_errmsg(database));
        return 0;
    }  

}
-(void) updateRow:(NSDictionary *) record: (NSNumber *) rowID{

}
-(void) deleteRow:(NSNumber *) rowID{

}
-(NSDictionary *) getRow:(NSNumber *) rowID{

}
-(NSNumber *)countRows{

}

@end
