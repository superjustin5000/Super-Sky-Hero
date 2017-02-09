//
//  PowerUp.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/22/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "PowerUp.h"

#import "Ship.h"
#import "Player.h"
#import "Bullet.h"
#import "Enemy.h"


static CCArray *_powerups;



@implementation PowerUp

@synthesize powerupType;


+(CCArray*)getPowerups {
    if (_powerups == NULL)
        _powerups = [[CCArray alloc] init];
    return _powerups;
}
+(void)removeFromPowerups:(PowerUp *)p {
    [_powerups removeObject:p];
}





+(id)powerUpWithType:(int)type {
    return [[[self alloc] initWithType:type] autorelease];
}

-(id)initWithType:(int)type {
    
    //////get a particular image file based on the type.
    NSString *file;
    
    switch (type) {
        case kPowerupNone:
            break;
        case kPowerupHoming:
            file = @"powerupTest.png";
            break;
        case kPowerupLaser:
            file = @"powerupTest.png";
            break;
            
        default:
            break;
    }
    
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:file];
    CGRect rect = CGRectZero;
    rect.size = tex.contentSize;
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:tex rect:rect];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:file];
    
    if ((self = [super initWithSpriteFrameName:file])) {
        
        powerupType = type;
        velocity = ccp(1,0);
        
        [_powerups addObject:self];
        
        [self scheduleUpdate];
        
    }
    
    
    return self;
    
}

-(void)destroyJSprite {
    [PowerUp removeFromPowerups:self];
    [super destroyJSprite];
}


-(void)checkCollisions {
    
    Player *player = (Player*)gs.player;
    
    Ship *s;
    CCARRAY_FOREACH(gs._ships, s) {
        if (s.hasPlayer) {
            if (CGRectIntersectsRect(spriteRect, s.spriteRect)) {
                [player addPowerUp:powerupType];
                [self destroyJSprite];
            }
        }
    }
    
    if (CGRectIntersectsRect(spriteRect, player.spriteRect)) {
        [player addPowerUp:powerupType];
        [self destroyJSprite];
    }
    
}


-(void)update:(ccTime)delta {
    
    if (self.position.x < -self.contentSize.width/2 || self.position.x > gs.winSize.width + self.contentSize.width/2) {
        [self destroyJSprite];
    }
    
    self.position = ccp(self.position.x - velocity.x, self.position.y);
    
}

-(void)dealloc {
    [super dealloc];
}

@end







/////////////////////
/////////////////////
/////////////////////------- POWER UP NODE
/////////////////////
////////////////////

@implementation PowerUpNode

+(id)powerupWithFile:(NSString*)filename type:(int)type {
    return [[[self alloc] initWithFile:filename type:type] autorelease];
}
+(id)powerupWithSpriteFrameName:(NSString *)spriteFrameName type:(int)type {
    return [[[self alloc] initWithSpriteFrameName:spriteFrameName type:type] autorelease];
}

-(id)initWithFile:(NSString *)filename type:(int)type {
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:filename];
    CGRect rect = CGRectZero;
    rect.size = tex.contentSize;
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:tex rect:rect];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:filename];
    
    return [self initWithSpriteFrameName:filename type:type];
}

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName type:(int)type {
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) {
        
        player = (Player*)gs.player;
        
        
        bulletFile = @"bullet_missile.png";
        moveType = kbulletMoveStraight;
        addBulletSmoke = YES;
        
        powerupType = type;
        
        switch (powerupType) {
            case kPowerupHoming:
                shootTime = 0.5f;
                moveType = kbulletMoveHoming;
                
                walkFrame = @"powerUpBot1_Walking";
                standFrame = @"powerUpBot1_Stand.png";
                transformFrame = @"powerUpBot1_Transform";
                flyFrame = @"powerUpBot1_Flying";
                break;
            case kPowerupLaser:
                shootTime = 1.5f;
                moveType = kbulletMoveLaser;
                bulletFile = @"laserTest.png";
                addBulletSmoke = NO;
                
                walkFrame = @"powerUpBot2_Walking";
                standFrame = @"powerUpBot2_Stand.png";
                transformFrame = @"powerUpBot2_Transform";
                flyFrame = @"powerUpBot2_Flying";
                break;
                
            default:
                break;
        }
        //shootTimer = shootTime;
        
        
        
        
        if (player.isWalking) {
            [self stateWalking];
        }
        else {
            [self stateFlying];
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[flyFrame stringByAppendingString:@"1.png"]]];
            self.position = ccp(player.currentShip.position.x, player.currentShip.position.y + 30);
        }
        
        
        flame = [EngineFlame flameWithType:kengineFlameSmallBlue];
        flame.position = ccp(self.contentSize.width/2 - 2, self.contentSize.height/2 - 5);
        flame.rotation = -90;
        [self addChild:flame z:self.zOrder - 1];
        
        
        
        [self scheduleUpdate];
        
    }
    
    return self;
}



