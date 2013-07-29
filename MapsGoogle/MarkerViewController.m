//
//  MarkerViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 27/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "MarkerViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MarkerViewController ()

@end

@implementation MarkerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:4.598056 longitude:-74.075833 zoom:10];
    GMSMapView * mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMarker * bogota = [[GMSMarker alloc] init];
    bogota.title = @"BOGOTA";
    bogota.snippet = @"Capital Colombia";
    bogota.position = CLLocationCoordinate2DMake(4.598056, -74.075833);
    bogota.map = mapView;
    
    GMSMarker * sydney = [[GMSMarker alloc] init];
    sydney.title = @"Sydney";
    sydney.snippet = @"Capital Australia";
    sydney.position = CLLocationCoordinate2DMake(-33.868 , 151.2086);
    sydney.map = mapView;
    
    
    mapView.selectedMarker = bogota;
    
    self.view = mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
