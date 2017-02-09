//
//  EnemyFlyingDroid.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/4/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "EnemyFlyingDroid.h"
#import "Bullet.h"
#import "EngineFlame.h"

@implementation EnemyFlyingDroid




-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall {
    if ((self = [super initWithSpriteFrameName:@"flyingdroid.png" health:1 speed:CGPointMake(0, 0.25) shootTime:0.2f spawnDifficulty:1 leftWall:lwall rightWall:rwall])) {
        
        
        EngineFlame *e = [EngineFlame flameWithType:kengineFlameSmallBlue];
        e.position = ccp(self.contentSize.width + 4, self.contentSize.height - 1);
        e.scaleX = -1;
        [self addChild:e z:self.zOrder - 1];
        
        delayShootTime = 2.0f;
        shootTime = bulletTime * 3; ///so it shoots 3 bullets
        
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
    Bullet *b1 = [Bullet bulletWithSpriteFrameName:@"bulletEnemy1.png" Power:10 Velocity:CGPointMake(1.5, -1.5) Direction:direction Movement:kbulletMoveStraight Type:kbulletWalkingEnemy Origin:o ExplodeType:kExplodeWalkingEnemyBurst];
    b1.position = ccp(self.position.x - 7, self.position.y - 3);
    b1.rotation = -45;
    
    if (self.scaleX < 0) {
        b1.scaleX = -1;
        b1.rotation = 45;
        b1.position = ccp(self.position.x + 7, self.position.y);
    }
    
    [parent_ addChild:b1];
}

-(void)updateMovement {
    
    
}



-(void)dealloc {
    [super dealloc];
}




@end
