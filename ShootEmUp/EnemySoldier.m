//
//  EnemySoldier.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/3/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "EnemySoldier.h"
#import "Bullet.h"

@implementation EnemySoldier


-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall {
    if ((self = [super initWithSpriteFrameName:@"soldier_walk00.png" health:1 speed:CGPointMake(1, 0) shootTime:0.5f spawnDifficulty:1 leftWall:lwall rightWall:rwall])) {
        
        
        NSArray *frames = [gs framesWithFrameName:@"soldier_walk0" fromFrame:0 toFrame:5];
        walkAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.05];
        
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]]];
        
        
    }
    return self;
}



-(void)die {
    [super die];
    
    NSArray *frames = [gs framesWithFrameName:@"soldier_die0" fromFrame:0 toFrame:4];
    dieAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.12];
    
    [self stopAllActions];
    
    
    id die = [CCAnimate actionWithAnimation:dieAnim];
    id remove = [CCCallFunc actionWithTarget:self selector:@selector(remove)];
    
    [self runAction:[CCSequence actionOne:die two:remove]];
}



-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    Bullet *b1 = [Bullet bulletWithSpriteFrameName:@"bulletEnemy1.png" Power:10 Velocity:CGPointMake(1.5, 0) Direction:direction Movement:kbulletMoveStraight Type:kbulletWalkingEnemy Origin:o ExplodeType:kExplodeWalkingEnemyBurst];
    b1.position = ccp(self.position.x - 5, self.position.y);
    
    CCSprite *flash = [CCSprite spriteWithSpriteFrameName:@"bulletEnemyFlash1.png"];
    
    if (self.scaleX < 0) {
        b1.scaleX = -1;
        flash.scaleX = -1;
        b1.position = ccp(self.position.x + 5, self.position.y);
    }
    
    flash.position = b1.position;
    
    [self addChild:flash];
    flash.position = [self convertToWorldSpace:flash.position];
    [parent_ addChild:b1];
    
    
    void (^removeFlash)(void)  = ^{
        [flash removeFromParentAndCleanup:YES];
    };
    ///animate the bullet flash.
    NSArray *f = [gs framesWithFrameName:@"bulletEnemyFlash" fromFrame:1 toFrame:3];
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:f delay:0.05];
    id animate = [CCAnimate actionWithAnimation:a];
    id remove = [CCCallBlock actionWithBlock:removeFlash];
    [flash runAction:[CCSequence actionOne:animate two:remove]];
    
    
    ////set bullet time since the initial is so low.
    bulletTime = 1.5f;
}

-(void)updateMovement {
    if (!setInitialD) {
        initialD = abs(self.position.x - gs.playerPos.x) + 20;
        setInitialD = YES;
    }
    
    int curD = abs(self.position.x - gs.playerPos.x);
    
    if (curD >= initialD) {
        [self remove];
    }
    
    self.position = ccp(self.position.x - (velocity.x * self.scaleX), self.position.y);
    
}



-(void)dealloc {
    [super dealloc];
}


@end
