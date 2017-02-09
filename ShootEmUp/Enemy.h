//
//  Enemy.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/18/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Shooter.h"

@interface Enemy : Shooter {
    int spawnDifficulty;
    int leftWall;
    int rightWall;
    CCAnimation *walkAnim;
    CCAnimation *dieAnim;
    CCAnimation *attackAnim;
}

@property(nonatomic)int spawnDifficulty;
@property(nonatomic)int leftWall, rightWall;

+(id)enemyWithLeftWall:(int)lwall RightWall:(int)rwall;
-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall;
-(id)initWithFileName:(NSString *)fileName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime spawnDifficulty:(int)sDiff leftWall:(int)lwall rightWall:(int)rwall;
-(id)initWithSpriteFrameName:(NSString *)frameName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime spawnDifficulty:(int)sDiff leftWall:(int)lwall rightWall:(int)rwall;

-(void)remove;
-(void)die;
-(void)updateMovement;
-(void)updateEnemy:(ccTime)dt;

@end
