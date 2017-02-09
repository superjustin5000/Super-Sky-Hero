//
//  Bullet.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/8/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Bullet.h"

#import "Explode.h"

#import "Ship.h"
#import "GroundTurret.h"
#import "Enemy.h"
#import "Player.h"

@class PlayerShip;

@implementation Bullet

@synthesize origin;
@synthesize hasOrigin;
@synthesize strength;
@synthesize type;
@synthesize isFollowingTarget;

+(id)bulletWithSpriteFrameName:(NSString*)framename Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode {
    return [[[self alloc] initWithSpriteFrameName:framename Power:power Velocity:vel Direction:direction Movement:(int)movement Type:bType Origin:o ExplodeType:explode] autorelease];
}

+(id)bulletWithFile:(NSString *)fileName Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode {
    return [[[self alloc] initWithFile:fileName Power:power Velocity:vel Direction:direction Movement:(int)movement Type:bType Origin:o ExplodeType:explode] autorelease];
}

-(id)initWithFile:(NSString *)fileName Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode {
    
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:fileName];
    CGRect theRect = CGRectZero;
    theRect.size = texture.contentSize;
    
    if ((self = [super initWithTexture:texture rect:theRect])) {
        
        spriteRect.origin = CGPointMake(o.position.x, o.position.y);  //// I am genuinly confused by this line! WTF!
        
        //drawRects = YES;
        
        strength = power;
        maxVelocity = initVelocity = velocity = vel;
        moveDirection = direction;
        moveType = movement;
        type = bType;
        explodeType = explode;
        origin = o;
        hasOrigin = YES;
        
        
        [self initBullet];
        
    }
    
    return self;
}







-(id)initWithSpriteFrameName:(NSString *)framename Power:(float)power Velocity:(CGPoint)vel Direction:(int)direction Movement:(int)movement Type:(int)bType Origin:(CCSprite *)o ExplodeType:(int)explode {
    
    
    if ((self = [super initWithSpriteFrameName:framename])) {
        
        
        
        spriteRect.origin = CGPointMake(o.position.x, o.position.y);  //// I am genuinly confused by this line! WTF!
        
        //drawRects = YES;
        
        strength = power;
        maxVelocity = initVelocity = velocity = vel;
        moveDirection = direction;
        moveType = movement;
        type = bType;
        explodeType = explode;
        origin = o;
        hasOrigin = YES;
        
        
        [self initBullet];
        
        //drawRects = YES;
        
        
    }
    return self;
    
}









-(void)initBullet {
    
    
    [self unschedule:@selector(updateJSprite:)];
    
    
    
    
    
    
    switch (moveType) {
        case kbulletMoveStraight:
            [self moveNormal];
            break;
        case kbulletMoveHoming:
            [self moveHoming];
            break;
        case kbulletMoveLaser:
            [self moveLaser];
            break;
            
        default:
            [self moveNormal];
            break;
    }
    
    
    
    ///////////// ------------------------    IF THE BULLET WILL BE ANIMATED
    switch (type) {
        case kbulletWalkingEnemy:
            [self setAnimationWithFrameName:@"bulletEnemy" fromFrame:1 toFrame:3 withReverse:YES andRepeat:YES];
            break;
        case kbulletWalkingPlayer:
            [self setAnimationWithFrameName:@"playerWalkingBullet" fromFrame:1 toFrame:3 withReverse:YES andRepeat:YES];
            break;
        default:
            break;
    }
    
    
    ////////// ------------------------------------------------------------------------
    
    
    
    
    [self scheduleUpdate];
    
    
    [gs._bullets addObject:self];
}




-(void)moveNormal {
    switch (moveDirection) {
        case kbulletDirectionNegativeX:
            velocity = CGPointMake(velocity.x * -1, velocity.y);
            break;
        case kbulletDirectionNegativeY:
            velocity = CGPointMake(velocity.x, velocity.y * -1);
            break;
        case kbulletDirectionNegativeXandY:
            velocity = CGPointMake(velocity.x * -1, velocity.y * -1);
            break;
        case kbulletDirectionZero:
            velocity = CGPointMake(0, velocity.y);
            break;
        default:
            break;
    }
    maxVelocity = velocity;
}

