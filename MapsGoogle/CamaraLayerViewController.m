//
//  CamaraLayerViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 27/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "CamaraLayerViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CamaraLayerViewController ()

@end

@implementation CamaraLayerViewController{
    GMSMapView *map_view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:-37.81696 longitude:144.966085 zoom:4];
    map_view = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    self.view = map_view;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        map_view.myLocationEnabled = YES;
    });
    
    UIBarButtonItem * miUbicacion = [[UIBarButtonItem alloc] initWithTitle:@"Ubicar"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(animarUbicacion)];
    self.navigationItem.rightBarButtonItem = miUbicacion;
 
    
}
-(void)animarUbicacion{
    CLLocation * ubicacion = map_view.myLocation;
    
    if(!ubicacion || !CLLocationCoordinate2DIsValid(ubicacion.coordinate)){
        return;
    }
    
    CAMediaTimingFunction * curve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation * animacion;
    
    animacion = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraLongitudeKey];
    animacion.duration = 2.0;
    animacion.timingFunction = curve;
    animacion.toValue = @(ubicacion.coordinate.longitude);
    
    [map_view.layer addAnimation:animacion forKey:kGMSLayerCameraLongitudeKey];
    

    animacion = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraLatitudeKey];
    animacion.duration = 2.0;
    animacion.timingFunction = curve;
    animacion.toValue = @(ubicacion.coordinate.latitude);
    
    [map_view.layer addAnimation:animacion forKey:kGMSLayerCameraLatitudeKey];
    
    
    animacion = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraBearingKey];
    animacion.duration = 2.0;
    animacion.timingFunction = curve;
    animacion.toValue = @(0.0);
    
    [map_view.layer addAnimation:animacion forKey:kGMSLayerCameraBearingKey];
    
    CGFloat zoom = map_view.camera.zoom;
    
    NSArray *keyValues = @[@(zoom), @(-100.0), @(zoom)];
    
    CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:kGMSLayerCameraZoomLevelKey];
    keyAnimation.duration = 2.0;
    keyAnimation.values = keyValues;
    
    [map_view.layer addAnimation:keyAnimation forKey:kGMSLayerCameraZoomLevelKey];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
