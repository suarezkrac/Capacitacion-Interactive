//
//  ViewController.m
//  MultiLenguaje
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
    self.etiqueta.text = NSLocalizedString(@"Label", nil);
    [self.boton setTitle: NSLocalizedString(@"Button", nil) forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
