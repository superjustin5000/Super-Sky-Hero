//
//  EnemyFlyingDroid2.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/22/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Enemy.h"

@interface EnemyFlyingDroid2 : Enemy {
    CGPoint startPos;
    int yDir;
}

@end
