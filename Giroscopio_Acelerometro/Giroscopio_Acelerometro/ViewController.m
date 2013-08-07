//
//  ViewController.m
//  Giroscopio_Acelerometro
//
//  Created by Equipo Desarrollo 2 on 6/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self outputAcelerationData: accelerometerData.acceleration];
                                                 if(error)
                                                 {
                                                     NSLog(@"%@", error);
                                                 }
                                            }];
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                        if(error)
                                        {
                                            NSLog(@"%@", error);
                                        }
                                    }];
    
}

-(void)outputAcelerationData:(CMAcceleration)acceleration{
    self.accX.text = [NSString stringWithFormat:@" %.2f", acceleration.x];
    self.accY.text = [NSString stringWithFormat:@" %.2f", acceleration.y];
    self.accZ.text = [NSString stringWithFormat:@" %.2f", acceleration.z];
    
    if (fabs(acceleration.x) > fabs(currentMaxAccelX)) {
        currentMaxAccelX = acceleration.x;
    }
    if (fabs(acceleration.y) > fabs(currentMaxAccelY)) {
        currentMaxAccelY = acceleration.y;
    }
    if (fabs(acceleration.z) > fabs(currentMaxAccelZ)) {
        currentMaxAccelZ = acceleration.z;
    }
    
    self.maxAccX.text = [NSString stringWithFormat:@" %.2f", currentMaxAccelX];
    self.maxAccY.text = [NSString stringWithFormat:@" %.2f", currentMaxAccelY];
    self.maxAccZ.text = [NSString stringWithFormat:@" %.2f", currentMaxAccelZ];

}

-(void)outputRotationData:(CMRotationRate)rotation{
    self.rotX.text = [NSString stringWithFormat:@" %.2f", rotation.x];
    self.rotY.text = [NSString stringWithFormat:@" %.2f", rotation.y];
    self.rotZ.text = [NSString stringWithFormat:@" %.2f", rotation.z];
    
    if (fabs(rotation.x) > fabs(currentMaxRotX)) {
        currentMaxRotX = rotation.x;
    }
    if (fabs(rotation.y) > fabs(currentMaxRotY)) {
        currentMaxRotY = rotation.y;
    }
    if (fabs(rotation.z) > fabs(currentMaxRotZ)) {
        currentMaxRotZ = rotation.z;
    }
    
    self.maxRotX.text = [NSString stringWithFormat:@" %.2f", currentMaxRotX];
    self.maxRotY.text = [NSString stringWithFormat:@" %.2f", currentMaxRotY];
    self.maxRotZ.text = [NSString stringWithFormat:@" %.2f", currentMaxRotZ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetMaxValues:(id)sender {
    
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
}
@end
