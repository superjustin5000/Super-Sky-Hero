//
//  Player.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/27/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Player.h"

#import "TestGame.h"
#import "Kamcord/Kamcord.h"
#import "Level3.h"

#import "Bullet.h"

#import "Ship.h"
#import "PowerUp.h"

#import "WallFlying.h"

@implementation Player

@synthesize currentShip, previousShip, currentPowerUpNode;
@synthesize footPosition;
@synthesize floorHeight, leftWall, rightWall;
@synthesize playerGround;
@synthesize jetPackMeter;
@synthesize isHoldingJump, isHoldingA, isJumping, isWalking, isFighting, isPunching, isFalling, jetPackRecharging;
@synthesize powerup;



-(id)init {
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"playerSpriteSheet1.plist" textureFilename:@"playerSpriteSheet1.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet_enemies1.plist" textureFilename:@"spritesheet_enemies1.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet_hudfaces.plist" textureFilename:@"spritesheet_hudfaces.png"];
    //if (!gs.loadedBulletSprites) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet_bullets.plist" textureFilename:@"spritesheet_bullets.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet_powerupbot.plist" textureFilename:@"spritesheet_powerupbot.png"];
    //    gs.loadedBulletSprites = YES;
    //}
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet_randomobjects.plist" textureFilename:@"spritesheet_randomobjects.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet_rescue.plist" textureFilename:@"spritesheet_rescue.png"];
    
    
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:@"laserTest.png"];
    CGRect rec = CGRectZero;
    rec.size = tex.contentSize;
    CCSpriteFrame *spr = [CCSpriteFrame frameWithTexture:tex rect:rec];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:spr name:@"laserTest.png"];
    
    
    if ((self = [super initWithSpriteFrameName:@"playerStand.png" health:100 speed:CGPointMake(2.5, 5) shootTime:-1])) {
        
        gs.player = self;
        
        //drawRects = YES;
        
        
        
        canMove = YES;
        
        
        
        //self.scale = 1;
        
        
        acceleration = CGPointMake(0, -0.2);  ////the player's jumping gravity.
        maxHoldTime = 0.3; ///how long to be able to hold the jump longer.
        
        
        shoot = NO;
        shootStr = 1;
        shootBulletFile = @"playerWalkingBullet1.png";
        
        currentShip = NULL;
        currentPowerUpNode = NULL;
        
        firstShip = YES;
        
        isFighting = NO;
        isPunching = NO;
        isWalking = NO;
        isRunning = NO;
        isPointingUp = NO;
        isPointingUpUp = NO;
        isCrouching = NO;
        isJumping = NO;
        isHoldingJump = NO;
        isHoldingA = NO;
        isRocketing = NO;
        isRespawning = YES;
        shouldRoll = NO;
        isRolling = NO;
        
        
        jetPackMeter = 100;
        
        [self scheduleUpdate];
        
    }
    
    return self;
    
}




////////////////
//////////////////////    ACTION STATE METHODS.


-(void)jump {
    [self stopAllActions];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerRocket.png"]];
    isJumping = YES;
    isRocketing = YES;
    jetPackMeter -= 70;
    if (jetPackMeter <= 0)
        jetPackMeter = 0;
    self.scale = 1;
    self.opacity = 255;
    canCollide = YES;
    shouldRoll = YES; //// big jumps mean that you roll when you land.
}
-(void)doubleJump {
    isHoldingJump = YES;
    jumpTime = 0;
    velocity = ccp(initVelocity.x, 3.0f);
    didDoubleJump = YES;
    [self jump];
}

-(void)stopJump {
    isWalking = NO;
    isJumping = NO;
    isHoldingJump = NO;
    didDoubleJump = NO;
    jumpTime = 0;
    velocity = initVelocity;
    if (jetPackMeter < 100) {
        jetPackRechargeTime = 3.0f;
        jetPackRecharging = YES;
    }
}

-(void)fightShipPilot:(Ship*)ship {
    [self stopJump];
    [self stopAllActions];
    self.scaleX = 1;
    self.position = ccp(ship.position.x + (ship.playerJumpPos.x*ship.scaleX), ship.position.y + ship.playerJumpPos.y);
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerPunchPilot1.png"]];
    canMove = NO; ///so the pilot fight can happen.
}

