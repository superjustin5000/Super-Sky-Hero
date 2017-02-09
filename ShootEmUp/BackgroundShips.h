//
//  BackgroundShips.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/11/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundShips : CCNode {
    GameState *gs;
    float shipTime;
    float shipTimer;
}

@end

@interface BackgroundShip : CCSprite {
    
}

@end