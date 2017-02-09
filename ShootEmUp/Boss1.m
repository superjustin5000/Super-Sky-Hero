//
//  Boss1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 6/1/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Boss1.h"

#import "Bullet.h"
#import "SawBlade.h"
#import "Player.h"
#import "Ship.h"
//////////////////////////
////////////////////////// ----------   TURRETS --------- >>>>>>>>>
/////////////////////////

@implementation BossTurret

@synthesize _turretState;
@synthesize isHoming;

+(id)turretWithBoss:(Boss*)boss AsBig:(BOOL)big {
    return [[self alloc] initWithBoss:boss AsBig:big]; /////// not autorelease make sure you release them in the boss dealloc method.
}

-(id)initWithBoss:(Boss*)boss AsBig:(BOOL)big {
    
    isBigTurret = big;
    isHoming = NO;
    
    NSString *filename = @"boss1Turret.png";
    float health = 20;
    CGPoint vel = ccp(0,0);
    
    if (isBigTurret) {
        filename = @"boss1Turret2.png";
        health = 30;
        vel = ccp(0, 0.5);
    }
    
    if ((self = [super initWithFileName:filename health:health speed:vel shootTime:0.5])) {
        turretBoss = boss;
        
        bulletType = kbulletEnemy;
        _turretState = turretStateOff;
        
        [self scheduleUpdate];
        
    }
    return self;
}

-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    if (_turretState == turretStateOn) {
        int move = kbulletMoveStraight;
        if (isHoming) move = kbulletMoveHoming;
        Bullet *b = [Bullet bulletWithFile:@"bullet_big.png" Power:5 Velocity:CGPointMake(3, 0) Direction:direction Movement:move Type:type Origin:o ExplodeType:kExplode1];
        if (isBigTurret) {
            b = NULL;
            b = [Bullet bulletWithSpriteFrameName:@"fireball.png" Power:10 Velocity:ccp(3,0) Direction:direction Movement:move Type:type Origin:o ExplodeType:kExplode1];
            [b runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.7f angle:-360]]];
        }
        b.position = ccp(self.position.x - self.contentSize.width/2 - b.contentSize.width/2 - 2, self.position.y);
        [parent_ addChild:b];
        
    }
}

-(void)checkCollisions {
    Bullet *b;
    CCARRAY_FOREACH(gs._bullets, b) {
        if (b.type == kbulletPlayer) {
            if (CGRectIntersectsRect(spriteRect, b.spriteRect)) {
                [turretBoss takeDamage:b.strength];
                [self hitByBullet:b.strength];
                [b hitShip:self];
            }
        }
    }
}


-(void)die {
    [turretBoss._bossNodes removeObject:self];
    [super die];
}

-(void)update:(ccTime)delta {
    if (!alive) {
        [self removeFromParentAndCleanup:YES];
    }
}


-(void)dealloc {
    [super dealloc];
}

@end







//////////////////////////
////////////////////////// ----------   THE ARM --------- >>>>>>>>>
/////////////////////////

@implementation BossArm

@synthesize arm6;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    if ((self = [super initWithTexture:texture rect:rect])) {
        
        isSwinging = NO;
        isSpeeding = NO;
        isSlowing = NO;
        isExtending = NO;
        isRetracting = NO;
        
        rotationVel = 0;
        maxRotationVel = 10;
        rotationAccel = 0.025;
        
        arm1 = [CCSprite spriteWithFile:@"bossArmTest.png"];
        arm2 = [CCSprite spriteWithFile:@"bossArmTest.png"];
        arm3 = [CCSprite spriteWithFile:@"bossArmTest.png"];
        arm4 = [CCSprite spriteWithFile:@"bossArmTest.png"];
        arm5 = [CCSprite spriteWithFile:@"bossArmTest.png"];
        arm6 = [CCSprite spriteWithFile:@"bossArmTest.png"];
        armDist = 4;
        arm1.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        arm2.position = ccp(arm1.position.x, arm1.position.y - armDist);
        arm3.position = ccp(arm1.position.x, arm2.position.y - armDist);
        arm4.position = ccp(arm1.position.x, arm3.position.y - armDist);
        arm5.position = ccp(arm1.position.x, arm4.position.y - armDist);
        arm6.position = ccp(arm1.position.x, arm5.position.y - armDist);
        
        [self addChild:arm1];
        [self addChild:arm2];
        [self addChild:arm3];
        [self addChild:arm4];
        [self addChild:arm5];
        [self addChild:arm6];
        
        [self schedule:@selector(updateArm:)];
    }
    return self;
}

