//
//  Ship.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Ship.h"

#import "PlayerShip.h"
#import "Player.h"

#import "Cruiser.h"
#import "Destructable.h"
#import "Parts.h"
#import "PartsBar.h"

@implementation Ship

@synthesize canHavePlayer, hasPlayer, playerJumpedOut, playerHasBeenIn;
@synthesize playerJumpPos;
@synthesize justHitDmg;
@synthesize isCrashing, isDamageBlinking;
@synthesize hasEnemyPilot;


+(id)ship { //// what you call when you create an instance of a subclass.
    return [[[self alloc] init] autorelease];
}


-(id)initWithFileName:(NSString*)fileName startingHealth:(float)startHealth jumpPos:(CGPoint)jumpPos speed:(CGPoint)spd shootTime:(float)stime {
    
    
    if ((self = [super initWithFileName:fileName health:startHealth speed:spd shootTime:stime])) {
        
        shipStartingTexture = self.texture;
        startingTexRect = self.textureRect;
        
        //spriteRect = CGRectMake(self.contentSize.width, self.contentSize.height, self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2);
        
        afterLife = YES; ////so that once alive = no, they can still be hit.
        
        
        hasPlayer = NO;
        canHavePlayer = YES;
        playerHasBeenIn = NO;
        hasEnemyPilot = NO;
        
        playerJumpPos = jumpPos; ///the only property in init method not going to super init method.
        justHitDmg = 0;
        
        startH = startHealth;
        curH = startH;
        
        velocity = spd;
        initVelocity = velocity;
        
        canHoldShoot = NO;
        didShoot = NO;
        bulletTime = stime;
        bulletTimer = bulletTime;
        shootTime = -1;
        shootTimer = 0;
        delayShootTime = 0;
        delayShootTimer = delayShootTime;
        
        damageTime = 1.5;
        damageTimer = 0;
        isDamageBlinking = NO;
        
        isTargeted = NO;
        _targetedBy = [[CCArray alloc] init];
        
        
        
        killPoints = 1; ////change in subclass init method if ship is more points.
        partsType = kPartsLevel1; ////subclass init method if ship drops more parts.
        
        
        
        
        controlsBasic = YES;
        
        
        pad = [JPad getPad];
        
        
        [gs._ships addObject:self]; //// ADD TO SHIP ARRAY
        
        
        [self unschedule:@selector(updateShooter:)]; ////ships worry about themselves. and shoot differently from other shooters.
        
        [self schedule:@selector(updateShip:)];
    
    }
    
    
    return self;
}



///override all these methods for each ship.
-(void)player:(ccTime)dt {
}
-(void)noPlayer:(ccTime)dt {
}

///// dont know why this is here since any ship that shoots will override it anyway. what the fuck am i doing.
-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship {
    Shooter *s = (Shooter*)ship;
    [super shootWithDirection:direction Type:type Origin:s];
}



-(void)enemyShoot { ////call whenever you want to ship to shoot an enemy bullet.
    int dir = kbulletDirectionNegativeX;
    if (self.scaleX == -1) {
        dir = kbulletDirectionNormal;
    }
    [self shootWithDirection:dir Type:kbulletEnemy Ship:self];
}
-(void)playerShoot { /// when you want a player bullet.
    int dir = kbulletDirectionNormal;
    if (self.scaleX == -1) {
        dir = kbulletDirectionNegativeX;
    }
    [self shootWithDirection:dir Type:kbulletPlayer Ship:self];
}



-(void)hitByBullet:(float)strength {
    /////override this for each ship. otherwise all it will do is.
    [super hitByBullet:strength];
    /*
    if (hasPlayer) { ///set the players hp as well so the health bar adjusts. only if the ship getting hit has the player.
        gs.player.curH = curH;
    }
     */
    justHitDmg = strength;
    
    if (hasPlayer && !isDamageBlinking && strength >= kdamageBlinkingStrength) {
        isDamageBlinking = YES;
    }
    
}

