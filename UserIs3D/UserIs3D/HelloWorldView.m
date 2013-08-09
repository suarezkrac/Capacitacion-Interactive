//
//  HelloWorldView.m
//  UserIs3D
//
//  Created by Equipo Desarrollo 2 on 8/08/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"

@implementation HelloWorldView

- (id) init {
	
	if ((self = [super init])) {
        
        self.camera.position = iv3(2, 20, 30);
        
		Isgl3dColorMaterial * colorMaterial = [Isgl3dColorMaterial materialWithHexColors:@"444444" diffuse:@"FFFFFF" specular:@"FFFFFF" shininess:0.7];
		
		Isgl3dTorus * torus = [Isgl3dTorus meshWithGeometry:3.0 tubeRadius:1.0 ns:32 nt:20];
		
		_torusNode = [self.scene createNodeWithMesh:torus andMaterial:colorMaterial];
        
		_redLight = [Isgl3dLight lightWithHexColor:@"FF0000" diffuseColor:@"FF0000" specularColor:@"FFFFFF" attenuation:0.02];
		_redLight.renderLight = YES;
		
        [self.scene addChild:_redLight];
        
        _torusNode.interactive = YES;
        [_torusNode addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
        
        
       

        
	}
	return self;
}

- (void) dealloc {

	[super dealloc];
}

-(void)objectTouched:(Isgl3dEvent3D *)event{
    
    Isgl3dNode * object = event.object;

    [Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.5], TWEEN_DURATION, TWEEN_FUNC_EASEINSINE, TWEEN_TRANSITION, [NSNumber numberWithFloat:object.y + 5.0], @"y", self, TWEEN_ON_COMPLETE_TARGET, @"tweenEnded", TWEEN_ON_COMPLETE_SELECTOR, nil]];
}
-(void)tweenEnded:(id)sender{

}

- (void) tick:(float)dt {

}


@end

