//
//  Camara3DViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "Camara3DViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface Camara3DViewController ()
    
@end

@implementation Camara3DViewController{
    GMSMapView *mapView_;
    GMSGeocoder * geocoder_;
    NSTimer * timer;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:-37.809487 longitude:144.965699 zoom:20 bearing:0 viewingAngle:0];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.zoomGestures = NO;
    mapView_.settings.scrollGestures = NO;
    mapView_.settings.rotateGestures = NO;
    
    self.view = mapView_;
}

-(void)moveCamera{
    GMSCameraPosition * camera = mapView_.camera;
    
    float zoom = fmax(camera.zoom - 0.1, 17.5);
    
    GMSCameraPosition *newCamera = [[GMSCameraPosition alloc] initWithTarget:camera.target zoom:zoom bearing:camera.bearing+10 viewingAngle:camera.viewingAngle + 10];
    
    [mapView_ animateToCameraPosition:newCamera];
    
}

-(void)viewDidAppear:(BOOL)animated{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(moveCamera)
                                           userInfo:nil
                                            repeats:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
