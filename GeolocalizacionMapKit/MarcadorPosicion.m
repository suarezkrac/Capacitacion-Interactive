//
//  MarcadorPosicion.m
//  GeolocalizacionMapKit
//
//  Created by Equipo Desarrollo 2 on 23/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "MarcadorPosicion.h"

@implementation MarcadorPosicion

@synthesize coordenada;

-(CLLocationCoordinate2D)coordinate{
    return coordenada;
}

-(NSString *)title{
    return @"Aqui estamos";
}

-(NSString *)subtitle{
    return @"Posicion encontrada";
}

@end
