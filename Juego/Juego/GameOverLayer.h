//
//  GameOverLayer.h
//  Juego
//
//  Created by Equipo Desarrollo 2 on 6/08/13.
//  Copyright 2013 Cymetria. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor

+(CCScene *)sceneWithWon:(BOOL)won;

-(id)initWithWon:(BOOL)won;

@end