-(void)speedUp {
    isSwinging = YES;
    isSpeeding = YES;
    isSlowing = NO;
}
-(void)slowDown {
    isSwinging = YES;
    isSpeeding = NO;
    isSlowing = YES;
}

-(void)updateArm:(ccTime)dt {
    if (isSwinging) {
        if (isSpeeding) {
            isExtending = YES;
            isRetracting = NO;
            if (rotationVel >= maxRotationVel) {
                rotationVel = maxRotationVel;
            }
            else {
                rotationVel += rotationAccel;
            }
        }
        if (isSlowing) {
            isExtending = NO;
            isRetracting = YES;
            if (rotationVel <= 0) {
                rotationVel = 0;
                isSwinging = NO;
            }
            else {
                rotationVel -= rotationAccel;
            }
        }
        self.rotation += rotationVel;
    }
    
    if (isExtending) {
        int maxDist = 12;
        if (armDist >= maxDist) {
            armDist = maxDist;
        }
        else {
            armDist += 0.03;
        }
        arm2.position = ccp(arm1.position.x, arm1.position.y - armDist);
        arm3.position = ccp(arm1.position.x, arm2.position.y - armDist);
        arm4.position = ccp(arm1.position.x, arm3.position.y - armDist);
        arm5.position = ccp(arm1.position.x, arm4.position.y - armDist);
        arm6.position = ccp(arm1.position.x, arm5.position.y - armDist);
        
        //float hyp = arm1.position.y - saw.position.y;
        //float newx = hyp * cos(self.rotation);
        //float sawX = [self convertToWorldSpace:saw.position].x;
        
    }
    
    if (isRetracting) {
        int minDist = 4;
        if (armDist <= minDist) {
            armDist = minDist;
        }
        else {
            armDist -= 0.03;
        }
        arm2.position = ccp(arm1.position.x, arm1.position.y - armDist);
        arm3.position = ccp(arm1.position.x, arm2.position.y - armDist);
        arm4.position = ccp(arm1.position.x, arm3.position.y - armDist);
        arm5.position = ccp(arm1.position.x, arm4.position.y - armDist);
        arm6.position = ccp(arm1.position.x, arm5.position.y - armDist);
    }
    
}

-(void)dealloc {
    [super dealloc];
}

@end











//////////////////////////
////////////////////////// ----------   THE BOSSS --------- >>>>>>>>>
/////////////////////////

@implementation Boss1

