//
//  UserIs3DAppDelegate.h
//  UserIs3D
//
//  Created by Equipo Desarrollo 2 on 8/08/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface UserIs3DAppDelegate : NSObject <UIApplicationDelegate> {

@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;

@end
