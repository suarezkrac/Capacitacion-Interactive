//
//  ViewController.h
//  Audio
//
//  Created by Equipo Desarrollo 2 on 17/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>

- (IBAction)play:(id)sender;
- (IBAction)pausa:(id)sender;
- (IBAction)stop:(id)sender;

- (IBAction)cambioVolumen:(id)sender;
- (IBAction)cambioVelocidad:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *etiqueta;
@property (strong, nonatomic) AVAudioPlayer * reproductor;


@end
