//
//  MyLocationViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 27/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "MyLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MyLocationViewController ()

@end

@implementation MyLocationViewController{
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868 longitude:151.2086 zoom:12];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.view = mapView_;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
}

-(void)dealloc{
    [mapView_ removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


#pragma mark - Metodos de Google

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(!firstLocationUpdate_){
        firstLocationUpdate_ = YES;
        CLLocation * location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:14];
        
    }
}

@end
