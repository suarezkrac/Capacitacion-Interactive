//
//  ModelController.h
//  Calendario
//
//  Created by Equipo Desarrollo 2 on 22/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

-(DataViewController *) viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
-(NSUInteger)indexOfViewController:(DataViewController *)viewController;


@end