-(void)damageBlinking { /////////damageblinking creates invulnerability
    if (isDamageBlinking) {
        float blinks = 15;
        float blinkTime = (damageTime/blinks)/2;
        id fadeOut = [CCFadeTo actionWithDuration:blinkTime opacity:50];
        id fadeIn = [CCFadeTo actionWithDuration:blinkTime opacity:255];
        id callfunc = [CCCallFunc actionWithTarget:self selector:@selector(damageBlinking)];
        [self runAction:[CCSequence actions:fadeOut, fadeIn, callfunc, nil]];
    }
}






-(void)dropParts {
    /*
    Parts *p = [Parts partsWithType:partsType];
    p.position = self.position;
    [parent_ addChild:p z:kZCollectables];
     */
    [[PartsBar getPartsBar] addParts:partsType];
}







-(void)kill {
    if (playerHasBeenIn) {
        isCrashing = YES;
    }
    [super kill]; /// [shooter kill] -> [self die] + [jsprite kill]
}
-(void)die {//////// gets called by [super kill]
    
    [super die]; /// [shooter die] removes targeting bullets.
    
    if (!playerHasBeenIn) {
        ////get chance to drop parts.
        //int chance = 25; //percent.
        //int randomNum = [gs randomNumberFrom:1 To:100];
        
        //if (randomNum <= chance) {
            [self dropParts];
        //}
        
    }
    
    if (!isCrashing) {
        [gs._ships removeObject:self];
        [parent_ removeChild:self cleanup:YES];
    }
}




//////////////////// SHIP COLLIDES WITH DIFFERENT OBJECTS.

-(void)didCollideWith:(JSprite *)sprite {
    [super didCollideWith:sprite];
    
    ////what happens when ships collide.
    BOOL isCollidable = [sprite isKindOfClass:[Ship class]];
    if (isCollidable && hasPlayer) {//only detect collision if you the ship has the player.
        Ship *s = (Ship*)sprite; ///cast sprite as ship.
        //write what happens to this ship (being the player's) and the enemy ship which is Ship* s.
        if (![s isKindOfClass:[PlayerShip class]]) { //dont do anything if you are colliding with the player's ship while in another ship.
            [self hitByBullet:20];
            [s hitByBullet:20];
        }
        
    }
}


