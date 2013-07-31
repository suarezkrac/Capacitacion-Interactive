//
//  AgregarViewController.h
//  Datos
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgregarViewController :  UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtNombre;
@property (strong, nonatomic) IBOutlet UISwitch *swDebe;
- (IBAction)guardar:(id)sender;
- (IBAction)cancelar:(id)sender;

@end