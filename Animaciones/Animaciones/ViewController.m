//
//  ViewController.m
//  Animaciones
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
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

- (IBAction)animar:(id)sender {
    [UIView animateWithDuration:2 animations:^{
        caja.frame = CGRectMake(200, caja.frame.origin.y, 50, 50);
        caja.alpha = 0.5;
        
        self.view.backgroundColor = [UIColor blueColor];
        
    }];
}

- (IBAction)animarDoble:(id)sender {
    
    [UIView animateWithDuration:2 animations:^{
        caja.frame = CGRectMake(0, 0, 100, 100);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            caja.alpha = 0;
        }];
    }];
}

- (IBAction)animarConOpciones:(id)sender {
    [UIView animateWithDuration:0.5f delay:2 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        caja.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}
@end