-(void)updateShip:(ccTime)dt {
    
    
    
    
    ////////############========------- WHAT THE SHIP DOES WHETHER OR NOT THE PLAYER IS IN IT
    
    
    //////// ######################## SHIP BLINKS WHEN DAMAGED FOR 'damageTime' seconds. making it unable to be damaged doing that time.
    
    if (isDamageBlinking) {
        if (damageTimer == 0) {
            ////start the blinking animation
            [self damageBlinking];
            canCollide = NO;
        }
        damageTimer = damageTimer + dt;
        if (damageTimer >= damageTime) {
            damageTimer = 0;
            canCollide = YES;
            isDamageBlinking = NO;
        }
    }
    
    
    /////////##############======------- END DAMAGE BLINKING
    
    
    
    
    //////// ##########--------- CRASHING
        
    if (isCrashing) {
        //////start making ship move down and right slowly.
        self.position = ccp(self.position.x + 0.2f, self.position.y - 0.5f); ///move down more than right.
        if (self.position.y < -self.contentSize.height/2) {
            if ( ![self isKindOfClass:[PlayerShip class]] ) { //only die if you're not the player ship.
                isCrashing = NO;
                if (!hasPlayer) {
                    [self die];
                }
            }
            else {
                PlayerShip *p = (PlayerShip*)self;
                p.didCrash = YES;
            }
        }
        
    }
    /////////############======------ END CRASHING
    
    
    
    
    
    ////////////////################ IF THE PLAYER IS IN THE SHIP
    
    if (hasPlayer) { /////////// it's the player's ship.
        
        if (isMovementScheduled) {
            [self unscheduleShipMovement];
        }
        
        
        if (!playerHasBeenIn) {
            playerHasBeenIn = YES;
        
        }
        
        [self player:dt]; //method gets called every frame when the ship has the player. so put that logic in that method.
        
        
        
        
        
        
        
        
        if (alive) { //only let controls work if you're alive.
            
            ////############ TOUCH B TO SHOOT &&&&&&&&&&&&&&&&&&&&&
            if (canHoldShoot) { ///just hold the button down.
            
                if (pad.touchB) {    
                    bulletTimer = bulletTimer + dt;
                    if (bulletTimer >= bulletTime) {
                        [self playerShoot];
                        bulletTimer = 0;
                    }
                }
                else {
                    bulletTimer = bulletTime; ///reset so that when you first press shoot, it will shoot immediately.
                }
                
            }
            
            else { ///only fires once when button is pressed.
                
                if (pad.touchB) {
                    if (!didShoot) {
                        didShoot = YES;
                        [self shootWithDirection:kbulletDirectionNormal Type:kbulletPlayer Ship:self];
                    }
                }
                else {
                    didShoot = NO;
                }
            
            }
            
            
            
            
            //////// ###################### SHIP BOUNDARIES
            
            int bounds = 30;
            ////left side
            if (self.position.x <= bounds + 60 + self.contentSize.width/2) {
                self.position = ccp(bounds + 60 + self.contentSize.width/2, self.position.y);
            }
            ////right side
            if (self.position.x >= gs.winSize.width - bounds - self.contentSize.width/2) {
                self.position = ccp(gs.winSize.width - bounds - self.contentSize.width/2, self.position.y);
            }
            ////bottom side
            if (self.position.y <= bounds + 15 + self.contentSize.height/2) {
                self.position = ccp(self.position.x, bounds + 15 + self.contentSize.height/2);
                downTime = NO;
            }
            ////top side
            if (self.position.y >= gs.winSize.height - bounds - self.contentSize.height/2) {
                self.position = ccp(self.position.x, gs.winSize.height - bounds - self.contentSize.height/2);
                upTime = NO;
            }
        
            //////// ship basic controls. up down left right, and only move in that direction if your not touching that bound.
            if (controlsBasic) {
                if (pad.touchUp) {
                    if (self.position.y < 320 - bounds - self.contentSize.height/2) {
                        self.position = ccp(self.position.x, self.position.y + velocity.y);
                    }
                }
                if (pad.touchDown) {
                    if (self.position.y > bounds + self.contentSize.height/2) {
                        self.position = ccp(self.position.x, self.position.y - velocity.y);
                    }
                }
                if (pad.touchLeft) {
                    if (self.position.x > bounds + 60 + self.contentSize.width/2) {
                        self.position = ccp(self.position.x - velocity.x, self.position.y);
                    }
                }
                if (pad.touchRight) {
                    if (self.position.x < 480 - bounds - self.contentSize.width/2) {
                        self.position = ccp(self.position.x + velocity.x, self.position.y);
                    }
                }
                
                
                
                if (pad.touchUp) {  ///////################ TOUCHING UP AND DOWN MAKES THE SHIP CHANGE TEXTURE /////////
                    if (shipUpTexture) {
                        upTimer = upTimer + dt;
                        if (upTimer >= 0.2) {
                            upTime = YES;
                            if (self.texture != shipUpTexture) {
                                shipUpTexRect = CGRectZero;
                                shipUpTexRect.size = shipUpTexture.contentSize;
                                [shipUpTexture setAliasTexParameters];
                                [self setTexture:shipUpTexture];
                                [self setTextureRect:shipUpTexRect];
                            }
                            upTimer = 0;
                        }
                    }
                }
                else if (pad.touchDown) {
                    if (shipDownTexture) {
                        downTimer = downTimer + dt;
                        if (downTimer >= 0.2) {
                            downTime = YES;
                            if (self.texture != shipDownTexture) {
                                shipDownTexRect = CGRectZero;
                                shipDownTexRect.size = shipDownTexture.contentSize;
                                [shipDownTexture setAliasTexParameters];
                                [self setTexture:shipDownTexture];
                                [self setTextureRect:shipDownTexRect];
                            }
                            downTimer = 0;
                        }
                    }
                }
                else {
                    upTime = NO;
                    downTime = NO;
                    if(self.texture != shipStartingTexture || upTimer != 0 || downTimer != 0) {
                        [self setTexture:shipStartingTexture];
                        [self setTextureRect:startingTexRect];
                        upTimer = 0;
                        downTimer = 0;
                    }
                }

            } /////// END IF controls basic
            
            
         } /////// END IF  alive
    
    }/////// END IF hasplayer
    
    
    
    
    else { ///// ################ THE PLAYER IS NOT IN THE SHIP, IT'S AN ENEMY SHIP
     
        canColMove = NO;
        
        [self noPlayer:dt]; ////method gets called every frame when the ship does not have a player.
        
        
        
        ///////// kill the ship if it's out of bounds.
        if (lifeTimer >= 3) {
            if ((self.position.x < -self.contentSize.width/2 - 50) || (self.position.x > gs.winSize.width + self.contentSize.width/2 + 50)) {
                if ([self isKindOfClass:[Cruiser1 class]]) {
                    
                } else {
                    if ( ![self isKindOfClass:[PlayerShip class]] ) { ///dont destroy player ship.
                        [self die];
                    }
                }
            }
        } else {
            lifeTimer = lifeTimer + dt;
        }
        
        
        
        
        /////////// ############ =====-----  SHOOTING
        
        if (!playerHasBeenIn) { /////only shoot if the player hasn't been in that ship yet.
        
            if (bulletTime != -1) {   ///set to -1 if you don't want the ship to shoot unless told to.
                if (shootTime != -1) {
                    if (shootTimer < shootTime) {
                        shootTimer = shootTimer + dt;
                        bulletTimer = bulletTimer + dt;
                        if (bulletTimer >= bulletTime) {
                            [self enemyShoot];
                            bulletTimer = 0;
                        }
                    }
                    else {
                        delayShootTimer = delayShootTimer + dt;
                        if (delayShootTimer >= delayShootTime) {
                            shootTimer = 0;
                            delayShootTimer = 0;
                        }
                    }
                
                }
                
                else {
                    bulletTimer = bulletTimer + dt;
                    if (bulletTimer >= bulletTime) {
                        [self enemyShoot];
                        bulletTimer = 0;
                    }
                }
            }
            
        }
        
        ///////////// ######## =====------ END SHOOTING
        
        
        
    }
    
    
    
    
    
        
    
}

