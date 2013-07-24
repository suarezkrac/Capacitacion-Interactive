//
//  MarcadorPosicion.h
//  GeolocalizacionMapKit
//
//  Created by Equipo Desarrollo 2 on 23/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MarcadorPosicion : NSObject <MKAnnotation>

@property CLLocationCoordinate2D coordenada;

@end