-(id)init {
    if ((self = [super initWithFileName:@"normal_white.png" Health:1000])) {
        ///set up all the boss parts.
        /////////////////////////////////////
        wall1 = [CCSprite spriteWithFile:@"boss1Test.png"];
        
        wall1.position = ccp(gs.winSize.width + 100, gs.winSize.height/2);
        
        
        ///WALL 1 NODES.
        
        turretWall1_Set1_1 = [BossTurret turretWithBoss:self AsBig:NO];
        turretWall1_Set1_2 = [BossTurret turretWithBoss:self AsBig:NO];
        turretWall1_Set1_1.position = ccp(wall1.position.x - wall1.contentSize.width/2 + 17, wall1.contentSize.height - 40);
        turretWall1_Set1_2.position = ccp(turretWall1_Set1_1.position.x, turretWall1_Set1_1.position.y - 20);
        
        turretWall1_Set2_1 = [BossTurret turretWithBoss:self AsBig:NO];
        turretWall1_Set2_2 = [BossTurret turretWithBoss:self AsBig:NO];
        turretWall1_Set2_1.position = ccp(turretWall1_Set1_1.position.x, 70);
        turretWall1_Set2_2.position = ccp(turretWall1_Set2_1.position.x, turretWall1_Set2_1.position.y - 20);
        
        
        turretWall1_Set3_1 = [BossTurret turretWithBoss:self AsBig:YES];
        turretWall1_Set3_2 = [BossTurret turretWithBoss:self AsBig:YES];
        float middle = turretWall1_Set1_2.position.y - ( (turretWall1_Set1_2.position.y - turretWall1_Set2_1.position.y) / 2 );
        turretWall1_Set3_1.position = ccp(turretWall1_Set1_1.position.x + 4, middle + 20);
        turretWall1_Set3_2.position = ccp(turretWall1_Set1_1.position.x + 4, middle - 20);
        
        ////add all the bosses nodes.
        ///////////////////////////////////////
        [_bossNodes addObject:wall1];
        
        [_bossNodes addObject:turretWall1_Set1_1];
        [_bossNodes addObject:turretWall1_Set1_2];
        [_bossNodes addObject:turretWall1_Set2_1];
        [_bossNodes addObject:turretWall1_Set2_2];
        [_bossNodes addObject:turretWall1_Set3_1];
        [_bossNodes addObject:turretWall1_Set3_2];
        
        
        
        
        
        ///WALL 2 NODES.
        
        wall2 = [CCSprite spriteWithFile:@"boss1Test.png"];
        wall2.position = ccp(wall1.position.x, gs.winSize.height+wall2.contentSize.height/2);
        
        arm = [BossArm spriteWithFile:@"bossArmTest.png"];
        arm.position = ccp(wall2.position.x - 20, wall2.position.y - 20);
        
        
        saw = [SawBlade saw];
        CGPoint sawPos = [arm convertToWorldSpace:arm.arm6.position];
        saw.position = sawPos;
        
        turretWall2_1 = [BossTurret turretWithBoss:self AsBig:NO]; turretWall2_1.isHoming = YES;
        turretWall2_2 = [BossTurret turretWithBoss:self AsBig:NO]; turretWall2_2.isHoming = YES;
        turretWall2_1.position = ccp(wall2.position.x - wall2.contentSize.width/2 + 20, wall2.position.x + wall2.contentSize.height/2 - 40);
        turretWall2_2.position = ccp(turretWall2_1.position.x, turretWall2_1.position.y - 20);
        
        [_bossNodes addObject:wall2];
        [_bossNodes addObject:arm];
        [_bossNodes addObject:saw];
        [_bossNodes addObject:turretWall2_1];
        [_bossNodes addObject:turretWall2_2];
        
        
        
        
        
        
        ///start with this attack sequence.
        /////////////////////////////////////////////
        sequence = attackSequence1;
        prevSequence = attackSequence3;
        nextSequence = attackSequence2;
        sequenceTimer = 0.0f;
        attackSequence1Time = 5.0f;
        attackSequence2Time = attackSequence1Time;
        attackSequence3Time = attackSequence1Time;
        sequenceTime = attackSequence1Time;
        
        
        state = none;
        
        
        
        [self scheduleUpdate];
        
    }
    return self;
}