-(void)moveHoming {
    
    if (type == kbulletPlayer || type == kbulletPowerup || type == kbulletWalkingPlayer || type == kbulletWalkingPowerup) { /// if the ship shot has the player.
        ///find the closest enemy.
        float closestX = gs.winSize.width;
        float closestY = gs.winSize.height;
        float closestDistance = sqrtf((closestX*closestX) + (closestY*closestY));
        
        
        if (type == kbulletPlayer || type == kbulletPowerup) {  ///homing bullet fired from ship.
            
            Ship *closestTarget = NULL;
            Ship *s;
            
            BOOL shipsInFront = NO;
            float distX = -1;
            CCARRAY_FOREACH(gs._ships, s) { ///check if any ships are in front. so that if there are none in front, you definitely shoot the ones behind you.
                if (s != origin && !s.hasPlayer && !s.playerHasBeenIn) {
                    distX = s.position.x - origin.position.x;
                    if (distX > 0) shipsInFront = YES; ///as soon as any ships diff in distance is greater than 0, there are ships in front, so break the loop.
                    break;
                }
            }
            
            CCARRAY_FOREACH(gs._ships, s) {
                if (s != origin && !s.hasPlayer && !s.playerHasBeenIn) { ///dont shoot at the own ship.
                    
                    float distanceX = (s.position.x - origin.position.x);
                    float distanceY = (s.position.y - origin.position.y);
                    float distanceX_2 = distanceX * distanceX;
                    float distanceY_2 = distanceY * distanceY;
                    float distance = sqrtf(distanceX_2 + distanceY_2);
                    
                    BOOL closerActualDistance = distance <= closestDistance;
                    //BOOL closerX = distanceX <= closestX;
                    //BOOL closerY = distanceY <= closestY;
                    BOOL tooFarBehind = distanceX <= -40; /////may have to play with the number.
                    
                    if (shipsInFront) {
                        if (closerActualDistance && !tooFarBehind) {
                            closestDistance = distance;
                            closestTarget = s;
                        }
                    }
                    else {
                        if (closerActualDistance) {
                            closestDistance = distance;
                            closestTarget = s;
                        }
                    }
                    
                }
            }
            
            if (closestTarget != NULL) { ///if closest ship is found. (otherwise there are probably no ships.)
                acceleration = CGPointMake(0.8,0.8);
                maxVelocity = ccp(velocity.x, velocity.x);
                closestTarget.isTargeted = YES; //let ship know it's targeted.
                [closestTarget._targetedBy addObject:self]; //add bullet to array of bullets targeting that ship.
                target = closestTarget;
                isFollowingTarget = YES; //tell bullet it's following a target.
            }
            else {
                target = NULL;
            }
            
            
       
        } ////END IF PLAYER OR POWER UP which means it was shot while flying.
        ////if it was shot while walking.
        else if (type == kbulletWalkingPlayer || type == kbulletWalkingPowerup) {
            Enemy *closestTarget = NULL;
            Enemy *s;
            
            float distanceX;
            float distanceY;
            CCARRAY_FOREACH(gs._enemies, s) {
                //if (s != origin) { ///dont shoot at self.
                    
                    distanceX = (s.position.x - origin.position.x);
                    distanceY = (s.position.y - origin.position.y);
                    float distanceX_2 = distanceX * distanceX;
                    float distanceY_2 = distanceY * distanceY;
                    float distance = sqrtf(distanceX_2 + distanceY_2);
                    
                    BOOL closerActualDistance = distance <= closestDistance;
                    //BOOL closerX = distanceX <= closestX;
                    //BOOL closerY = distanceY <= closestY;
                    
                    if (closerActualDistance) {
                        closestDistance = distance;
                        closestTarget = s;
                    }
                    
                //}
            }
            
            if (closestTarget != NULL) { ///if closest ship is found. (otherwise there are probably no ships.)
                
                acceleration = CGPointMake(0.8,0.8);
                maxVelocity = ccp(velocity.x, velocity.x);
                closestTarget.isTargeted = YES; //let ship know it's targeted.
                [closestTarget._targetedBy addObject:self]; //add bullet to array of bullets targeting that ship.
                target = closestTarget;
                isFollowingTarget = YES; //tell bullet it's following a target.
            }
            
            else {
                target = NULL;
            }
            
        } ////// END IF WALKING PLAYER OR WALKING POWER UP so it was shot while walking.
        
    }



    else if (type == kbulletEnemy) { ///an enemy shoots homing bullet at whatever ship the player is currently in.
        
        Player *player = (Player*)gs.player;
        target = player.currentShip;
        
        CGPoint shipPos;
        if (hasOrigin) {
            shipPos = origin.position; ///get position of ship that shot the bullet
        }
        else {
            shipPos = self.position;
        }
        int dx = gs.playerPos.x - shipPos.x; ////subtracting this way so that a ship to the right will make the bullet go left.
        int dy = gs.playerPos.y - shipPos.y; ////and a ship below will make the bullet go up.
        float ratio = (float)abs(dy)/(float)abs(dx); /// dy over dx so the ratio will be multiplied by y. since y is mostly 0.
        
        float scaleXratio = (float)abs(dx) / gs.winSize.width;
        float velX = velocity.x * scaleXratio;
        
        float velY = velX*ratio;
        int dirX = 1;
        int dirY = 1;
        if (dx != 0) { dirX = dx/(abs(dx)); } ///this will produce either 1 or -1;
        if (dy != 0) { dirY = dy/(abs(dy)); } ///same thing.
        velX = velX * dirX;
        velY = velY * dirY;
        
        velocity = CGPointMake(velX, velY);
        maxVelocity = velocity;
        
    }
    
    else {
        velocity = CGPointMake(velocity.x * -1, velocity.y);
        maxVelocity = velocity;
    }
}





