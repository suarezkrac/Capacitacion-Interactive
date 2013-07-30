//
//  ViewController.h
//  Animaciones
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *caja;

- (IBAction)animar:(id)sender;
- (IBAction)animarDoble:(id)sender;
- (IBAction)animarConOpciones:(id)sender;

@end
