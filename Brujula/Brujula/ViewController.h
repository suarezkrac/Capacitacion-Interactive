//
//  ViewController.h
//  Brujula
//
//  Created by Equipo Desarrollo 2 on 5/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager * locationManager;
    IBOutlet UIImageView *compassImage;
}
@property (nonatomic, retain) CLLocationManager * locationManager;


@end
