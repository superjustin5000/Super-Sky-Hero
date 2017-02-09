//
//  Bomb.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/28/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Bomb.h"
#import "Enemy.h"
#import "Ship.h"

@implementation Bomb

-(id)init {
    if ((self = [super init])) {
        bombTimer = 0.0f;
        bombDamageTimer = 0.0f;
    }
    return self;
}

-(void)explode {
    [self scheduleUpdate];
}


-(void)doDamage:(int)damage {
    
    /////find ships.
    if ([gs._ships count] > 0) {
        Ship *s;
        CCARRAY_FOREACH(gs._ships, s) {
            if (!s.hasPlayer) { //only enemy ships.
                [s hitByBullet:damage];
            }
        }
    }
    
    ////find enemies
    if ([gs._enemies count] > 0) {
        Enemy *e;
        CCARRAY_FOREACH(gs._enemies, e) {
            [e hitByBullet:damage];
        }
    }
    
}



-(void)update:(ccTime)delta {
    if (bombTimer <= 3.0f) {
        if (bombDamageTimer >= 1.0f) {
            bombDamageTimer = 0.0f;
            [self doDamage:100];
        }
        else {
            bombDamageTimer += delta;
        }
        bombTimer += delta;
    } else {
        [self destroyJSprite];
    }
}



-(void)dealloc {
    [super dealloc];
}

@end
