//
//  ViewController.h
//  Alertas
//
//  Created by Equipo Desarrollo 2 on 22/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate>

- (IBAction)AlertaSimple:(id)sender;

- (IBAction)AlertaSheet:(id)sender;

@end
