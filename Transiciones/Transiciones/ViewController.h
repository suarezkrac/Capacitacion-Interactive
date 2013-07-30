//
//  ViewController.h
//  Transiciones
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *vista1;
@property (strong, nonatomic) IBOutlet UIView *vista2;

@property (strong, nonatomic) IBOutlet UILabel *titulo;

- (IBAction)girar:(id)sender;
- (IBAction)cambiar:(id)sender;

@end
