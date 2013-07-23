//
//  ViewController.m
//  Navegador
//
//  Created by Equipo Desarrollo 2 on 22/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize navegador;
@synthesize cargando;

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

- (IBAction)leerHTML:(id)sender {
    NSString * html = @"<h1>Esto es HTML</h1><p style='color:red;'>Esto es un <b>parrafo</b></p>";
    
    [navegador loadHTMLString:html baseURL:nil];
}

- (IBAction)leerJS:(id)sender {
    
    [navegador stringByEvaluatingJavaScriptFromString:@"alert('Hola')"];
}

- (IBAction)leerWeb:(id)sender {
    
    NSURL * url = [[NSURL alloc] initWithString:@"http://google.com"];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    navegador.delegate = self;
    [navegador loadRequest:request];
    
}

- (IBAction)leerPdf:(id)sender {
    NSString * ruta = [[NSBundle mainBundle] pathForResource:@"manual" ofType:@"pdf"];
    NSData * datosPDF = [[NSData alloc] initWithContentsOfFile:ruta];
    
    [navegador loadData:datosPDF MIMEType:@"application/pdf" textEncodingName:nil baseURL:nil];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [cargando startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [cargando stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [cargando stopAnimating];
}


@end
