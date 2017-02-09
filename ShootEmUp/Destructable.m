//
//  Destructable.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/18/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Destructable.h"
#import "Bullet.h"
#import "Ship.h"

@implementation Destructable

+(id)destructable {
    return [[[self alloc] init] autorelease];
}

-(id)initWithSpriteFrameName:(NSString *)framename Strength:(int)str StartingHealth:(float)startHP Velocity:(CGPoint)vel {
    
    if ((self = [super initWithSpriteFrameName:framename])) {

        canCollide = YES;
        invincible = NO;
        
        strength = str;
        startH = startHP; if (startHP < 1) startH = 1;
        maxH = startH;
        curH = maxH;
        
        velocity = vel;
        initVelocity = velocity;
        
        [self schedule:@selector(updateDestructable:)];
        
    }
    
    return self;
}

-(id)initWithFileName:(NSString *)filename Strength:(int)str StartingHealth:(float)startHP Velocity:(CGPoint)vel {
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:filename];
    CGRect rect = CGRectZero;
    rect.size = tex.contentSize;
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:tex rect:rect];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:filename];
    
    return [self initWithSpriteFrameName:filename Strength:str StartingHealth:startHP Velocity:vel];
}

-(void)checkCollisions { ///override jsprite collision detection.
    
    ///////// collission with player's ship. and that it can take damage from player bullets.
    ////////// also collission with the jumping player?
    if (curH > 0) {
        for (Bullet *b in gs._bullets) {
            if (b.type == kbulletPlayer || b.type == kbulletWalkingPlayer) {
                if (CGRectIntersectsRect(self.spriteRect, b.spriteRect)) {
                    if (!invincible)[self hitByBullet:b.strength];
                    [b hitShip:self];
                }
            }
        }
        
        for (Ship *s in gs._ships) {
            if (s.hasPlayer && s.canCollide) {
                if (CGRectIntersectsRect(self.spriteRect, s.spriteRect)) {
                    [s hitByBullet:strength];
                    if (!invincible) curH = 0;
                }
            }
        }
        
    }
    
    
}



-(void)hitByBullet:(float)str {
    curH = curH - str;
}


-(void)kill {
    [super kill];
    
    id explode;
    if (explodeAnimation) {
        explode = [CCAnimate actionWithAnimation:explodeAnimation];
    }
    else {
        explode = [CCDelayTime actionWithDuration:0];
    }
    id explodedone = [CCCallFunc actionWithTarget:self selector:@selector(kill2)];
    [self runAction:[CCSequence actions:explode, explodedone, nil]];
}
-(void)kill2 {
    [self destroyJSprite];
}





-(void)updateDestructable:(ccTime)dt {
    self.position = ccp(self.position.x - self.velocity.x, self.position.y - self.velocity.y);
    
    if (self.position.x > gs.winSize.width+self.contentSize.width || self.position.x < -self.contentSize.width || self.position.y < -self.contentSize.height/2) {
        [self kill2];
    }
}





-(void)dealloc {
    [baseAnimation release];
    baseAnimation = nil;
    
    [explodeAnimation release];
    explodeAnimation = nil;
    
    [super dealloc];
}

@end
