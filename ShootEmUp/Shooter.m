//
//  Shooter.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/20/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Shooter.h"

#import "Bullet.h"

@implementation Shooter

@synthesize bulletTime;
@synthesize isTargeted, _targetedBy;


+(id)shooter { ////// calls init of subclass which calls super initwithfilename health etc.
    return [[[self alloc] init] autorelease];
}



-(id)initWithFileName:(NSString *)fileName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime {
    
    
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:fileName];
    CGRect theRect = CGRectZero;
    theRect.size = texture.contentSize;
    
    if ((self = [super initWithTexture:texture rect:theRect])) {
        
        //drawRects = YES;
        
        velocity = maxVelocity = initVelocity = spd;
        
        curH = maxH = startH = startHealth;
        
        
        bulletTime = stime;
        bulletTimer = 0;
        shootTime = -1;
        shootTimer = 0;
        delayShootTime = 0;
        delayShootTimer = delayShootTime;
        
        killPoints = 1;
        
        [self schedule:@selector(updateShooter:)];
        
    }
    
    return self;
    
}



-(id)initWithSpriteFrameName:(NSString *)spriteFrameName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime {
    
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) {
        
        //drawRects = YES;
        
        velocity = maxVelocity = initVelocity = spd;
        
        curH = maxH = startH = startHealth;
        
        bulletTime = stime;
        bulletTimer = 0;
        shootTime = -1;
        shootTimer = 0;
        delayShootTime = 0;
        delayShootTimer = delayShootTime;
        
        killPoints = 1;
        
        [self schedule:@selector(updateShooter:)];
        
    }
    
    return self;
    
}




-(void)didCollideWith:(JSprite *)sprite {
    [super didCollideWith:sprite];
    
    
}


-(void)hitByBullet:(float)strength {
    [self takeDamage:strength];
    [self flash];
}

-(void)die {
    if (isTargeted) { ////if the ship is targeted when it dies, tell the bullets targeting it to stop doing that.
        if ([_targetedBy count] > 0) {
            Bullet *b;
            CCARRAY_FOREACH(_targetedBy, b) { ///// tell  those bullets to find new targets.
                b.isFollowingTarget = NO;
                [b moveHoming];
            }
        }
    }
    
    Bullet *b;
    CCARRAY_FOREACH(gs._bullets, b) { ////tell the bullets now that this ship is not it's origin, since it's dead.
        if (b.origin == self) {
            b.hasOrigin = NO;
        }
    }
}

-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
}
-(void)attack {
    isAttacking = YES;
}
-(void)stopAttack {
    isAttacking = NO;
}




-(void)kill {
    [self die];
    [super kill];
}

-(void)updateShooter:(ccTime)dt {
    
    
    int bulletDirection = kbulletDirectionNormal;
    if (dirFacing != self.scaleX) {
        bulletDirection = kbulletDirectionNegativeX;
    }
    
    if (bulletTime != -1) {   ///set to -1 if you don't want the ship to shoot unless told to.
        if (shootTime != -1) {
            if (shootTimer < shootTime) {
                shootTimer = shootTimer + gs.gameDelta;
                bulletTimer = bulletTimer + gs.gameDelta;
                if (bulletTimer >= bulletTime) {
                    [self shootWithDirection:bulletDirection Type:bulletType Origin:self];
                    bulletTimer = 0;
                }
            }
            else {
                delayShootTimer = delayShootTimer + gs.gameDelta;
                if (delayShootTimer >= delayShootTime) {
                    shootTimer = 0;
                    delayShootTimer = 0;
                }
            }
            
        }
        
        else {
            bulletTimer = bulletTimer + gs.gameDelta;
            if (bulletTimer >= bulletTime) {
                [self shootWithDirection:bulletDirection Type:bulletType Origin:self];
                bulletTimer = 0;
            }
        }
    }

    
}




-(void)dealloc {
    [super dealloc];
}

@end
