//
//  AppDelegate.h
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 23/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController * navigationController;

@property (strong, nonatomic) UISplitViewController * splitViewController;

@property (strong, nonatomic) UIViewController *sample;


@end
