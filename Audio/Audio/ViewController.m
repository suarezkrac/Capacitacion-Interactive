//
//  ViewController.m
//  Audio
//
//  Created by Equipo Desarrollo 2 on 17/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize etiqueta;
@synthesize reproductor;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSError * error;
    NSString * ruta = [[NSBundle mainBundle] pathForResource:@"musica" ofType:@"mp3"];
    NSURL * url = [[NSURL alloc] initFileURLWithPath:ruta];
    
    self.reproductor = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.reproductor.pan = 0.5;
    self.reproductor.enableRate = YES;
    self.reproductor.rate = 1;
    self.reproductor.numberOfLoops = -1;
    self.reproductor.volume = 1;
    self.reproductor.delegate = self;
    
    [self.reproductor prepareToPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    [self.reproductor play];
}

- (IBAction)pausa:(id)sender {
    [self.reproductor pause];
    etiqueta.text = [[NSString alloc] initWithFormat:@"Duracion : %f, currentTime : %f", self.reproductor.duration, self.reproductor.currentTime ];
}

- (IBAction)stop:(id)sender {
    [self.reproductor stop];
}

- (IBAction)cambioVolumen:(id)sender {
    self.reproductor.volume = ((UISlider *) sender).value;
    
    /*UISlider * vol = sender;
     self.reproductor.volume = vol.value;*/
}

- (IBAction)cambioVelocidad:(id)sender {
}
@end
