//
//  Samples.h
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 24/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

@interface Samples : NSObject
+ (NSArray *)loadSections;
+ (NSArray *)loadDemos;
+ (NSDictionary *)newDemo:(Class) class
withTitle:(NSString *)title
andDescription:(NSString *)description;
@end