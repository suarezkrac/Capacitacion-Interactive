//
//  Samples.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 24/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "Samples.h"

//Import Map
#import "BasicMapViewController.h"
#import "MyLocationViewController.h"

//Import Camera

//Import Services

@implementation Samples

+(NSArray *)loadSections{
//    return @[@"Map", @"Camera", @"Services"];
    return @[@"Mapas"];

}

+(NSArray *)loadDemos{
    NSArray *mapDemos = @[[self newDemo:[BasicMapViewController class]
                              withTitle:@"Mapa Basico"
                         andDescription:nil],
                          [self newDemo:[MyLocationViewController class]
                              withTitle:@"Mi Ubicación"
                         andDescription:nil]];
    
  //  NSArray *cameraDemos = nil;
  //  NSArray *servicesDemos = nil;
    
  //  return @[mapDemos, cameraDemos, servicesDemos];
    
    return @[mapDemos];
}

+ (NSDictionary *)newDemo:(Class) class
                withTitle:(NSString *)title
           andDescription:(NSString *)description {
    return [[NSDictionary alloc] initWithObjectsAndKeys:class, @"controller",
            title, @"title", description, @"description", nil];
}
@end
