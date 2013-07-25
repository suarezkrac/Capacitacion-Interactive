//
//  BasicMapViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 24/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "BasicMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation BasicMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    GMSCameraPosition * camara = [GMSCameraPosition cameraWithLatitude:-33.868 longitude:151.2086 zoom:13];
    
    self.view = [GMSMapView mapWithFrame:CGRectZero camera:camara];
}

@end
