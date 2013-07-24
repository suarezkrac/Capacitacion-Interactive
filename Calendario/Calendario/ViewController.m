//
//  ViewController.m
//  Calendario
//
//  Created by Equipo Desarrollo 2 on 22/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"

#import "ModelController.h"

#import "DataViewController.h"

@interface ViewController ()
@property (readonly, strong, nonatomic) ModelController * modelController;

@end

@implementation ViewController

@synthesize pageViewController=_pageViewController;
@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationVertical
                                                                            options:nil];
    self.pageViewController.delegate = self;
    
    DataViewController * startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    
    NSArray * viewControllers = [NSArray arrayWithObject:startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:NULL];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    
    [self.view addSubview:self.pageViewController.view];
    
    CGRect pageViewRect = self.view.bounds;
    
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(ModelController *)modelController{
    if(!_modelController){
        _modelController = [[ModelController alloc] init];
    }
    
    return _modelController;
}

-(UIPageViewControllerSpineLocation) pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    
    UIViewController * currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    
    NSArray * viewControllers = [NSArray arrayWithObject:currentViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:NULL];

    self.pageViewController.doubleSided = NO;
    
    return UIPageViewControllerSpineLocationMin;

}



@end