-(void)moveLaser {
    maxVelocity = initVelocity = velocity = ccp(0,0);
    self.anchorPoint = ccp(0,0);
    
    int posX = origin.contentSize.width/2 + 2;
    if (origin.scaleX < 0) {
        posX = -posX;
        self.scaleX = -1;
    }
    self.position = ccp(origin.position.x + posX, origin.position.y - 5);
    [self schedule:@selector(shootLaser:)];
}

-(void)shootLaser:(ccTime)dt {
    if (laserTimer >= 0.5) {
        laserTimer = 0;
        [self stopLaser];
    }
    else {
        laserTimer += dt;
    }
}
-(void)stopLaser {
    [self destroyBullet];
}




/////////////
///////////// ------------   END MOVE TYPES ------ >>>>>>>>>>>>>>










-(CGRect)newSpriteRect {
    if (moveType == kbulletMoveLaser) {
        if (origin.scaleX < 0) {
            return CGRectMake(self.position.x - self.contentSize.width, self.position.y, self.contentSize.width, self.contentSize.height);
        }
        else {
            return spriteRect;
        }
    }
    else {
        return spriteRect;
    }
}




-(void)checkCollisions { ///overrided to only check collisions with ships.

    if (type == kbulletPlayer || type == kbulletPowerup) {
        Ship *s;
        CCARRAY_FOREACH(gs._ships, s) {
            if (s.canCollide && !s.playerHasBeenIn && s != origin) {
                if (CGRectIntersectsRect(spriteRect, s.spriteRect)) { //can hit enemy ship but not origin ship or ships player has been in.
                    [self hitShip:s];
                    [s hitByBullet:strength];
                    break;
                }
            }
        }
        Shooter *s2;
        CCARRAY_FOREACH(gs._otherShooters, s2) {
            if (s2.canCollide) {
                if (CGRectIntersectsRect(spriteRect, s2.spriteRect)) {
                    [self hitShip:s2];
                    [s2 hitByBullet:strength];
                    break; ////breaking stops the loop. ensuring that
                }
            }
        }
    }
    else if (type == kbulletEnemy) {
        Ship *s;
        CCARRAY_FOREACH(gs._ships, s) {
            if (s.canCollide && s.playerHasBeenIn && s != origin) {
                if(CGRectIntersectsRect(spriteRect, s.spriteRect)) { ///can hit ships player has been in but not origin ship.
                    [self hitShip:s];
                    [s hitByBullet:strength];
                    break;
                }
            }
        }
    }
    else if (type == kbulletWalkingPlayer || type == kbulletWalkingPowerup) {
        Enemy *e;
        CCARRAY_FOREACH(gs._enemies, e) {
            if (e.canCollide) {
                if (CGRectIntersectsRect(spriteRect, e.spriteRect)) {
                    [self hitShip:e]; ////don't destroy the laser if it hits the ship.
                    [e hitByBullet:strength];
                    
                    if (e.curH <= 0) {
                        if (e.scaleX > 0) {
                            if (e.position.x < self.position.x) {
                                e.scaleX = -1;
                            }
                        }
                        else {
                            if (e.position.x > self.position.x) {
                                e.scaleX = 1;
                            }
                        }
                    }
                    
                    break;
                }
            }
        }
    }
    else if (type == kbulletWalkingEnemy) {
        Player *player = (Player*)gs.player;
        if (player.canCollide) {
            if (CGRectIntersectsRect(player.spriteRect, spriteRect)) {
                [self hitShip:player];
                [player hitByBullet:0];
                [player die];
                
                if (player.scaleX > 0) {
                    if (player.position.x > self.position.x) {
                        player.scaleX = -1;
                    }
                }
                else {
                    if (player.position.x < self.position.x) {
                        player.scaleX = 1;
                    }
                }
            }
        }
    }
    
}

