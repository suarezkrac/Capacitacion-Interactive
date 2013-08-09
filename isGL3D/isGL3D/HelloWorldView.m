//
//  HelloWorldView.m
//  isGL3D
//
//  Created by Equipo Desarrollo 2 on 8/08/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#define LIGHT_RADIUS 4

@implementation HelloWorldView

- (id) init {
	
	if ((self = [super init])) {
        self.camera.position = iv3(2,15,20);
        
        [self.camera lookAt:0.5 y:0 z:1];
        
        Isgl3dTextureMaterial * torusMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"donut.jpg" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:YES repeatY:YES];
        
		[torusMaterial setAmbientColorAsString:@"444444"];
        
        Isgl3dTextureMaterial * planeMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"cloth.jpeg" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:YES repeatY:YES];
        
        Isgl3dTorus * torus = [Isgl3dTorus meshWithGeometry:3.5 tubeRadius:1.5 ns:32 nt:16];
        Isgl3dUVMap * uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:1.0 vB:0.0 uC:0.0 vC:1.0 ];
        Isgl3dPlane * plane = [Isgl3dPlane meshWithGeometryAndUVMap:100.0 height:100.0 nx:2 ny:2 uvMap:uvMap];
        
        _torusNode = [self.scene createNodeWithMesh:torus andMaterial:torusMaterial];
        
        Isgl3dMeshNode * planeNode = [self.scene createNodeWithMesh:plane andMaterial:planeMaterial];
        
        planeNode.rotationX = -90;
        planeNode.position = iv3(30, -10, 0);
        
        Isgl3dLight * light = [Isgl3dLight lightWithHexColor:@"ffffff" diffuseColor:@"ffffff" specularColor:@"ffffff" attenuation:0.2];
        light.lightType = DirectionalLight;
        
        [light setDirection:-1 y:-1 z:0];
        
        [self.scene addChild:light];
        
        
     
	}
	return self;
}

- (void) dealloc {

	[super dealloc];
}


- (void) tick:(float)dt {
	// Rotate the text around the y axis
	/*_torusNode.rotationZ +=1;
    
    _redLight.position = iv3(LIGHT_RADIUS * sin(_lightAngle * M_PI/ 30), LIGHT_RADIUS * cos(_lightAngle * *M_PI/30), 0);
     _blueLight.position = iv3(LIGHT_RADIUS * -cos(_lightAngle * M_PI/ 60), LIGHT_RADIUS * sin(_lightAngle * M_PI/60), LIGHT_RADIUS * cos(_lightAngle * M_PI/60));

    _greenLight.position = iv3(LIGHT_RADIUS * -cos(_lightAngle * M_PI/ 45), LIGHT_RADIUS * sin(_lightAngle * M_PI/45), LIGHT_RADIUS * cos(_lightAngle * M_PI/45));

    
    _lightAngle = _lightAngle +0.5;*/
    _torusNode.rotationY +=1;
}



@end