/////################################################
/////################################################
/////################################################
////////////////  SHIP MOVEMENTS  ///////////////////
/////################################################
/////################################################

-(void)scheduleShipMovement {
    [self schedule:currentScheduledMovement];
    isMovementScheduled = YES;
}
-(void)unscheduleShipMovement {
    [self unschedule:currentScheduledMovement];
    isMovementScheduled = NO;
}







-(void)moveRightToLeftWithY:(int)y {
    self.position = ccp(gs.winSize.width + self.contentSize.width/2, y);
    
    currentScheduledMovement = @selector(moveRightToLeft:);
    [self scheduleShipMovement];
}
-(void)moveRightToLeft:(ccTime)dt {
    self.position = ccp(self.position.x - velocity.x, self.position.y);
}



-(void)moveLeftToRightWithY:(int)y {
    self.position = ccp(-self.contentSize.width/2, y);
    self.scale = -1;
    currentScheduledMovement = @selector(moveLeftToRight:);
    [self scheduleShipMovement];
}
-(void)moveLeftToRight:(ccTime)dt {
    self.position = ccp(self.position.x + velocity.x, self.position.y);

}





-(void)moveBottomUpTo:(int)y {
    [self moveBottomUpTo:y withX:400];
}
-(void)moveBottomUpTo:(int)y withX:(int)x {
    self.position = ccp(x, 0 - self.contentSize.height/2);
    id move = [CCMoveTo actionWithDuration:1.5f position:ccp(self.position.x, y)];
    id movedone = [CCCallFunc actionWithTarget:self selector:@selector(moveBottomUpDone)];
    [self runAction:[CCSequence actions:move, movedone, nil]];
}
-(void)moveBottomUpDone {
    [self schedule:@selector(moveRightToLeft:)]; //////now move from right to left after entering scene. a very common movement.
}





