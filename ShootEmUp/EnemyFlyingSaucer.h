//
//  EnemyFlyingSaucer.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/16/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Enemy.h"


typedef enum {
    attackSequence1 = 0,
    attackSequence2 = 1,
    attackSequence3 = 2
} attackSequence;

@interface EnemyFlyingSaucer : Enemy {
    int startX;
    attackSequence AS;
    BOOL isBusy;
    
    int slowFlyTimes;
    
    CCSprite *f1;
}


@end