-(void)punch {
    isPunching = YES;
    NSMutableArray *punchFrames = [gs framesWithFrameName:@"playerPunchPilot" fromFrame:1 toFrame:3 andReverse:YES andAntiAlias:NO];
    CCAnimation *punchAnim = [CCAnimation animationWithSpriteFrames:punchFrames delay:0.1];
    id punch = [CCAnimate actionWithAnimation:punchAnim];
    id punchDone = [CCCallFunc actionWithTarget:self selector:@selector(punchDone)];
    [self runAction:[CCSequence actionOne:punch two:punchDone]];
}
-(void)punchDone {
    isPunching = NO;
}


-(void)landInShip:(Ship*)ship {
    [self stopJump];
    self.opacity = 0;
    self.scaleX = 1;
    canCollide = NO;
    canMove = YES; //////was set to no because of fighting pilot.
    currentShip = ship;
    
    if (!firstShip) ////only blink if this isn't the first time you land in a ship in a level.
        currentShip.isDamageBlinking = YES;
    else
        firstShip = NO; /////////for the first time you land in a ship (the very beginning of a level, don't damage blink).
    
    playerGround = NULL;
}

-(void)landOnGround:(CCNode*)ground {
    [self stopJump];
    velocity = CGPointMake(1.5, 3);
    //self.opacity = 255; ///not sure why it sets your opacity ...
    isWalking = YES;
    isFalling = NO;
    playerGround = ground;
    
    [self stopRunOnGround];
    isRunning = NO;
    
    if (shouldRoll) {
        canMove = NO;
        isRolling = YES;
        shouldRoll = NO;
        void (^stopRoll) (void) = ^{
            isRolling = NO;
            canMove = YES;
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerStand.png"]];
        };
        [self stopAllActions];
        NSMutableArray *frames = [gs framesWithFrameName:@"playerRoll" fromFrame:1 toFrame:5];
        CCAnimation *rollAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.08];
        id roll = [CCAnimate actionWithAnimation:rollAnim];
        id done = [CCCallBlock actionWithBlock:stopRoll];
        [self runAction:[CCSequence actionOne:roll two:done]];
    }
}
-(void)landOnSameGround {
    [self stopJump];
    velocity = CGPointMake(1.5, 3);
    isWalking = YES;
    isFalling = NO;
    [self stopRunOnGround];
    isRunning = NO;
}

-(void)runOnGroundAndPointUp:(BOOL)up {
    if (!isJumping) {
        [self stopAllActions];
        NSMutableArray *runFrames;
        if (up) {
            runFrames = [gs framesWithFrameName:@"playerRunUp" fromFrame:1 toFrame:6];
        }
        else {
            runFrames = [gs framesWithFrameName:@"playerRun" fromFrame:1 toFrame:6];
        }
        runAnim = [CCAnimation animationWithSpriteFrames:runFrames delay:0.1f];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim]]];
    }
}

-(void)stopRunOnGround {
    [self stopAllActions];
    if ( [JPad getPad].touchUp && !([JPad getPad].touchLeft || [JPad getPad].touchRight || [JPad getPad].touchDown) ) {
        isPointingUpUp = YES;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerStandStraightUp.png"]];
    }
    else {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerStand.png"]];
    }
}

-(void)groundJump {
    if (canMove) {
        isJumping = YES;
        [self stopAllActions];
        if ([JPad getPad].touchUp) {
            if ([JPad getPad].touchLeft || [JPad getPad].touchRight) {
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerJumpUp.png"]];
            }
            else {
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerJumpStraightUp.png"]];
            }
        } else {
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerJump.png"]];
        }
    }
}

-(void)wallFlyingJump {
    [self jump];
}

-(void)fall {
    floorHeight = 0;
    playerGround = NULL; ///remove the ground, so you can land on another ground.
    isWalking = NO;
    if (!isJumping) { ////if you're not jumping, you just fall
        velocity = ccp(velocity.x, 0);
        isJumping = YES;
        isFalling = YES;
    }
    
    [self stopAllActions];
    NSMutableArray *fallFrames = [gs framesWithFrameName:@"playerFall" fromFrame:1 toFrame:7];
    fallAnim = [CCAnimation animationWithSpriteFrames:fallFrames delay:0.08f];
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallAnim]]];
}