//////////    #######   SIN WAVE

-(void)moveSinWaveWithY:(int)y {
    self.position = ccp(gs.winSize.width + self.contentSize.width/2, y);
    moveY = y;
    currentScheduledMovement = @selector(moveSinWave:);
    [self scheduleShipMovement];
}
-(void)moveSinWaveFromLeftWithY:(int)y {
    self.position = ccp(-self.contentSize.width/2, y);
    moveY = y;
    self.scaleX = -1;
    currentScheduledMovement = @selector(moveSinWave:);
    [self scheduleShipMovement];
}
-(void)moveSinWave:(ccTime)dt {
    ///move
    int nextX = self.position.x - (self.scaleX)*velocity.x; ///based off scale so -scale makes velocity go the other way.
    double sinY = self.position.x/50;
    int nextY = moveY + (sin(sinY) * 30);
    self.position = ccp(nextX, nextY);
}


///////////  ########### COS WAVE  --- to complement sin.   //////Since cos and sin are only half a wavelength different I need to subtract half a wavelength from cos to make them equal and opposite.
-(void)moveCosWaveWithY:(int)y {
    self.position = ccp(gs.winSize.width + self.contentSize.width/2, y);
    moveY = y;
    currentScheduledMovement = @selector(moveCosWave:);
    [self scheduleShipMovement];
}
-(void)moveCosWaveFromLeftWithY:(int)y {
    self.position = ccp(-self.contentSize.width/2, y);
    moveY = y;
    self.scaleX = -1;
    currentScheduledMovement = @selector(moveCosWave:);
    [self scheduleShipMovement];
}
-(void)moveCosWave:(ccTime)dt {
    ///move
    int nextX = self.position.x - (self.scaleX)*velocity.x; ///based off scale so -scale makes velocity go the other way.
    double cosY = self.position.x/50 + M_PI_2; /////adding pi/2 offsets the cos wave to be in sync yet opposite the sin wave.
    int nextY = moveY + (cos(cosY) * 30);
    self.position = ccp(nextX, nextY);
}



////////  ########## move with a sqaure root curve.
-(void)moveRootCurveWithY:(int)y {
    double adjustX = 40;
    double adjustY = y - sqrt(0.5*adjustX);
    moveY = adjustY;
    self.position = ccp(gs.winSize.width + self.contentSize.width + self.contentSize.width/2, moveY);
    currentScheduledMovement = @selector(moveRootCurve:);
    [self scheduleShipMovement];
}
-(void)moveRootCurve:(ccTime)dt {
    
    double convertX = (gs.winSize.width + self.contentSize.width - self.position.x); ///so the numbers increase and made into a much smaller number.
    double srX = sqrt(0.5*convertX);
    double calculateY = (srX * 15) + moveY;
    float newY = (float)calculateY; ///use a float instead.
    int newX = self.position.x - velocity.x;
    self.position = ccp(newX, newY);
}


