//
//  HelloWorldLayer.h
//  Juego
//
//  Created by Equipo Desarrollo 2 on 6/08/13.
//  Copyright Cymetria 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
/*@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}*/

@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray * _monsters;
    NSMutableArray * _projectiles;
    int _monstersDestroyed;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
