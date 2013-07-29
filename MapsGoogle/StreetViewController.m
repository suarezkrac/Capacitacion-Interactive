//
//  StreetViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 27/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "StreetViewController.h"
#import <GoogleMaps/GoogleMaps.h>

static CLLocationCoordinate2D kPanoramaNear = {40.761388, -73.978133};
static CLLocationCoordinate2D kMarkerAt = {40.761455, -73.977814};

@implementation StreetViewController{
    GMSPanoramaView *view_;
    BOOL configured_;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    view_ = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:kPanoramaNear];
    
    view_.backgroundColor = [UIColor grayColor];
    view_.delegate = self;

    self.view = view_;
}

-(void)panoramaView:(GMSPanoramaView *)panoramaView didMoveCamera:(GMSPanoramaCamera *)camera{
    NSLog(@"Camara: (%f, %f, %f)", camera.orientation.heading, camera.orientation.pitch, camera.zoom);
}

-(void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama{
    if(!configured_){
        GMSMarker *marcador = [GMSMarker markerWithPosition:kMarkerAt];
        marcador.panoramaView = view_;
        
        CLLocationDegrees heading = GMSGeometryHeading(kPanoramaNear, kMarkerAt);
        view_.camera = [GMSPanoramaCamera cameraWithHeading:heading pitch:0 zoom:1];
        configured_ = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