-(void)stateWalking {
    stateWalking = YES;
    stateFlying = NO;
    stateLanding = NO;
    stateStartFlying = NO;
    
    flame.opacity = 0;
    [self stopAllActions];
    
    void (^stand)(void) = ^{
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:standFrame]];
    };
    NSArray *frames = [gs framesWithFrameName:transformFrame fromFrame:1 toFrame:4];
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:0.08];
    id a1 = [CCAnimate actionWithAnimation:a];
    id block = [CCCallBlock actionWithBlock:stand];
    [self runAction:[CCSequence actionOne:a1 two:block]];
    
    
}
-(void)stateFlying {
    stateWalking = NO;
    stateFlying = YES;
    stateLanding = NO;
    stateStartFlying = NO;
    
    flame.opacity = 255;
}
-(void)stateLanding {
    stateWalking = NO;
    stateFlying = NO;
    stateLanding = YES;
    stateStartFlying = NO;
}
-(void)stateStartFlying {
    stateWalking = NO;
    stateFlying = NO;
    stateLanding = NO;
    stateStartFlying = YES;
    
    [self stopAllActions];
    void (^fly)(void) = ^{
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[flyFrame stringByAppendingString:@"1.png"]]];
        flame.opacity = 255;
    };
    NSArray *frames = [gs framesWithFrameName:transformFrame fromFrame:4 toFrame:1];
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:0.08];
    id a1 = [CCAnimate actionWithAnimation:a];
    id block = [CCCallBlock actionWithBlock:fly];
    [self runAction:[CCSequence actionOne:a1 two:block]];
}





-(void)shootWithDirection:(int)direction type:(int)type {
    CGPoint v = ccp(4,0);
    if (direction == kbulletDirectionNegativeX) {
        v = ccp(-4, 0);
    }
    Bullet *b = [Bullet bulletWithSpriteFrameName:bulletFile Power:1 Velocity:v Direction:direction Movement:moveType Type:type Origin:self ExplodeType:kExplodePlayerNormal];
    
    if (powerupType != kPowerupLaser)
        b.position = ccp(self.position.x, self.position.y);
    
    [parent_ addChild:b];
    
    if (addBulletSmoke)
        [b addSmokeWithType:1];
}


