//
//  ViewController.h
//  Selector
//
//  Created by Equipo Desarrollo 2 on 17/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray * paises;

@end

