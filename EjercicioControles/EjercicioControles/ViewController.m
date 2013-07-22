//
//  ViewController.m
//  EjercicioControles
//
//  Created by Equipo Desarrollo 2 on 17/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize output;
@synthesize caja;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)prendeApaga:(id)sender {
    UISwitch * swonoff = sender;
    
    if (swonoff.on) {
        caja.hidden = NO;
    }else{
        caja.hidden = YES;
    }
    
}
- (IBAction)cambioSlider:(id)sender {
    UISlider * slider = sender;
    output.text = [[NSString alloc] initWithFormat:@"Slider : %f", slider.value];
}

- (IBAction)cambioStepper:(id)sender {
    UIStepper * stepper = sender;
    output.text = [[NSString alloc] initWithFormat:@"Slider : %f", stepper.value];
}
@end
