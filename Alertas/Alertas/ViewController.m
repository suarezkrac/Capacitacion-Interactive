//
//  ViewController.m
//  Alertas
//
//  Created by Equipo Desarrollo 2 on 22/07/13.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AlertaSimple:(id)sender {
    UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Alerta Simple"
                                                      message:@"Esta es una alerta"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancelar"
                                            otherButtonTitles: nil];
    
    alerta.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alerta show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"El texto ingresado es : %@",[alertView textFieldAtIndex:0].text);
    }

}

- (IBAction)AlertaSheet:(id)sender {
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"Action" delegate:self cancelButtonTitle:@"Aceptar" destructiveButtonTitle:@"Borrar" otherButtonTitles:@"Boton1", nil];
    
    [action showInView:self.view];
    
}
@end
