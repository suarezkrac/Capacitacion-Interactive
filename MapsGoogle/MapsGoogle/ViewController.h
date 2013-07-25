//
//  ViewController.h
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 23/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface ViewController : UITableViewController <UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AppDelegate * appDelegate;

@end