-(void)update:(ccTime)delta {
    
    if (didEnter && state == none) {
        state = wall1Battle;
    }
    
    if (state == wall1Battle) {
        
        if (curH <= 800) state = wall2Entering; ///change state when health is low.
        
        /////////////////////// the currect sequence is s1, s2, s1, s3, repeat.
        switch (sequence) {
            case attackSequence1:
                if (prevSequence == attackSequence3) nextSequence = attackSequence2; ////this way it alternates between going to s2 and s3 after s1.
                else nextSequence = attackSequence3;
                sequenceTime = attackSequence1Time;
                turretWall1_Set1_1._turretState = turretStateOn;
                turretWall1_Set1_2._turretState = turretStateOn;
                turretWall1_Set2_1._turretState = turretStateOn;
                turretWall1_Set2_2._turretState = turretStateOn;
                turretWall1_Set3_1._turretState = turretStateOn;
                turretWall1_Set3_2._turretState = turretStateOn;
                break;
            case attackSequence2:
                prevSequence = attackSequence2;
                nextSequence = attackSequence1;
                sequenceTime = attackSequence2Time;
                turretWall1_Set1_1._turretState = turretStateOff;
                turretWall1_Set1_2._turretState = turretStateOff;
                turretWall1_Set2_1._turretState = turretStateOn;
                turretWall1_Set2_2._turretState = turretStateOn;
                turretWall1_Set3_1._turretState = turretStateOff;
                turretWall1_Set3_2._turretState = turretStateOff;
                break;
            case attackSequence3:
                prevSequence = attackSequence3;
                nextSequence = attackSequence1;
                sequenceTime = attackSequence3Time;
                turretWall1_Set1_1._turretState = turretStateOn;
                turretWall1_Set1_2._turretState = turretStateOn;
                turretWall1_Set2_1._turretState = turretStateOff;
                turretWall1_Set2_2._turretState = turretStateOff;
                turretWall1_Set3_1._turretState = turretStateOff;
                turretWall1_Set3_2._turretState = turretStateOff;
                break;
            default:
                break;
        }
        
        /////move the big turrets.
        float middle = turretWall1_Set1_2.position.y - ( (turretWall1_Set1_2.position.y - turretWall1_Set2_1.position.y) / 2 );
        int moveTo = 60;
        if (turretWall1_Set3_1.position.y >= middle + moveTo || turretWall1_Set3_2.position.y <= middle - moveTo) { ////keep reversing y velocity.
            turretWall1_Set3_1.velocity = ccp(turretWall1_Set3_1.velocity.x, -turretWall1_Set3_1.velocity.y);
            turretWall1_Set3_2.velocity = ccp(turretWall1_Set3_2.velocity.x, -turretWall1_Set3_2.velocity.y);
        }
        turretWall1_Set3_1.position = ccp(turretWall1_Set3_1.position.x, turretWall1_Set3_1.position.y + turretWall1_Set3_1.velocity.y);
        turretWall1_Set3_2.position = ccp(turretWall1_Set3_2.position.x, turretWall1_Set3_2.position.y + turretWall1_Set3_2.velocity.y);
        
            
        if (sequenceTimer >= sequenceTime) {
            sequenceTimer = 0.0f;
            sequence = nextSequence;
        } else {
            sequenceTimer += delta;
        }
        
    } ////// end state wall1battle.
    
    else if (state == wall2Entering) { //////first wall has died, enter second wall.
        
        
        
    }
    
    else if (state == wall2Battle) { ////second wall has entered, fight second wall.
        wall2.position = ccp(wall2.position.x, gs.winSize.height/2);
        arm.position = ccp(wall2.position.x - 20, wall2.position.y - 20);
        if (turretWall2_1 != NULL) turretWall2_1.position = ccp(wall2.position.x - wall2.contentSize.width/2 + 20, wall2.contentSize.height - 40);
        turretWall2_2.position = ccp(turretWall2_1.position.x, turretWall2_1.position.y - 20);
        
        ///////attack 1 swing saw blade arm.
        ///get the pos of the saw right.
        CGPoint sawPos = [arm convertToWorldSpace:arm.arm6.position];
        sawPos = [parent_ convertToNodeSpace:sawPos];
        saw.position = sawPos;
        
        if (swingWait >= 8.0f) {
            [arm speedUp];
            if (swingTimer >= 8.0f) {
                [arm slowDown];
                swingTimer = 0.0f;
                swingWait = 0.0f;
            }
            else {
                swingTimer += delta;
            }
        }
        else {
            swingWait += delta;
        }
        
        //////attack 2 suck in ship.
        
        if (suckWait >= 20.0f) {
            isSucking = YES;
            if (suckTimer >= 6.0f) {
                isSucking = NO;
                suckTimer = 0.0f;
                suckWait = 0.0f;
            }
            else {
                suckTimer += delta;
            }
        }
        else {
            suckWait += delta;
        }
        if (isSucking) {
            
            Player *player = (Player*)gs.player;
            Ship *playerShip = player.currentShip;
            
            playerShip.position = ccp(playerShip.position.x + playerShip.velocity.x + 0.1, playerShip.position.y + playerShip.velocity.y + 0.1);
            
        }
        
        
        //////attack 3 fire homing bullets.
        if (shootWait >= 5.0f) {
            turretWall2_1._turretState = turretStateOn;
            turretWall2_2._turretState = turretStateOn;
            [turretWall2_1 shootWithDirection:kbulletDirectionNegativeX Type:kbulletEnemy Origin:turretWall2_1];
            [turretWall2_2 shootWithDirection:kbulletDirectionNegativeX Type:kbulletEnemy Origin:turretWall2_2];
            turretWall2_1._turretState = turretStateOff;
            turretWall2_2._turretState = turretStateOff;
            shootWait = 0.0f;
        }
        else {
            shootWait += gs.gameDelta;
        }
        
    }
    
}




-(void)dealloc {
    [turretWall1_Set1_1 release];
    [turretWall1_Set1_2 release];
    [turretWall1_Set2_1 release];
    [turretWall1_Set2_2 release];
    [turretWall1_Set3_1 release];
    [turretWall1_Set3_2 release];
    
    [turretWall2_1 release];
    [turretWall2_2 release];
    
    [super dealloc];
}
@end
