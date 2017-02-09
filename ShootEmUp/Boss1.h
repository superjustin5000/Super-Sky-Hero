//
//  Boss1.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 6/1/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Boss.h"
#import "Shooter.h"

@class SawBlade;

typedef enum {
    turretStateOn = 0,
    turretStateOff = 1
} turretState;

@interface BossTurret : Shooter {
    turretState state;
    BOOL isBigTurret;
    BOOL isHoming;
    Boss *turretBoss;
}
@property(nonatomic)turretState _turretState;
@property(nonatomic)BOOL isHoming;

+(id)turretWithBoss:(Boss*)boss AsBig:(BOOL)big;
-(id)initWithBoss:(Boss*)boss AsBig:(BOOL)big;

@end






@interface BossArm : JSprite {
    CCSprite *arm1, *arm2, *arm3, *arm4, *arm5, *arm6;
    BOOL isSwinging;
    BOOL isSpeeding;
    BOOL isSlowing;
    BOOL isExtending;
    BOOL isRetracting;
    float rotationVel;
    float maxRotationVel;
    float rotationAccel;
    float armDist;
}
@property(nonatomic, retain)CCSprite *arm6;

-(void)updateArm:(ccTime)dt;
-(void)speedUp;
-(void)slowDown;
@end






typedef enum {
    attackSequence1 = 0,
    attackSequence2 = 1,
    attackSequence3 = 2
} attackSequence;

typedef enum {
    none = 0,
    wall1Battle = 1,
    wall2Entering = 0,
    wall2Battle = 3,
} wallState;

@interface Boss1 : Boss {
    
    wallState state;
    
    /////////////////// WALL 1
    JSprite *wall1;
    BossTurret *turretWall1_Set1_1, *turretWall1_Set1_2, *turretWall1_Set2_1, *turretWall1_Set2_2, *turretWall1_Set3_1, *turretWall1_Set3_2;
    
    attackSequence sequence;
    attackSequence prevSequence;
    attackSequence nextSequence;
    float attackSequence1Time, attackSequence2Time, attackSequence3Time, sequenceTimer, sequenceTime;
    
    
    ////////////////// WALL 2
    JSprite *wall2;
    BossArm *arm;
    SawBlade *saw;
    BossTurret *turretWall2_1, *turretWall2_2;
    float swingTimer;
    float swingWait;
    float suckTimer;
    float suckWait;
    BOOL isSucking;
    float shootWait;
    
}

@end