//////////// ######## move from one corner to another.
-(void)moveCornerToCornerFromQuadrant:(int)q1 toQuadrant:(int)q2 {
    int testQ = abs(q1-q2);
    if (testQ != 2 || q1 > 4 || q1 < 1 || q2 > 4 || q2 < 1) {
        NSLog(@"invalid quadrant input");
        return;
    }
    
    if (q1 == 1 && q2 == 3) {
        fromX = gs.winSize.width+self.contentSize.width/2;
        fromY = gs.winSize.height+self.contentSize.height/2;
        directionX = -1;
        directionY = -1;
    }
    else if (q1 == 3 && q2 == 1) {
        fromX = -self.contentSize.width/2;
        fromY = -self.contentSize.height/2;
        directionX = 1;
        directionY = 1;
    }
    else if (q1 == 2 && q2 == 4) {
        fromX = -self.contentSize.width/2;
        fromY = gs.winSize.height + self.contentSize.height/2;
        directionX = 1;
        directionY = -1;
    }
    else if (q1 == 4 && q2 == 2) {
        fromX = gs.winSize.width + self.contentSize.width/2;
        fromY = -self.contentSize.height/2;
        directionX = -1;
        directionY = 1;
    }
    
    self.position = ccp(fromX, fromY);
    self.scaleX = -directionX;
    
    currentScheduledMovement = @selector(moveCornerToCorner:);
    [self scheduleShipMovement];
}
-(void)moveCornerToCorner:(ccTime)dt {
    float ratio = gs.winSize.height/gs.winSize.width;
    float velX = velocity.x * directionX;
    float velY = velocity.x * ratio * directionY;
    self.position = ccp(self.position.x + velX, self.position.y + velY);
}



-(void)moveSemiCircleFromTop {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2 - 80, gs.winSize.height+self.contentSize.height/2);
    float velX = 2;
    float timeY = 5; ///seconds.
    float velY = (gs.winSize.height / (60 * timeY));
    velocity = ccp(velX, velY);
    currentScheduledMovement = @selector(moveSemiCircle:);
    [self scheduleShipMovement];
}
-(void)moveSemiCircleFromBottom {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2 - 50, -self.contentSize.height/2);
    float velX = 2;
    float timeY = 5; ///seconds.
    float velY = (gs.winSize.height / (60 * timeY));
    velocity = ccp(velX, -velY);
    currentScheduledMovement = @selector(moveSemiCircle:);
    [self scheduleShipMovement];
}
-(void)moveSemiCircle:(ccTime)dt {
    self.position = ccp(self.position.x - velocity.x, self.position.y - velocity.y);
    float xAccel = 0.012;
    self.velocity = ccp(self.velocity.x - xAccel, self.velocity.y);
}



-(void)moveEnterFromRightAndStopWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    currentScheduledMovement = @selector(moveEnterFromRightAndStop:);
    [self scheduleShipMovement];
}
-(void)moveEnterFromRightAndStop:(ccTime)dt {
    BOOL targetX = self.position.x <= gs.winSize.width-100;
    if (!targetX) {
        self.position = ccp(self.position.x - velocity.x, self.position.y);
    }
}


-(void)moveEnterFromTopLeftAndDown {
    self.position = ccp(-self.contentSize.width/2, gs.winSize.height-self.contentSize.width/2);
    currentScheduledMovement = @selector(moveEnterFromTopLeftAndDown:);
    [self scheduleShipMovement];
}
-(void)moveEnterFromTopLeftAndDown:(ccTime)dt {
    BOOL targetX = self.position.x >= (gs.winSize.width/3)*2;
    if (!targetX) {
        self.position = ccp(self.position.x + velocity.x, self.position.y);
    }
    else {
        self.position = ccp(self.position.x, self.position.y - velocity.y);
    }
}

-(void)moveEnterFromBottomLeftAndUp {
    self.position = ccp(-self.contentSize.width/2, self.contentSize.width/2+50);
    currentScheduledMovement = @selector(moveEnterFromBottomLeftAndUp:);
    [self scheduleShipMovement];
}
-(void)moveEnterFromBottomLeftAndUp:(ccTime)dt {
    BOOL targetX = self.position.x >= (gs.winSize.width/3)*2;
    if (!targetX) {
        self.position = ccp(self.position.x + velocity.x, self.position.y);
    }
    else {
        self.position = ccp(self.position.x, self.position.y + velocity.y);
    }
}


