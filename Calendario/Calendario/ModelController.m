//
//  ModelController.m
//  Calendario
//
//  Created by Equipo Desarrollo 2 on 22/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ModelController.h"

#import "DataViewController.h"

@interface ModelController()
@property (readonly, strong, nonatomic) NSArray * pageData;
@end

@implementation ModelController

@synthesize pageData = _pageData;

- (id)init{
    self = [super init];
    if(self){
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
    }
    return self;
}


-(DataViewController *) viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard{
    if(([self.pageData count] == 0) || (index >= [self.pageData count]))
    {
        return nil;
    }
    
    //Creamos un nuevo view controller para el storyboard
    
    DataViewController * dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    
    dataViewController.dataObject = [self.pageData objectAtIndex:index];
    
    return dataViewController;

}

-(NSUInteger)indexOfViewController:(DataViewController *)viewController{
    
    return [self.pageData indexOfObject:viewController.dataObject];

}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if((index == 0) || (index == NSNotFound)){
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
    

}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
   
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];

    if(index == NSNotFound){
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];

}
@end