-(void)update:(ccTime)delta {
    
    if (player.isWalking || player.isFalling) { ///PLAYER IS WALKING ON A GROUND....
        ////////////////////--------important Y positions
        
        float landYVel = 5;
        float groundY = player.floorHeight;
        lastFloorHeight = groundY;
        float footY = self.position.y - self.contentSize.height/2;
        float walkingY = groundY + self.contentSize.height/2;
        BOOL onGround = (footY <= groundY + landYVel) && (footY >= groundY - landYVel) && (velocity.y < 0); ////in a certain range to be considered on the ground. and velocity is not going up.
        BOOL aboveGround = groundY < footY;
        //BOOL belowGround = groundY > footY;
        
        ////////////////////--------important X positions
        int playerX = player.position.x;
        int playerDistance = 20; ////how far away from player to know when it's near the player.
        int playerLeft = playerX - playerDistance;
        int playerRight = playerX + playerDistance;
        //BOOL nextToPlayer = (self.position.x <= playerRight) && (self.position.x >= playerLeft);
        BOOL leftOfPlayer = self.position.x < playerLeft;
        BOOL rightOfPlayer = self.position.x > playerRight;
        BOOL outOfLeftBound = self.position.x < player.leftWall;
        BOOL outOfRightBound = self.position.x > player.rightWall;
        
        ///FLYING STATE
        if (stateFlying) { ///if you're flying, start landing
            velocity = ccp(2,0);
            maxVelocity = ccp(velocity.x, landYVel);
            [self stateLanding];
        }
        ///LANDING STATE
        if (stateLanding) { ////if you're landing, quickly move to where the player is.
            if (onGround && (!outOfLeftBound && !outOfRightBound)) { ///once you've reached the ground, set vel and pos and start walking. And within bounds
                maxVelocity = velocity = ccp(1.5, 0);
                self.position = ccp(self.position.x, walkingY);
                [self stateWalking];
            }
            else {
                float landA = 0.035; ///landing acceleration.
                int velX = 0;
                if (aboveGround) { ////accelerate down if you're above the ground.
                    landA = -landA;
                }
                if (leftOfPlayer || outOfLeftBound) {
                    velX = maxVelocity.x;
                }
                else if (rightOfPlayer || outOfRightBound) { ///move negative x if you're right of the player.
                    velX = -maxVelocity.x;
                }
                
                velocity = ccp(velX, velocity.y+landA); //adjust landing velocity w/ accel. and keep in max velocity range.
                if (velocity.y >= maxVelocity.y) velocity = ccp(velocity.x, maxVelocity.y);
                else if (velocity.y <= -maxVelocity.y) velocity = ccp(velocity.x, -maxVelocity.y);
                
                self.position = ccp(self.position.x + velocity.x, self.position.y + velocity.y);
            }
            
        }
        ///WALKING STAE
        if (stateWalking) {
            
            ///find closest enemy to shoot at, and face in that direction.
            Enemy *e;
            int closestDistance = gs.winSize.width;
            int closestX = gs.winSize.width;
            
            if ([gs._enemies count] > 0) {
                CCARRAY_FOREACH(gs._enemies, e) {
                    int dist = self.position.x - e.position.x;
                    dist = abs(dist);
                    if (dist < closestDistance) {
                        closestDistance = dist;
                        closestX = e.position.x;
                    }
                }
                
                enemyLeft = closestX < self.position.x;
                //BOOL enemyRight = closestX > self.position.x;
                if (!isWalking) { /////////////////////////////////// ---- dont turn around if you're chasing the player. makes you walk backwards.
                    if (enemyLeft) {
                        enemyRight = NO;
                        self.scaleX = -1;
                    }
                    else {
                        enemyRight = YES;
                        self.scaleX = 1;
                    }
                }
                
            }
            
            
            
            
            /////////////////make him follow the player.
            if (player.isWalking) {
                int velX = 0;
                if (leftOfPlayer || rightOfPlayer) {
                    if (!isWalking) {    ////////////// robot is chasing player.
                        isWalking = YES;
                        self.scaleX = player.scaleX;
                        [self stopAllActions];
                        NSArray *frames = [gs framesWithFrameName:walkFrame fromFrame:1 toFrame:6];
                        CCAnimation *walk = [CCAnimation animationWithSpriteFrames:frames delay:0.1];
                        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walk]]];
                    }
                    
                    if (leftOfPlayer) {
                        velX = velocity.x;
                    }
                    else if (rightOfPlayer) {
                        velX = -velocity.x;
                    }
                }
                else { /////standing next to the player.
                    if (isWalking) {
                        isWalking = NO;
                        [self stopAllActions];
                        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:standFrame]];
                    }
                }
                
                self.position = ccp(self.position.x + velX, self.position.y);
                
            }
            else if (player.isFalling) {
                isWalking = NO; ////robot to stop following player.
                
                velocity = ccp(2,0);
                maxVelocity = ccp(velocity.x, landYVel);
                [self stateStartFlying];
            }
            
            
            
            
            
        } //////////------- END STATE WALKING
    
    
    
        if (stateStartFlying) {
            if (player.isWalking) {
                [self stateLanding];
            }
            else if (player.isFalling) {
                int velX = 0;
                int velY = 0;
                if (leftOfPlayer) {
                    velX = velocity.x;
                }
                else if (rightOfPlayer) {
                    velX = -velocity.x;
                }
                
                if (self.position.y >= player.position.y + 20) {
                    velY = -velocity.x;
                }
                else if (self.position.y <= player.position.y - 20) {
                    velY = velocity.x;
                }
                
                self.position = ccp(self.position.x + velX, self.position.y + velY);
            }
        }



    } else {  ////PLAYER IS IN SHIP...
        ////follow ship.
        if (stateWalking || stateLanding) {
            
            [self stateStartFlying];
            
        }
        
        else if (stateStartFlying) {
            
            BOOL moveToX = YES;
            BOOL moveToY = YES;
            
            float flyY = 5;
            
            if (self.position.x <= player.currentShip.position.x - 5) {
                self.position = ccp(self.position.x + velocity.x, self.position.y);
            }
            else if (self.position.x > player.currentShip.position.x + 5) {
                self.position = ccp(self.position.x - velocity.x, self.position.y);
            }
            else {
                moveToX = NO;
            }
            if (self.position.y <= player.currentShip.position.y + 15 - 5) {
                self.position = ccp(self.position.x, self.position.y + flyY);
            }
            else if (self.position.y > player.currentShip.position.y + 15 + 5) {
                self.position = ccp(self.position.x, self.position.y - flyY);
            }
            else {
                moveToY = NO;
            }
            
            if (!moveToX && !moveToY) [self stateFlying];
            
        } else {
            self.scaleX = 1;
            self.position = ccp(player.currentShip.position.x, player.currentShip.position.y + 15);
        }
    }
    
    
    
    
    
    
    BOOL isShips = [gs._ships count] > 1;
    BOOL isEnemies = [gs._enemies count] > 0;
    
    if ((isShips && stateFlying) || (isEnemies && stateWalking)) { ////only shoot if bad guys are present.
        if (shootTimer >= shootTime) {
            BOOL shoot = YES;
            int shootDir;
            if (self.scaleX >= 0) {
                shootDir = kbulletDirectionNormal;
                if (enemyLeft && isWalking) {
                    shoot = NO;
                }
            }
            else if (self.scaleX < 0) {
                shootDir = kbulletDirectionNegativeX;
                if (enemyRight && isWalking) {
                    shoot = NO;
                }
            }
            if (shoot) {
                shootTimer = 0.0f;
                if (stateFlying) [self shootWithDirection:shootDir type:kbulletPowerup];
                else if (stateWalking) [self shootWithDirection:shootDir type:kbulletWalkingPowerup];
            }
        } else {
            shootTimer = shootTimer+delta;
        }
    }
    
}


-(void)dealloc {
    [super dealloc];
}

@end


