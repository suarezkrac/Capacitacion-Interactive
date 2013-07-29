//
//  GestosViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 27/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "GestosViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GestosViewController ()

@end

@implementation GestosViewController{
    GMSMapView * mapView_;
    UISwitch * gestoSwitch_;
    UISwitch * gestoSwitch2_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:4.598056 longitude:-74.075833 zoom:3];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mapView_];
    
    UIView * holder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 95)];
    holder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    holder.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    [self.view addSubview:holder];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 200, 20)];
    label.text = @"Habilitar Zoom";
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    
    label.layer.shadowColor = [[UIColor whiteColor] CGColor];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 56, 200, 20)];
    label2.text = @"Habilitar Rotar";
    label2.font = [UIFont boldSystemFontOfSize:18.0f];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    
    label2.layer.shadowColor = [[UIColor whiteColor] CGColor];
    
    
    [holder addSubview:label];
    [holder addSubview:label2];

    
    gestoSwitch_ = [[UISwitch alloc] initWithFrame:CGRectMake(-90, 16, 0, 0)];
    gestoSwitch_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    gestoSwitch_.on = YES;
    [gestoSwitch_ addTarget:self action:@selector(cambioSwitch) forControlEvents:UIControlEventValueChanged];
    
    
    gestoSwitch2_ = [[UISwitch alloc] initWithFrame:CGRectMake(-90, 56, 0, 0)];
    gestoSwitch2_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    gestoSwitch2_.on = YES;
    [gestoSwitch2_ addTarget:self action:@selector(cambioSwitch2) forControlEvents:UIControlEventValueChanged];
    
    
    [holder addSubview:gestoSwitch_];
    [holder addSubview:gestoSwitch2_];
    
}

-(void)cambioSwitch{
    mapView_.settings.zoomGestures = gestoSwitch_.isOn;

}
-(void)cambioSwitch2{
    mapView_.settings.rotateGestures = gestoSwitch2_.isOn;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
