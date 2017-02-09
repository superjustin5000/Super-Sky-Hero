//
//  EnemyFlyingDroid2.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/22/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "EnemyFlyingDroid2.h"
#import "EngineFlame.h"
#import "Bullet.h"
@implementation EnemyFlyingDroid2


-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall {
    if ((self = [super initWithSpriteFrameName:@"flyingdroid2.png" health:1 speed:CGPointMake(0, 0.25) shootTime:0.2f spawnDifficulty:1 leftWall:lwall rightWall:rwall])) {
        
        
        EngineFlame *e = [EngineFlame flameWithType:kengineFlameSmallBlue];
        e.position = ccp(1, -3);
        e.rotation = -90;
        [self addChild:e z:self.zOrder - 1];
        
        EngineFlame *e2 = [EngineFlame flameWithType:kengineFlameSmallBlue];
        e2.position = ccp(self.contentSize.width - 2, e.position.y);
        e2.rotation = -90;
        [self addChild:e2 z:self.zOrder - 1];
        
        delayShootTime = 2.0f;
        shootTime = bulletTime * 3; ///so it shoots 3 bullets
        
        
        startPos = CGPointMake(1000, 1000);
        yDir = 1;
        
    }
    return self;
}



-(void)die {
    [super die];
    
    //NSArray *frames = [gs framesWithFrameName:@"soldier_die0" fromFrame:0 toFrame:4];
    //dieAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.12];
    
    [self stopAllActions];
    
    
    //id die = [CCAnimate actionWithAnimation:dieAnim];
    id remove = [CCCallFunc actionWithTarget:self selector:@selector(remove)];
    
    [self runAction:remove];
}



-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    Bullet *b1 = [Bullet bulletWithSpriteFrameName:@"bulletEnemy1.png" Power:1 Velocity:CGPointMake(1.5, 0) Direction:direction Movement:kbulletMoveStraight Type:kbulletWalkingEnemy Origin:o ExplodeType:kExplodeWalkingEnemyBurst];
    b1.position = ccp(self.position.x - 7, self.position.y);
    
    if (self.scaleX < 0) {
        b1.scaleX = -1;
        b1.position = ccp(self.position.x + 7, self.position.y);
    }
    
    [parent_ addChild:b1];
}

-(void)updateMovement {
    if (startPos.x == 1000 && startPos.y == 1000) {
        startPos = self.position;
    }
    else {
        if (yDir > 0) {
            if (self.position.y >= startPos.y + 10)
                yDir = -1;
        }
        else {
            if (self.position.y <= startPos.y - 10)
                yDir = 1;
        }
        self.position = ccp(self.position.x, self.position.y + (velocity.y * yDir));
    }
    
}



-(void)dealloc {
    [super dealloc];
}
@end
