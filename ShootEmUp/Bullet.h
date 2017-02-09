//
//  Bullet.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/8/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#ifndef __BULLET_H__
#define __BULLET_H__

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Shooter;

@interface Bullet : JSprite {
    
    float strength;
    int moveDirection;
    int moveType;
    int type;
    int explodeType;
    
    float laserTimer;
    
    CCSprite *origin;
    BOOL hasOrigin;
    
    JSprite *target;
    BOOL isFollowingTarget;
    
    CCAnimation *baseAnimation;
    
}
@property(nonatomic, retain)CCSprite *origin;
@property(nonatomic)BOOL hasOrigin;
@property(nonatomic)float strength;
@property(nonatomic)int type;
@property(nonatomic)BOOL isFollowingTarget;

+(id)bulletWithSpriteFrameName:(NSString*)framename Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode;
+(id)bulletWithFile:(NSString*)fileName Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode;
-(id)initWithFile:(NSString*)fileName Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode;
-(id)initWithSpriteFrameName:(NSString *)framename Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode;

-(void)initBullet;

-(void)moveNormal;
-(void)moveHoming;
-(void)moveLaser;
-(void)stopLaser;

-(void)addSmokeWithType:(int)t;


-(void)hitShip:(JSprite*)targetHit;
-(void)destroyBullet;

@end



@interface BulletSmoke : CCNode {
    int type;
    float smokeTime;
    float smokeTimer;
    CCNode *smokeParent; ///smoke parent is the level. the actual parent is the bullet.
}
+(id)smokeWithType:(int)type andParent:(CCNode*)p;
-(id)initWithType:(int)type andParent:(CCNode*)p;
@end




#endif
