//
//  ViewController.m
//  Selector
//
//  Created by MacBook on 3/09/12.
//  Copyright (c) 2012 MacBook. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize paises;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSBundle * paquete =[NSBundle mainBundle];
    
    NSString * ruta= [paquete pathForResource:@"paises" ofType:@"plist"];
    self.paises = [[NSArray alloc] initWithContentsOfFile:ruta ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.paises count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.paises objectAtIndex:row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Seleccion Pais"
                                                      message:[self.paises objectAtIndex:row]
                                                     delegate:nil
                                            cancelButtonTitle:@"Aceptar"
                                            otherButtonTitles:@"OK", nil];
    [alerta show];
}


@end