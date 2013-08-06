//
//  ViewController.h
//  Camara
//
//  Created by Equipo Desarrollo 2 on 5/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;

@end
