//
//  CustomMarkViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 27/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "CustomMarkViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomMarkViewController ()

@end

@implementation CustomMarkViewController{
    GMSMapView *map_view;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:4.598056 longitude:-74.075833 zoom:3];
    
    map_view = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self addDefaulMarkers];
    
    self.view = map_view;
}

-(void)addDefaulMarkers{
    GMSMarker *bogotacustom = [[GMSMarker alloc]init];
    bogotacustom.title = @"Aqui es Bogota!";
    bogotacustom.icon = [UIImage imageNamed:@"arrow"];
    bogotacustom.position = CLLocationCoordinate2DMake(4.598056,-74.075833);
    bogotacustom.map = map_view;
    
    
}
-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
