//
//  ViewController.m
//  Transiciones
//
//  Created by Equipo Desarrollo 2 on 29/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize vista1, vista2, titulo;

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

- (IBAction)girar:(id)sender {
    
    [UIView transitionWithView:vista1 duration:2 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        titulo.textColor = [UIColor yellowColor];
        titulo.text = @"Lado Dos";
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)cambiar:(id)sender {
    vista2.frame = vista1.frame;
    
    [UIView transitionFromView:vista1 toView:vista2 duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
    }];
}
@end
