//
//  Shooter.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/20/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Shooter : JSprite {
    
    int dirFacing;
    int bulletType;
    
    float bulletTimer;
    float bulletTime;
    float shootTimer;
    float shootTime;
    float delayShootTimer;
    float delayShootTime;
    
    BOOL isAttacking;
    BOOL isTargeted;
    CCArray *_targetedBy; //array of bullets.
    
    
    int killPoints;
    
}


@property(nonatomic)float bulletTime;
@property(nonatomic)BOOL isTargeted;
@property(nonatomic, retain)CCArray *_targetedBy;

+(id)shooter;
-(id)initWithFileName:(NSString*)fileName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime;
-(id)initWithSpriteFrameName:(NSString *)spriteFrameName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime;

-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter*)o;
-(void)attack; /////////an attack that does not produce a bullet.
-(void)stopAttack;
-(void)hitByBullet:(float)strength;
-(void)die;

-(void)updateShooter:(ccTime)dt;

@end