-(void)die {
    [super die];
    
    
    canCollide = NO;
    canMove = NO;
    
    //////// incase anything else is going on, shut it down.
    [self stopAllActions];
    
    isRunning = NO;
    [self stopRunOnGround];

    if (isJumping) {
        [self landOnSameGround];
        //self.position = ccp(self.position.x, floorHeight + self.contentSize.height/2);
    }
    
    
    
    void (^respawn) (void) = ^{
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerStand.png"]];
        self.opacity = 150;
        isRespawning = YES;
        canMove = YES;
        
        if (self.footPosition.y > self.floorHeight) {
            isJumping = YES;
            velocity = ccp(velocity.x, 0);
        }
        else if (self.footPosition.y < self.floorHeight) {
            self.position = ccp(self.position.x, self.floorHeight + self.contentSize.height/2);
        }
        
    };
    
    NSArray *dieframes = [gs framesWithFrameName:@"playerDie" fromFrame:1 toFrame:4];
    CCAnimation *dieanim = [CCAnimation animationWithSpriteFrames:dieframes delay:0.1];
    
    id die = [CCAnimate actionWithAnimation:dieanim];
    id opacity = [CCFadeOut actionWithDuration:0.0f];
    id wait1 = [CCDelayTime actionWithDuration:2];
    id _respawn = [CCCallBlock actionWithBlock:respawn];
    
    [self runAction:[CCSequence actions:die, opacity, wait1, _respawn, nil]];
    
}

-(void)kill { ///dont want player to die.

}










/////////////////
/////////////////////////



-(void)shootWithDirection:(int)direction {
    shoot = YES;
    [self shootWithDirection:direction Type:kbulletWalkingPlayer Origin:self];
}

-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    
    ///changing the bullet velocity based on dpad touch.
    JPad *pad = [JPad getPad];
    CGPoint vel = CGPointMake(3, 0);
    
    if (pad.touchUp) {
        vel.y = 1.0; //press up as well as left or right, bullets will rise with this vel.
        if (direction == kbulletDirectionZero) vel.y = 3.0; ////only pressing up, bullets go straight up faster.
    }

    Bullet *b1 = [Bullet bulletWithSpriteFrameName:shootBulletFile Power:shootStr Velocity:vel Direction:direction Movement:kbulletMoveStraight Type:type Origin:o ExplodeType:kExplodePlayerNormal];
    
    
    CCSprite *flash = [CCSprite spriteWithSpriteFrameName:@"playerGunFlash1.png"];
    NSArray *frames = [gs framesWithFrameName:@"playerGunFlash" fromFrame:1 toFrame:3];
    
    float yPos = self.position.y + 1.1;
    int xPos = 2 * self.scaleX;
    
    float flashX = self.contentSize.width + flash.contentSize.width/2 - 2;
    float flashY = self.contentSize.height/2 + 1;
    
    if (isJumping) { yPos = self.position.y + 3; flashY = self.contentSize.height/2 + 2; }
    if (isCrouching) { yPos = self.position.y - 1; flashY = self.contentSize.height/2 - 1; }
    
    if (  [JPad getPad].touchUp ) {  /////////////--------- CHANGING THE ANGLE OF THE BULLET
        
        if ( !( [JPad getPad].touchLeft || [JPad getPad].touchRight )  ) { //touch up with no direction
           
            b1.rotation = -90 * self.scaleX;
            flash.rotation = -90;
            
            
            xPos = -2 * self.scaleX;
            yPos = self.position.y + self.contentSize.height/2;
            
            flashX = self.contentSize.width/2;
            flashY = self.contentSize.height + flash.contentSize.height/2 - 1;
        
        }
        else { ///touching up with a direction.
            
            b1.rotation = -45 * self.scaleX;
            flash.rotation = -45;
            
            xPos = 0;
            yPos = self.position.y + 2;
            
            flashX = self.contentSize.width + flash.contentSize.width/2 - 3;
            flashY = self.contentSize.height/2 + 4;
        
        }
    }
    
    b1.position = ccp(self.position.x + xPos + (self.scaleX * (b1.contentSize.width/2)), yPos);
    b1.scaleX = self.scaleX;
    
    
    //////////------- THE FLASH OF THE BULLET
    
    void (^destroyFlash) (void) = ^{
        [flash removeFromParentAndCleanup:YES];
    };
    
    flash.position = ccp(flashX, flashY);
    
    [self addChild:flash];
    
    id animate = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.02]];
    id callblock = [CCCallBlock actionWithBlock:destroyFlash];
    
    [flash runAction:[CCSequence actionOne:animate two:callblock]];
    
    
    
    
    
    [parent_ addChild:b1];
    
}