-(void)hitShip:(JSprite *)targetHit {
    
    CGPoint explodePos = self.position;
    BOOL destroy = YES;
    
    if (moveType == kbulletMoveLaser) {
        int randomXStart = targetHit.position.x - targetHit.contentSize.width/2;
        int randomXEnd = targetHit.position.x + targetHit.contentSize.width/2;
        if (randomXEnd >= gs.winSize.width) randomXEnd = gs.winSize.width;
        int randomX = [gs randomNumberFrom:randomXStart To:randomXEnd];
        explodePos = ccp(randomX, self.position.y);
        destroy = NO;
    }
    
    Explode *e = [Explode ExplodeWithType:explodeType];
    [parent_ addChild:e z:kZExplode];
    e.position = explodePos;
    [e explode];
    
    if (destroy) [self destroyBullet];
    
}


-(void)destroyBullet {
    if (isFollowingTarget) {
        if ([gs._ships containsObject:target] || [gs._enemies containsObject:target]) { ///if the target exists.
            Shooter *theTarget = (Shooter*)target;
            [theTarget._targetedBy removeObject:self];
            isFollowingTarget = NO;
        }
    }
    
    [self kill];
    [gs._bullets removeObject:self];
    [parent_ removeChild:self cleanup:YES];
}


-(void)update:(ccTime)dt {
    
    if (moveType == kbulletMoveLaser) {
        int posX = origin.contentSize.width/2 + 2;
        self.scaleX = 1;
        if (origin.scaleX < 0) {
            posX = -posX;
            self.scaleX = -1;
        }
        self.position = ccp(origin.position.x + posX, origin.position.y - 1);
    }
    
    else {
        if (moveType == kbulletMoveHoming) {
            if (target == NULL) [self moveHoming];
        }
        if (isFollowingTarget) { ////homing bullets constantly adjust veloctiy based on target position.
            
            if ([gs._ships containsObject:target] || [gs._enemies containsObject:target]) {
                Shooter *theTarget = (Shooter*)target;
                ////////// SETTING THE VELOCITY OF THE BULLET.
                
                int dirX = 1;
                int dirY = 1;
                
                
                if (theTarget.position.x < self.position.x) dirX = -1;
                if (theTarget.position.y < self.position.y) dirY = -1;
                float velX = velocity.x + (acceleration.x * dirX);
                float velY = velocity.y + (acceleration.y * dirY);
                
                /////control max x vel.
                if (moveDirection == kbulletDirectionNegativeX) { /////////regular max vel is negative.
                    if (velX <= maxVelocity.x) {
                        velX = maxVelocity.x;
                    }
                    else if (velX >= -maxVelocity.x) {
                        velX = -maxVelocity.x;
                    }
                    /////control max y vel.
                    if (velY <= maxVelocity.y) {
                        velY = maxVelocity.y;
                    }
                    else if (velY >= -maxVelocity.y) {
                        velY = -maxVelocity.y;
                    }
                }
                else { ////////////////////////////////////////////// regular max vel is positive.
                    if (velX >= maxVelocity.x) {
                        velX = maxVelocity.x;
                    }
                    else if (velX <= -maxVelocity.x) {
                        velX = -maxVelocity.x;
                    }
                    /////control max y vel.
                    if (velY >= maxVelocity.y) {
                        velY = maxVelocity.y;
                    }
                    else if (velY <= -maxVelocity.y) {
                        velY = -maxVelocity.y;
                    }
                }
                
                velocity = CGPointMake(velX, velY);
                
                
                ////////// SETTING THE ANGLE OF THE BULLET.
                float angle = atan2f(velocity.y, velocity.x); if (angle < 0) { angle = -angle; angle = 3.14 + (3.14 - angle); } ///getting the radians right
                angle = angle * 180 / 3.14; ////turning it into degrees.
                
                self.rotation = -angle;
            }
            
        }
        self.position = ccp(self.position.x + velocity.x, self.position.y + velocity.y); ///move bullet based on x and y velocity.
        
        ///if bullet goes outside screen border, kill it.
        BOOL outsideH = self.position.x >= gs.winSize.width+self.contentSize.width || self.position.x <= -self.contentSize.width;
        BOOL outsideV = self.position.y >= gs.winSize.height+self.contentSize.height || self.position.y <= -self.contentSize.height;
        if (outsideH || outsideV) {
            [self destroyBullet];
        }
    }
    
    
        
}







