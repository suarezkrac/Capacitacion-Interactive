//
//  MapTypesViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 27/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "MapTypesViewController.h"
#import <GoogleMaps/GoogleMaps.h>

static NSString const * kNormalType = @"Normal";
static NSString const * kSatelliteType = @"Satellite";
static NSString const * kHybridType = @"Hybrid";
static NSString const * kTerrainType = @"Terain";

@interface MapTypesViewController ()
   
    
@end

@implementation MapTypesViewController{
    UISegmentedControl *switcher_;
    GMSMapView *mapView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:-33.868 longitude:151.2086 zoom:12];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //Trafico
    mapView_.trafficEnabled = YES;
    
    self.view = mapView_;
    
    NSArray * types = @[kNormalType, kSatelliteType, kHybridType, kTerrainType];
    
    switcher_ = [[UISegmentedControl alloc]initWithItems:types];
    switcher_.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    switcher_.selectedSegmentIndex = 0;
    switcher_.segmentedControlStyle = UISegmentedControlStyleBar;
    
    self.navigationItem.titleView = switcher_;
    
    [switcher_ addTarget:self
                  action:@selector(didChangeSwitcher)
        forControlEvents:UIControlEventValueChanged];
}

-(void)didChangeSwitcher{
    NSString * titulo = [switcher_ titleForSegmentAtIndex:switcher_.selectedSegmentIndex];
    
    if([kNormalType isEqualToString:titulo]){
        mapView_.mapType = kGMSTypeNormal;
    } else if([kSatelliteType isEqualToString:titulo]){
        mapView_.mapType = kGMSTypeSatellite;
    } else if ([kHybridType isEqualToString:titulo]){
        mapView_.mapType = kGMSTypeHybrid;
    }else if ([kTerrainType isEqualToString:titulo]){
        mapView_.mapType = kGMSTypeTerrain;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