-(void)addPowerUp:(int)type {
    if (currentPowerUpNode) {
        [currentPowerUpNode removeFromParentAndCleanup:YES];
        currentPowerUpNode = NULL;
    }
    currentPowerUpNode = [PowerUpNode powerupWithSpriteFrameName:@"powerUpBot1_Walking1.png" type:type];
    [parent_ addChild:currentPowerUpNode z:kZPowerup];
    
    powerup = type;
}

-(void)addBomb {
    gs.bombAmount += 1;
}






////////////////////
////////////////////
////////////////////----------- UPDATE ---------
////////////////////
////////////////////





-(void)update:(ccTime)dt {
    
    ///get the dpad and a,b buttons info.
    JPad *pad = [JPad getPad];
    
    
    
    ///// dont think this is necessary since when you land in a ship it gets set to currentShip.
    /*
    if (!currentShip) {
        for (Ship *s in gs._ships) {
            if (s.hasPlayer) {
                currentShip = s;
                break;
            }
        }
    }
    */
    
    
    if (isJumping || isWalking || isPunching) {
        gs.playerPos = self.position;
    } else {
        gs.playerPos = currentShip.position;
    }
    
    
    
    
    
    
    ///////////////////////////////TEST THIS
    if (jetPackRecharging) {
        if (jetPackRechargeTime > 0.0f) {
            jetPackRechargeTime -= gs.gameDelta;
        }
        else {
            jetPackRechargeTime = 0.0f;
            jetPackRecharging = NO;
            jetPackMeter = 100;
        }
    }
    
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////Jumping
    //foot positon
    double footY = self.position.y - (self.contentSize.height/2);
    footPosition = CGPointMake(self.position.x, footY);
    
    if (isJumping) {
        jumpTime = jumpTime + gs.gameDelta;
        if (isHoldingJump) {
            if (jumpTime >= maxHoldTime) {
                isHoldingJump = NO;
            }
        }
        else {
            ///// so you show the rocket as long as holding jump is true, so you feel like you're holding the rocket boost to ON!!!
            if (isRocketing) { ////you were rocketing but no longer holding jump so......
                ///////////////////////////////// START FALLING ANIMATION....
                isRocketing = NO;
                [self stopAllActions];
                NSMutableArray *fallFrames = [gs framesWithFrameName:@"playerFall" fromFrame:1 toFrame:7];
                fallAnim = [CCAnimation animationWithSpriteFrames:fallFrames delay:0.08f];
                [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallAnim]]];
            }
            
            //////////////////////////////////////////// SET THE VELOCITY OF THE JUMP every frame and make sure it stays within limits.
            velocity.y = velocity.y + acceleration.y;
            if (velocity.y >= maxVelocity.y) velocity = ccp(velocity.x, maxVelocity.y);
            else if (velocity.y <= -maxVelocity.y) velocity = ccp(velocity.x, -maxVelocity.y);
        }
        
        /////////////////////////////////////////////////   DOUBLE JUMP, once you let go of a you can hit is again and do a double jump. ONLY ONCE PER INITAL JUMP
        if (!didDoubleJump && !isHoldingA) {
            if (!isWalking) {
                if (pad.touchA) {
                    [self doubleJump];
                }
            }
        }
        
        self.position = ccp(self.position.x, self.position.y + velocity.y);
        
        
        /////land on ground if you're walking.
        if (isWalking) { ///////////////////////// anything for when you jump while walking and not from a ship.
            
            if (![playerGround isKindOfClass:[WallFlying class]]) { ////only do walking jump animations if you're on a normal wall
            
                ///////set display frames for pointing diagonal and up,
                if (pad.touchUp) {
                    if (pad.touchLeft || pad.touchRight) {
                        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerJumpUp.png"]];
                    }
                    else {
                        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerJumpStraightUp.png"]];
                    }
                }
                else {
                    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerJump.png"]];
                }
            
            }
            
            
            //// this has to be last in this if statement since landing is the last thing you do in a jump.
            if (footPosition.y < floorHeight) {
                [self landOnSameGround];
                self.position = ccp(self.position.x, floorHeight + self.contentSize.height/2);
            }
        }
        
        
    } else {
        isRocketing = NO;
    }
     
    
    ///////////////////////////// MOVING LEFT AND RIGHT
    if (canMove) {
        if (!isWalking) { ////////only if you're jumping from ships.
            if (pad.touchLeft) {
                self.scaleX = -1;
                self.position = ccp(self.position.x - velocity.x, self.position.y);
            }
            
            if (pad.touchRight) {
                self.scaleX = 1;
                self.position = ccp(self.position.x + velocity.x, self.position.y);
            }
        }
    }
    
    
    
    ///////////////////// DOING A ROLL AFTER LANDING, YOU MOVE FORWARD WITH THE ROLL.
    if (isRolling) {
        self.position = ccp(self.position.x + (1 * self.scaleX), self.position.y);
    }
    
    
    
    
    /////////////// When on ground walking.

    
    if ([playerGround isKindOfClass:[WallFlying class]]) {  //////////////////////////////// WHEN ON A FLYING GROUND. --- NO SHOOTING
        
        
        
        if (canMove) {
            if (pad.touchLeft || pad.touchRight) { /////start running animations or stop them.
                
                if (pad.touchLeft) {  /////moving left or right.
                    self.scaleX = -1;
                    self.position = ccp(self.position.x - velocity.x, self.position.y);
                }
                
                if (pad.touchRight) {
                    self.scaleX = 1;
                    self.position = ccp(self.position.x + velocity.x, self.position.y);
                }
                
                if (!isRunning) {
                    isRunning = YES;
                    [self runOnGroundAndPointUp:NO]; ///if touching up, gun will point up (AT START OF RUN)
                }
            }
            else {
                if (isRunning) {
                    [self stopRunOnGround];
                    isRunning = NO;
                }
            }
        }
        
        
        
        
        
        int groundX = playerGround.position.x;
        if (playerGround.parent != self.parent) { ///if the grounds parent is not the main game layer.
            groundX = groundX + playerGround.parent.position.x - playerGround.parent.contentSize.width/2;
        }
        //int leftWall = playerGround.position.x - playerGround.contentSize.width/2;
        leftWall = groundX - playerGround.contentSize.width/2;
        rightWall = leftWall + playerGround.contentSize.width;
        int leftSelf = self.position.x + self.contentSize.width/2;
        int rightSelf = leftSelf - self.contentSize.width;
        //if (leftSelf <= leftWall) //self.position = ccp(leftWall + self.contentSize.width/2, self.position.y);
        //if (rightSelf >= rightWall) //self.position = ccp(rightWall - self.contentSize.width/2, self.position.y);
        if ((leftSelf <= leftWall || rightSelf >= rightWall) && playerGround != NULL) {
            [self fall];
            /////////////if you walk out of the bounds of your current ground you fall.
        }

        
        
        
    }
    
    
    
    else if (isWalking) { ////////////////////////////////// -------------- WHEN ON A NORMAL GROUND. ------ SHOOTING AND POINTING ALOUD.
        
        
        
        ///////////////////////////////////////// RESPAWNING
        
        if (isRespawning) {
            if (respawnTimer >= 1.0f) {
                respawnTimer = 0.0f;
                self.opacity = 255;
                canCollide = YES;
                isRespawning = NO;
            }
            else {
                respawnTimer += gs.gameDelta;
            }
        }
        
        
       
        if (canMove) { ////// can't move then you can't do any of this shit.
        
            
            ////// FIGURING OUT THE BOUNDARIES OF THE GROUND YOURE WALKING ON.
            
            int groundX = playerGround.position.x;
            if (playerGround.parent != self.parent) { ///if the grounds parent is not the main game layer.
                groundX = groundX + playerGround.parent.position.x - playerGround.parent.contentSize.width/2;
            }
            //int leftWall = playerGround.position.x - playerGround.contentSize.width/2;
            leftWall = groundX - playerGround.contentSize.width/2;
            rightWall = leftWall + playerGround.contentSize.width;
            int leftSelf = self.position.x + self.contentSize.width/2;
            int rightSelf = leftSelf - self.contentSize.width;
            //if (leftSelf <= leftWall) //self.position = ccp(leftWall + self.contentSize.width/2, self.position.y);
            //if (rightSelf >= rightWall) //self.position = ccp(rightWall - self.contentSize.width/2, self.position.y);
            if ((leftSelf <= leftWall || rightSelf >= rightWall) && playerGround != NULL) {
                [self fall];
                
            }
            
            
            
            ///////   THE SHOOTING
            
            
            if (pad.touchB) {  ////B button shoots.
                if (!shoot) {
                    if (self.scaleX > 0) {
                        if (pad.touchUp && !pad.touchRight) {
                            [self shootWithDirection:kbulletDirectionZero];
                        }
                        else {
                            [self shootWithDirection:kbulletDirectionNormal];
                        }
                    }
                    else if (self.scaleX < 0) {
                        if (pad.touchUp && !pad.touchLeft) {
                            [self shootWithDirection:kbulletDirectionZero];
                        }
                        else {
                            [self shootWithDirection:kbulletDirectionNegativeX];
                        }
                    }
                }
                
            } else {
                shoot = NO;
            }
            
            
            
            
            
            
            
            ////////////// UP LEFT DOWN RIGHT  character animations.
            
            
            if (!pad.touchDown) {   ///////if you're not pressing down.
                
                if (isCrouching) { ////stop crouching if you are.
                    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerStand.png"]];
                    isCrouching = NO;
                }
                    
                if (pad.touchLeft || pad.touchRight) { /////start running animations or stop them.
                    
                    if (pad.touchLeft) {  /////moving left or right.
                        self.scaleX = -1;
                        self.position = ccp(self.position.x - velocity.x, self.position.y);
                    }
                    
                    if (pad.touchRight) {
                        self.scaleX = 1;
                        self.position = ccp(self.position.x + velocity.x, self.position.y);
                    }
                    
                    if (!isRunning) {
                        isRunning = YES;
                        [self runOnGroundAndPointUp:pad.touchUp]; ///if touching up, gun will point up (AT START OF RUN)
                    }
                    else {
                        if (pad.touchUp) {                  /////////if you point up MID RUN.
                            if (!isPointingUp) {
                                isPointingUp = YES;
                                [self runOnGroundAndPointUp:YES];
                            }
                        } else {
                            if (isPointingUp) {
                                isPointingUp = NO;
                                [self runOnGroundAndPointUp:NO];
                            }
                        }
                    }
                }
                else {
                    if (isRunning) {
                        [self stopRunOnGround];
                        isRunning = NO;
                    }
                }
                
                
            }
            else { ////////////////////// IF YOU ARE PRESSING DOWN.
                
                if (pad.touchLeft) {
                    self.scaleX = -1;
                }
                if (pad.touchRight) {
                    self.scaleX = 1;
                }
                if (!isCrouching) { /////////////if you're not crouching, you should since down is being pressed.
                    if (!isJumping) {
                        [self stopAllActions];
                        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerCrouch.png"]];
                        isCrouching = YES;
                        isRunning = NO;
                    }
                }
            }
            
            
            
            
            /////////////// if you touch up button , but no other buttons. then point the gun up.
            if (!isJumping) { ///// ONLY WHEN NOT JUMPING.
                if ( pad.touchUp && !(pad.touchLeft || pad.touchRight || pad.touchDown) ) {
                    if (!isPointingUpUp) {
                        isPointingUpUp = YES;
                        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerStandStraightUp.png"]];
                
                    }
                }
                else {
                    if (isPointingUpUp) {
                        isPointingUpUp = NO;
                        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playerStand.png"]];
                    }
                }
            }
        
            
            
            
        } //////// end if canMove .
        
        
        
    } ///////// end if isWalking
    
    
    
    
}










-(void)dealloc {
    [super dealloc];
}


@end
