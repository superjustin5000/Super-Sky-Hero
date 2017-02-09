//
//  Player.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/27/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Shooter.h"

@class Ship;
@class PowerUpNode;

@interface Player : Shooter {
    
    Ship *currentShip;
    Ship *previousShip;
    PowerUpNode *currentPowerUpNode;
    
    BOOL firstShip;
    
    ////Walking.
    CGPoint footPosition;
    int floorHeight;
    int leftWall;
    int rightWall;
    BOOL isWalking;
    BOOL isFalling;
    BOOL isRunning;
    BOOL isPointingUp;
    BOOL isPointingUpUp;
    BOOL isCrouching;
    CCNode *playerGround;
    
    ///respawning.
    BOOL isRespawning;
    float respawnTimer;
    
    
    ////Jumping.
    BOOL isJumping;
    BOOL isHoldingJump;
    BOOL isHoldingA;
    BOOL isRocketing;
    BOOL didDoubleJump;
    float maxHoldTime;
    float jumpTime;
    float jetPackMeter;
    BOOL jetPackRecharging;
    float jetPackRechargeTime;
    BOOL shouldRoll;
    BOOL isRolling;
    
    BOOL canMove;
    
    
    ////shooting
    int powerup;
    BOOL shoot;
    int shootStr;
    NSString *shootBulletFile;
    
    ////fighting enemy pilot
    BOOL isFighting;
    BOOL isPunching;
    
    CCAnimation *fallAnim;
    CCAnimation *runAnim;
    
}


@property(nonatomic, retain) Ship *currentShip;
@property(nonatomic, retain) Ship *previousShip;
@property(nonatomic, retain) PowerUpNode *currentPowerUpNode;
@property(nonatomic)CGPoint footPosition;
@property(nonatomic)int floorHeight, leftWall, rightWall;
@property(nonatomic)BOOL isWalking;
@property(nonatomic, retain)CCNode *playerGround;
@property(nonatomic)BOOL isJumping, isFalling, jetPackRecharging;
@property(nonatomic)BOOL isHoldingJump, isHoldingA;
@property(nonatomic)float jetPackMeter;
@property(nonatomic)int powerup;
@property(nonatomic)BOOL isFighting, isPunching;

-(void)jump;
-(void)doubleJump;
-(void)stopJump;
-(void)fightShipPilot:(Ship*)ship;
-(void)punch;
-(void)punchDone;
-(void)landInShip:(Ship*)ship;
-(void)landOnGround:(CCNode*)ground;
-(void)landOnSameGround;
-(void)runOnGroundAndPointUp:(BOOL)up;
-(void)stopRunOnGround;
-(void)groundJump;
-(void)wallFlyingJump;
-(void)fall;

-(void)shootWithDirection:(int)direction;
-(void)addPowerUp:(int)type;
-(void)addBomb;

@end
