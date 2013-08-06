//
//  ViewController.m
//  Camara
//
//  Created by Equipo Desarrollo 2 on 5/08/13.
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
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Dispositivo no encontro camara" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    

    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imageView.image = chosenImage;
    
    UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];

}
@end
