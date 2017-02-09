//
//  TestEnemy.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/27/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "TestEnemy.h"
#import "Bullet.h"

@implementation TestEnemy

-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall {
    if ((self = [super initWithSpriteFrameName:@"goldRobo_walk00.png" health:1 speed:CGPointMake(1, 0) shootTime:2.5f spawnDifficulty:1 leftWall:lwall rightWall:rwall])) {
        
        
        NSArray *frames = [gs framesWithFrameName:@"goldRobo_walk0" fromFrame:0 toFrame:5];
        walkAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.08];
        
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]]];
        
        
    }
    return self;
}



-(void)die {
    [super die];
    
    NSArray *frames = [gs framesWithFrameName:@"goldRobo_die0" fromFrame:1 toFrame:8];
    dieAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.1];
    
    [self stopAllActions];
    
    
    id die = [CCAnimate actionWithAnimation:dieAnim];
    id remove = [CCCallFunc actionWithTarget:self selector:@selector(remove)];
    
    [self runAction:[CCSequence actionOne:die two:remove]];
}



-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    Bullet *b1 = [Bullet bulletWithSpriteFrameName:@"bulletEnemy1.png" Power:10 Velocity:CGPointMake(1.5, 0) Direction:direction Movement:kbulletMoveStraight Type:kbulletWalkingEnemy Origin:o ExplodeType:kExplode1];
    b1.position = ccp(self.position.x, self.position.y);
    
    if (self.scaleX < 0) {
        b1.scaleX = -1;
    }
    
    [parent_ addChild:b1];
}

-(void)updateMovement {
    self.position = ccp(self.position.x - (velocity.x * self.scaleX), self.position.y);
}



-(void)dealloc {
    [super dealloc];
}

@end
