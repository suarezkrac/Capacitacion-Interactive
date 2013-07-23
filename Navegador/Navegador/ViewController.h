//
//  ViewController.h
//  Navegador
//
//  Created by Equipo Desarrollo 2 on 22/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *navegador;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *cargando;

- (IBAction)leerHTML:(id)sender;
- (IBAction)leerJS:(id)sender;
- (IBAction)leerWeb:(id)sender;
- (IBAction)leerPdf:(id)sender;

@end
