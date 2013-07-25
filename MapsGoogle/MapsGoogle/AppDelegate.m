//
//  AppDelegate.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 23/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [GMSServices provideAPIKey:@"AIzaSyCciPR0yTO-0v-AUyF5qxKNp3hNCUGRCIk"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewController *master = [[ViewController alloc] init];
    master.appDelegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        self.navigationController =
        [[UINavigationController alloc] initWithRootViewController:master];
        self.window.rootViewController = self.navigationController;
    } else {
        
        UINavigationController *masterNavigationController =
        [[UINavigationController alloc] initWithRootViewController:master];
        
        UIViewController *empty = [[UIViewController alloc] init];
        UINavigationController *detailNavigationController =
        [[UINavigationController alloc] initWithRootViewController:empty];
        
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = master;
        self.splitViewController.viewControllers =
        @[masterNavigationController, detailNavigationController];
        self.splitViewController.presentsWithGesture = NO;
        
        self.window.rootViewController = self.splitViewController;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)setSample: (UIViewController *)sample{
    
    UINavigationController *nav = [self.splitViewController.viewControllers objectAtIndex:1];
    [nav setViewControllers:[NSArray arrayWithObject:sample] animated:NO];
}

-(UIViewController *)sample{

    UINavigationController *nav = [self.splitViewController.viewControllers objectAtIndex:1];
    return [[nav viewControllers] objectAtIndex:0];
}

@end