-(void)addSmokeWithType:(int)t {
    BulletSmoke *b = [BulletSmoke smokeWithType:t andParent:parent_];
    [self addChild:b];
}








-(void)dealloc {
    [super dealloc];
}


@end

























@implementation BulletSmoke

+(id)smokeWithType:(int)type andParent:(CCNode *)p {
    return [[[self alloc] initWithType:type andParent:p] autorelease];
}

-(id)initWithType:(int)type andParent:(CCNode *)p {
    if ((self = [super init])) {
        smokeParent = p;
        smokeTime = 0.03f;
        [self scheduleUpdate];
    }
    return self;
}


-(void)update:(ccTime)delta {
    
    if (smokeTimer >= smokeTime) {
        
        smokeTimer = 0.0f;
        
        ////make another smoke particle.
        CCSprite *s = [CCSprite spriteWithSpriteFrameName:@"bulletTrail1.png"];
        s.position = ccp(parent_.position.x - parent_.contentSize.width/2, parent_.position.y);
        [smokeParent addChild:s];
        
        void (^removeSmoke)(void) = ^{
            [s removeFromParentAndCleanup:YES];
        };
        
        id shrink = [CCScaleTo actionWithDuration:0.7f scale:0];
        id fade = [CCFadeOut actionWithDuration:0.7f];
        id remove = [CCCallBlock actionWithBlock:removeSmoke];
        
        [s runAction:shrink];
        [s runAction:[CCSequence actionOne:fade two:remove]];
        
    }
    else {
        smokeTimer += delta;
    }
    
}




-(void)dealloc {
    [super dealloc];
}

@end


