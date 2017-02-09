//
//  Ship.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//
#ifndef __SHIP_H__
#define __SHIP_H__


#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "SimpleAudioEngine.h"

#import "Shooter.h"

#import "EngineFlame.h"
#import "EngineSmoke.h"

@interface Ship : Shooter {
    
    BOOL canHavePlayer;
    BOOL hasPlayer;
    BOOL playerJumpedOut;
    BOOL playerHasBeenIn;
    CGPoint playerJumpPos;
    float justHitDmg;
    
    float lifeTimer;
    
    BOOL canHoldShoot;
    BOOL didShoot;
    
    float damageTime;
    float damageTimer;
    BOOL isDamageBlinking;
    
    BOOL hasEnemyPilot;
    
    BOOL isCrashing;
    
    
    BOOL controlsBasic;
    JPad *pad;
    
    
    float upTimer;
    float downTimer;
    BOOL upTime;
    BOOL downTime;
    
    CGRect startingTexRect;
    CGRect shipDownTexRect;
    CGRect shipUpTexRect;
    CCTexture2D *shipStartingTexture;
    CCTexture2D *shipDownTexture;
    CCTexture2D *shipUpTexture;
    
    
    int partsType;
    
    SEL currentScheduledMovement;
    BOOL isMovementScheduled;
    int moveY;
    float fromX, fromY, toX, toY;
    int directionX, directionY;
    
    
    
}

@property(nonatomic)BOOL canHavePlayer;
@property(nonatomic)BOOL hasPlayer;
@property(nonatomic)BOOL playerJumpedOut;
@property(nonatomic)BOOL playerHasBeenIn;
@property(nonatomic)CGPoint playerJumpPos;
@property(nonatomic)float justHitDmg;
@property(nonatomic)BOOL hasEnemyPilot;
@property(nonatomic)BOOL isCrashing, isDamageBlinking;


+(id)ship;
-(id)initWithFileName:(NSString *)fileName startingHealth:(float)startHealth jumpPos:(CGPoint)jumpPos speed:(CGPoint)spd shootTime:(float)stime;

-(void)player:(ccTime)dt;
-(void)noPlayer:(ccTime)dt;

-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship*)ship;
-(void)enemyShoot;
-(void)playerShoot;
-(void)damageBlinking;

-(void)dropParts;


/////ship movements.

-(void)scheduleShipMovement;
-(void)unscheduleShipMovement;

-(void)moveRightToLeftWithY:(int)y;
-(void)moveRightToLeft:(ccTime)dt;

-(void)moveLeftToRightWithY:(int)y;
-(void)moveLeftToRight:(ccTime)dt;


-(void)moveBottomUpTo:(int)y;
-(void)moveBottomUpTo:(int)y withX:(int)x;
-(void)moveBottomUpDone;

-(void)moveSinWaveWithY:(int)y;
-(void)moveSinWaveFromLeftWithY:(int)y;
-(void)moveSinWave:(ccTime)dt;

-(void)moveCosWaveWithY:(int)y;
-(void)moveCosWaveFromLeftWithY:(int)y;
-(void)moveCosWave:(ccTime)dt;

-(void)moveRootCurveWithY:(int)y;
-(void)moveRootCurve:(ccTime)dt;

-(void)moveCornerToCornerFromQuadrant:(int)q1 toQuadrant:(int)q2;
-(void)moveCornerToCorner:(ccTime)dt;

-(void)moveSemiCircleFromTop;
-(void)moveSemiCircleFromBottom;
-(void)moveSemiCircle:(ccTime)dt;

-(void)moveEnterFromRightAndStopWithY:(int)y;
-(void)moveEnterFromRightAndStop:(ccTime)dt;


-(void)moveEnterFromTopLeftAndDown;
-(void)moveEnterFromTopLeftAndDown:(ccTime)dt;

-(void)moveEnterFromBottomLeftAndUp;
-(void)moveEnterFromBottomLeftAndUp:(ccTime)dt;


-(void)moveEnterAndLeaveWithY:(int)y;
-(void)moveEnterAndLeave:(ccTime)dt;

-(void)moveEnterSemiCircleExitWithY:(int)y;
-(void)moveEnterSemiCircleExit:(ccTime)dt;

-(void)moveFollowPlayerWithY:(int)y;
-(void)moveFollowPlayer:(ccTime)dt;

-(void)moveStepUpWithY:(int)y;
-(void)moveStepDownWithY:(int)y;
-(void)moveStep:(ccTime)dt;

-(void)moveSplitDiagonalUpWithY:(int)y;
-(void)moveSplitDiagonalDownWithY:(int)y;
-(void)moveSplitDiagonal:(ccTime)dt;



-(void)updateShip:(ccTime)dt;

@end

#endif