-(void)moveEnterAndLeaveWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    currentScheduledMovement = @selector(moveEnterAndLeave:);
    [self scheduleShipMovement];
}
-(void)moveEnterAndLeave:(ccTime)dt {
    BOOL targetX = self.position.x <= (gs.winSize.width/3)*2;
    if (targetX) {
        float accelX = 0.025;
        velocity = ccp(velocity.x - accelX, velocity.y); ///change in vel causes ship to slow down, stop and reverse.
    }
    self.position = ccp(self.position.x - velocity.x, self.position.y);
}


-(void)moveEnterSemiCircleExitWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    velocity = ccp(velocity.x, 1);
    currentScheduledMovement = @selector(moveEnterSemiCircleExit:);
    [self scheduleShipMovement];
}
-(void)moveEnterSemiCircleExit:(ccTime)dt {
    BOOL targetX = self.position.x <= (gs.winSize.width/3)*2;
    if (targetX) {
        float accelX = 0.05;
        velocity = ccp(velocity.x - accelX, velocity.y); ///slow down x velocity and reverse.
        self.position = ccp(self.position.x, self.position.y - velocity.y); ///move down in y pos.
    }
    self.position = ccp(self.position.x - velocity.x, self.position.y);
}



-(void)moveFollowPlayerWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    currentScheduledMovement = @selector(moveFollowPlayer:);
    [self scheduleShipMovement];
}
-(void)moveFollowPlayer:(ccTime)dt {
    Ship *playerShip = NULL;
    Ship *s;
    CCARRAY_FOREACH(gs._ships, s) {
        if (s.hasPlayer) {
            playerShip = s;
            break;
        }
    }
    float velY = 0;
    if (playerShip) {
        BOOL isPlayerAbove = playerShip.position.y - 10 > self.position.y;
        BOOL isPlayerBelow = playerShip.position.y + 10 < self.position.y;
        if (isPlayerAbove) {
            velY = -velocity.y;
        }
        else if (isPlayerBelow) {
            velY = velocity.y;
        }
        else {
            velY = 0;
        }
    }
    self.position = ccp(self.position.x - velocity.x, self.position.y - velY);
}



-(void)moveStepUpWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    velocity = ccp(velocity.x, -2);
    toY = y + 60;
    currentScheduledMovement = @selector(moveStep:);
    [self scheduleShipMovement];
}
-(void)moveStepDownWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    velocity = ccp(velocity.x, 2);
    toY = y - 60;
    currentScheduledMovement = @selector(moveStep:);
    [self scheduleShipMovement];
}
-(void)moveStep:(ccTime)dt {
    BOOL targetX = self.position.x <= (gs.winSize.width/3)*2;
    BOOL targetY = self.position.y >= toY;
    if (velocity.y >= 0) targetY = self.position.y <= toY;
    if (!targetX || targetY) {
        self.position = ccp(self.position.x - velocity.x, self.position.y);
    }
    else {
        self.position = ccp(self.position.x, self.position.y - velocity.y);
    }
}



-(void)moveSplitDiagonalUpWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    velocity = ccp(velocity.x, -velocity.x);
    currentScheduledMovement = @selector(moveSplitDiagonal:);
    [self scheduleShipMovement];
}
-(void)moveSplitDiagonalDownWithY:(int)y {
    self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
    velocity = ccp(velocity.x, velocity.x);
    currentScheduledMovement = @selector(moveSplitDiagonal:);
    [self scheduleShipMovement];
}
-(void)moveSplitDiagonal:(ccTime)dt {
    BOOL targetX = self.position.x <= (gs.winSize.width/3)*2;
    if(!targetX) {
        self.position = ccp(self.position.x - velocity.x, self.position.y);
    }
    else {
        self.position = ccp(self.position.x - velocity.x, self.position.y - velocity.y);
    }
}



-(void)dealloc {
    [_targetedBy release];
    _targetedBy = nil;
    
    [super dealloc];
}

@end












