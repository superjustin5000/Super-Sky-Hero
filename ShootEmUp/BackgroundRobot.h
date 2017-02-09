//
//  BackgroundRobot.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/12/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundRobot : CCSprite {
    GameState *gs;
    float actionTime;
    float actionTimer;
}

+(id)robot;

-(int)getAction;

@end
