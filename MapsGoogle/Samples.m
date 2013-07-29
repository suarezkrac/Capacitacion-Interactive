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
#import "MapTypesViewController.h"
#import "GestosViewController.h"

//Import Camera
#import "CamaraLayerViewController.h"

//Import Marker
#import "MarkerViewController.h"
#import "CustomMarkViewController.h"

//Import Street
#import "StreetViewController.h"

@implementation Samples

+(NSArray *)loadSections{
    return @[@"Mapas", @"Camara", @"Marcadores", @"Street View"];

}

+(NSArray *)loadDemos{
    NSArray *mapDemos = @[[self newDemo:[BasicMapViewController class]
                              withTitle:@"Mapa Basico"
                         andDescription:nil],
                          [self newDemo:[MyLocationViewController class]
                              withTitle:@"Mi Ubicación"
                         andDescription:nil],
                          [self newDemo:[MapTypesViewController class]
                              withTitle:@"Tipos de Mapa"
                         andDescription:nil],
                          [self newDemo:[GestosViewController class]
                              withTitle:@"Control de Gestos"
                         andDescription:nil]];
    
    NSArray *cameraDemos = @[[self newDemo:[CamaraLayerViewController class]
                                 withTitle:@"Movimiento Camara"
                            andDescription:nil]];
    
    NSArray *markers = @[[self newDemo:[MarkerViewController class]
                                 withTitle:@"Marcador"
                            andDescription:nil],
                         [self newDemo:[CustomMarkViewController class]
                             withTitle:@"Marcadores Custom"
                        andDescription:nil]];
    
    NSArray *streetview = @[[self newDemo:[StreetViewController class]
                              withTitle:@"Street"
                         andDescription:nil]];
 
    return @[mapDemos, cameraDemos, markers, streetview];
    
}

+ (NSDictionary *)newDemo:(Class) class
                withTitle:(NSString *)title
           andDescription:(NSString *)description {
    return [[NSDictionary alloc] initWithObjectsAndKeys:class, @"controller",
            title, @"title", description, @"description", nil];
}
@end
