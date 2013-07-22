//
//  ViewController.h
//  EjercicioControles
//
//  Created by Equipo Desarrollo 2 on 17/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)prendeApaga:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *caja;

@property (strong, nonatomic) IBOutlet UILabel *output;

- (IBAction)cambioSlider:(id)sender;

- (IBAction)cambioStepper:(id)sender;

@end
